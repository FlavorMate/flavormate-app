import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/storage/shared_preferences/enums/image_mode.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/settings/p_settings_image_mode.dart';
import 'package:flavormate/generated/flutter_gen/assets.gen.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/features/settings/settings_app/subpages/image_mode/widgets/settings_app_image_mode_example.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsAppImageModePage extends ConsumerWidget {
  const SettingsAppImageModePage({super.key});

  final PSettingsImageModeProvider provider = pSettingsImageModeProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);

    return Scaffold(
      appBar: FAppBar(
        title: context.l10n.settings_app_image_mode_page__title,
      ),
      body: SafeArea(
        child: FResponsive(
          child: Column(
            spacing: PADDING,
            children: [
              FText(
                context.l10n.settings_app_image_mode_page__hint_1,
                style: .bodyLarge,
              ),
              SettingsAppImageModeExample(
                label: context.l10n.settings_app_image_mode_page__fit_mode,
                hint: context.l10n.settings_app_image_mode_page__hint_2,
                image: Assets.images.settings.imageMode.a169.path,
                value: ImageMode.Wide,
                state: state == ImageMode.Wide,
                onTap: (val) => setMode(ref, val),
              ),
              SettingsAppImageModeExample(
                label: context.l10n.settings_app_image_mode_page__fill_mode,
                hint: context.l10n.settings_app_image_mode_page__hint_3,
                image: Assets.images.settings.imageMode.original.path,
                value: ImageMode.Scale,
                state: state == ImageMode.Scale,
                onTap: (val) => setMode(ref, val),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setMode(WidgetRef ref, ImageMode value) {
    ref.read(pSettingsImageModeProvider.notifier).set(value);
  }
}
