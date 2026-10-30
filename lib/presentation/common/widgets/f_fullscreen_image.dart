import 'package:flavormate/core/cache/provider/p_cached_image.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/utils/u_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FFullscreenImage extends ConsumerStatefulWidget {
  final List<String> urls;
  final int index;

  const FFullscreenImage({
    super.key,
    required this.urls,
    required this.index,
  });

  @override
  ConsumerState<FFullscreenImage> createState() => _FFullscreenImageState();
}

class _FFullscreenImageState extends ConsumerState<FFullscreenImage> {
  late final PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: widget.index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Material(
        color: Colors.black,
        child: SafeArea(
          child: Stack(
            fit: .expand,
            children: [
              PhotoViewGallery.builder(
                pageController: _controller,
                itemCount: widget.urls.length,
                loadingBuilder: (_, chunk) =>
                    UImage.buildLoadingWidget(chunk: chunk),
                builder: (context, index) {
                  final imageSrc = widget.urls[index];
                  final imageProvider = ref.watch(
                    pCachedImageProvider(imageSrc),
                  );
                  return PhotoViewGalleryPageOptions(
                    imageProvider: imageProvider,
                    initialScale: PhotoViewComputedScale.contained,
                    heroAttributes: PhotoViewHeroAttributes(tag: imageSrc),
                  );
                },
              ),
              Positioned(
                top: PADDING,
                right: PADDING,
                child: M3EFab(
                  size: .regular,
                  onPressed: () => context.pop(),
                  icon: const Icon(Symbols.close_rounded),
                ),
              ),
              Positioned(
                bottom: PADDING,
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: Row(
                    mainAxisAlignment: .center,
                    children: [
                      M3EButtonGroup(
                        type: .connected,
                        onSelectedIndexChanged: (index) {
                          switch (index) {
                            case 0:
                              _controller.previousPage(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.ease,
                              );
                              return;
                            case 1:
                              _controller.nextPage(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.ease,
                              );
                              return;
                          }
                        },
                        actions: const [
                          M3EButtonGroupAction(
                            icon: Icon(Symbols.arrow_back_rounded),
                          ),
                          M3EButtonGroupAction(
                            icon: Icon(Symbols.arrow_forward_rounded),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
