import 'package:flavormate/components/dialogs/t_full_dialog.dart';
import 'package:flavormate/components/t_button.dart';
import 'package:flavormate/components/t_card.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_row.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/components/t_text_form_field.dart';
import 'package:flavormate/extensions/e_number.dart';
import 'package:flavormate/extensions/e_string.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/recipe/unit_ref/unit_localized.dart';
import 'package:flavormate/models/recipe_draft/nutrition/nutrition_draft.dart';
import 'package:flavormate/riverpod/features/p_feature_open_food_facts.dart';
import 'package:flavormate/utils/u_double.dart';
import 'package:flavormate/utils/u_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class DNutrition extends ConsumerStatefulWidget {
  final NutritionDraft nutrition;
  final UnitLocalized? unitRef;
  final double? amount;

  const DNutrition({
    super.key,
    required this.nutrition,
    required this.unitRef,
    required this.amount,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DNutritionState();
}

class _DNutritionState extends ConsumerState<DNutrition> {
  final double _dividerWidth = 250;

  final _formKey = GlobalKey<FormState>();

  int _mode = 1;

  late NutritionDraft _nutrition;

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
    }

    super.initState();
  }

  @override
  void dispose() {
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
    return TFullDialog(
      title: L10n.of(context).d_nutrition_title,
      submit: submit,
      child: Form(
        key: _formKey,
        child: TColumn(
          mainAxisSize: MainAxisSize.min,
          children: [
            SegmentedButton<int>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: 0,
                  label: Text(L10n.of(context).d_nutrition_off_title),
                ),
                ButtonSegment(
                  value: 1,
                  label: Text(L10n.of(context).d_nutrition_custom_title),
                ),
              ],
              selected: {_mode},
              onSelectionChanged: (selected) {
                setState(() {
                  _mode = selected.first;
                });
              },
            ),
            if (_mode == 0)
              if (!offFeature)
                TCard(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  child: TRow(
                    children: [
                      Icon(MdiIcons.alertCircleOutline),
                      Expanded(
                        child: TText(
                          L10n.of(context).d_nutrition_off_disabled,
                          TextStyles.titleSmall,
                          color: TextColor.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                )
              else
                TColumn(
                  children: [
                    TCard(
                      child: TColumn(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TText(
                            L10n.of(context).d_nutrition_off_hint_1,
                            TextStyles.bodyMedium,
                            color: TextColor.onPrimaryContainer,
                          ),
                          TText(
                            L10n.of(context).d_nutrition_off_hint_2,
                            TextStyles.bodyMedium,
                            color: TextColor.onPrimaryContainer,
                          ),
                          TText(
                            L10n.of(context).d_nutrition_off_hint_3,
                            TextStyles.bodyMedium,
                            color: TextColor.onPrimaryContainer,
                          ),
                          TText(
                            L10n.of(context).d_nutrition_off_hint_4,
                            TextStyles.bodyMedium,
                            color: TextColor.onPrimaryContainer,
                          ),
                          TButton(
                            onPressed: launchOFF,
                            label: L10n.of(context).d_nutrition_off_open_off,
                          ),
                        ],
                      ),
                    ),
                    // if widget is null or not convertable
                    if (!convertableUnit)
                      TCard(
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                        child: TRow(
                          children: [
                            Icon(MdiIcons.alertCircleOutline),
                            Expanded(
                              child: TText(
                                L10n.of(context).d_nutrition_off_error_hint,
                                TextStyles.titleSmall,
                                color: TextColor.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    TTextFormField(
                      controller: _openFoodFactsIdController,
                      label: L10n.of(context).d_nutrition_off_product_ean,
                      prefix: Icon(MdiIcons.barcodeScan),
                      readOnly: !convertableUnit,
                    ),
                  ],
                ),
            if (_mode == 1)
              TColumn(
                children: [
                  if (!enableCustom)
                    TCard(
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                      child: TRow(
                        children: [
                          Icon(MdiIcons.alertCircleOutline),
                          Expanded(
                            child: TText(
                              L10n.of(context).d_nutrition_custom_disabled_hint,
                              TextStyles.titleSmall,
                              color: TextColor.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  TCard(
                    child: TText(
                      L10n.of(context).d_nutrition_custom_hint_1(
                        [
                          widget.amount?.beautify,
                          widget.unitRef?.getLabel(widget.amount),
                        ].nonNulls.join(' '),
                      ),
                      TextStyles.bodyMedium,
                      color: TextColor.onPrimaryContainer,
                    ),
                  ),
                  TTextFormField(
                    controller: _energyKcalController,
                    label: L10n.of(context).nutrition_kcal,
                    keyboardType: TextInputType.number,
                    readOnly: !enableCustom,
                    validators: validate,
                    prefix: Icon(MdiIcons.fire),
                  ),
                  SizedBox(width: _dividerWidth, child: Divider()),
                  TTextFormField(
                    controller: _carbohydratesController,
                    label: '${L10n.of(context).nutrition_carbohydrates} (g)',
                    keyboardType: TextInputType.number,
                    readOnly: !enableCustom,
                    validators: validate,
                    prefix: Icon(MdiIcons.corn),
                  ),
                  TTextFormField(
                    controller: _sugarsController,
                    label: '${L10n.of(context).nutrition_sugars} (g)',
                    keyboardType: TextInputType.number,
                    readOnly: !enableCustom,
                    validators: validate,
                    prefix: Icon(MdiIcons.cubeOutline),
                  ),
                  SizedBox(width: _dividerWidth, child: Divider()),
                  TTextFormField(
                    controller: _fatController,
                    label: '${L10n.of(context).nutrition_fat} (g)',
                    keyboardType: TextInputType.number,
                    readOnly: !enableCustom,
                    validators: validate,
                    prefix: Icon(MdiIcons.waterOutline),
                  ),
                  TTextFormField(
                    controller: _saturatedFatController,
                    label: '${L10n.of(context).nutrition_saturated_fat} (g)',
                    keyboardType: TextInputType.number,
                    readOnly: !enableCustom,
                    validators: validate,
                    prefix: Icon(MdiIcons.foodDrumstickOutline),
                  ),
                  SizedBox(width: _dividerWidth, child: Divider()),
                  TTextFormField(
                    controller: _fiberController,
                    label: '${L10n.of(context).nutrition_fiber} (g)',
                    keyboardType: TextInputType.number,
                    readOnly: !enableCustom,
                    validators: validate,
                    prefix: Icon(MdiIcons.leaf),
                  ),
                  TTextFormField(
                    controller: _proteinsController,
                    label: '${L10n.of(context).nutrition_proteins} (g)',
                    keyboardType: TextInputType.number,
                    readOnly: !enableCustom,
                    validators: validate,
                    prefix: Icon(MdiIcons.peanutOutline),
                  ),
                  TTextFormField(
                    controller: _saltController,
                    label: '${L10n.of(context).nutrition_salt} (g)',
                    keyboardType: TextInputType.number,
                    readOnly: !enableCustom,
                    validators: validate,
                    prefix: Icon(MdiIcons.shakerOutline),
                  ),
                  TTextFormField(
                    controller: _sodiumController,
                    label: '${L10n.of(context).nutrition_sodium} (g)',
                    keyboardType: TextInputType.number,
                    readOnly: !enableCustom,
                    validators: validate,
                    prefix: Icon(MdiIcons.flaskOutline),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  bool get convertableUnit {
    return (widget.unitRef?.unitRef.isConvertable ?? false) &&
        UDouble.isPositive(widget.amount);
  }

  String? validate(String? input) {
    if (EString.isEmpty(input)) return null;

    if (!UValidator.isNumber(input!)) {
      return L10n.of(context).v_isNumber;
    }

    return null;
  }

  bool get enableCustom {
    return _openFoodFactsIdController.text.isEmpty;
  }

  void submit() {
    if (!_formKey.currentState!.validate()) return;

    context.pop(
      NutritionDraft(
        openFoodFactsId: EString.trimToNull(_openFoodFactsIdController.text),
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
    final uri = Uri.parse('https://$language.openfoodfacts.org');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
