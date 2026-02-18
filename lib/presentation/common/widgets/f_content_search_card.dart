import 'dart:ui';

import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/storage/shared_preferences/enums/image_mode.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/settings/p_settings_image_mode.dart';
import 'package:flavormate/core/utils/u_image.dart';
import 'package:flavormate/data/models/features/search/search_dto.dart';
import 'package:flavormate/data/models/shared/enums/image_resolution.dart';
import 'package:flavormate/presentation/common/widgets/f_image/f_image.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_m3shapes/flutter_m3shapes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FContentSearchCard extends ConsumerWidget {
  final SearchDto searchDto;

  final VoidCallback onTap;

  final bool first;
  final bool last;

  static const double _height = 96;

  const FContentSearchCard({
    super.key,
    required this.searchDto,
    required this.onTap,
    this.first = false,
    this.last = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageMode = ref.watch(pSettingsImageModeProvider);

    final top = first ? BORDER_RADIUS_OUT : BORDER_RADIUS_IN;
    final bottom = last ? BORDER_RADIUS_OUT : BORDER_RADIUS_IN;

    return LayoutBuilder(
      builder: (context, constraints) {
        final im = switch (searchDto.source) {
          .Account => ImageMode.Plane,
          _ => imageMode,
        };

        final resolution = UImage.getResolution(
          ref,
          context,
          im,
          _height - 2 * PADDING,
        );

        return SizedBox(
          height: _height,
          child: ClipRRect(
            borderRadius: .only(
              topLeft: .circular(top),
              topRight: .circular(top),
              bottomLeft: .circular(bottom),
              bottomRight: .circular(bottom),
            ),
            child: Material(
              color: context.colorScheme.surfaceContainer,
              child: Stack(
                fit: .expand,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(PADDING),
                    child: Row(
                      spacing: PADDING,
                      children: [
                        M3Container(
                          searchDto.source.shape,
                          height: _height - 2 * PADDING,
                          width: _height - 2 * PADDING,
                          color: context.colorScheme.onPrimaryContainer,
                          child: (searchDto.cover != null)
                              ? _buildLeadingImage(context, resolution)
                              : Icon(
                                  searchDto.source.icon,
                                  color: context.colorScheme.primaryContainer,
                                ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: .center,
                            crossAxisAlignment: .start,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: .centerLeft,
                                  child: FText(
                                    searchDto.label,
                                    style: .titleMedium,
                                    textOverflow: .ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                              FText(
                                searchDto.source.getName(context),
                                style: .bodyMedium,
                                color: .onPrimaryContainer,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onTap,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Stack _buildLeadingImage(
    BuildContext context,
    ImageResolution resolution,
  ) {
    return Stack(
      fit: .expand,
      children: [
        Transform.scale(
          scale: 1.05,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 1,
              sigmaY: 1,
            ),
            child: FImage(
              imageSrc: searchDto.url(resolution),
              type: .secure,
              fit: .cover,
              onError: Container(),
            ),
          ),
        ),
        Container(color: Colors.black45),
        Icon(
          searchDto.source.icon,
          color: Theme.brightnessOf(context) == .light
              ? context.colorScheme.primaryContainer
              : context.colorScheme.onPrimaryContainer,
        ),
      ],
    );
  }
}
