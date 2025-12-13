import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/settings/p_settings_image_mode.dart';
import 'package:flavormate/core/utils/u_image.dart';
import 'package:flavormate/data/models/shared/enums/image_resolution.dart';
import 'package:flavormate/presentation/common/widgets/f_image/f_image.dart';
import 'package:flavormate/presentation/common/widgets/f_message/f_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FMessageImage extends ConsumerWidget implements FMessage {
  final String Function(ImageResolution) imageBuilder;

  const FMessageImage({
    super.key,
    required this.imageBuilder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageMode = ref.read(pSettingsImageModeProvider);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: GestureDetector(
        onTap: () => context.showFullscreenImage(imageBuilder.call(.Original)),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final resolution = UImage.getResolution(
                ref,
                context,
                imageMode,
                constraints.maxWidth,
              );

              return FImage(
                imageSrc: imageBuilder.call(resolution),
                type: .secure,
              );
            },
          ),
        ),
      ),
    );
  }
}
