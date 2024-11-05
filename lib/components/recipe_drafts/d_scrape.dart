import 'package:flavormate/components/dialogs/t_alert_dialog.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/utils/u_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DScrape extends StatefulWidget {
  const DScrape({super.key});

  @override
  State<StatefulWidget> createState() => _DScrapeState();
}

class _DScrapeState extends State<DScrape> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TAlertDialog(
      title: L10n.of(context).d_drafts_scrape_title,
      submit: submit,
      positiveLabel: L10n.of(context).btn_download,
      child: Form(
        key: _formKey,
        child: TextFormField(
          controller: _urlController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            label: Text(L10n.of(context).d_drafts_scrape_url),
          ),
          validator: (input) {
            if (UValidator.isEmpty(input)) {
              return L10n.of(context).v_isEmpty;
            }

            return null;
          },
        ),
      ),
    );
  }

  void submit() {
    if (!_formKey.currentState!.validate()) return;
    context.pop(_urlController.text);
  }
}
