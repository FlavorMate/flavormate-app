import 'package:flavormate/components/riverpod/r_struct.dart';
import 'package:flavormate/components/t_button.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_row.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/changelog/changelog.dart';
import 'package:flavormate/riverpod/changelog/p_changelog.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DChangelog extends ConsumerWidget {
  const DChangelog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(pChangelogProvider);
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
          forceMaterialTransparency: true,
        ),
        body: Column(
          children: [
            TText(
              L10n.of(context).d_changelog_title,
              TextStyles.headlineMedium,
            ),
            SizedBox(height: 48),
            Expanded(
              child: SingleChildScrollView(
                child: RStruct(
                  provider,
                  (_, changelogs) => TColumn(
                    space: PADDING * 2.5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final changelog in changelogs)
                        ChangelogEntry(changelog: changelog),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            height: 80,
            padding: const EdgeInsets.all(PADDING),
            constraints: BoxConstraints(maxWidth: Breakpoints.sm),
            child: TButton(
              onPressed: () => context.pop(),
              label: L10n.of(context).btn_close,
            ),
          ),
        ),
      ),
    );
  }
}

class ChangelogEntry extends StatelessWidget {
  final Changelog changelog;

  const ChangelogEntry({
    super.key,
    required this.changelog,
  });

  @override
  Widget build(BuildContext context) {
    return TRow(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          MdiIcons.values.byName(changelog.icon),
          size: 48,
        ),
        TColumn(
          space: 4,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TText(changelog.version, TextStyles.titleMedium),
            for (final change in changelog.changes)
              SizedBox(
                width: 250,
                child: TText(change, TextStyles.bodyMedium),
              ),
          ],
        ),
      ],
    );
  }
}
