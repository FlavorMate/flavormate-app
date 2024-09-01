import 'package:flutter/material.dart';

class TImage extends StatelessWidget {
  final String? imageSrc;
  final double width;
  final double height;

  const TImage({
    super.key,
    required this.imageSrc,
    this.width = double.infinity,
    this.height = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    if (imageSrc != null) {
      return Image.network(
        imageSrc!,
        fit: BoxFit.cover,
        height: height,
        width: width,
        errorBuilder: (_, __, ___) => _NoImage(height: height, width: width),
      );
    } else {
      return _NoImage(height: height, width: width);
    }
  }
}

class _NoImage extends StatelessWidget {
  final double height;
  final double width;

  const _NoImage({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/no_image.png',
      fit: BoxFit.cover,
      height: height,
      width: width,
    );
  }
}
