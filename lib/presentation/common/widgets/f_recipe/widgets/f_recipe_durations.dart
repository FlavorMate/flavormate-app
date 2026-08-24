import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_duration.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:material_ui/material_ui.dart';

class FRecipeDurations extends StatelessWidget {
  final Duration? prepTime;
  final Duration? cookTime;
  final Duration? restTime;

  const FRecipeDurations({
    super.key,
    required this.prepTime,
    required this.cookTime,
    required this.restTime,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: PADDING / 2,
      spacing: PADDING / 2,
      alignment: WrapAlignment.center,
      children: [
        if (!prepTime!.isEmpty)
          RecipeDuration(
            duration: prepTime!,
            label: context.l10n.f_recipe_durations__prep_time,
            type: .prepare,
          ),
        if (!cookTime!.isEmpty)
          RecipeDuration(
            duration: cookTime!,
            label: context.l10n.f_recipe_durations__cook_time,
            type: .cook,
          ),
        if (!restTime!.isEmpty)
          RecipeDuration(
            duration: restTime!,
            label: context.l10n.f_recipe_durations__rest_time,
            type: .rest,
          ),
      ],
    );
  }
}

class RecipeDuration extends StatelessWidget {
  final String label;
  final Duration duration;
  final RecipeDurationType type;

  const RecipeDuration({
    super.key,
    required this.duration,
    required this.label,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final icon = switch (type) {
      RecipeDurationType.prepare => Symbols.countertops_rounded,
      RecipeDurationType.cook => Symbols.skillet_rounded,
      RecipeDurationType.rest => Symbols.snooze_rounded,
    };
    return Chip(
      avatar: Icon(icon),
      label: Text('$label: ${duration.beautify(context)}'),
    );
  }
}

enum RecipeDurationType { prepare, cook, rest }
