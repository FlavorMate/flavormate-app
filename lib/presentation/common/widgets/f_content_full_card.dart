import 'dart:ui';

import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_object.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/settings/p_settings_image_mode.dart';
import 'package:flavormate/core/utils/u_image.dart';
import 'package:flavormate/data/models/shared/enums/image_resolution.dart';
import 'package:flavormate/presentation/common/widgets/f_image/f_image.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FContentFullCard extends ConsumerWidget {
  final String title;
  final String? subtitle;
  final double blurRadius;
  final String? Function(ImageResolution)? imageSelector;
  final VoidCallback onTap;
  final bool first;
  final bool last;

  final double height;

  const FContentFullCard({
    super.key,
    this.first = false,
    this.last = false,
    required this.title,
    this.subtitle,
    this.blurRadius = 4,
    this.imageSelector,
    required this.onTap,
    this.height = 96,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageMode = ref.watch(pSettingsImageModeProvider);

    final top = first ? BORDER_RADIUS_OUT : BORDER_RADIUS_IN;
    final bottom = last ? BORDER_RADIUS_OUT : BORDER_RADIUS_IN;

    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final resolution = UImage.getResolution(
            ref,
            context,
            imageMode,
            constraints.maxWidth,
          );

          return ClipRRect(
            borderRadius: .only(
              topLeft: .circular(top),
              topRight: .circular(top),
              bottomLeft: .circular(bottom),
              bottomRight: .circular(bottom),
            ),
            child: Stack(
              fit: .expand,
              children: [
                Transform.scale(
                  scale: 1.05,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: blurRadius,
                      sigmaY: blurRadius,
                    ),
                    child: FImage(
                      imageSrc: imageSelector?.call(resolution),
                      type: .secure,
                      fit: .cover,
                      onError: Container(
                        color: Color.lerp(
                          context.colorScheme.inversePrimary,
                          Colors.black,
                          0.15,
                        ),
                      ),
                    ),
                  ),
                ),

                Container(color: Colors.black54),

                Padding(
                  padding: const .all(PADDING),
                  child: Column(
                    mainAxisSize: .max,
                    mainAxisAlignment: .spaceEvenly,
                    crossAxisAlignment: .start,
                    children: [
                      FText(
                        title,
                        style: .titleLarge,
                        color: .white,
                        maxLines: subtitle == null ? 2 : 1,
                        textOverflow: .ellipsis,
                      ),

                      ?subtitle?.let(
                        (it) => FText(
                          it,
                          style: .bodyMedium,
                          color: .white,
                          maxLines: 1,
                          textOverflow: .ellipsis,
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
          );
        },
      ),
    );
  }
}
