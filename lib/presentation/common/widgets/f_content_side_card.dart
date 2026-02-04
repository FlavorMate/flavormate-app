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

class FContentSideCard extends ConsumerWidget {
  final String title;
  final String? subtitle;

  final String? Function(ImageResolution)? imageSelector;

  final VoidCallback onTap;

  final bool first;
  final bool last;

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
    final imageMode = ref.watch(pSettingsImageModeProvider);

    final top = first ? 16.0 : 4.0;
    final bottom = last ? 16.0 : 4.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final resolution = UImage.getResolution(
          ref,
          context,
          imageMode,
          constraints.maxWidth,
        );

        return SizedBox(
          height: 96,
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
                  Row(
                    children: [
                      SizedBox(
                        width: 128,
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
                                    style: .titleMedium,
                                    textOverflow: .ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                              ?subtitle?.let(
                                (it) => FText(
                                  it,
                                  style: .bodySmall,
                                  color: .onPrimaryContainer,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
}
