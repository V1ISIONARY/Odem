import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:odem/frontend/widget/schema/color.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widget/bottom_navigation.dart';

class Splash extends StatefulWidget {

  const Splash({
    super.key
  });

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToNextScreen();
    });
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstRun', false);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageTransition(
        child: BottomNavigation(initialPage: 0),
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Stack(
          children: [
            Center(
              child: Container(
                // width: 100,
                // height: 100,
                width: 200,
                height: 200,
                color: Colors.transparent,
                child: Image.asset(
                  'lib/resources/image/visionary_background.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  child: const Text(
                    'Visionary 0.0.1',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}