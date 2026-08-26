import 'package:flavormate/core/storage/shared_preferences/providers/settings/p_settings_image_mode.dart';
import 'package:flavormate/core/utils/u_image.dart';
import 'package:flavormate/data/models/shared/enums/image_resolution.dart';
import 'package:flavormate/presentation/common/widgets/f_image/f_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_3_expressive/components/lists/components/m3e_card_list_item.dart';
import 'package:material_3_expressive/components/lists/enums/m3e_list_enums.dart';
import 'package:material_3_expressive/foundations/foundations.dart';
import 'package:material_ui/material_ui.dart';

class FContentImageCard extends ConsumerWidget {
  final String? Function(ImageResolution)? imageSelector;
  final VoidCallback onTap;
  final bool first;
  final bool last;

  bool get single => first && last;

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
    final theme = M3ETheme.of(context).listTheme.cardList;

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

    final imageMode = ref.watch(pSettingsImageModeProvider);

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
