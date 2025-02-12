import 'package:flutter/material.dart';

class Setting extends StatefulWidget {

  const Setting({
    super.key
  });

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          Container(
            width: 200,
            height: 200,
            color: Colors.transparent,
            child: Center(
              child: Container(
                height: 150,
                width: 150,
                child: Image.asset(
                'lib/resources/image/visionary_background.png',
                fit: BoxFit.cover,
              ),
              )
            )
          ),
        ]
      )
    );
  }
}