import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import '../schema/text_format.dart';

class IconCard extends StatelessWidget {
  final String title;
  final String? svgPath;
  final Color? iconColor;  // Changed from String? to Color?
  final IconData? iconData;
  final Widget? iconWidget;

  const IconCard({
    super.key,
    required this.title,
    this.svgPath,
    this.iconData,
    this.iconWidget,
    this.iconColor,
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
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: _buildIcon(),
              ),
              ContentDescrip(description: title),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (iconWidget != null) {
      return iconWidget!;
    } else if (svgPath != null) {
      return SvgPicture.asset(
        svgPath!,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          iconColor ?? Colors.white70,
          BlendMode.srcIn,
        ),
      );
    } else if (iconData != null) {
      return Icon(
        iconData,
        color: iconColor ?? Colors.white70,
        size: 24,
      );
    } else {
      return const SizedBox();
    }
  }
}