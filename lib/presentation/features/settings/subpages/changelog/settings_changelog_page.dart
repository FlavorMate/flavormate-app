import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/storage/root_bundle/changelog/p_rb_changelog.dart';
import 'package:flavormate/data/models/changelog/changelog.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_page.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsChangelogPage extends ConsumerStatefulWidget {
  const SettingsChangelogPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangelogDialogState();

  PRBChangelogProvider get provider => pRBChangelogProvider;
}

class _ChangelogDialogState extends ConsumerState<SettingsChangelogPage> {
  final double _buttonWidth = 100;

  ChangelogVersion? current;

  @override
  void initState() {
    ref.listenManual(pRBChangelogProvider, fireImmediately: true, (_, value) {
      if (!value.hasValue) return;
      current = value.value!.sorted.first;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FProviderPage(
      provider: widget.provider,
      appBarBuilder: (_, _) =>
          FAppBar(title: L10n.of(context).settings_changelog_page__title),
      builder: (_, data) => Column(
        children: [
          const SizedBox(height: PADDING),
          MenuAnchor(
            style: MenuStyle(
              maximumSize: WidgetStateProperty.resolveWith<Size?>(
                (_) => const Size.fromHeight(250),
              ),
            ),
            builder: (_, controller, widget) => SizedBox(
              width: _buttonWidth,
              child: OutlinedButton(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                child: FText(
                  current?.version.toString() ?? '',
                  style: FTextStyle.titleMedium,
                  color: FTextColor.onPrimaryContainer,
                ),
              ),
            ),
            menuChildren: [
              for (final entry in data.sorted)
                SizedBox(
                  width: _buttonWidth,
                  child: MenuItemButton(
                    child: Center(
                      child: FText(
                        entry.version.toString(),
                        style: FTextStyle.titleMedium,
                        color: FTextColor.onPrimaryContainer,
                      ),
                    ),
                    onPressed: () => setState(() => current = entry),
                  ),
                ),
            ],
          ),

          const SizedBox(height: PADDING * 3),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                spacing: PADDING * 2.5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final change in current?.details ?? [])
                    _Detail(detail: change),
                ],
              ),
            ),
          ),
        ],
      ),
      onError: FEmptyMessage(
        title: L10n.of(context).settings_changelog_page__on_error,
        icon: StateIconConstants.changelog.errorIcon,
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  final ChangelogDetail detail;

  const _Detail({required this.detail});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: PADDING,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(MdiIcons.values.byName(detail.icon), size: 32),
        SizedBox(
          width: 250,
          child: FText(detail.change, style: FTextStyle.bodyMedium),
        ),
      ],
    );
  }
}
