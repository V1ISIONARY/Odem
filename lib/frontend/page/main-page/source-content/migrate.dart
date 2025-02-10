import 'package:flutter/material.dart';
import 'package:odem/frontend/widget/schema/text_format.dart';

import '../../../widget/button/source_card.dart';

class Migrate extends StatefulWidget {
  const Migrate({super.key});

  @override
  State<Migrate> createState() => _MigrateState();
}

class _MigrateState extends State<Migrate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ContentTitle(title: "Select a source to migrate from"),
                    Spacer(),
                    Row(
                      children: [
                        GestureDetector(
                          child: Container(
                            width: 50,
                            child: Center(
                              child: Icon(
                                Icons.sort_by_alpha,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            width: 50,
                            child: Center(
                              child: Icon(
                                Icons.arrow_upward_outlined,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ]
                )
              ),
              SourceCard(
                sourceTitle: 'Installed',
                within: false,
                title: 'Asura', 
                version: '69.0.21', 
                language: 'English',
                thumbnail: 'lib/resources/image/static/solo.png',
                navigateTo: ''
              )
            ]
          )
        ],
      ),
    );
  }
}