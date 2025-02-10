import 'package:flutter/material.dart';

import '../../../widget/button/source_card.dart';

class Roots extends StatefulWidget {
  const Roots({super.key});

  @override
  State<Roots> createState() => _RootsState();
}

class _RootsState extends State<Roots> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          SourceCard(
            sourceTitle: 'Last used',
            within: true,
            title: 'Asura', 
            version: '1.4.1', 
            language: 'English',
            thumbnail: 'lib/resources/image/static/solo.png',
            navigateTo: '',
            icon2: Icons.cyclone,
          )
        ],
      ),
    );
  }
}