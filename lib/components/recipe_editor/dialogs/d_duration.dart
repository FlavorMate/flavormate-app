import 'package:flavormate/components/dialogs/t_alert_dialog.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/utils/u_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DDuration extends StatefulWidget {
  final Duration duration;

  const DDuration({super.key, required this.duration});

  @override
  State<StatefulWidget> createState() => _DDurationState();
}

class _DDurationState extends State<DDuration> {
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

    _daysController.text = days.toString();
    _hoursController.text = hours.toString();
    _minutesController.text = minutes.toString();
    _secondsController.text = seconds.toString();
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
    return TAlertDialog(
      scrollable: true,
      title: L10n.of(context).d_editor_durations_title,
      submit: submit,
      child: Form(
        key: _formKey,
        child: TColumn(
          children: [
            TextFormField(
              controller: _daysController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: Text(L10n.of(context).d_editor_duration_days),
              ),
              validator: (input) {
                if (!UValidator.isNumber(input!)) {
                  return L10n.of(context).v_isNumber;
                }
                return null;
              },
            ),
            TextFormField(
              controller: _hoursController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: Text(L10n.of(context).d_editor_duration_hours),
              ),
              validator: (input) {
                if (!UValidator.isNumber(input!)) {
                  return L10n.of(context).v_isNumber;
                }
                return null;
              },
            ),
            TextFormField(
              controller: _minutesController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: Text(L10n.of(context).d_editor_duration_minutes),
              ),
              validator: (input) {
                if (!UValidator.isNumber(input!)) {
                  return L10n.of(context).v_isNumber;
                }
                return null;
              },
            ),
            TextFormField(
              controller: _secondsController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: Text(L10n.of(context).d_editor_duration_seconds),
              ),
              validator: (input) {
                if (!UValidator.isNumber(input!)) {
                  return L10n.of(context).v_isNumber;
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
