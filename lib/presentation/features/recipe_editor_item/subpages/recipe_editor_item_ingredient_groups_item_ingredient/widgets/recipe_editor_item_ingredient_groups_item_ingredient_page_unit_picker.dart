import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/data/models/features/unit/unit_dto.dart';
import 'package:flavormate/data/repositories/features/units/p_rest_units.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_struct.dart';
import 'package:flavormate/presentation/common/widgets/f_text_form_field.dart';
import 'package:flutter/material.dart';

class RecipeEditorItemIngredientGroupsItemIngredientPageUnitPicker
    extends StatelessWidget {
  final String? initialValue;

  final void Function(UnitLocalizedDto) onSelected;

  final void Function() clear;

  const RecipeEditorItemIngredientGroupsItemIngredientPageUnitPicker({
    super.key,
    required this.initialValue,
    required this.onSelected,
    required this.clear,
  });

  PRestUnitsProvider get provider => pRestUnitsProvider(pageSize: -1);

  @override
  Widget build(BuildContext context) {
    return FProviderStruct(
      provider: provider,
      builder: (_, units) => Autocomplete<UnitLocalizedDto>(
        initialValue: TextEditingValue(text: initialValue.trimToBlank),
        displayStringForOption: (unit) => unit.labelSg,
        optionsBuilder: (textEditingValue) => textEditingValue.text.isEmpty
            ? []
            : units.data
                  .where((unit) => _matchesInput(unit, textEditingValue.text))
                  .toList(),
        fieldViewBuilder:
            (
              BuildContext context,
              TextEditingController fieldTextEditingController,
              FocusNode fieldFocusNode,
              VoidCallback onFieldSubmitted,
            ) => FTextFormField(
              controller: fieldTextEditingController,
              label: L10n.of(
                context,
              ).recipe_editor_item_ingredient_groups_item_ingredient_page_unit_picker__title,
              focusNode: fieldFocusNode,
              clear: clear,
            ),
        onSelected: onSelected,
      ),
      onError: FEmptyMessage(
        title: L10n.of(
          context,
        ).recipe_editor_item_ingredient_groups_item_ingredient_page_unit_picker__on_error,
        icon: StateIconConstants.units.errorIcon,
      ),
    );
  }

  bool _matchesInput(UnitLocalizedDto unit, String input) {
    return [
      unit.labelSg,
      unit.labelSgAbrv,
      unit.labelPl,
      unit.labelPlAbrv,
    ].nonNulls.any((label) => label.containsIgnoreCase(input));
  }
}
