import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odem/backend/architecture/bloc/manga/manga_bloc.dart';
import 'package:odem/backend/model/extension.dart';
import 'package:odem/backend/properties/local_properties.dart';
import 'package:odem/resources/schema.dart';
import 'package:page_transition/page_transition.dart';

import '../../widget/bottom_navigation.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final localProperties = LocalProperties();
  bool _isNavigating = false;
  bool _hasTriggeredLoad = false;

  @override
  void initState() {
    super.initState();
    _initSplash();
    _waitForInstalledExtension();
  }

  Future<void> _waitForInstalledExtension() async {
    while (localProperties.installedExtension.value.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    if (localProperties.installedExtension.value.length == 1) {
      await localProperties.setMangaRootByIndex(0);
    }
  }

  Future<void> _initSplash() async {
    await localProperties.syncData();

    localProperties.searchManga.addListener(() {
      if (!mounted) return;
      final searchMap = localProperties.searchManga.value;
        searchMap.forEach((sourceKey, innerMap) {
          print('Source: $sourceKey');
          innerMap.forEach((listType, list) {
            print('  $listType: ${list.length} items');
            for (var item in list.take(10)) { 
              print('   - ${item.title}');
            }
          });
        });
    });

    if (localProperties.extensions.value.isNotEmpty) {
      _navigateToMainWrapper(skipBloc: true);
      return;
    }
    _hasTriggeredLoad = true;
    context.read<MangaBloc>().add(LoadExtensions());
    _startNavigationTimer();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Extension>>(
      valueListenable: localProperties.extensions,
      builder: (context, extensionsList, _) {
        return BlocListener<MangaBloc, MangaState>(
          listener: (context, state) {
            if (state is ExtensionLoaded && !_isNavigating) {
              _navigateToMainWrapper();
            } else if (state is ErrorOdem && !_isNavigating) {
              debugPrint("Error: ${state.response}");
              _navigateToMainWrapper();
            }
          },
          child: Scaffold(
            backgroundColor: widgetPricolor,
            body: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black,
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'を',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 110,
                            fontWeight: FontWeight.w700,
                            
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(0, -10),
                          child: Text(
                            'other demension',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 10,
                            ),
                          )
                        )
                      ]
                    )
                  ),
                  Positioned(
                    bottom: 60,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: BlocBuilder<MangaBloc, MangaState>(
                        builder: (context, state) {
                          if (state is ExtensionLoading) {
                            return const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            );
                          } else if (state is ErrorOdem) {
                            return Text(
                              "Error: ${state.response}",
                              style: const TextStyle(color: Colors.red, fontSize: 12),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        'Visionary 0.0.1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToMainWrapper({bool skipBloc = false}) {
    if (_isNavigating) return;

    _isNavigating = true;
    Navigator.pushReplacement(
      context,
      PageTransition(
        child: BottomNavigation(initialPage: 0),
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _startNavigationTimer() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && !_isNavigating) {
        _navigateToMainWrapper();
      }
    });
  }
  
}