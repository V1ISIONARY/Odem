import 'dart:ui';

import 'package:flutter/material.dart';

class BlurFadeOverImage extends StatelessWidget {
  final String imageUrl;
  final double sigma;
  final double fadeFraction;
  final bool fromTop;

  const BlurFadeOverImage({
    Key? key,
    required this.imageUrl,
    this.sigma = 10,
    this.fadeFraction = 0.25,
    this.fromTop = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = NetworkImage(imageUrl);
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: fromTop ? Alignment.topCenter : Alignment.bottomCenter,
          end: fromTop ? Alignment.bottomCenter : Alignment.topCenter,
          colors: const [
            Colors.black,
            Colors.transparent,
          ],
          stops: const [0.0, 0.6],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: Image(
          image: provider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
