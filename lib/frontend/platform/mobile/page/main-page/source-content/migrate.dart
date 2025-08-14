import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:odem/backend/architecture/bloc/manga/manga_bloc.dart';
import 'package:odem/backend/model/extension.dart';
import 'package:odem/backend/properties/local_properties.dart';
import 'package:odem/frontend/platform/mobile/widget/schema/text_format.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widget/button/source_card.dart';

class Migrate extends StatefulWidget {
  const Migrate({super.key});

  @override
  State<Migrate> createState() => _MigrateState();
}

class _MigrateState extends State<Migrate>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  final localProperties = LocalProperties();
  int? loadingIndex;

  Map<String, int> lastMigrationTimes = {};
  Timer? _timer;

  static const _migrationCooldown = Duration(minutes: 5);
  static const _prefsKey = 'lastMigrationTimestampsMap';

  String? _expandedKey;
  Timer? _hideCooldownTimer;

  final Map<String, AnimationController> _animationControllers = {};

  @override
  void initState() {
    super.initState();
    _loadLastMigrationTimes();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (lastMigrationTimes.isEmpty) return;

      final nowMillis = DateTime.now().millisecondsSinceEpoch;
      bool shouldUpdate = false;

      final keysToRemove = <String>[];
      lastMigrationTimes.forEach((key, timestamp) {
        if (nowMillis - timestamp >= _migrationCooldown.inMilliseconds) {
          keysToRemove.add(key);
          shouldUpdate = true;
          if (_expandedKey == key) {
            _expandedKey = null;
            _animationControllers[key]?.reverse();
          }
        }
      });

      if (keysToRemove.isNotEmpty) {
        for (var key in keysToRemove) {
          _animationControllers[key]?.dispose();
          _animationControllers.remove(key);
          lastMigrationTimes.remove(key);
        }
      }

      if (_expandedKey != null) {
        shouldUpdate = true;
      }

      if (shouldUpdate) {
        setState(() {});
      }
    });
  }

  Future<void> _loadLastMigrationTimes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_prefsKey);
    if (jsonString != null) {
      final Map<String, dynamic> decoded =
          Map<String, dynamic>.from(await jsonDecode(jsonString));
      lastMigrationTimes =
          decoded.map((key, value) => MapEntry(key, value as int));
      setState(() {});
    }
  }

  Future<void> _saveLastMigrationTimes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(lastMigrationTimes));
  }

  bool _isCooldownActiveForKey(String key) {
    if (!lastMigrationTimes.containsKey(key)) return false;
    final lastMillis = lastMigrationTimes[key]!;
    final elapsed = DateTime.now().millisecondsSinceEpoch - lastMillis;
    return elapsed < _migrationCooldown.inMilliseconds;
  }

  Duration _cooldownRemainingForKey(String key) {
    if (!_isCooldownActiveForKey(key)) return Duration.zero;
    final lastMillis = lastMigrationTimes[key]!;
    final elapsed = DateTime.now().millisecondsSinceEpoch - lastMillis;
    return _migrationCooldown - Duration(milliseconds: elapsed);
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    if (minutes > 0) {
      return '$minutes:${seconds.toString().padLeft(2, '0')} minutes remaining';
    }
    return '$seconds seconds remaining';
  }

  Future<void> _onSourceCardTap(int index, Extension? ext) async {
    if (loadingIndex != null) return;
    if (ext == null) return;

    if (_isCooldownActiveForKey(ext.key)) {
      setState(() {
        if (_expandedKey == ext.key) {
          _animationControllers[ext.key]?.reverse();
          _expandedKey = null;
          _hideCooldownTimer?.cancel();
        } else {
          if (_expandedKey != null) {
            _animationControllers[_expandedKey!]?.reverse();
            _hideCooldownTimer?.cancel();
          }

          _expandedKey = ext.key;
          if (!_animationControllers.containsKey(ext.key)) {
            _animationControllers[ext.key] = AnimationController(
              vsync: this,
              duration: const Duration(milliseconds: 300),
            );
          }
          _animationControllers[ext.key]?.forward();

          _hideCooldownTimer = Timer(const Duration(seconds: 10), () {
            if (mounted && _expandedKey == ext.key) {
              setState(() {
                _animationControllers[ext.key]?.reverse();
                _expandedKey = null;
              });
            }
          });
        }
      });
      return;
    }

    setState(() {
      loadingIndex = index;
      if (_expandedKey != null) {
        _animationControllers[_expandedKey!]?.reverse();
        _expandedKey = null;
        _hideCooldownTimer?.cancel();
      }
    });

    context.read<MangaBloc>().add((LoadSearch("", ext.key, false)));
    context.read<MangaBloc>().add(InstallExtension(ext.key, false));

    lastMigrationTimes[ext.key] = DateTime.now().millisecondsSinceEpoch;
    await _saveLastMigrationTimes();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _hideCooldownTimer?.cancel();
    for (var controller in _animationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<MangaBloc, MangaState>(
      listener: (context, state) async {
        if (state is ExtensionInstalled) {
          if (loadingIndex != null) {
            final ext = localProperties.migrateExtension.value[loadingIndex!];
            lastMigrationTimes[ext.key] = DateTime.now().millisecondsSinceEpoch;
            await _saveLastMigrationTimes();
          }
          setState(() {
            loadingIndex = null;
          });
        } else if (state is ErrorOdem) {
          setState(() {
            loadingIndex = null;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 15, left: 15, bottom: 14),
                child: Row(
                  children: const [
                    ContentTitle(title: "Select a source to migrate from"),
                    Spacer(),
                  ],
                ),
              ),
              Expanded(
                child: ValueListenableBuilder<List<Extension>>(
                  valueListenable: localProperties.migrateExtension,
                  builder: (context, migrateExtensions, _) {
                    if (migrateExtensions.isEmpty) {
                      return const Center(
                        child: Text(
                          'No extensions to migrate',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: migrateExtensions.length,
                      itemBuilder: (context, index) {
                        final ext = migrateExtensions[index];
                        final isLoading = loadingIndex == index;

                        final isCooldownActive = _isCooldownActiveForKey(ext.key);
                        final canTap = !isCooldownActive && !isLoading;
                        final iconColor = canTap ? Colors.white : Colors.grey;

                        final showCooldown = _expandedKey == ext.key;
                        final remaining = _cooldownRemainingForKey(ext.key);

                        if (!_animationControllers.containsKey(ext.key)) {
                          _animationControllers[ext.key] = AnimationController(
                            vsync: this,
                            duration: const Duration(milliseconds: 300),
                          );
                          if (showCooldown) {
                            _animationControllers[ext.key]?.value = 1;
                          }
                        }

                        return Column(
                          children: [
                            SourceCard(
                              sourceTitle: '',
                              within: false,
                              extension: ext,
                              action: [
                                GestureDetector(
                                  onTap: () => _onSourceCardTap(index, ext),
                                  child: Container(
                                    width: 50,
                                    child: Center(
                                      child: isLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : SvgPicture.asset(
                                            'lib/resources/svg/database_upload.svg',
                                            color: iconColor,
                                            height: 20,
                                            width: 20,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ClipRect(
                              child: SizeTransition(
                                sizeFactor: _animationControllers[ext.key]!.drive(CurveTween(curve: Curves.easeInOut)),
                                axisAlignment: -1,
                                child: Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(
                                    left: 15,
                                    right: 15,
                                    bottom: 20
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 10
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${_formatDuration(remaining)}",
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 1),
                                      const Text(
                                        "Under migration control, unfortunately we're only allowed to migrate one at a time every 5 minutes.",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 9,
                                        ),
                                      ),
                                    ]
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}