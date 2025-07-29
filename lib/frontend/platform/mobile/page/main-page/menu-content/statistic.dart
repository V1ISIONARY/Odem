import 'package:flutter/material.dart';
import 'package:odem/frontend/platform/mobile/widget/design/overview.dart';
import 'package:odem/frontend/platform/mobile/widget/schema/color.dart';

import '../../../widget/schema/text_format.dart';

class Statistic extends StatefulWidget {
  const Statistic({super.key});

  @override
  State<Statistic> createState() => _StatisticState();
}

class _StatisticState extends State<Statistic> {
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
              ContentTitle(title: 'Statistic'),
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
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ContentTitle(title: 'Overview'),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Overview(title: 'In Library', count: 0),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Overview(title: 'Reed duration', count: 0),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Overview(title: 'Complete entries', count: 0),
                      )
                    ],
                  ) 
                )
              ]
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ContentTitle(title: 'Entries'),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Overview(title: 'In Global Update', count: 0),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Overview(title: 'Started', count: 0),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Overview(title: 'Local', count: 0),
                      )
                    ],
                  ) 
                )
              ]
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ContentTitle(title: 'Chapter'),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Overview(title: 'Total', count: 0),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Overview(title: 'Read', count: 0),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Overview(title: 'Downloaded', count: 0),
                      )
                    ],
                  ) 
                )
              ]
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ContentTitle(title: 'Trackers'),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Overview(title: 'Tracked entries', count: 0),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Overview(title: 'Mean Score', count: 0),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Overview(title: 'Used', count: 0),
                      )
                    ],
                  ) 
                )
              ]
            )
          ]
        )
      )
    );
  }
}