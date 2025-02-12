import 'package:flutter/material.dart';

import '../schema/text_format.dart';

class ChapterCard extends StatelessWidget {
  
  final int chapter;
  final int page;
  final String date;
  final IconData status;
  
  const ChapterCard({
    super.key,
    required this.chapter,
    required this.page,
    required this.date,
    required this.status
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ContentTitle(title: 'Chapter ${chapter}'),
                ContentDescrip(description: '${date} ⋅ Page: ${page}', size: 9)
              ],
            ),
            GestureDetector(
              onTap: () {
              },
              child: Container(
                width: 30,
                height: 30,
                alignment: Alignment.center, 
                child: Icon(
                  status,
                  color: Colors.white,
                  size: 17,
                )
              )
            )
          ]
        )
      )
    );
  }
}