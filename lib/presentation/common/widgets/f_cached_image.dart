import 'package:flavormate/presentation/common/widgets/f_image/f_image_error.dart';
import 'package:flutter/material.dart';

class FCachedImage extends StatelessWidget {
  final ImageProvider imageProvider;
  final BoxFit? fit;
  final Widget onError;

  const FCachedImage({
    super.key,
    required this.imageProvider,
    this.fit,
    this.onError = const FImageError(),
  });

  @override
  Widget build(BuildContext context) {
    return Image(
      image: imageProvider,
      fit: fit,
      errorBuilder: (_, _, _) => onError,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (frame != null) return child;
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
