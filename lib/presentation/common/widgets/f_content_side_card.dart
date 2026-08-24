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

class FContentSideCard extends ConsumerWidget {
  final String title;
  final String? subtitle;

  final String? Function(ImageResolution)? imageSelector;

  final VoidCallback onTap;

  final bool first;
  final bool last;

  bool get single => first && last;

  static const double _imageWidth = 128;

  const FContentSideCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.imageSelector,
    required this.onTap,
    this.first = false,
    this.last = false,
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final resolution = UImage.getResolution(
          ref,
          context,
          imageMode,
          _imageWidth,
        );

        return SizedBox(
          height: 96,
          child: M3ECard(
            variant: .filled,
            borderRadius: borderRadius,
            color: context.colorScheme.surfaceContainer,
            onPressed: onTap,
            padding: .zero,
            child: Row(
              children: [
                SizedBox(
                  width: _imageWidth,
                  height: double.infinity,
                  child: FImage(
                    imageSrc: imageSelector?.call(resolution),
                    type: .secure,
                    fit: .cover,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const .all(PADDING),
                    child: Column(
                      mainAxisAlignment: .center,
                      crossAxisAlignment: .start,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: .centerLeft,
                            child: FText(
                              title,
                              style: .bodyLarge,
                              color: .onPrimaryContainer,
                              fontRoundness: subtitle == null ? 0 : 100,
                              fontWeight: subtitle == null ? .normal : .w500,
                              textOverflow: .ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ),
                        ?subtitle?.let(
                          (it) => FText(
                            it,
                            style: .bodyMedium,
                            color: .grey,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
