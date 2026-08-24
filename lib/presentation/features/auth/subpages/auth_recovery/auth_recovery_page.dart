import 'package:flavormate/core/apis/rest/p_dio_public.dart';
import 'package:flavormate/core/constants/api_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_dio.dart';
import 'package:flavormate/core/utils/u_validator.dart';
import 'package:flavormate/presentation/common/layouts/auth_page_template.dart';
import 'package:flavormate/presentation/common/widgets/f_text_form_field.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

class AuthRecoveryPage extends ConsumerStatefulWidget {
  const AuthRecoveryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AuthRecoveryPageState();
}

class _AuthRecoveryPageState extends ConsumerState<AuthRecoveryPage> {
  final _form = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageTemplate(
      title: context.l10n.auth_recovery_page__title,
      subtitle: context.l10n.auth_recovery_page__hint_1,
      bottomChild: M3EButton.text(
        onPressed: context.pop,
        child: Text(context.l10n.btn_back),
      ),
      children: [
        AutofillGroup(
          child: Form(
            key: _form,
            child: FTextFormField(
              controller: _emailController,
              label: context.l10n.auth_recovery_page__email,
              autocorrect: false,
              autofillHints: const [AutofillHints.username],
              keyboardType: TextInputType.visiblePassword,
              onFieldSubmitted: (_) => resetPassword(),
              validators: (input) {
                if (UValidator.isEmpty(input)) {
                  return context.l10n.validator__is_empty;
                }

                if (!UValidator.isMail(input!)) {
                  return context.l10n.validator__is_email;
                }

                return null;
              },
            ),
          ),
        ),
        Align(
          alignment: .centerRight,
          child: M3EButton(
            onPressed: resetPassword,
            child: Text(context.l10n.btn_continue),
          ),
        ),
      ],
    );
  }

  void resetPassword() async {
    if (!_form.currentState!.validate()) return;

    context.showLoadingDialog();

    bool isOk = false;
    try {
      final response = await ref
          .read(pDioPublicProvider)
          .put(ApiConstants.Recovery, data: _emailController.text);

      isOk = response.isOK;
    } catch (_) {
      isOk = false;
    }

    if (!mounted) return;
    context.pop();

    if (!isOk) {
      context.showTextSnackBar(
        context.l10n.auth_recovery_page__recovery_failure,
      );
    } else {
      _emailController.clear();
      context.pop();
      context.showTextSnackBar(
        context.l10n.auth_recovery_page__recovery_success,
      );
    }
  }
}
