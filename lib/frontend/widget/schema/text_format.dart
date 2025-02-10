import 'package:flutter/material.dart';

class ContentTitle extends StatelessWidget {

  final String title;
  final String? alignment;
  const ContentTitle({
    super.key,
    required this.title,
    this.alignment
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 10
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

class ContentDescrip extends StatelessWidget {

  final String description;
  final String? alignment;
  final double? size;
  const ContentDescrip({
    super.key,
    required this.description,
    this.alignment,
    this.size
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: TextStyle(
        color: Colors.white70,
        fontSize: size ?? 10
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