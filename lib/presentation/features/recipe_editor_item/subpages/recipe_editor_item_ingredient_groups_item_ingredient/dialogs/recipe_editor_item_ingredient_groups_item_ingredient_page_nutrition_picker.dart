import 'package:flavormate/core/config/features/p_feature_open_food_facts.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_number.dart';
import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/core/utils/u_double.dart';
import 'package:flavormate/core/utils/u_validator.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_ingredient_group_dto.dart';
import 'package:flavormate/data/models/features/unit/unit_dto.dart';
import 'package:flavormate/data/models/shared/enums/nutrition_type.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_card.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/common/widgets/f_text_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

// TODO: own page
class RecipeEditorItemIngredientGroupsItemIngredientPageNutritionPicker
    extends ConsumerStatefulWidget {
  final RecipeDraftIngredientGroupItemNutritionDto nutrition;
  final UnitLocalizedDto? unit;
  final double? amount;

  const RecipeEditorItemIngredientGroupsItemIngredientPageNutritionPicker({
    super.key,
    required this.nutrition,
    required this.unit,
    required this.amount,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DNutritionState();
}

class _DNutritionState
    extends
        ConsumerState<
          RecipeEditorItemIngredientGroupsItemIngredientPageNutritionPicker
        > {
  final _pageController = PageController(initialPage: 1);

  final _formKey = GlobalKey<FormState>();

  int _mode = 1;

  late RecipeDraftIngredientGroupItemNutritionDto _nutrition;

  final _openFoodFactsIdController = TextEditingController();

  final _carbohydratesController = TextEditingController();
  final _energyKcalController = TextEditingController();
  final _fatController = TextEditingController();
  final _saturatedFatController = TextEditingController();
  final _sugarsController = TextEditingController();
  final _fiberController = TextEditingController();
  final _proteinsController = TextEditingController();
  final _saltController = TextEditingController();
  final _sodiumController = TextEditingController();

  @override
  void initState() {
    _nutrition = widget.nutrition.copyWith();

    _openFoodFactsIdController.text = _nutrition.openFoodFactsId ?? '';

    _carbohydratesController.text = _nutrition.carbohydrates?.beautify ?? '';
    _energyKcalController.text = _nutrition.energyKcal?.beautify ?? '';
    _fatController.text = _nutrition.fat?.beautify ?? '';
    _saturatedFatController.text = _nutrition.saturatedFat?.beautify ?? '';
    _sugarsController.text = _nutrition.sugars?.beautify ?? '';
    _fiberController.text = _nutrition.fiber?.beautify ?? '';
    _proteinsController.text = _nutrition.proteins?.beautify ?? '';
    _saltController.text = _nutrition.salt?.beautify ?? '';
    _sodiumController.text = _nutrition.sodium?.beautify ?? '';

    if (_nutrition.openFoodFactsId?.isNotEmpty ?? false) {
      _mode = 0;
      _pageController.jumpToPage(0);
    }

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();

    _openFoodFactsIdController.dispose();

    _carbohydratesController.dispose();
    _energyKcalController.dispose();
    _fatController.dispose();
    _saturatedFatController.dispose();
    _sugarsController.dispose();
    _fiberController.dispose();
    _proteinsController.dispose();
    _saltController.dispose();
    _sodiumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offFeature = ref.watch(pFeatureOpenFoodFactsProvider);

    return Dialog.fullscreen(
      child: Scaffold(
        appBar: FAppBar(
          title: context
              .l10n
              .recipe_editor_item_ingredient_groups_item_ingredient_page_nutrition_picker__title,
          scrollController: null,
        ),
        floatingActionButton: M3EFab(
          icon: const Icon(Symbols.save_rounded),
          onPressed: submit,
        ),
        body: SafeArea(
          child: FFixedResponsive(
            child: Column(
              spacing: PADDING,
              children: [
                M3ESegmentedButton<int>(
                  showSelectedIcon: false,
                  segments: [
                    M3ESegment(
                      value: 0,
                      label: context
                          .l10n
                          .recipe_editor_item_ingredient_groups_item_ingredient_page_nutrition_picker__off_title,
                    ),
                    M3ESegment(
                      value: 1,
                      label: context
                          .l10n
                          .recipe_editor_item_ingredient_groups_item_ingredient_page_nutrition_picker__custom_title,
                    ),
                  ],
                  selected: {_mode},
                  onSelectionChanged: (selected) {
                    setState(() {
                      _mode = selected.first;
                      _pageController.animateToPage(
                        selected.first,
                        duration: const .new(milliseconds: 250),
                        curve: Curves.ease,
                      );
                    });
                  },
                ),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        offSection(offFeature),
                        manualSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget offSection(bool offFeature) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (!offFeature) offSectionDisabled() else offSectionEnabled(),

          // Padding for FAB Button
          const SizedBox(height: kFabHeight + PADDING),
        ],
      ),
    );
  }

  Widget offSectionDisabled() {
    return FCard(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Row(
        spacing: PADDING,
        children: [
          const Icon(Symbols.error_rounded),
          Expanded(
            child: FText(
              context
                  .l10n
                  .recipe_editor_item_ingredient_groups_item_ingredient_page_nutrition_picker__off_disabled,
              style: FTextStyle.titleSmall,
              color: FTextColor.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  Widget offSectionEnabled() {
    return Column(
      spacing: PADDING,
      children: [
        M3EExpandableList(
          style: const .new(
            useInkWell: false,
            headerAlignment: .center,
            headerPadding: .symmetric(horizontal: 16, vertical: 8),
          ),
          data: [
            M3EExpandableData(
              // TODO: L10n
              title: 'Whats OFF?',
              body: Column(
                mainAxisSize: .min,
                spacing: PADDING,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FText(
                    context
                        .l10n
                        .recipe_editor_item_ingredient_groups_item_ingredient_page_nutrition_picker__off_hint_1,
                    style: FTextStyle.bodyMedium,
                    color: FTextColor.onPrimaryContainer,
                  ),
                  FText(
                    context
                        .l10n
                        .recipe_editor_item_ingredient_groups_item_ingredient_page_nutrition_picker__off_hint_2,
                    style: FTextStyle.bodyMedium,
                    color: FTextColor.onPrimaryContainer,
                  ),
                  FText(
                    context
                        .l10n
                        .recipe_editor_item_ingredient_groups_item_ingredient_page_nutrition_picker__off_hint_3,
                    style: FTextStyle.bodyMedium,
                    color: FTextColor.onPrimaryContainer,
                  ),
                  FText(
                    context
                        .l10n
                        .recipe_editor_item_ingredient_groups_item_ingredient_page_nutrition_picker__off_hint_4,
                    style: FTextStyle.bodyMedium,
                    color: FTextColor.onPrimaryContainer,
                  ),
                  Center(
                    child: M3EButton(
                      onPressed: launchOFF,
                      child: Text(
                        context
                            .l10n
                            .recipe_editor_item_ingredient_groups_item_ingredient_page_nutrition_picker__off_launch,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // if widget is null or not convertable
        if (!convertableUnit)
          FCard(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            child: Row(
              spacing: PADDING,
              children: [
                Icon(
                  Symbols.error_rounded,
                  color: context.colorScheme.onTertiaryContainer,
                ),
                Expanded(
                  child: FText(
                    context
                        .l10n
                        .recipe_editor_item_ingredient_groups_item_ingredient_page_nutrition_picker__off_unavailable,
                    style: FTextStyle.titleSmall,
                    color: FTextColor.onTertiaryContainer,
                  ),
                ),
              ],
            ),
          ),
        FTextFormField(
          controller: _openFoodFactsIdController,
          label: context
              .l10n
              .recipe_editor_item_ingredient_groups_item_ingredient_page_nutrition_picker__off_ean,
          prefix: const Icon(Symbols.barcode_scanner_rounded),
          readOnly: !convertableUnit,
        ),
      ],
    );
  }

  Widget manualSection() {
    return SingleChildScrollView(
      child: Column(
        spacing: PADDING,
        children: [
          if (!enableCustom)
            FCard(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Row(
                spacing: PADDING,
                children: [
                  const Icon(Symbols.error_rounded),
                  Expanded(
                    child: FText(
                      context
                          .l10n
                          .recipe_editor_item_ingredient_groups_item_ingredient_page_nutrition_picker__custom_unavailable,
                      style: FTextStyle.titleSmall,
                      color: FTextColor.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          FCard(
            child: FText(
              context.l10n
                  .recipe_editor_item_ingredient_groups_item_ingredient_page_nutrition_picker__custom_hint_1(
                    [
                      widget.amount?.beautify,
                      widget.unit?.getLabel(widget.amount),
                    ].nonNulls.join(' '),
                  ),
              style: FTextStyle.bodyMedium,
              color: FTextColor.onPrimaryContainer,
            ),
          ),
          FTextFormField(
            controller: _energyKcalController,
            label: context.l10n.nutrition__kcal,
            keyboardType: TextInputType.number,
            readOnly: !enableCustom,
            validators: validate,
            prefix: Icon(NutritionType.energyKcal.icon),
          ),
          const SizedBox(width: BUTTON_WIDTH, child: Divider()),
          FTextFormField(
            controller: _carbohydratesController,
            label: '${context.l10n.nutrition__carbohydrates} (g)',
            keyboardType: TextInputType.number,
            readOnly: !enableCustom,
            validators: validate,
            prefix: Icon(NutritionType.carbohydrates.icon),
          ),
          FTextFormField(
            controller: _sugarsController,
            label: '${context.l10n.nutrition__sugars} (g)',
            keyboardType: TextInputType.number,
            readOnly: !enableCustom,
            validators: validate,
            prefix: Icon(NutritionType.sugars.icon),
          ),
          const SizedBox(width: BUTTON_WIDTH, child: Divider()),
          FTextFormField(
            controller: _fatController,
            label: '${context.l10n.nutrition__fats} (g)',
            keyboardType: TextInputType.number,
            readOnly: !enableCustom,
            validators: validate,
            prefix: Icon(NutritionType.fat.icon),
          ),
          FTextFormField(
            controller: _saturatedFatController,
            label: '${context.l10n.nutrition__fats_saturated} (g)',
            keyboardType: TextInputType.number,
            readOnly: !enableCustom,
            validators: validate,
            prefix: Icon(NutritionType.saturatedFat.icon),
          ),
          const SizedBox(width: BUTTON_WIDTH, child: Divider()),
          FTextFormField(
            controller: _fiberController,
            label: '${context.l10n.nutrition__fibers} (g)',
            keyboardType: TextInputType.number,
            readOnly: !enableCustom,
            validators: validate,
            prefix: Icon(NutritionType.fiber.icon),
          ),
          FTextFormField(
            controller: _proteinsController,
            label: '${context.l10n.nutrition__proteins} (g)',
            keyboardType: TextInputType.number,
            readOnly: !enableCustom,
            validators: validate,
            prefix: Icon(NutritionType.proteins.icon),
          ),
          FTextFormField(
            controller: _saltController,
            label: '${context.l10n.nutrition__salt} (g)',
            keyboardType: TextInputType.number,
            readOnly: !enableCustom,
            validators: validate,
            prefix: Icon(NutritionType.salt.icon),
          ),
          FTextFormField(
            controller: _sodiumController,
            label: '${context.l10n.nutrition__sodium} (g)',
            keyboardType: TextInputType.number,
            readOnly: !enableCustom,
            validators: validate,
            prefix: Icon(NutritionType.sodium.icon),
          ),

          // Padding for FAB Button
          const SizedBox(height: kFabHeight),
        ],
      ),
    );
  }

  bool get convertableUnit {
    return (widget.unit?.unitRef.isConvertable ?? false) &&
        UDouble.isPositive(widget.amount);
  }

  String? validate(String? input) {
    if (EString.isEmpty(input)) return null;

    if (!UValidator.isNumber(input!)) {
      return context.l10n.validator__is_number;
    }

    return null;
  }

  bool get enableCustom {
    return _openFoodFactsIdController.text.isEmpty;
  }

  void submit() {
    if (!_formKey.currentState!.validate()) return;

    context.pop(
      RecipeDraftIngredientGroupItemNutritionDto(
        openFoodFactsId: _openFoodFactsIdController.text.trimToNull,
        carbohydrates: UDouble.tryParsePositive(_carbohydratesController.text),
        energyKcal: UDouble.tryParsePositive(_energyKcalController.text),
        fat: UDouble.tryParsePositive(_fatController.text),
        saturatedFat: UDouble.tryParsePositive(_saturatedFatController.text),
        sugars: UDouble.tryParsePositive(_sugarsController.text),
        fiber: UDouble.tryParsePositive(_fiberController.text),
        proteins: UDouble.tryParsePositive(_proteinsController.text),
        salt: UDouble.tryParsePositive(_saltController.text),
        sodium: UDouble.tryParsePositive(_sodiumController.text),
      ),
    );
  }

  void launchOFF() async {
    final language = Localizations.localeOf(context).languageCode;

    final url = switch (language) {
      'en' => OPEN_FOOD_FACTS_US,
      'de' => OPEN_FOOD_FACTS_DE,
      _ => throw UnimplementedError(),
    };

    final uri = Uri.parse(url);

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
