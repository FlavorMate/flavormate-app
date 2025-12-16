import 'dart:convert';

import 'package:flavormate/core/cache/provider/p_cached_image.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_current_server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
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
          errorBuilder: (_, _, _) => _NoImage(),
        ),
        FImageType.secure => Consumer(
          builder: (context, ref, child) {
            final server = ref.read(pSPCurrentServerProvider);
            final url = '$server$imageSrc';
            final imageProvider = ref.watch(pCachedImageProvider(url));
            return Image(
              image: imageProvider,
              fit: fit,
              errorBuilder: (_, _, e) => _NoImage(),
            );
          },
        ),
        FImageType.network => Image.network(
          imageSrc!,
          fit: fit,
          errorBuilder: (_, _, _) => _NoImage(),
        ),
        FImageType.memory => Image.memory(
          base64Decode(imageSrc!),
          fit: fit,
          errorBuilder: (_, _, _) => _NoImage(),
        ),
      };
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
      child: const Icon(
        MdiIcons.cameraOffOutline,
        size: 64,
        color: Colors.white,
      ),
    );
  }
}
