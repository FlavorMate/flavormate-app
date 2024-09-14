import 'package:flavormate/components/dialogs/t_loading_dialog.dart';
import 'package:flavormate/components/drafts/d_scrape.dart';
import 'package:flavormate/components/riverpod/r_scaffold.dart';
import 'package:flavormate/components/t_app_bar.dart';
import 'package:flavormate/components/t_button.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_responsive.dart';
import 'package:flavormate/extensions/e_build_context.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/riverpod/draft/p_drafts.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DraftsPage extends ConsumerWidget {
  const DraftsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(pDraftsProvider);
    return RScaffold(
      provider,
      appBar: TAppBar(title: L10n.of(context).p_drafts_title),
      builder: (_, drafts) => TResponsive(
        child: TColumn(
          children: [
            TButton(
              onPressed: () => createDraft(context, ref),
              label: L10n.of(context).p_drafts_create_draft,
              leading: const Icon(MdiIcons.plus),
            ),
            TButton(
              onPressed: () => scrapeDraft(context, ref),
              label: L10n.of(context).p_drafts_scrape_draft,
              leading: const Icon(MdiIcons.download),
            ),
            if (drafts.isNotEmpty) const SizedBox(height: PADDING),
            if (drafts.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: DataTable(
                  showCheckboxColumn: false,
                  columns: [
                    const DataColumn(label: Text('Name')),
                    const DataColumn(label: Text('State')),
                    DataColumn(label: Container()),
                  ],
                  rows: [
                    for (final draft in drafts)
                      DataRow(
                        onSelectChanged: (value) => openDraft(
                          context,
                          value,
                          draft.id,
                        ),
                        cells: [
                          DataCell(SizedBox(
                              width: double.infinity,
                              child:
                                  Text(draft.recipeDraft.label ?? 'unnamed'))),
                          DataCell(Text(draft.version <= 0 ? 'new' : 'update')),
                          DataCell(IconButton(
                            icon: Icon(
                              MdiIcons.delete,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            onPressed: () => deleteDraft(ref, draft.id),
                          )),
                        ],
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> createDraft(BuildContext context, WidgetRef ref) async {
    final id = await ref.read(pDraftsProvider.notifier).createDraft();
    openDraft(context, true, id);
  }

  deleteDraft(WidgetRef ref, int id) async {
    await ref.read(pDraftsProvider.notifier).deleteDraft(id);
  }

  void openDraft(BuildContext context, bool? value, int id) {
    if (value != true) return;

    context.pushNamed(
      'editor',
      pathParameters: {'id': id.toString()},
    );
  }

  void scrapeDraft(BuildContext context, WidgetRef ref) async {
    try {
      final response =
          await showDialog<String>(context: context, builder: (_) => DScrape());

      if (response == null) return;

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => TLoadingDialog(),
      );

      final id = await ref.read(pDraftsProvider.notifier).scrape(response);

      context.pop();

      openDraft(context, true, id);
    } catch (e) {
      context.pop();
      context.showTextSnackBar(L10n.of(context).p_drafts_scrape_failed);
    }
  }
}
