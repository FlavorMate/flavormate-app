import 'package:flavormate/components/riverpod/r_struct.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/extensions/e_number.dart';
import 'package:flavormate/extensions/e_string.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/recipe_draft/ingredients/ingredient_draft.dart';
import 'package:flavormate/models/unit.dart';
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
  final _ingredientController = TextEditingController();

  @override
  void initState() {
    _ingredient = widget.ingredient.copyWith();

    if (_ingredient.amount <= 0) {
      _amountController.text = '';
    } else {
      _amountController.text = _ingredient.amount.beautify;
    }
    _ingredientController.text = _ingredient.label;
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _ingredientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(pUnitsProvider);
    return AlertDialog(
      scrollable: true,
      title: Text(L10n.of(context).d_editor_ingredient_title),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(L10n.of(context).btn_cancel),
        ),
        FilledButton(
          onPressed: submit,
          child: Text(L10n.of(context).btn_save),
        ),
      ],
      content: Form(
        key: _formKey,
        child: TColumn(
          children: [
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text(L10n.of(context).d_editor_ingredient_amount),
              ),
              validator: (input) {
                if (EString.isEmpty(input)) return null;

                if (!UValidator.isNumber(input!)) {
                  return L10n.of(context).v_isNumber;
                }

                return null;
              },
            ),
            RStruct(
              provider,
              (_, units) => Autocomplete<Unit>(
                initialValue:
                    TextEditingValue(text: _ingredient.unit?.beautify ?? ''),
                displayStringForOption: (unit) => unit.beautify,
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return [];
                  }
                  return units.where(
                    (unit) {
                      return unit.label
                              .containsIgnoreCase(textEditingValue.text) ||
                          (unit.shortLabel
                                  ?.containsIgnoreCase(textEditingValue.text) ??
                              false);
                    },
                  );
                },
                fieldViewBuilder: (BuildContext context,
                        TextEditingController fieldTextEditingController,
                        FocusNode fieldFocusNode,
                        VoidCallback onFieldSubmitted) =>
                    TextField(
                  controller: fieldTextEditingController,
                  focusNode: fieldFocusNode,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text(L10n.of(context).d_editor_ingredient_unit),
                    suffixIcon: _ingredient.unit != null
                        ? IconButton(
                            onPressed: () =>
                                clearUnit(fieldTextEditingController),
                            icon: Icon(
                              MdiIcons.delete,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          )
                        : null,
                  ),
                ),
                onSelected: (Unit selection) {
                  setState(() {
                    _ingredient.unit = selection;
                  });
                },
                optionsViewBuilder: (
                  BuildContext context,
                  AutocompleteOnSelected<Unit> onSelected,
                  Iterable<Unit> options,
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
                border: OutlineInputBorder(),
                label: Text(L10n.of(context).d_editor_ingredient_label),
              ),
              validator: (input) {
                if (UValidator.isEmpty(input)) {
                  return L10n.of(context).v_isEmpty;
                }

                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  void clearUnit(TextEditingController unitController) {
    setState(() {
      _ingredient.unit = null;
      unitController.clear();
    });
  }

  void submit() {
    if (!_formKey.currentState!.validate()) return;
    context.pop(
      IngredientDraft(
        amount: double.tryParse(_amountController.text) ?? -1,
        unit: _ingredient.unit,
        label: _ingredientController.text.trim(),
      ),
    );
  }
}

/// Necessary until https://github.com/flutter/flutter/issues/98728 is fixed
class AutocompleteOptions extends StatelessWidget {
  final AutocompleteOnSelected<Unit> onSelected;
  final Iterable<Unit> options;

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
              final Unit option = options.elementAt(index);
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
                    child: Text(option.beautify),
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
