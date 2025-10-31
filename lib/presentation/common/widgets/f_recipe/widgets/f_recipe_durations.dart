import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_duration.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

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
            label: L10n.of(context).f_recipe_durations__prep_time,
          ),
        if (!cookTime!.isEmpty)
          RecipeDuration(
            duration: cookTime!,
            label: L10n.of(context).f_recipe_durations__cook_time,
          ),
        if (!restTime!.isEmpty)
          RecipeDuration(
            duration: restTime!,
            label: L10n.of(context).f_recipe_durations__rest_time,
          ),
      ],
    );
  }
}

class RecipeDuration extends StatelessWidget {
  final String label;
  final Duration duration;

  const RecipeDuration({
    super.key,
    required this.duration,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: const Icon(MdiIcons.clockOutline),
      label: Text('$label: ${duration.beautify(context)}'),
    );
  }
}
