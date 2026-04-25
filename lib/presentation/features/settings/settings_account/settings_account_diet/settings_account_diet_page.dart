import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/models/features/accounts/account_update_dto.dart';
import 'package:flavormate/data/models/shared/enums/diet.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_self.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_page_introduction.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_group.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsAccountDietPage extends ConsumerStatefulWidget {
  const SettingsAccountDietPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SettingsAccountDietPageState();

  PRestAccountsSelfProvider get provider => pRestAccountsSelfProvider;
}

class _SettingsAccountDietPageState
    extends ConsumerState<SettingsAccountDietPage> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentDiet = ref.watch(
      widget.provider.select(
        (it) => it.value?.diet,
      ),
    );

    return Scaffold(
      appBar: FAppBar(
        title: context.l10n.settings_account_diet_page__title,
        scrollController: _scrollController,
      ),
      body: SafeArea(
        child: FResponsive(
          controller: _scrollController,
          child: Column(
            spacing: PADDING,
            children: [
              FPageIntroduction(
                shape: .soft_burst,
                icon: MdiIcons.leaf,
                description:
                    context.l10n.settings_account_diet_page__description,
              ),

              if (currentDiet != null)
                FTileGroup(
                  items: List.generate(Diet.values.length, (index) {
                    final item = Diet.values[index];
                    return FTile(
                      label: item.getName(context),
                      subLabel: null,
                      leading: FTileIcon(
                        iconBackgroundColor: Colors.transparent,
                        icon: currentDiet == item
                            ? MdiIcons.checkCircleOutline
                            : MdiIcons.circleOutline,
                      ),
                      onTap: () => updateValue(item),
                    );
                  }),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void updateValue(Diet input) async {
    context.showLoadingDialog();

    final result = await ref
        .read(widget.provider.notifier)
        .putAccountsId(AccountUpdateDto(diet: input));

    if (!mounted) return;
    context.pop();

    if (!result.hasError) {
      context.showTextSnackBar(
        context.l10n.settings_account_page__change_diet_success,
      );
    } else {
      context.showTextSnackBar(
        context.l10n.settings_account_page__change_diet_failure,
      );
    }
  }
}
