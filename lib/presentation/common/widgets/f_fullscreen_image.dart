import 'package:flavormate/core/cache/provider/p_cached_image.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';

class FFullscreenImage extends ConsumerWidget {
  final String imageSrc;

  const FFullscreenImage({
    super.key,
    required this.imageSrc,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageProvider = ref.watch(pCachedImageProvider(imageSrc));
    return Dialog.fullscreen(
      child: Material(
        color: Colors.black,
        child: SafeArea(
          child: Stack(
            children: [
              PhotoView(
                imageProvider: imageProvider,
              ),
              Positioned(
                top: PADDING,
                right: PADDING,
                child: FloatingActionButton(
                  onPressed: () => context.pop(),
                  child: const Icon(MdiIcons.close),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
