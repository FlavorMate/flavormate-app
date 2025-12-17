import 'dart:convert';

import 'package:flavormate/core/cache/provider/p_cached_image.dart';
import 'package:flavormate/core/cache/widgets/cached_image.dart';
import 'package:flavormate/presentation/common/widgets/f_image/f_image_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'f_image_type.dart';

class FImage extends StatelessWidget {
  final String? imageSrc;
  final FImageType? type;
  final BoxFit fit;

  const FImage({
    super.key,
    required this.imageSrc,
    required this.type,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (imageSrc != null) {
      return switch (type!) {
        FImageType.asset => Image.asset(
          imageSrc!,
          fit: fit,
          errorBuilder: (_, _, _) => const FImageError(),
        ),
        FImageType.secure => Consumer(
          builder: (context, ref, child) {
            final imageProvider = ref.watch(pCachedImageProvider(imageSrc!));
            return CachedImage(
              imageProvider: imageProvider,
              fit: fit,
            );
          },
        ),
        FImageType.network => Image.network(
          imageSrc!,
          fit: fit,
          errorBuilder: (_, _, _) => const FImageError(),
        ),
        FImageType.memory => Image.memory(
          base64Decode(imageSrc!),
          fit: fit,
          errorBuilder: (_, _, _) => const FImageError(),
        ),
      };
    } else {
      return const FImageError();
    }
  }
}
