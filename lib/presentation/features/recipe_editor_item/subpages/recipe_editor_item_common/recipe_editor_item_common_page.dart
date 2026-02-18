import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/utils/u_debouncer.dart';
import 'package:flavormate/core/utils/u_riverpod.dart';
import 'package:flavormate/presentation/common/slivers/f_constrained_box_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_page_introduction_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_sized_box_sliver.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_progress/f_progress.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_loading_page.dart';
import 'package:flavormate/presentation/common/widgets/f_text_form_field.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_common/providers/p_recipe_editor_item_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
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

  final _scrollController = ScrollController();
  final _labelController = TextEditingController();
  final _labelDebouncer = UDebouncer();
  final _descriptionController = TextEditingController();
  final _descriptionDebouncer = UDebouncer();

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
    _scrollController.dispose();
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
          scrollController: _scrollController,
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
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              FConstrainedBoxSliver(
                maxWidth: FBreakpoint.smValue,
                padding: const .all(PADDING),
                sliver: SliverMainAxisGroup(
                  slivers: [
                    FPageIntroductionSliver(
                      shape: .c7_sided_cookie,
                      icon: MdiIcons.noteEdit,
                      description: context
                          .l10n
                          .recipe_editor_item_common_page__description,
                    ),

                    const FSizedBoxSliver(height: PADDING),

                    SliverToBoxAdapter(
                      child: Column(
                        spacing: PADDING * 1.5,
                        children: [
                          FTextFormField(
                            controller: _labelController,
                            label: context
                                .l10n
                                .recipe_editor_item_common_page__name,
                            onChanged: setLabel,
                            clear: () => setLabel(''),
                          ),
                          FTextFormField(
                            controller: _descriptionController,
                            label: context
                                .l10n
                                .recipe_editor_item_common_page__hint__description,
                            onChanged: setDescription,
                            clear: () => setDescription(''),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
