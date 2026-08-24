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
  final String title;
  final String? subtitle;
  final double blurRadius;
  final String? Function(ImageResolution)? imageSelector;
  final VoidCallback onTap;
  final bool first;
  final bool last;

  bool get single => first && last;

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
    this.height = 96 - 16 + 4,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = M3ETheme.of(context).listTheme.cardList;
    final imageMode = ref.watch(pSettingsImageModeProvider);

    final M3ECardPosition position = single
        ? .single
        : first
        ? .first
        : last
        ? .last
        : .middle;

    final borderRadius = calculateCardRadius(
      position: position,
      outerRadius: theme.outerRadius,
      innerRadius: theme.innerRadius,
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
