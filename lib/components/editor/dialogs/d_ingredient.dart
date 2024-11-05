import 'package:flavormate/components/dialogs/t_alert_dialog.dart';
import 'package:flavormate/components/editor/dialogs/d_nutrition.dart';
import 'package:flavormate/components/riverpod/r_struct.dart';
import 'package:flavormate/components/t_button.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/extensions/e_number.dart';
import 'package:flavormate/extensions/e_string.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/recipe/unit_ref/unit_localized.dart';
import 'package:flavormate/models/recipe_draft/ingredients/ingredient_draft.dart';
import 'package:flavormate/models/recipe_draft/nutrition/nutrition_draft.dart';
import 'package:flavormate/riverpod/units/p_units.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flavormate/utils/u_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DIngredient extends ConsumerStatefulWidget {
  final IngredientDraft ingredient;

  const DIngredient({
    super.key,
    required this.ingredient,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DIngredientState();
}

class _DIngredientState extends ConsumerState<DIngredient> {
  final _formKey = GlobalKey<FormState>();

  late IngredientDraft _ingredient;

  final _amountController = TextEditingController();
  final _oldUnitController = TextEditingController();
  final _ingredientController = TextEditingController();

  @override
  void initState() {
    _ingredient = widget.ingredient.copyWith();

    _amountController.text = _ingredient.amount?.beautify ?? '';

    if (_ingredient.unit != null) {
      _oldUnitController.text = _ingredient.unit!.beautify;
    }

    _ingredientController.text = _ingredient.label;
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _oldUnitController.dispose();
    _ingredientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(pUnitsProvider);
    return TAlertDialog(
      title: L10n.of(context).d_editor_ingredient_title,
      submit: submit,
      child: Form(
        key: _formKey,
        child: TColumn(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: Text(L10n.of(context).d_editor_ingredient_amount),
                suffix: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => _amountController.clear(),
                    child: Icon(
                      MdiIcons.delete,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ),
              validator: (input) {
                if (EString.isEmpty(input)) return null;

                if (!UValidator.isNumber(input!)) {
                  return L10n.of(context).v_isNumber;
                }

                return null;
              },
            ),
            if (_oldUnitController.text.isNotEmpty)
              TextField(
                controller: _oldUnitController,
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label:
                      Text(L10n.of(context).d_editor_ingredient_old_unit_label),
                ),
              ),
            RStruct(
              provider,
              (_, units) => Autocomplete<UnitLocalized>(
                initialValue: TextEditingValue(
                  text: _ingredient.unitLocalized?.labelSg ?? '',
                ),
                displayStringForOption: (unit) => unit.labelSg,
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return [];
                  }
                  final responses = units.where(
                    (unit) {
                      return [
                        unit.labelSg,
                        unit.labelSgAbrv,
                        unit.labelPl,
                        unit.labelPlAbrv
                      ].nonNulls.any((label) =>
                          label.containsIgnoreCase(textEditingValue.text));
                    },
                  ).toList();

                  return responses;
                },
                fieldViewBuilder: (BuildContext context,
                        TextEditingController fieldTextEditingController,
                        FocusNode fieldFocusNode,
                        VoidCallback onFieldSubmitted) =>
                    TextField(
                  controller: fieldTextEditingController,
                  focusNode: fieldFocusNode,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    label: Text(L10n.of(context).d_editor_ingredient_unit),
                    suffix: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => clearUnit(fieldTextEditingController),
                        child: Icon(
                          MdiIcons.delete,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ),
                ),
                onSelected: (UnitLocalized selection) {
                  setState(() {
                    _ingredient.unit = null;
                    _ingredient.unitLocalized = selection;
                  });
                },
                optionsViewBuilder: (
                  BuildContext context,
                  AutocompleteOnSelected<UnitLocalized> onSelected,
                  Iterable<UnitLocalized> options,
                ) {
                  return AutocompleteOptions(
                    onSelected: onSelected,
                    options: options,
                  );
                },
              ),
            ),
            TextFormField(
              controller: _ingredientController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: Text(L10n.of(context).d_editor_ingredient_label),
              ),
              validator: (input) {
                if (UValidator.isEmpty(input)) {
                  return L10n.of(context).v_isEmpty;
                }

                return null;
              },
            ),
            TButton(
              onPressed: openNutrition,
              label: L10n.of(context).d_editor_ingredient_edit_nutrition,
              trailing: Visibility(
                visible: _ingredient.nutrition?.exists ?? false,
                child: Icon(MdiIcons.checkCircleOutline),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openNutrition() async {
    final response = await showDialog<NutritionDraft>(
      context: context,
      useSafeArea: false,
      builder: (_) => DNutrition(
        amount: _ingredient.amount,
        unitRef: _ingredient.unitLocalized,
        nutrition: _ingredient.nutrition ?? NutritionDraft(),
      ),
    );

    if (response == null) return;

    setState(() {
      _ingredient.nutrition = response;
    });
  }

  void clearUnit(TextEditingController unitController) {
    setState(() {
      _ingredient.unitLocalized = null;
      unitController.clear();
    });
  }

  void submit() {
    if (!_formKey.currentState!.validate()) return;

    var parsedAmount = double.tryParse(_amountController.text);
    if (parsedAmount != null && parsedAmount <= 0) {
      parsedAmount = null;
    }

    context.pop(
      IngredientDraft(
        amount: parsedAmount,
        unit: _ingredient.unit,
        unitLocalized: _ingredient.unitLocalized,
        label: _ingredientController.text.trim(),
        nutrition: _ingredient.nutrition,
      ),
    );
  }
}

/// Necessary until https://github.com/flutter/flutter/issues/78746 is fixed
class AutocompleteOptions extends StatelessWidget {
  final AutocompleteOnSelected<UnitLocalized> onSelected;
  final Iterable<UnitLocalized> options;

  const AutocompleteOptions({
    super.key,
    required this.onSelected,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4.0,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 500,
            maxWidth: 233,
          ),
          // width: 230,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              final UnitLocalized option = options.elementAt(index);
              return InkWell(
                onTap: () => onSelected(option),
                child: Builder(builder: (BuildContext context) {
                  final bool highlight =
                      AutocompleteHighlightedOption.of(context) == index;
                  if (highlight) {
                    SchedulerBinding.instance.addPostFrameCallback(
                        (Duration timeStamp) {
                      Scrollable.ensureVisible(context, alignment: 0.5);
                    }, debugLabel: 'AutocompleteOptions.ensureVisible');
                  }
                  return Container(
                    color: highlight ? Theme.of(context).focusColor : null,
                    padding: const EdgeInsets.all(PADDING),
                    //TODO: label
                    child: Text(option.labelSg),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}
