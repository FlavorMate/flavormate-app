import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/utils/debouncer.dart';
import 'package:flavormate/core/utils/u_riverpod.dart';
import 'package:flavormate/core/utils/u_validator.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_progress/f_progress.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_loading_page.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
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
  bool _ready = false;

  final _originController = TextEditingController();
  final _originDebouncer = Debouncer();

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
          title: L10n.of(context).recipe_editor_item_origin_page__title,
          actions: [
            FProgress(
              provider: widget.provider,
              color: context.colorScheme.onSurface,
              getProgress: (data) => (data?.isEmpty ?? true) ? 0 : 1,
              optional: true,
            ),
          ],
        ),
        body: Form(
          key: _key,
          child: SafeArea(
            child: Center(
              child: FResponsive(
                child: Column(
                  spacing: PADDING,
                  children: [
                    Icon(
                      MdiIcons.web,
                      size: 96,
                      color: context.colorScheme.onPrimaryContainer,
                    ),
                    FText(
                      L10n.of(context).recipe_editor_item_origin_page__hint_1,
                      style: FTextStyle.bodyLarge,
                    ),
                    const SizedBox(height: PADDING / 4),
                    FTextFormField(
                      controller: _originController,
                      label: L10n.of(
                        context,
                      ).recipe_editor_item_origin_page__label,
                      onChanged: setOrigin,
                      clear: () => setOrigin(''),
                      validators: (val) {
                        if (val == null || val.isEmpty) return null;
                        if (!UValidator.isHttpUrl(val)) {
                          return L10n.of(context).validator__is_http_url;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
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
