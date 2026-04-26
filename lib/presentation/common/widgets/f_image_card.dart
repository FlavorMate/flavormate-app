import 'dart:ui';

import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/settings/p_settings_image_mode.dart';
import 'package:flavormate/core/utils/u_image.dart';
import 'package:flavormate/data/models/shared/enums/image_resolution.dart';
import 'package:flavormate/presentation/common/widgets/f_image/f_image.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FImageCard extends ConsumerWidget {
  static const double fadeRange = 40;

  final VoidCallback? onTap;
  final double contentWidth;
  final String? label;
  final String? Function(ImageResolution) coverSelector;
  final String? subLabel;
  final FImageType imageType;
  final BorderRadiusGeometry? borderRadius;

  const FImageCard({
    super.key,
    required this.label,
    required this.coverSelector,
    required this.contentWidth,
    this.imageType = FImageType.secure,
    this.onTap,
    this.subLabel,
    this.borderRadius,
  });

  static SizedBox maximized({
    String? label,
    required String? Function(ImageResolution) coverSelector,
    double height = 200,
    double width = double.infinity,
    FImageType imageType = FImageType.secure,
    VoidCallback? onTap,
    String? subLabel,
    BorderRadiusGeometry? borderRadius,
  }) {
    return SizedBox(
      height: height,
      width: width,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return FImageCard(
            label: label,
            coverSelector: coverSelector,
            contentWidth: constraints.maxWidth - fadeRange,
            onTap: onTap,
            imageType: imageType,
            subLabel: subLabel,
            borderRadius: borderRadius,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageMode = ref.watch(pSettingsImageModeProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final resolution = UImage.getResolution(
          ref,
          context,
          imageMode,
          constraints.maxWidth,
        );

        final (backdropStart, backdropEnd) = calculateBackdrop(
          context,
          constraints.maxHeight,
        );

        final opacity = calculateOpacity(constraints.maxWidth);

        return ClipRRect(
          borderRadius: borderRadius ?? .circular(BORDER_RADIUS),
          child: Stack(
            fit: StackFit.expand,
            children: [
              FImage(imageSrc: coverSelector.call(resolution), type: imageType),
              if (label != null || subLabel != null)
                Opacity(
                  opacity: opacity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: const [
                          Colors.black54,
                          Colors.transparent,
                        ],
                        stops: [
                          backdropStart,
                          backdropEnd,
                        ],
                      ),
                    ),
                  ),
                ),
              if (label != null || subLabel != null)
                OverflowBox(
                  alignment: Alignment.bottomLeft,
                  minWidth: contentWidth,
                  maxWidth: contentWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(PADDING),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Opacity(
                        opacity: opacity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (label != null)
                              FText(
                                label!,
                                style: FTextStyle.titleLarge,
                                fontSize: 20,
                                maxLines: 4,
                                fontWeight: FontWeight.w600,
                                textOverflow: TextOverflow.ellipsis,
                                color: FTextColor.white,
                              ),
                            if (subLabel != null)
                              FText(
                                subLabel!,
                                style: FTextStyle.bodyMedium,
                                maxLines: 2,
                                textOverflow: TextOverflow.ellipsis,
                                color: FTextColor.white,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(BORDER_RADIUS),
                    onTap: onTap,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Returns the minimum width for an item by subtracting padding from both sides of parent width.
  double get labelWidth => contentWidth - PADDING * 2;

  double get fadeStart => contentWidth - fadeRange;

  double get fadeEnd => contentWidth;

  /// Calculates opacity value based on width parameter using a fade range.
  ///
  /// Returns 0 if width is less than or equal to fadeStart.
  /// Returns 1 if width is greater than or equal to fadeEnd.
  /// Otherwise returns a value between 0 and 1 based on width's position within the fade range.
  ///
  /// The fade range is defined between fadeStart and fadeEnd values.
  /// Linear interpolation is used for values within the fade range.
  double calculateOpacity(double width) {
    return width <= fadeStart
        ? 0
        : (width >= fadeEnd ? 1 : (width - fadeStart) / fadeRange);
  }

  /// Calculates the start and end point for the backdrop,
  /// so text is always readable.
  ///
  /// One label line is 25px tall while a subLabel line is 20px tall.
  /// Padding is added on top and on bottom
  (double, double) calculateBackdrop(BuildContext context, double maxHeight) {
    final span = TextSpan(
      text: label,
      style: context.textTheme.titleLarge!.copyWith(
        fontSize: 20,
        fontWeight: .w700,
        fontVariations: [
          const FontVariation.weight(700),
        ],
      ),
    );
    final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout(maxWidth: contentWidth - 2 * PADDING);
    final numLines = tp.computeLineMetrics().length.clamp(0, 4);

    final titleHeight = numLines * 25;
    final paddingHeight = titleHeight + 2 * PADDING;

    final subtitleHeight = subLabel != null
        ? paddingHeight + 20
        : paddingHeight;

    final backdropStart = subtitleHeight / maxHeight;
    final backdropEnd = clampDouble(backdropStart + 0.25, backdropStart, 1);

    return (backdropStart, backdropEnd);
  }
}
