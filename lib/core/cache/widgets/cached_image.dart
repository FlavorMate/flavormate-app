import 'package:flavormate/presentation/common/widgets/f_image/f_image_error.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final ImageProvider imageProvider;
  final BoxFit? fit;

  const CachedImage({super.key, required this.imageProvider, this.fit});
 
  @override
  Widget build(BuildContext context) {
    return Image(
      image: imageProvider,
      fit: fit,
      errorBuilder: (_, _, _) => const FImageError(),
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (frame != null) return child;
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    
  }
}
