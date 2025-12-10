import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_number.dart';
import 'package:flavormate/core/utils/debouncer.dart';
import 'package:flavormate/core/utils/u_double.dart';
import 'package:flavormate/core/utils/u_riverpod.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_progress/f_progress.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_loading_page.dart';
import 'package:flavormate/presentation/common/widgets/f_text_form_field.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_serving/providers/p_recipe_editor_item_serving.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipeEditorItemServingPage extends ConsumerStatefulWidget {
  const RecipeEditorItemServingPage({super.key, required this.draftId});

  final String draftId;

  PRecipeEditorItemServingProvider get provider =>
      pRecipeEditorItemServingProvider(draftId);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecipeEditorItemServingPageState();
}

class _RecipeEditorItemServingPageState
    extends ConsumerState<RecipeEditorItemServingPage> {
  bool _ready = false;

  final _amountController = TextEditingController();
  final _amountDebouncer = Debouncer();
  final _labelController = TextEditingController();
  final _labelDebouncer = Debouncer();

  @override
  void initState() {
    URiverpod.listenManual(ref, widget.provider, (data) {
      if (!_ready) {
        _amountController.text = UDouble.isPositive(data.amount)
            ? data.amount!.beautify
            : '';
        _labelController.text = data.label ?? '';
      }
      _ready = true;
    });

    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountDebouncer.dispose();
    _labelController.dispose();
    _labelDebouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(widget.provider);

    if (!_ready) {
      return const FLoadingPage();
    } else {
      return Scaffold(
        appBar: FAppBar(
          title: context.l10n.recipe_editor_item_serving_page__title,
          actions: [
            FProgress(
              provider: widget.provider,
              color: context.colorScheme.onSurface,
              getProgress: (data) => data.validPercent,
            ),
          ],
        ),

        body: SafeArea(
          child: FResponsive(
            child: Column(
              spacing: PADDING,
              children: [
                FTextFormField(
                  controller: _amountController,
                  label: context.l10n.recipe_editor_item_serving_page__amount,
                  onChanged: setAmount,
                  clear: () => setAmount(''),
                ),
                FTextFormField(
                  controller: _labelController,
                  label: context.l10n.recipe_editor_item_serving_page__label,
                  onChanged: setLabel,
                  clear: () => setLabel(''),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  void setAmount(String input) {
    _amountDebouncer.run(() {
      ref.read(widget.provider.notifier).setAmount(input);
    });
  }

  void setLabel(String input) {
    _labelDebouncer.run(() {
      ref.read(widget.provider.notifier).setLabel(input);
    });
  }
}
