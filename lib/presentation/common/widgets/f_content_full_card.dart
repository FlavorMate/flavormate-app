import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_object.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/settings/p_settings_image_mode.dart';
import 'package:flavormate/core/utils/u_image.dart';
import 'package:flavormate/data/models/shared/enums/image_resolution.dart';
import 'package:flavormate/presentation/common/widgets/f_image/f_image.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

class FContentFullCard extends ConsumerWidget {
  static const double HEIGHT = 96 - 16 + 4;

  final String title;
  final String? subtitle;
  final double blurRadius;
  final String? Function(ImageResolution)? imageSelector;
  final VoidCallback onTap;

  final bool topLeft;
  final bool topRight;
  final bool bottomLeft;
  final bool bottomRight;

  final double height;

  const FContentFullCard({
    super.key,
    required this.title,
    this.subtitle,
    this.blurRadius = 4,
    this.imageSelector,
    required this.onTap,
    this.height = HEIGHT,
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
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

          return M3ECard(
            variant: .filled,
            borderRadius: borderRadius,
            elevation: 0,
            padding: .zero,
            onPressed: onTap,
            child: Stack(
              fit: .expand,
              children: [
                FImage.blur(
                  imageSrc: imageSelector?.call(resolution),
                  onError: Container(
                    color: Color.lerp(
                      context.colorScheme.inversePrimary,
                      Colors.black,
                      0.15,
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
                        style: .bodyLarge,
                        color: .white,
                        maxLines: 1,
                        fontWeight: .w500,
                        fontRoundness: 100,
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
              ],
            ),
          );
        },
      ),
    );
  }
}
