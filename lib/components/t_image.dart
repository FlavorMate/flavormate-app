import 'dart:convert';

import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';

enum TImageType { asset, network, memory }

class TImage extends StatelessWidget {
  final String? imageSrc;
  final TImageType? type;
  final double borderRadius;

  const TImage({
    super.key,
    required this.imageSrc,
    required this.type,
    this.borderRadius = BORDER_RADIUS,
  });

  @override
  Widget build(BuildContext context) {
    if (imageSrc != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: switch (type!) {
          TImageType.asset => Image.asset(
            imageSrc!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _NoImage(),
          ),
          TImageType.network => Image.network(
            imageSrc!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _NoImage(),
          ),
          TImageType.memory => Image.memory(
            base64Decode(imageSrc!),
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _NoImage(),
          ),
        },
      );
    } else {
      return _NoImage();
    }
  }
}

class _NoImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(BORDER_RADIUS),
        color: Color.lerp(
          Theme.of(context).colorScheme.inversePrimary,
          Colors.black,
          0.15,
        ),
      ),
    );
  }
}
