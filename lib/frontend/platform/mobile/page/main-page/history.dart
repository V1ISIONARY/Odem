import 'package:flutter/material.dart';
import 'package:odem/frontend/platform/mobile/widget/button/history_card.dart';
import 'package:odem/frontend/platform/mobile/widget/schema/text_format.dart';

class History extends StatefulWidget {
  
  const History({
    super.key
  });

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(
          'History',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white
          ),
        ),
        actions: [
          Container(
            width: 150,
            margin: EdgeInsets.only(right: 10),
            color: Colors.transparent,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      
                    },
                    child: Icon(Icons.search_outlined, color: Colors.white, size: 20)
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      
                    },
                    child: Icon(Icons.widgets_outlined, color: Colors.white, size: 20)
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      
                    },
                    child: Icon(Icons.delete_sweep, color: Colors.white, size: 20)
                  ),
                )
              ]
            ),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: ContentTitle(title: 'Today')
            ),
            HistoryCard(
              time: '6:06 PM', 
              title: "Solo Leveling", 
              chapter: 126, 
              mangaId: 1, 
              thumbnail: 'lib/resources/image/static/solo.png'
            )
          ],
        ),
      )
    );
  }
}