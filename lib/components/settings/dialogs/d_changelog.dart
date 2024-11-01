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

class DChangelog extends ConsumerStatefulWidget {
  const DChangelog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DChangelogState();
}

class _DChangelogState extends ConsumerState<DChangelog> {
  late ChangelogVersion? current;

  @override
  void initState() {
    ref.listenManual(
      pChangelogProvider,
      fireImmediately: true,
      (_, value) {
        if (!value.hasValue) return;
        current = value.value!.sorted.first;
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            SizedBox(height: PADDING),
            RStruct(
                provider,
                (_, value) => SizedBox(
                      width: 200,
                      child: DropdownButtonFormField(
                        value: current,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hoverColor: Colors.red,
                          focusColor: Colors.blue,
                          fillColor: Colors.yellow,
                          filled: false,
                        ),
                        // borderRadius: BorderRadius.circular(BORDER_RADIUS),
                        items: value.sorted
                            .map(
                              (version) => DropdownMenuItem(
                                value: version,
                                child: Text('${version.version}'),
                              ),
                            )
                            .toList(),
                        onChanged: (val) => setState(() => current = val!),
                      ),
                    )),
            SizedBox(height: PADDING * 3),
            Expanded(
              child: SingleChildScrollView(
                child: TColumn(
                  space: PADDING * 2.5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final change in current!.details)
                      _Detail(detail: change),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            height: 80,
            padding: const EdgeInsets.all(PADDING),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TButton(
                  width: 300,
                  onPressed: () => context.pop(),
                  label: L10n.of(context).btn_close,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  final ChangelogDetail detail;

  const _Detail({
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return TRow(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          MdiIcons.values.byName(detail.icon),
          size: 32,
        ),
        SizedBox(
          width: 250,
          child: TText(detail.change, TextStyles.bodyMedium),
        ),
      ],
    );
  }
}
