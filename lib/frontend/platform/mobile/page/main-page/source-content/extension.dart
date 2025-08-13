import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odem/backend/architecture/bloc/manga/manga_bloc.dart';
import 'package:odem/backend/model/extension.dart';
import 'package:odem/backend/properties/local_properties.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widget/button/source_card.dart';

class ExtensionPage extends StatefulWidget {
  const ExtensionPage({super.key});

  @override
  State<ExtensionPage> createState() => _ExtensionPageState();
}

class _ExtensionPageState extends State<ExtensionPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final localProperties = LocalProperties();

  int? loadingIndex;
  Extension? loadingExtension; 

  Future<void> _saveInstalledToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final installedJson = localProperties.installedExtension.value.map((e) => e.toJson()).toList();
    final migrateJson = localProperties.migrateExtension.value.map((e) => e.toJson()).toList();
    final rootJson = localProperties.rootsExtension.value.map((e) => e.toJson()).toList();

    await prefs.setString('installedExtensions', jsonEncode(installedJson));
    await prefs.setString('migrateExtension', jsonEncode(migrateJson));
    await prefs.setString('rootExtensions', jsonEncode(rootJson));
  }

  Future<void> _handleDownloadTap(Extension ext) async {
    if (!localProperties.installedExtension.value.any((e) => e.exName == ext.exName)) {
      localProperties.installedExtension.value = List.from(localProperties.installedExtension.value)..add(ext);
      localProperties.migrateExtension.value = List.from(localProperties.migrateExtension.value)..add(ext);
      localProperties.rootsExtension.value = List.from(localProperties.rootsExtension.value)..add(ext);
      await _saveInstalledToPrefs();
    }
  }

  void _onBlocStateChange(BuildContext context, MangaState state) {
    if (loadingExtension != null) {
      if (state is ExtensionInstalled) {
        if (state.recommended.isNotEmpty) {
          _handleDownloadTap(loadingExtension!);
        }
        setState(() {
          loadingExtension = null;
          loadingIndex = null;
        });
      } else if (state is ErrorOdem) {
        setState(() {
          loadingExtension = null;
          loadingIndex = null;
        });
      }
    }
  }

  void _onSourceCardTap(int index, Extension? ext) {
    if (loadingIndex != null) return; 
    setState(() {
      loadingIndex = index;
      loadingExtension = ext;
    });
    if (ext != null) {
      context.read<MangaBloc>().add(InstallExtension(ext.key)); 
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocListener<MangaBloc, MangaState>(
      listener: _onBlocStateChange,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: ValueListenableBuilder<List<Extension>>(
          valueListenable: localProperties.extensions,
          builder: (context, extensions, _) {
            if (extensions.isEmpty) {
              return const Center(
                child: Text(
                  'No extensions loaded',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return ValueListenableBuilder<List<Extension>>(
              valueListenable: localProperties.installedExtension,
              builder: (context, installedExtensions, _) {
                return ListView(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  children: [
                    if (installedExtensions.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Text(
                          'No installed extensions',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      )
                    else
                      Column(
                        children: installedExtensions.asMap().entries.map((entry) {
                          int idx = entry.key;
                          Extension ext = entry.value;
                          return SourceCard(
                            sourceTitle: 'Installed',
                            within: idx == 0,
                            extension: ext,
                            action: [
                              GestureDetector(
                                onTap: () {
                                  // your action here if any
                                },
                                child: Container(
                                  width: 50,
                                  child: Center(
                                    child: Icon(
                                      Icons.settings,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),

                    ...extensions
                        .where((ext) => !installedExtensions.any((e) => e.exName == ext.exName))
                        .toList()
                        .asMap()
                        .entries
                        .map((entry) {
                      int idx = entry.key;
                      Extension ext = entry.value;
                      final isLoading = loadingIndex == idx;

                      return SourceCard(
                        sourceTitle: const String.fromEnvironment('multi', defaultValue: 'Multi'),
                        within: idx == 0,
                        extension: ext,
                        action: [
                          GestureDetector(
                            onTap: () {
                              // some action
                            },
                            child: Container(
                              width: 50,
                              child: Center(
                                child: Icon(
                                  Icons.public,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: isLoading ? null : () => _onSourceCardTap(idx, ext),
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
                                    : Icon(
                                        Icons.downloading_sharp,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}