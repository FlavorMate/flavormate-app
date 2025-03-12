import 'package:flavormate/components/recipe/recipe_informations.dart';
import 'package:flavormate/components/recipe_editor/preview/preview_categories.dart';
import 'package:flavormate/components/recipe_editor/preview/preview_tags.dart';
import 'package:flavormate/components/recipe_editor/preview/variations/desktop.dart';
import 'package:flavormate/components/recipe_editor/preview/variations/mobile.dart';
import 'package:flavormate/components/t_app_bar.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_responsive.dart';
import 'package:flavormate/models/recipe_draft_wrapper/recipe_draft_wrapper.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';

class DPreview extends StatefulWidget {
  final RecipeDraftWrapper draft;

  const DPreview({super.key, required this.draft});

  @override
  State<StatefulWidget> createState() => _DPreviewState();
}

class _DPreviewState extends State<DPreview> {
  late RecipeDraftWrapper _draft;

  @override
  void initState() {
    _draft = widget.draft.copyWith();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: TAppBar(title: _draft.recipeDraft.label!),
        body: LayoutBuilder(
          builder: (_, constraints) {
            final useDesktop = Breakpoints.gt(context, Breakpoints.m);
            return TResponsive(
              maxWidth: useDesktop ? Breakpoints.l : constraints.maxWidth,
              child: TColumn(
                children: [
                  if (useDesktop)
                    PreviewDesktop(
                      images: _draft.displayImages,
                      recipe: _draft.recipeDraft,
                    ),
                  if (!useDesktop)
                    PreviewMobile(
                      images: _draft.displayImages,
                      recipe: _draft.recipeDraft,
                    ),
                  const Divider(),
                  RecipeInformations(
                    course: _draft.recipeDraft.course!,
                    diet: _draft.recipeDraft.diet!,
                  ),
                  const Divider(),
                  PreviewCategories(categories: _draft.recipeDraft.categories),
                  const Divider(),
                  PreviewTags(tags: _draft.recipeDraft.tags),
                  const SizedBox(height: 48),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: submit,
          child: const Icon(MdiIcons.upload),
        ),
      ),
    );
  }

  void submit() {
    context.pop(true);
  }
}
