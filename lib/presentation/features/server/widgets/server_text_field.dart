import 'package:flavormate/core/utils/u_validator.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/widgets/f_text_form_field.dart';
import 'package:flutter/material.dart';

class ServerTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool readOnly;
  final VoidCallback setServer;

  const ServerTextField({
    super.key,
    required this.controller,
    required this.readOnly,
    required this.setServer,
  });

  @override
  Widget build(BuildContext context) {
    return FTextFormField(
      label: context.l10n.server_text_field__title,
      controller: controller,
      readOnly: readOnly,
      validators: (input) {
        if (UValidator.isEmpty(input)) {
          return context.l10n.validator__is_empty;
        }

        if (!UValidator.isHttpUrl(input!)) {
          return context.l10n.validator__is_http_url;
        }

        return null;
      },
      keyboardType: TextInputType.visiblePassword,
      autocorrect: false,
      onFieldSubmitted: (_) => setServer(),
    );
  }
}
