import 'package:flutter/material.dart';
import 'package:odem/frontend/widget/schema/color.dart';

import '../../../widget/schema/text_format.dart';

class Storage extends StatefulWidget {
  const Storage({super.key});

  @override
  State<Storage> createState() => _StorageState();
}

class _StorageState extends State<Storage> {
  bool isToggled = false;

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
              ContentTitle(title: 'Data and Storage'),
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
            GestureDetector(
              child: Container(
                color: Colors.black,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ContentTitle(title: 'Storage location'),
                    ContentDescrip(description: '/storage/emulated/0/Manga')
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.black,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, color: Colors.white, size: 20),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: ContentDescrip(description: 'Used for automatic backups, chapter downloads, and local sources.')
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: ContentTitle(title: 'Backup and restore')
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                        border: Border.all(width: 2, color: widget_primary_color),
                        color: Colors.transparent
                      ),
                      child: Center(
                        child: ContentTitle(title: 'Create backup'),
                      ),
                    ),
                  )
                ),
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        border: Border.all(width: 2, color: widget_primary_color),
                        color: Colors.transparent
                      ),
                      child: Center(
                        child: ContentTitle(title: 'Create backup'),
                      ),
                    ),
                  )
                )
              ],
            ),
            GestureDetector(
              child: Container(
                color: Colors.black,
                width: double.infinity,
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ContentTitle(title: 'Autoamtic backup frequency'),
                    ContentDescrip(description: 'Every 12 hours')
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.black,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, color: Colors.white, size: 20),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: ContentDescrip(description: 'You should keep copies of backup in other places as well. Backups may contain sensitive data including nay stored passwords; be careful if sharing.\n\nLast automatically backed up: Yesterday\n\n\n\n')
                  )
                ],
              ),
            ),
            ContentTitle(title: 'Storage usage\n'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: ContentDescrip(description: '/storage/emulated/0')
                ),
                Container(
                  height: 10,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: widget_primary_color,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 100, 
                      height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: ContentDescrip(description: 'Available: 1.44 GB / Total: 116 GB')
                ),
              ],
            ),
            GestureDetector(
              child: Container(
                color: Colors.black,
                width: double.infinity,
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ContentTitle(title: 'Clear chapter cache'),
                    ContentDescrip(description: 'Used: 13.59 kB')
                  ],
                ),
              ),
            ),
            GestureDetector(
              child: Container(
                color: Colors.black,
                width: double.infinity,
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ContentTitle(title: 'Clear chapter cache'),
                        ContentDescrip(description: 'Used: 13.59 kB')
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isToggled = !isToggled; 
                        });
                      },
                      child: Container(
                        height: 15,
                        width: 40, 
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: isToggled ? widget_primary_color : widget_primary_color,
                          borderRadius: BorderRadius.circular(10), 
                        ),
                        child: AnimatedAlign(
                          duration: Duration(milliseconds: 200), 
                          alignment: isToggled ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            height: 16,
                            width: 16,
                            decoration: BoxDecoration(
                              color: Colors.white, 
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ),
            ),
          ],
        ),
      )
    );
  }
}