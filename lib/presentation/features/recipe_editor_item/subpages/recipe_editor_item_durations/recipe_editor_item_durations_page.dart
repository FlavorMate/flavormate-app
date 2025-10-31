import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_duration.dart';
import 'package:flavormate/core/utils/u_riverpod.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_button.dart';
import 'package:flavormate/presentation/common/widgets/f_card.dart';
import 'package:flavormate/presentation/common/widgets/f_progress/f_progress.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_loading_page.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_durations/providers/p_recipe_editor_item_durations.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_durations/widgets/recipe_editor_item_durations_page_duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipeEditorItemDurationsPage extends ConsumerStatefulWidget {
  final String draftId;

  const RecipeEditorItemDurationsPage({super.key, required this.draftId});

  PRecipeEditorItemDurationsProvider get provider =>
      pRecipeEditorItemDurationsProvider(draftId);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecipeEditorItemDurationsPageState();
}

class _RecipeEditorItemDurationsPageState
    extends ConsumerState<RecipeEditorItemDurationsPage> {
  bool _ready = false;

  Duration _prepTime = Duration.zero;
  Duration _cookTime = Duration.zero;
  Duration _restTime = Duration.zero;

  @override
  void initState() {
    URiverpod.listenManual(ref, widget.provider, (data) {
      if (!_ready) {
        _prepTime = data.prepTime;
        _cookTime = data.cookTime;
        _restTime = data.restTime;
      }
      _ready = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(widget.provider);

    if (!_ready) {
      return const FLoadingPage();
    } else {
      return Scaffold(
        appBar: FAppBar(
          title: L10n.of(context).recipe_editor_item_durations_page__title,
          actions: [
            FProgress(
              provider: widget.provider,
              color: context.colorScheme.onSurface,
              getProgress: (data) => data.durationProgress,
            ),
          ],
        ),
        body: SafeArea(
          child: FResponsive(
            child: Column(
              spacing: PADDING,
              children: [
                FCard(
                  child: Column(
                    spacing: PADDING,
                    children: [
                      FText(
                        L10n.of(
                          context,
                        ).recipe_editor_item_durations_page__prep_time,
                        style: FTextStyle.titleLarge,
                      ),
                      FButton(
                        leading: const Icon(MdiIcons.stove),
                        onPressed: () => setPrepTime(),
                        label: _prepTime.beautify2(context),
                      ),
                    ],
                  ),
                ),
                FCard(
                  child: Column(
                    spacing: PADDING,
                    children: [
                      FText(
                        L10n.of(
                          context,
                        ).recipe_editor_item_durations_page__cook_time,
                        style: FTextStyle.titleLarge,
                      ),
                      FButton(
                        leading: const Icon(MdiIcons.stove),
                        onPressed: () => setCookTime(),
                        label: _cookTime.beautify2(context),
                      ),
                    ],
                  ),
                ),
                FCard(
                  child: Column(
                    spacing: PADDING,
                    children: [
                      FText(
                        L10n.of(
                          context,
                        ).recipe_editor_item_durations_page__rest_time,
                        style: FTextStyle.titleLarge,
                      ),
                      FButton(
                        leading: const Icon(MdiIcons.stove),
                        onPressed: () => setRestTime(),
                        label: _restTime.beautify2(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  void setPrepTime() async {
    final response = await showDialog<Duration>(
      context: context,
      builder: (_) =>
          RecipeEditorItemDurationsPageDurationPicker(duration: _prepTime),
    );
    if (response == null) return;

    await ref.read(widget.provider.notifier).setPrepTime(response);

    setState(() => _prepTime = response);
  }

  void setCookTime() async {
    final response = await showDialog<Duration>(
      context: context,
      builder: (_) =>
          RecipeEditorItemDurationsPageDurationPicker(duration: _cookTime),
    );
    if (response == null) return;

    await ref.read(widget.provider.notifier).setCookTime(response);

    setState(() => _cookTime = response);
  }

  void setRestTime() async {
    final response = await showDialog<Duration>(
      context: context,
      builder: (_) =>
          RecipeEditorItemDurationsPageDurationPicker(duration: _restTime),
    );
    if (response == null) return;

    await ref.read(widget.provider.notifier).setRestTime(response);

    setState(() => _restTime = response);
  }
}
