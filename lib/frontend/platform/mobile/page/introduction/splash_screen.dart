import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odem/backend/architecture/bloc/manga/manga_bloc.dart';
import 'package:odem/backend/model/manga/recommend.dart';
import 'package:odem/backend/properties/local_properties.dart';
import 'package:odem/frontend/platform/mobile/widget/schema/color.dart';
import 'package:odem/resources/schema.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  }

  Future<void> _initSplash() async {
    await localProperties.syncData();
    if (localProperties.recommendManga.value.isNotEmpty) {
      _navigateToMainWrapper(skipBloc: true);
      return; 
    }
    _hasTriggeredLoad = true;
    context.read<MangaBloc>().add(LoadOdem());
    _startNavigationTimer();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<RecoModel>>(
      valueListenable: localProperties.recommendManga,
      builder: (context, recommendedList, _) {
        return BlocListener<MangaBloc, MangaState>(
          listener: (context, state) {
            if (state is FetchReco && !_isNavigating) {
              _navigateToMainWrapper();
              context.read<MangaBloc>().add(LoadExtensions());
            } else if (state is ErrorOdem) {
              debugPrint("Error: ${state.response}");
              context.read<MangaBloc>().add(LoadExtensions());
              if (!_isNavigating) {
                _navigateToMainWrapper();
              }
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
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: Image.asset(
                        'lib/resources/image/visionary_background.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: BlocBuilder<MangaBloc, MangaState>(
                        builder: (context, state) {
                          if (state is LoadingOdem) {
                            return const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
        final state = context.read<MangaBloc>().state;
        if (state is FetchReco) {
          _navigateToMainWrapper();
        }
      }
    });
  }
}