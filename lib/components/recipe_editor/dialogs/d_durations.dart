import 'package:flavormate/components/dialogs/t_full_dialog.dart';
import 'package:flavormate/components/recipe_editor/dialogs/d_duration.dart';
import 'package:flavormate/components/t_button.dart';
import 'package:flavormate/components/t_card.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/extensions/e_duration.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';

class DDurations extends StatefulWidget {
  final Duration prepTime;
  final Duration cookTime;
  final Duration restTime;

  const DDurations({
    super.key,
    required this.prepTime,
    required this.cookTime,
    required this.restTime,
  });

  @override
  State<StatefulWidget> createState() => _DDurationsState();
}

class _DDurationsState extends State<DDurations> {
  late Duration _prepTime;
  late Duration _cookTime;
  late Duration _restTime;

  @override
  void initState() {
    _prepTime = widget.prepTime;
    _cookTime = widget.cookTime;
    _restTime = widget.restTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TFullDialog(
      title: L10n.of(context).d_editor_durations_title,
      submit: submit,
      child: TColumn(
        children: [
          TCard(
            child: TColumn(
              children: [
                TText(
                  L10n.of(context).d_editor_durations_prep_time_title,
                  TextStyles.titleLarge,
                ),
                TButton(
                  leading: const Icon(MdiIcons.stove),
                  onPressed: () => setPrepTime(context),
                  label: _prepTime.beautify2(context),
                ),
              ],
            ),
          ),
          TCard(
            child: TColumn(
              children: [
                TText(
                  L10n.of(context).d_editor_durations_cook_time_title,
                  TextStyles.titleLarge,
                ),
                TButton(
                  leading: const Icon(MdiIcons.stove),
                  onPressed: () => setCookTime(context),
                  label: _cookTime.beautify2(context),
                ),
              ],
            ),
          ),
          TCard(
            child: TColumn(
              children: [
                TText(
                  L10n.of(context).d_editor_durations_rest_time_title,
                  TextStyles.titleLarge,
                ),
                TButton(
                  leading: const Icon(MdiIcons.stove),
                  onPressed: () => setRestTime(context),
                  label: _restTime.beautify2(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void setPrepTime(BuildContext context) async {
    final response = await showDialog<Duration>(
      context: context,
      builder: (_) => DDuration(duration: _prepTime),
    );
    if (response == null) return;
    setState(() => _prepTime = response);
  }

  void setCookTime(BuildContext context) async {
    final response = await showDialog<Duration>(
      context: context,
      builder: (_) => DDuration(duration: _cookTime),
    );
    if (response == null) return;
    setState(() => _cookTime = response);
  }

  void setRestTime(BuildContext context) async {
    final response = await showDialog<Duration>(
      context: context,
      builder: (_) => DDuration(duration: _restTime),
    );
    if (response == null) return;
    setState(() => _restTime = response);
  }

  void submit() {
    context.pop({
      'prepTime': _prepTime,
      'cookTime': _cookTime,
      'restTime': _restTime,
    });
  }
}
