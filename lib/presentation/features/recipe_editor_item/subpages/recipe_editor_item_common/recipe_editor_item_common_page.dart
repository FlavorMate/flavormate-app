import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/utils/debouncer.dart';
import 'package:flavormate/core/utils/u_riverpod.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_progress/f_progress.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_loading_page.dart';
import 'package:flavormate/presentation/common/widgets/f_text_form_field.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_common/providers/p_recipe_editor_item_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipeEditorItemCommonPage extends ConsumerStatefulWidget {
  const RecipeEditorItemCommonPage({super.key, required this.draftId});

  final String draftId;

  PRecipeEditorItemCommonProvider get provider =>
      pRecipeEditorItemCommonProvider(draftId);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecipeEditorItemCommonPageState();
}

class _RecipeEditorItemCommonPageState
    extends ConsumerState<RecipeEditorItemCommonPage> {
  bool _ready = false;

  final _labelController = TextEditingController();
  final _labelDebouncer = Debouncer();
  final _descriptionController = TextEditingController();
  final _descriptionDebouncer = Debouncer();

  @override
  void initState() {
    URiverpod.listenManual(ref, widget.provider, (data) {
      if (!_ready) {
        _labelController.text = data.label ?? '';
        _descriptionController.text = data.description ?? '';
      }
      _ready = true;
    });

    super.initState();
  }

  @override
  void dispose() {
    _labelController.dispose();
    _labelDebouncer.dispose();
    _descriptionController.dispose();
    _descriptionDebouncer.dispose();
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
          title: context.l10n.recipe_editor_item_common_page__title,
          actions: [
            FProgress(
              provider: widget.provider,
              color: context.colorScheme.onSurface,
              getProgress: (data) => data.commonProgress,
            ),
          ],
        ),
        body: SafeArea(
          child: FResponsive(
            child: Column(
              spacing: PADDING,
              children: [
                FTextFormField(
                  controller: _labelController,
                  label: context.l10n.recipe_editor_item_common_page__name,
                  onChanged: setLabel,
                  clear: () => setLabel(''),
                ),
                FTextFormField(
                  controller: _descriptionController,
                  label:
                      context.l10n.recipe_editor_item_common_page__description,
                  onChanged: setDescription,
                  clear: () => setDescription(''),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  void setLabel(String input) {
    _labelDebouncer.run(() {
      ref.read(widget.provider.notifier).setLabel(input);
    });
  }

  void setDescription(String input) {
    _descriptionDebouncer.run(() {
      ref.read(widget.provider.notifier).setDescription(input);
    });
  }
}
