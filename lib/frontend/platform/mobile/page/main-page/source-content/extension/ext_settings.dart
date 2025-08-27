import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

String getWeservUrl(String originalUrl) {
  final noProtocol = originalUrl.replaceFirst(RegExp(r'^https?://'), '');
  final parts = noProtocol.split('/'); 
  final domain = parts.first;
  final pathSegments = parts.sublist(1).map(Uri.encodeComponent).join('/');
  return 'https://images.weserv.nl/?url=$domain/$pathSegments';
}


class _ExtSettingsState extends State<ExtSettings> {
  bool _isToggling = false;

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
      body: Container(
        width: double.infinity,
        child: ListView(
          children: [
            Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.only(top: 40, bottom: 30),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      getWeservUrl(widget.extracted.logoImg),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(
                  widget.extracted.exName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                Text(
                  widget.extracted.key,
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 10,
                  ),
                ),
              ]
            ),
            SizedBox(height: 50),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.extracted.version,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                      Text(
                        "Version",
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 20,
                  width: 0.5,
                  color: Colors.white,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.extracted.language,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "Language",
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(right: 20, left: 20, top: 50, bottom: 50),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(width: 1, color: Colors.white),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            "Uninstall",
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            "App Info",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isToggling = !_isToggling;
                });
              },
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.transparent),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          "lib/resources/svg/eyeglasses.svg",
                          color: Colors.white,
                          height: 30,
                          width: 30,
                        ),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Incognito mode",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              "Pause reading history for extension",
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Container(
                          height: 20,
                          width: 35,
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: _isToggling ? Colors.blue : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: AnimatedAlign(
                            duration: const Duration(milliseconds: 200),
                            alignment: _isToggling
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              height: 16,
                              width: 16,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    spreadRadius: 0.5,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 0.5,
              width: double.infinity,
              color: Colors.grey,
              margin: EdgeInsets.only(
                bottom: 40,
                top: 30
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.transparent),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.extracted.language,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        child: Icon(
                          size: 20,
                          Icons.settings_outlined,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 15),
                      Container(
                        height: 20,
                        width: 35,
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: _isToggling ? Colors.blue : Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: AnimatedAlign(
                          duration: const Duration(milliseconds: 200),
                          alignment: _isToggling
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            height: 16,
                            width: 16,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 0.5,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}