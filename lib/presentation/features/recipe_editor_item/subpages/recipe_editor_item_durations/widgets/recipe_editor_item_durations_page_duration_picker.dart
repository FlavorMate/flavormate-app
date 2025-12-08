import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/core/utils/u_int.dart';
import 'package:flavormate/core/utils/u_validator.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/dialogs/f_alert_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecipeEditorItemDurationsPageDurationPicker extends StatefulWidget {
  final Duration duration;

  const RecipeEditorItemDurationsPageDurationPicker({
    super.key,
    required this.duration,
  });

  @override
  State<StatefulWidget> createState() =>
      _RecipeEditorItemDurationsPageDurationPickerState();
}

class _RecipeEditorItemDurationsPageDurationPickerState
    extends State<RecipeEditorItemDurationsPageDurationPicker> {
  final _formKey = GlobalKey<FormState>();

  final _daysController = TextEditingController();
  final _hoursController = TextEditingController();
  final _minutesController = TextEditingController();
  final _secondsController = TextEditingController();

  @override
  void initState() {
    int days = widget.duration.inDays;
    int hours = widget.duration.inHours.remainder(24);
    int minutes = widget.duration.inMinutes.remainder(60);
    int seconds = widget.duration.inSeconds.remainder(60);

    _daysController.text = UInt.isPositive(days) ? days.toString() : '';
    _hoursController.text = UInt.isPositive(hours) ? hours.toString() : '';
    _minutesController.text = UInt.isPositive(minutes)
        ? minutes.toString()
        : '';
    _secondsController.text = UInt.isPositive(seconds)
        ? seconds.toString()
        : '';
    super.initState();
  }

  @override
  void dispose() {
    _daysController.dispose();
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FAlertDialog(
      scrollable: true,
      title:
          context.l10n.recipe_editor_item_durations_page_duration_picker__title,
      submit: submit,
      child: Form(
        key: _formKey,
        child: Column(
          spacing: PADDING,
          children: [
            FTextFormField(
              controller: _daysController,
              label: context.l10n.time__days_long,

              validators: (input) {
                if (EString.isNotEmpty(input) && !UValidator.isNumber(input!)) {
                  return context.l10n.validator__is_number;
                }
                return null;
              },
            ),
            FTextFormField(
              controller: _hoursController,
              label: context.l10n.time__hours_long,

              validators: (input) {
                if (EString.isNotEmpty(input) && !UValidator.isNumber(input!)) {
                  return context.l10n.validator__is_number;
                }
                return null;
              },
            ),
            FTextFormField(
              controller: _minutesController,
              label: context.l10n.time__minutes_long,

              validators: (input) {
                if (EString.isNotEmpty(input) && !UValidator.isNumber(input!)) {
                  return context.l10n.validator__is_number;
                }
                return null;
              },
            ),
            FTextFormField(
              controller: _secondsController,
              label: context.l10n.time__seconds_long,

              validators: (input) {
                if (EString.isNotEmpty(input) && !UValidator.isNumber(input!)) {
                  return context.l10n.validator__is_number;
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  void submit() {
    if (!_formKey.currentState!.validate()) return;

    final duration = Duration(
      days: int.tryParse(_daysController.text) ?? 0,
      hours: int.tryParse(_hoursController.text) ?? 0,
      minutes: int.tryParse(_minutesController.text) ?? 0,
      seconds: int.tryParse(_secondsController.text) ?? 0,
    );
    context.pop(duration);
  }
}
