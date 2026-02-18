import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/utils/u_debouncer.dart';
import 'package:flavormate/core/utils/u_riverpod.dart';
import 'package:flavormate/core/utils/u_validator.dart';
import 'package:flavormate/presentation/common/slivers/f_constrained_box_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_page_introduction_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_sized_box_sliver.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_progress/f_progress.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_loading_page.dart';
import 'package:flavormate/presentation/common/widgets/f_text_form_field.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_origin/providers/p_recipe_editor_item_origin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipeEditorItemOriginPage extends ConsumerStatefulWidget {
  final String draftId;

  const RecipeEditorItemOriginPage({super.key, required this.draftId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecipeEditorItemOriginPageState();

  PRecipeEditorItemOriginProvider get provider =>
      pRecipeEditorItemOriginProvider(draftId);
}

class _RecipeEditorItemOriginPageState
    extends ConsumerState<RecipeEditorItemOriginPage> {
  final _key = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  bool _ready = false;

  final _originController = TextEditingController();
  final _originDebouncer = UDebouncer();

  @override
  void initState() {
    URiverpod.listenManualNullable(ref, widget.provider, (data) {
      if (!_ready) {
        _originController.text = data ?? '';
      }
      _ready = true;
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _originController.dispose();
    _originDebouncer.dispose();
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
          title: context.l10n.recipe_editor_item_origin_page__title,
          actions: [
            FProgress(
              provider: widget.provider,
              color: context.colorScheme.onSurface,
              getProgress: (data) => (data?.isEmpty ?? true) ? 0 : 1,
              optional: true,
            ),
          ],
        ),
        body: SafeArea(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              FConstrainedBoxSliver(
                padding: const .all(PADDING),
                maxWidth: FBreakpoint.smValue,
                sliver: SliverMainAxisGroup(
                  slivers: [
                    FPageIntroductionSliver(
                      shape: .c7_sided_cookie,
                      icon: MdiIcons.web,
                      description:
                          context.l10n.recipe_editor_item_origin_page__hint_1,
                    ),

                    const FSizedBoxSliver(height: PADDING),

                    SliverToBoxAdapter(
                      child: Form(
                        key: _key,
                        child: FTextFormField(
                          controller: _originController,
                          label: context
                              .l10n
                              .recipe_editor_item_origin_page__label,
                          onChanged: setOrigin,
                          clear: () => setOrigin(''),
                          validators: (val) {
                            if (val == null || val.isEmpty) return null;
                            if (!UValidator.isHttpUrl(val)) {
                              return context.l10n.validator__is_http_url;
                            }
                            return null;
                          },
                        ),
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

  void setOrigin(String input) {
    _originDebouncer.run(() {
      if (!_key.currentState!.validate()) return;
      ref.read(widget.provider.notifier).set(input);
    });
  }
}
