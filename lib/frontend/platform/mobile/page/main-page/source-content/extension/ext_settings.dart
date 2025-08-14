import 'package:flutter/material.dart';
import 'package:odem/backend/model/extension.dart';

class ExtSettings extends StatefulWidget {

  final Extension extracted;
  const ExtSettings({
    super.key,
    required this.extracted
  });

  @override
  State<ExtSettings> createState() => _ExtSettingsState();
}

class _ExtSettingsState extends State<ExtSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
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
        title: Transform.translate(
          offset: Offset(-20, 0),
          child: ClipRect( 
            child: Text(
              'Extension Info',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),    
            )
          )
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.share_outlined,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {},
          ),
          SizedBox(width: 5),
          Builder(
            builder: (context) {
              return Theme(
                data: Theme.of(context).copyWith(
                  popupMenuTheme: PopupMenuThemeData(
                    color: Colors.grey[900],
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                child: PopupMenuButton<int>(
                  icon: const Icon(
                    Icons.more_vert_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  offset: const Offset(0, 45),
                  onSelected: (int value) {
                    print("Clicked item: $value");
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                    PopupMenuItem<int>(
                      value: 1,
                      child: Text(
                        'Refresh',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13
                        ),
                      ),
                    ),
                    // PopupMenuItem<int>(
                    //   value: 2,
                    //   child: Text(
                    //     'Notes',
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 13
                    //     ),
                    //   ),
                    // ),
                    PopupMenuItem<int>(
                      value: 2,
                      child: Text(
                        'Share',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(width: 15),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              margin: EdgeInsets.only(
                top: 50,
                bottom: 30
              ),
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(10)
              ),
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(10),
                child: Image.network(
                  widget.extracted.logoImg,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              widget.extracted.exName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),    
            ),
            Text(
              widget.extracted.exName,
              style: TextStyle(
                color: Colors.white60,
                fontSize: 10,
              ),    
            )
          ]
        )
      )
    );
  }
}