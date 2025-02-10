import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odem/backend/cubic/sources_pages.dart';
import 'package:odem/frontend/widget/bottom_navigation.dart';

import 'backend/cubic/main_page.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => mainPage()),
        BlocProvider(create: (context) => sourcePage()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavigation(initialPage: 0),
    );
  }
}