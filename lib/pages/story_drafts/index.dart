import 'package:flavormate/components/riverpod/r_scaffold.dart';
import 'package:flavormate/components/t_app_bar.dart';
import 'package:flavormate/components/t_button.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_responsive.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/riverpod/story_draft/p_story_drafts.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StoryDraftsPage extends ConsumerWidget {
  const StoryDraftsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(pStoryDraftsProvider);
    return RScaffold(
      provider,
      appBar: TAppBar(title: L10n.of(context).p_story_drafts_title),
      builder: (_, drafts) => TResponsive(
        child: TColumn(
          children: [
            TButton(
              onPressed: () => createDraft(context, ref),
              label: L10n.of(context).p_story_drafts_create,
              leading: const Icon(MdiIcons.plus),
            ),
            if (drafts.isNotEmpty) const SizedBox(height: PADDING),
            if (drafts.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: DataTable(
                  showCheckboxColumn: false,
                  columns: [
                    DataColumn(
                      label: Text(L10n.of(context).p_drafts_drafts_name),
                    ),
                    DataColumn(
                      label: Text(L10n.of(context).p_drafts_drafts_state),
                    ),
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
                          DataCell(
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                draft.label ??
                                    L10n.of(context)
                                        .p_drafts_drafts_name_unnamed,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              draft.version < 0
                                  ? L10n.of(context).p_drafts_drafts_state_new
                                  : L10n.of(context)
                                      .p_drafts_drafts_state_update,
                            ),
                          ),
                          DataCell(
                            IconButton(
                              icon: Icon(
                                MdiIcons.delete,
                                color: Colors.red.shade500,
                              ),
                              onPressed: () => deleteDraft(ref, draft.id),
                            ),
                          ),
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
    final id = await ref.read(pStoryDraftsProvider.notifier).createDraft();

    if (!context.mounted) return;
    openDraft(context, true, id);
  }

  deleteDraft(WidgetRef ref, int id) async {
    await ref.read(pStoryDraftsProvider.notifier).deleteDraft(id);
  }

  void openDraft(BuildContext context, bool? value, int id) {
    if (value != true) return;

    if (!context.mounted) return;
    context.pushNamed(
      'storyEditor',
      pathParameters: {'id': id.toString()},
    );
  }
}