import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odem/backend/cubic/sources_pages.dart';
import 'package:odem/frontend/page/introduction/splash_screen.dart';
import 'package:odem/frontend/widget/bottom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'backend/cubic/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstRun = prefs.getBool('isFirstRun') ?? true;

  runApp(MyApp(isFirstRun: isFirstRun));
}

class MyApp extends StatelessWidget {
  final bool isFirstRun;
  
  const MyApp({super.key, required this.isFirstRun});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => mainPage()), 
        BlocProvider(create: (context) => sourcePage()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: isFirstRun ? Splash() : BottomNavigation(initialPage: 0),
      ),
    );
  }
}
