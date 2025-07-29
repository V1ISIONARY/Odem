import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import '../schema/text_format.dart';

class IconCard extends StatelessWidget {

  final String title;
  final String? svgPath; 
  final IconData? iconData; 

  const IconCard({
    super.key,
    required this.title,
    this.svgPath,
    this.iconData
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        color: Colors.transparent,
        height: 50,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.only(bottom: 5), child: _buildIcon()),
              ContentDescrip(description: title)
            ]
          )
        )
      )
    );
  }

  Widget _buildIcon() {
    if (svgPath != null) {
      return SvgPicture.asset(
        svgPath!,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(Colors.white70, BlendMode.srcIn),
      );
    } else if (iconData != null) {
      return Icon(
        iconData,
        color: Colors.white70,
        size: 24,
      );
    } else {
      return SizedBox(); 
    }
  }

}