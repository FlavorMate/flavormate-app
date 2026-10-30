import 'package:flavormate/core/storage/shared_preferences/providers/settings/p_settings_image_mode.dart';
import 'package:flavormate/core/utils/u_image.dart';
import 'package:flavormate/data/models/shared/enums/image_resolution.dart';
import 'package:flavormate/presentation/common/widgets/f_image/f_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_3_expressive/foundations/foundations.dart';
import 'package:material_ui/material_ui.dart';

class FContentImageCard extends ConsumerWidget {
  static const double HEIGHT = 192;

  final String? Function(ImageResolution)? imageSelector;
  final VoidCallback onTap;

  final bool topLeft;
  final bool topRight;
  final bool bottomLeft;
  final bool bottomRight;

  final List<Widget>? children;

  final double height;

  const FContentImageCard({
    super.key,
    required this.imageSelector,
    required this.onTap,
    this.height = HEIGHT,
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
    this.children,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = M3ETheme.of(context).listTheme.cardList;

    final imageMode = ref.watch(pSettingsImageModeProvider);

    final borderRadius = BorderRadius.only(
      topLeft: Radius.circular(topLeft ? theme.outerRadius : theme.innerRadius),
      topRight: Radius.circular(
        topRight ? theme.outerRadius : theme.innerRadius,
      ),
      bottomLeft: Radius.circular(
        bottomLeft ? theme.outerRadius : theme.innerRadius,
      ),
      bottomRight: Radius.circular(
        bottomRight ? theme.outerRadius : theme.innerRadius,
      ),
    );

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
            borderRadius: borderRadius,
            child: Stack(
              fit: .expand,
              children: [
                FImage(
                  imageSrc: imageSelector?.call(resolution),
                  type: .secure,
                ),

                GestureDetector(
                  onTap: onTap,
                  child: const MouseRegion(
                    cursor: SystemMouseCursors.click,
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
