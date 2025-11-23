import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/utils/u_image.dart';
import 'package:flavormate/data/models/shared/enums/image_resolution.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_image/f_image.dart';
import 'package:flavormate/presentation/common/widgets/f_image_card.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FCarousel<T> extends ConsumerStatefulWidget {
  static const double labelWidth = 200;

  final double height;

  final String? title;
  final void Function()? onShowAll;
  final List<T> data;
  final void Function(T)? onTap;
  final String? Function(T, ImageWideResolution) coverSelector;
  final String Function(T)? labelSelector;
  final String Function(T)? subLabelSelector;
  final FImageType imageType;

  const FCarousel({
    super.key,
    required this.data,
    required this.coverSelector,
    this.labelSelector,
    this.subLabelSelector,
    this.title,
    this.onTap,
    this.onShowAll,
    this.height = 250,
    this.imageType = FImageType.secure,
  });

  void Function(int)? get onTapCallback {
    if (onTap == null) {
      return null;
    } else {
      return (i) => onTap!(data.elementAt(i));
    }
  }

  List<int> getCurrentLayout(FBreakpoint breakpoint, int availableItems) {
    final layout = _layouts[breakpoint]!;

    if (layout.length <= availableItems) {
      return layout;
    } else {
      if (breakpoint == FBreakpoint.xs) return [12];

      return getCurrentLayout(breakpoint.previous!, availableItems);
    }
  }

  @override
  ConsumerState<FCarousel<T>> createState() => _FCarouselState<T>();
}

class _FCarouselState<T> extends ConsumerState<FCarousel<T>> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final currentBreakpoint = FBreakpoint.getCurrent(constraints.maxWidth);
        final layout = widget.getCurrentLayout(
          currentBreakpoint,
          widget.data.length,
        );
        final showAllButton = widget.data.length > 1;

        final resolution = UImage.getResolution(ref, context, constraints);

        return Column(
          spacing: PADDING / 4,
          children: [
            if (widget.title?.isNotEmpty ?? false)
              SizedBox(
                height: 40,
                child: Row(
                  spacing: PADDING / 4,
                  children: [
                    FText(
                      widget.title!,
                      style: FTextStyle.headlineSmall,
                      weight: .w500,
                    ),
                    if (showAllButton)
                      IconButton(
                        onPressed: widget.onShowAll,
                        icon: const Icon(MdiIcons.arrowRight),
                      ),
                  ],
                ),
              ),
            SizedBox(
              height: widget.height,
              child: CarouselView.weighted(
                flexWeights: layout,
                itemSnapping: true,
                onTap: widget.onTapCallback,
                enableSplash: widget.onTapCallback != null,
                children: [
                  for (final item in widget.data)
                    FImageCard(
                      label: widget.labelSelector?.call(item),
                      subLabel: widget.subLabelSelector?.call(item),
                      coverSelector: (_) =>
                          widget.coverSelector.call(item, resolution),
                      contentWidth: FCarousel.labelWidth,
                      imageType: widget.imageType,
                    ),
                ],
              ),
            ),
            if (showAllButton && (widget.title?.isEmpty ?? true))
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: widget.onShowAll,
                  child: Text(L10n.of(context).btn_show_more),
                ),
              ),
          ],
        );
      },
    );
  }
}

const _layouts = {
  FBreakpoint.xs: [10, 2],
  FBreakpoint.sm: [8, 3, 1],
  FBreakpoint.md: [6, 3, 2, 1],
  FBreakpoint.lg: [5, 3, 2, 1, 1],
  FBreakpoint.xl: [4, 3, 2, 1, 1, 1],
};
