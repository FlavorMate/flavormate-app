import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/utils/u_image.dart';
import 'package:flavormate/data/models/shared/enums/image_resolution.dart';
import 'package:flavormate/presentation/common/widgets/f_image/f_image.dart';
import 'package:flavormate/presentation/common/widgets/f_message/f_message.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FMessageLink extends ConsumerWidget implements FMessage {
  final String Function(ImageWideResolution) imageBuilder;
  final VoidCallback onTap;

  final String linkLabel;

  const FMessageLink({
    super.key,
    required this.linkLabel,
    required this.imageBuilder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: context.colorScheme.surfaceContainer,
      constraints: const BoxConstraints(maxWidth: 300),
      child: GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final resolution = UImage.getResolution(
                ref,
                context,
                constraints,
              );

              return Column(
                children: [
                  FImage(
                    imageSrc: imageBuilder.call(resolution),
                    type: .secure,
                  ),
                  Padding(
                    padding: const .all(PADDING / 2),
                    child: Row(
                      spacing: PADDING,
                      children: [
                        const Icon(MdiIcons.link),
                        FText(
                          linkLabel,
                          style: .bodyMedium,
                          weight: .w600,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
