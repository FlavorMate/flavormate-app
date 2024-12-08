import 'package:data_table_2/data_table_2.dart';
import 'package:flavormate/components/dialogs/t_confirm_dialog.dart';
import 'package:flavormate/components/riverpod/r_struct.dart';
import 'package:flavormate/components/t_app_bar.dart';
import 'package:flavormate/extensions/e_date_time.dart';
import 'package:flavormate/extensions/e_string.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/user/token.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/riverpod/recipes/p_recipe.dart';
import 'package:flavormate/riverpod/tokens/p_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ShareManagementPage extends ConsumerStatefulWidget {
  const ShareManagementPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShareManagementPageState();
}

class _ShareManagementPageState extends ConsumerState<ShareManagementPage> {
  int? currentSortIndex;
  bool sortASC = true;

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(pTokensProvider);

    final double columnSpacing = 10;
    final double horizontalMargin = 24;

    final double minWidth = horizontalMargin * 2 +
        columnSpacing * 6 +
        160 * 3 +
        64 +
        128 * 1 +
        128 +
        72;

    return Scaffold(
      appBar: TAppBar(title: L10n.of(context).p_admin_share_title),
      body: SafeArea(
        child: RStruct(
          provider,
          (_, tokens) => DataTable2(
            isHorizontalScrollBarVisible: true,
            isVerticalScrollBarVisible: true,
            minWidth: minWidth,
            columnSpacing: columnSpacing,
            horizontalMargin: horizontalMargin,
            sortColumnIndex: currentSortIndex,
            sortAscending: sortASC,
            sortArrowIcon: MdiIcons.chevronUp,
            columns: [
              DataColumn2(
                label: Text(L10n.of(context).p_admin_share_username),
                fixedWidth: 128,
                onSort: (i, j) => sort(i),
              ),
              DataColumn2(
                label: Text(L10n.of(context).p_admin_share_type),
                fixedWidth: 64,
                onSort: (i, j) => sort(i),
              ),
              DataColumn2(
                label: Text(L10n.of(context).p_recipe_title),
                fixedWidth: 160,
              ),
              DataColumn2(
                label: Text(L10n.of(context).p_admin_share_created),
                fixedWidth: 160,
                onSort: (i, j) => sort(i),
              ),
              DataColumn2(
                label: Text(L10n.of(context).p_admin_share_valid_until),
                fixedWidth: 160,
                onSort: (i, j) => sort(i),
              ),
              DataColumn2(
                label: Text(L10n.of(context).p_admin_share_uses),
                fixedWidth: 128,
                numeric: true,
                onSort: (i, j) => sort(i),
              ),
              DataColumn2(
                label: SizedBox.shrink(),
                fixedWidth: 72,
              ),
            ],
            rows: [
              for (final token in tokens)
                DataRow2(
                  cells: [
                    DataCell(Text(token.owner.username)),
                    DataCell(Text(token.type)),
                    DataCell(
                      RStruct(
                        ref.watch(pRecipeProvider(token.content!)),
                        (_, recipe) => SizedBox(
                          width: 150,
                          child: FilledButton.tonal(
                            onPressed: () => context.pushNamed(
                              'recipe',
                              pathParameters: {'id': recipe.id.toString()},
                              extra: recipe.label,
                            ),
                            child: Text(
                              recipe.label.shorten(length: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                        Text(token.createdOn!.toLocalDateTimeString2(context))),
                    DataCell(
                      Text(
                        token.validUntil?.toLocalDateTimeString2(context) ??
                            '-',
                      ),
                    ),
                    DataCell(Text(token.uses.toString())),
                    DataCell(
                      Center(
                        child: IconButton(
                          color: Colors.red,
                          onPressed: () => deleteToken(context, ref, token),
                          icon: Icon(MdiIcons.delete),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  sort(int index) {
    if (currentSortIndex != index) {
      setState(() {
        sortASC = false;
        currentSortIndex = index;
      });
    }

    setState(() => sortASC = !sortASC);
    switch (index) {
      case 0:
        ref.read(pTokensProvider.notifier).sortByUsername(sortASC);
        return;
      case 1:
        ref.read(pTokensProvider.notifier).sortByType(sortASC);
        return;
      case 2:
        ref.read(pTokensProvider.notifier).sortByCreated(sortASC);
        return;
      case 3:
        ref.read(pTokensProvider.notifier).sortByValidUntil(sortASC);
        return;
      case 4:
        ref.read(pTokensProvider.notifier).sortByUses(sortASC);
        return;
    }
  }

  deleteToken(BuildContext context, WidgetRef ref, TToken token) async {
    final response = await showDialog<bool>(
      context: context,
      builder: (_) => TConfirmDialog(
        title: L10n.of(context).p_admin_share_delete_title,
        content: L10n.of(context).p_admin_share_delete_content,
      ),
    );
    if (response == true) {
      await ref.read(pApiProvider).tokenClient.deleteById(token.id!);
      ref.invalidate(pTokensProvider);
    }
  }
}
