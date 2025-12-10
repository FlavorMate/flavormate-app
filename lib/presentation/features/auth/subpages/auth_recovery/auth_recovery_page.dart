import 'package:flavormate/core/apis/rest/p_dio_public.dart';
import 'package:flavormate/core/constants/api_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_dio.dart';
import 'package:flavormate/core/utils/u_validator.dart';
import 'package:flavormate/presentation/common/layouts/f_bottom_navigation_back_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_button.dart';
import 'package:flavormate/presentation/common/widgets/f_card.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/common/widgets/f_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    return Scaffold(
      bottomNavigationBar: const FBottomNavigationBackBar(),
      body: SafeArea(
        child: FFixedResponsive(
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _form,
                child: FCard(
                  child: Column(
                    spacing: PADDING,
                    children: [
                      const Icon(MdiIcons.lockRemoveOutline, size: 72),
                      FText(
                        context.l10n.auth_recovery_page__hint_1,
                        style: FTextStyle.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        width: BUTTON_WIDTH,
                        child: FText(
                          context.l10n.auth_recovery_page__hint_2,
                          style: FTextStyle.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      FTextFormField(
                        controller: _emailController,
                        label: context.l10n.auth_recovery_page__email,
                        autocorrect: false,
                        autofillHints: const [AutofillHints.username],
                        keyboardType: TextInputType.visiblePassword,
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
                      FButton(
                        label: context.l10n.btn_reset_password,
                        onPressed: resetPassword,
                        width: BUTTON_WIDTH,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
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
