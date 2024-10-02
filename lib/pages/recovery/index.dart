import 'package:flavormate/components/t_app_bar.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/extensions/e_build_context.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flavormate/utils/u_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RecoveryPage extends ConsumerStatefulWidget {
  const RecoveryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RecoveryPageState();
}

class _RecoveryPageState extends ConsumerState<RecoveryPage> {
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
      appBar: TAppBar(title: L10n.of(context).p_recovery_title),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(PADDING),
              constraints: const BoxConstraints(maxWidth: Breakpoints.sm),
              child: Form(
                key: _form,
                child: Column(
                  children: [
                    Icon(
                      MdiIcons.lockRemoveOutline,
                      size: 128,
                    ),
                    TText(
                      L10n.of(context).p_recovery_title,
                      TextStyles.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: PADDING * 2),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        label: Text(L10n.of(context).p_recovery_mail),
                        border: const OutlineInputBorder(),
                      ),
                      autocorrect: false,
                      autofillHints: const [AutofillHints.username],
                      validator: (input) {
                        if (UValidator.isEmpty(input)) {
                          return L10n.of(context).v_isEmpty;
                        }

                        if (!UValidator.isMail(input!)) {
                          return L10n.of(context).v_isMail;
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: PADDING / 2),
                    FilledButton(
                      onPressed: resetPassword,
                      child: Text(L10n.of(context).btn_reset),
                    ),
                  ],
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

    await ref
        .read(pApiProvider)
        .selfServiceClient
        .recovery(_emailController.text);

    if (!mounted) return;
    // pop the dialog
    context.pop();
    context.showTextSnackBar(L10n.of(context).p_recovery_mail_confirm);
    context.pop();
  }
}
