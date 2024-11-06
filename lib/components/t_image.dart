import 'dart:convert';

import 'package:flavormate/gen/assets.gen.dart';
import 'package:flutter/material.dart';

enum TImageType {
  asset,
  network,
  memory;
}

class TImage extends StatelessWidget {
  final String? imageSrc;
  final double width;
  final double height;
  final TImageType? type;

  const TImage({
    super.key,
    required this.imageSrc,
    required this.type,
    this.width = double.infinity,
    this.height = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    if (imageSrc != null) {
      return switch (type!) {
        TImageType.asset => Image.asset(
            imageSrc!,
            fit: BoxFit.cover,
            height: height,
            width: width,
            errorBuilder: (_, __, ___) =>
                _NoImage(height: height, width: width),
          ),
        TImageType.network => Image.network(
            imageSrc!,
            fit: BoxFit.cover,
            height: height,
            width: width,
            errorBuilder: (_, __, ___) =>
                _NoImage(height: height, width: width),
          ),
        TImageType.memory => Image.memory(
            base64Decode(imageSrc!),
            fit: BoxFit.cover,
            height: height,
            width: width,
            errorBuilder: (_, __, ___) =>
                _NoImage(height: height, width: width),
          ),
      };
    } else {
      return _NoImage(height: height, width: width);
    }
  }
}

class _NoImage extends StatelessWidget {
  final double height;
  final double width;

  const _NoImage({required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Assets.images.noImage.image(
      fit: BoxFit.cover,
      height: height,
      width: width,
    );
  }
}
