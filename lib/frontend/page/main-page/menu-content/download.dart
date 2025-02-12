import 'package:flutter/material.dart';

import '../../../widget/button/single_card.dart';
import '../../../widget/schema/text_format.dart';

class Download extends StatefulWidget {
  const Download({super.key});

  @override
  State<Download> createState() => _DownloadState();
}

class _DownloadState extends State<Download> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Transform.translate(
          // offset: Offset(-20, 0),
          offset: Offset(-20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContentTitle(title: 'Download Queue'),
            ],
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.white),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back, color: Colors.white, size: 10),
          ),
        ),
      ),
      body: ListView(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double screenWidth = constraints.maxWidth;
                    int crossAxisCount = (screenWidth / 150).floor(); 
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount, 
                        mainAxisSpacing: 5, 
                        crossAxisSpacing: 5, 
                        childAspectRatio: 100 / 200, 
                      ),
                      itemCount: 1, 
                      shrinkWrap: true, 
                      physics: const NeverScrollableScrollPhysics(), 
                      padding: const EdgeInsets.symmetric(horizontal: 15), 
                      itemBuilder: (_, index) => GridTile(
                        child: SingleCard(
                          title: 'Solo Leveling',
                          ratings: '4.5',
                          thumbnail: 'lib/resources/image/static/solo.png',
                          description: 'Ep: 23 ⋅ Season: 2', mangaId: 1
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          )
        ]
      ),
    );
  }
}