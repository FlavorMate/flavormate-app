import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/storage/shared_preferences/enums/sp_settings_image_mode.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/settings/p_settings_full_image.dart';
import 'package:flavormate/generated/flutter_gen/assets.gen.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/features/settings/subpages/full_image/widgets/settings_full_image_example.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsFullImagePage extends ConsumerStatefulWidget {
  const SettingsFullImagePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SettingsFullImagePageState();

  final PSettingsFullImageProvider provider = pSettingsFullImageProvider;
}

class _SettingsFullImagePageState extends ConsumerState<SettingsFullImagePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);

    return Scaffold(
      appBar: FAppBar(
        title: L10n.of(context).settings_full_image_page__title,
      ),
      body: SafeArea(
        child: FResponsive(
          child: Column(
            spacing: PADDING,
            children: [
              Column(
                crossAxisAlignment: .start,
                children: [
                  FText(
                    L10n.of(context).settings_full_image_page__hint_1,
                    style: .bodyLarge,
                  ),
                  const SizedBox(height: PADDING),
                  FText(
                    L10n.of(context).settings_full_image_page__fit_mode,
                    style: .titleMedium,
                    textAlign: .justify,
                  ),
                  const SizedBox(height: PADDING / 2),
                  FText(
                    L10n.of(context).settings_full_image_page__hint_2,
                    style: .bodyLarge,
                    textAlign: .justify,
                  ),
                  const SizedBox(height: PADDING),
                  FText(
                    L10n.of(context).settings_full_image_page__fill_mode,
                    style: .titleMedium,
                    textAlign: .justify,
                  ),
                  const SizedBox(height: PADDING / 2),
                  FText(
                    L10n.of(context).settings_full_image_page__hint_3,
                    style: .bodyLarge,
                    textAlign: .justify,
                  ),
                ],
              ),
              const Divider(),
              SettingsFullImageExample(
                label: L10n.of(context).settings_full_image_page__fit_mode,
                image: Assets.images.settings.fullImage.a169.path,
                onTap: setMode,
                value: SpSettingsImageMode.FitMode,
                state: state == SpSettingsImageMode.FitMode,
              ),
              SettingsFullImageExample(
                label: L10n.of(context).settings_full_image_page__fill_mode,
                image: Assets.images.settings.fullImage.original.path,
                onTap: setMode,
                value: SpSettingsImageMode.FillMode,
                state: state == SpSettingsImageMode.FillMode,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setMode(SpSettingsImageMode value) {
    ref.read(pSettingsFullImageProvider.notifier).set(value);
  }
}
