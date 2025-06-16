import 'package:flavormate/components/t_card.dart';
import 'package:flavormate/components/t_gradient.dart';
import 'package:flavormate/components/t_image.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';

class TContentCard extends StatelessWidget {
  final double headerHeight;

  final Widget content;
  final double contentHeight;

  final IconData? emptyIcon;

  final List<Widget>? header;
  final String? imageUrl;
  final VoidCallback onTap;

  const TContentCard({
    super.key,
    required this.onTap,
    required this.content,
    required this.contentHeight,
    required this.emptyIcon,
    required this.imageUrl,
    this.header,
    this.headerHeight = 24,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: WIDGET_WIDTH,
      child: AspectRatio(
        aspectRatio: 16.0 / 9.0,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final pxPercent = 1 / constraints.maxHeight;
            final headerSection = (PADDING * 2 + headerHeight) * pxPercent;

            final contentSection =
                (constraints.maxHeight - PADDING * 2 - contentHeight) *
                pxPercent;

            return TCard(
              padding: 0,
              onTap: onTap,
              child: Stack(
                children: [
                  TImage(imageSrc: imageUrl, type: TImageType.network),
                  if (imageUrl != null)
                    TGradient(
                      showHeader: header?.isNotEmpty ?? false,
                      steps: [
                        0,
                        headerSection,
                        headerSection + 0.05,
                        contentSection - 0.05,
                        contentSection,
                        1,
                      ],
                    ),
                  Positioned.fill(
                    left: PADDING,
                    right: PADDING,
                    bottom: PADDING,
                    top: PADDING,
                    child: Column(
                      spacing: PADDING + 0.05,
                      children: [
                        if (header?.isNotEmpty ?? false)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: header!,
                          ),
                        Expanded(
                          child: imageUrl != null
                              ? const SizedBox.shrink()
                              : FittedBox(
                                  fit: BoxFit.fill,
                                  child: Icon(emptyIcon, color: Colors.white),
                                ),
                        ),
                        Align(alignment: Alignment.centerLeft, child: content),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
