import 'package:flutter/material.dart';

class ContentTitle extends StatelessWidget {
  final String title;
  final String? alignment;

  const ContentTitle({
    super.key,
    required this.title,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: double.infinity);

        final textWidth = textPainter.width;
        final thresholdWidth = constraints.maxWidth * 0.8;

        final applyFade = textWidth > thresholdWidth;

        final textWidget = Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
          textAlign: _getTextAlignment(),
          maxLines: 1,
          overflow: TextOverflow.clip,
          softWrap: false,
        );

        if (!applyFade) return textWidget;

        return ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.white,
                Colors.white,
                Colors.transparent,
              ],
              stops: [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstIn,
          child: textWidget,
        );
      },
    );
  }

  TextAlign _getTextAlignment() {
    switch (alignment?.toLowerCase()) {
      case "right":
        return TextAlign.right;
      case "center":
        return TextAlign.center;
      case "left":
        return TextAlign.left;
      default:
        return TextAlign.start;
    }
  }
}

class ContentDescrip extends StatelessWidget {
  final String description;
  final String? alignment;
  final double? size;
  final Color? color;

  const ContentDescrip({
    super.key,
    required this.description,
    this.alignment,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: TextStyle(
        color: color ?? Colors.white70,
        fontSize: size ?? 10,
      ),
      textAlign: _getTextAlignment(),
    );
  }

  TextAlign _getTextAlignment() {
    switch (alignment?.toLowerCase()) {
      case "right":
        return TextAlign.right;
      case "center":
        return TextAlign.center;
      case "left":
        return TextAlign.left;
      default:
        return TextAlign.start;
    }
  }
}
