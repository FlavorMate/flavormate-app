import 'package:flavormate/core/constants/constants.dart';
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
  final String? Function(ImageWideResolution) coverSelector;
  final String? subLabel;
  final FImageType imageType;

  const FImageCard({
    super.key,
    required this.label,
    required this.coverSelector,
    required this.contentWidth,
    this.imageType = FImageType.secure,
    this.onTap,
    this.subLabel,
  });

  static SizedBox maximized({
    String? label,
    required String? Function(ImageWideResolution) coverSelector,
    double height = 200,
    double width = double.infinity,
    FImageType imageType = FImageType.secure,
    VoidCallback? onTap,
    String? subLabel,
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
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final resolution = UImage.getResolution(ref, context, constraints);

        final opacity = calculateOpacity(constraints.maxWidth);
        return Stack(
          fit: StackFit.expand,
          children: [
            FImage(imageSrc: coverSelector.call(resolution), type: imageType),
            if (label != null || subLabel != null)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(BORDER_RADIUS),
                  gradient: const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black54, Colors.transparent],
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
                              maxLines: 2,
                              weight: FontWeight.w600,
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
        );
      },
    );
  }

  /// Returns the minimum width for an item by subtracting padding from both sides of parent width.
  double get labelWidth => contentWidth - PADDING * 2;

  double get fadeStart => contentWidth;

  double get fadeEnd => contentWidth + fadeRange;

  /// Calculates opacity value based on width parameter using a fade range.
  ///
  /// Returns 0 if width is less than or equal to fadeStart.
  /// Returns 1 if width is greater than or equal to fadeEnd.
  /// Otherwise returns a value between 0 and 1 based on width's position within the fade range.
  ///
  /// The fade range is defined between fadeStart and fadeEnd values.
  /// Linear interpolation is used for values within the fade range.
  double calculateOpacity(double width) => width <= fadeStart
      ? 0
      : (width >= fadeEnd ? 1 : (width - fadeStart) / fadeRange);
}
