import 'package:flutter/material.dart';

import '../schema/text_format.dart';

class HistoryCard extends StatelessWidget {

  final String time;
  final String title;
  final int chapter;
  final int mangaId;
  final String thumbnail;
  const HistoryCard({
    super.key,
    required this.time,
    required this.title,
    required this.chapter,
    required this.mangaId,
    required this.thumbnail
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        color: Colors.black,
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: thumbnail.isNotEmpty
                  ? Image.network(
                      thumbnail,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'lib/resources/image/static/solo.png',
                          fit: BoxFit.cover,
                          color: Colors.white,
                        );
                      },
                    )
                  : Image.asset(
                      'lib/resources/image/static/solo.png',
                      fit: BoxFit.cover,
                      color: Colors.white,
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ContentTitle(title: title),
                  ContentDescrip(description: 'Chapter $chapter ⋅ $time', size: 9),
                ],
              ),
            ),
            Spacer(),
            Icon(Icons.delete_outline, size: 20, color: Colors.grey), 
          ]
        )
      )
    );
  }
}