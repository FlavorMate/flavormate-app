import 'package:flavormate/core/cache/provider/p_cached_image.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/utils/u_image.dart';
import 'package:flutter/services.dart';
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
  static const Curve _scrollCurve = Curves.ease;
  static const Duration _scrollDuration = Duration(milliseconds: 250);

  late final PageController _controller;

  int _currentPage = 0;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _controller = PageController(initialPage: widget.index);
    _currentPage = widget.index;

    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Material(
        color: Colors.black,
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
            SafeArea(
              child: Stack(
                fit: .expand,
                children: [
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
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: .center,
                      children: [
                        M3EButtonGroup(
                          type: .connected,
                          onSelectedIndexChanged: (index) {
                            switch (index) {
                              case 0:
                                previousPage();
                                return;
                              case 1:
                                nextPage();
                                return;
                            }
                          },
                          actions: [
                            M3EButtonGroupAction(
                              decoration: getDecoration(_currentPage > 0),
                              enabled: _currentPage > 0,
                              icon: const Icon(Symbols.arrow_back_rounded),
                            ),
                            M3EButtonGroupAction(
                              decoration: getDecoration(
                                _currentPage < widget.urls.length - 1,
                              ),
                              enabled: _currentPage < widget.urls.length - 1,
                              icon: const Icon(Symbols.arrow_forward_rounded),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  M3EButtonDecoration getDecoration(bool enabled) {
    return M3EButtonDecoration(
      backgroundColor: .all(
        enabled
            ? context.colorScheme.primaryContainer
            : Color.lerp(
                context.colorScheme.primaryContainer,
                Colors.grey,
                0.75,
              ),
      ),
      foregroundColor: .all(
        enabled
            ? context.colorScheme.onPrimaryContainer
            : Color.lerp(
                context.colorScheme.onPrimaryContainer,
                Colors.grey,
                0.25,
              ),
      ),
    );
  }

  void previousPage() {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
      _controller.previousPage(duration: _scrollDuration, curve: _scrollCurve);
    }
  }

  void nextPage() {
    if (_currentPage < widget.urls.length - 1) {
      setState(() => _currentPage++);
      _controller.nextPage(duration: _scrollDuration, curve: _scrollCurve);
    }
  }
}
