import 'package:flutter/material.dart';
import 'package:odem/frontend/widget/schema/text_format.dart';

import '../../../widget/button/source_card.dart';

class Extension extends StatefulWidget {

  const Extension({super.key});

  @override
  State<Extension> createState() => _ExtensionState();
}

class _ExtensionState extends State<Extension> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SourceCard(
                sourceTitle: 'Installed',
                within: true,
                title: 'Asura', 
                version: '69.0.21', 
                language: 'English',
                thumbnail: 'lib/resources/image/static/solo.png',
                navigateTo: '',
                icon1: Icons.settings_outlined,
              ),
              SourceCard(
                sourceTitle: 'Multi',
                within: true,
                title: 'AnimeH', 
                version: '1.4.7', 
                language: 'English',
                thumbnail: 'lib/resources/image/static/solo.png',
                navigateTo: '',
                icon1: Icons.public,
                icon2: Icons.download_outlined,
              ),
              SourceCard(
                sourceTitle: 'Multi',
                within: false,
                title: '3Hentai', 
                version: '1.4.1', 
                language: 'English',
                thumbnail: 'lib/resources/image/static/solo.png',
                navigateTo: '',
                icon1: Icons.public,
                icon2: Icons.download_outlined,
              )
            ]
          )
        ],
      ),
    );
  }
}