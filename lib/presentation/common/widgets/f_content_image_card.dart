import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/settings/p_settings_image_mode.dart';
import 'package:flavormate/core/utils/u_image.dart';
import 'package:flavormate/data/models/shared/enums/image_resolution.dart';
import 'package:flavormate/presentation/common/widgets/f_image/f_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FContentImageCard extends ConsumerWidget {
  final String? Function(ImageResolution)? imageSelector;
  final VoidCallback onTap;
  final bool first;
  final bool last;

  final List<Widget>? children;

  final double height;

  const FContentImageCard({
    super.key,
    this.first = false,
    this.last = false,
    required this.imageSelector,
    required this.onTap,
    this.height = 192,
    this.children,
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
                FImage(
                  imageSrc: imageSelector?.call(resolution),
                  type: .secure,
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onTap,
                    ),
                  ),
                ),
                ...?children,
              ],
            ),
          );
        },
      ),
    );
  }
}
