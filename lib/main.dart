import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odem/backend/architecture/bloc/manga/manga_bloc.dart';
import 'package:odem/backend/architecture/cubic/widget/sources_pages.dart';
import 'package:odem/backend/repositories/manga-repository.dart';
import 'package:odem/frontend/platform/mobile/page/introduction/splash_screen.dart';
import 'package:odem/frontend/platform/mobile/widget/bottom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'backend/architecture/cubic/widget/main_page.dart';

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
        //cubic
        BlocProvider(create: (context) => mainPage()), 
        BlocProvider(create: (context) => sourcePage()),
        
        //bloc
        BlocProvider(create: (context) => MangaBloc(MangaRepository()))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: isFirstRun ? Splash() : BottomNavigation(initialPage: 0),
      ),
    );
  }
}
