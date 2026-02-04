import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';

class FM3EAppbar extends StatefulWidget {
  static const double _expandedHeight = 180;
  static const double _collapsedHeight = kToolbarHeight;

  final ScrollController controller;
  final String smallLabel;
  final String? largeLabel;

  final List<Widget> actions;

  const FM3EAppbar({
    super.key,
    required this.controller,
    required this.smallLabel,
    this.largeLabel,
    this.actions = const [],
  });

  @override
  State<FM3EAppbar> createState() => _FM3EAppbarState();
}

class _FM3EAppbarState extends State<FM3EAppbar> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.jumpTo(FM3EAppbar._expandedHeight - kToolbarHeight);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: FM3EAppbar._expandedHeight,
      forceMaterialTransparency: true,
      actions: widget.actions,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final progress =
              ((constraints.maxHeight - FM3EAppbar._collapsedHeight) /
                      (FM3EAppbar._expandedHeight -
                          FM3EAppbar._collapsedHeight))
                  .clamp(0.0, 1.0);

          // Expressive timing window
          const largeFadeStart = 0.70;
          const largeFadeEnd = 0.40;
          const smallFadeStart = 0.35;

          final largeOpacity = switch (progress) {
            >= largeFadeStart => 1.0,
            < largeFadeStart && > largeFadeEnd =>
              (progress - largeFadeEnd) / (1 - largeFadeEnd),
            _ => 0.0,
          };

          final smallOpacity = progress < smallFadeStart
              ? (smallFadeStart - progress) / smallFadeStart
              : 0.0;

          return Stack(
            fit: StackFit.expand,
            children: [
              // Large title (left, expanded area)
              Positioned(
                left: PADDING,
                bottom: PADDING,
                child: Opacity(
                  opacity: largeOpacity,
                  child: FText(
                    widget.largeLabel ?? widget.smallLabel,
                    style: .headlineMedium,
                    fontRoundness: 100,
                  ),
                ),
              ),

              Align(
                alignment: .topCenter,
                child: Container(
                  height: kToolbarHeight,
                  color: context.colorScheme.surface,
                ),
              ),

              // Small title
              Positioned(
                top:
                    MediaQuery.of(context).padding.top +
                    (kToolbarHeight - 28) / 2,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: smallOpacity,
                  child: Center(
                    child: GestureDetector(
                      onTap: () => scrollToTop(),
                      child: FText(
                        widget.smallLabel,
                        style: .titleLarge,
                        fontRoundness: 100,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void scrollToTop() {
    widget.controller.animateTo(
      FM3EAppbar._expandedHeight - kToolbarHeight,
      duration: const Duration(milliseconds: 250),
      curve: Curves.ease,
    );
  }
}
