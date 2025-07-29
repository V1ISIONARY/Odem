import 'package:flutter/material.dart';
import 'package:odem/frontend/platform/mobile/widget/schema/text_format.dart';

import '../schema/color.dart';

class Overview extends StatelessWidget {

  final String title;
  final int count;
  const Overview({
    super.key,
    required this.title,
    required this.count
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: widget_primary_color,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Align(
          alignment: Alignment.bottomLeft, 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, 
            children: [
              Text(
                count.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35
                ),
              ),
              ContentTitle(title: title)
            ],
          ),
        ),
      )
    );
  }
}