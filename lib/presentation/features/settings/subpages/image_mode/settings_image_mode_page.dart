import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/storage/shared_preferences/enums/sp_settings_image_mode.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/settings/p_settings_image_mode.dart';
import 'package:flavormate/generated/flutter_gen/assets.gen.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/features/settings/subpages/image_mode/widgets/settings_image_mode_example.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsImageModePage extends ConsumerWidget {
  const SettingsImageModePage({super.key});

  final PSettingsImageModeProvider provider = pSettingsImageModeProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);

    return Scaffold(
      appBar: FAppBar(
        title: L10n.of(context).settings_image_mode_page__title,
      ),
      body: SafeArea(
        child: FResponsive(
          child: Column(
            spacing: PADDING,
            children: [
              FText(
                L10n.of(context).settings_image_mode_page__hint_1,
                style: .bodyLarge,
              ),
              SettingsImageModeExample(
                label: L10n.of(
                  context,
                ).settings_image_mode_page__fit_mode,
                hint: L10n.of(
                  context,
                ).settings_image_mode_page__hint_2,
                image: Assets.images.settings.imageMode.a169.path,
                value: SpSettingsImageMode.FitMode,
                state: state == SpSettingsImageMode.FitMode,
                onTap: (val) => setMode(ref, val),
              ),
              SettingsImageModeExample(
                label: L10n.of(
                  context,
                ).settings_image_mode_page__fill_mode,
                hint: L10n.of(
                  context,
                ).settings_image_mode_page__hint_3,
                image: Assets.images.settings.imageMode.original.path,
                value: SpSettingsImageMode.FillMode,
                state: state == SpSettingsImageMode.FillMode,
                onTap: (val) => setMode(ref, val),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setMode(WidgetRef ref, SpSettingsImageMode value) {
    ref.read(pSettingsImageModeProvider.notifier).set(value);
  }
}
