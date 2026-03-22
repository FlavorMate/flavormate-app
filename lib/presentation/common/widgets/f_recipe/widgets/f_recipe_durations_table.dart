import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_duration.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class FRecipeDurationsTable extends StatelessWidget {
  final Duration prepTime;
  final Duration cookTime;
  final Duration restTime;

  const FRecipeDurationsTable({
    super.key,
    required this.prepTime,
    required this.cookTime,
    required this.restTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: PADDING / 2,
      children: [
        if (!prepTime.isEmpty)
          _buildRow(
            context,
            prepTime,
            MdiIcons.knife,
            context.l10n.f_recipe_durations__prep_time,
          ),
        if (!cookTime.isEmpty)
          _buildRow(
            context,
            cookTime,
            MdiIcons.potSteam,
            context.l10n.f_recipe_durations__cook_time,
          ),
        if (!restTime.isEmpty)
          _buildRow(
            context,
            restTime,
            MdiIcons.clock,
            context.l10n.f_recipe_durations__rest_time,
          ),
      ],
    );
  }

  Row _buildRow(
    BuildContext context,
    Duration duration,
    IconData icon,
    String label,
  ) {
    return Row(
      spacing: PADDING / 2,
      children: [
        Icon(icon),
        FText(
          label,
          style: .bodyMedium,
        ),
        Expanded(
          child: FText(
            duration.beautify(context),
            style: .bodyMedium,
            textAlign: .end,
          ),
        ),
      ],
    );
  }
}
