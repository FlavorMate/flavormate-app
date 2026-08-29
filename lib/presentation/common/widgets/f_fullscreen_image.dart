import 'package:flavormate/core/cache/provider/p_cached_image.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/utils/u_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:material_ui/material_ui.dart';
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
                loadingBuilder: (_, chunk) =>
                    UImage.buildLoadingWidget(chunk: chunk),
              ),
              Positioned(
                top: PADDING,
                right: PADDING,
                child: M3EFab(
                  onPressed: () => context.pop(),
                  icon: const Icon(Symbols.close_rounded),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
