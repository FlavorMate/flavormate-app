import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/utils/u_validator.dart';
import 'package:flavormate/data/models/features/accounts/account_update_dto.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_self.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_page_introduction.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsAccountEmailPage extends ConsumerStatefulWidget {
  const SettingsAccountEmailPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SettingsAccountEmailPageState();

  PRestAccountsSelfProvider get provider => pRestAccountsSelfProvider;
}

class _SettingsAccountEmailPageState
    extends ConsumerState<SettingsAccountEmailPage> {
  final _scrollController = ScrollController();

  final _newMail1Controller = TextEditingController();
  final _newMail2Controller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _scrollController.dispose();
    _newMail1Controller.dispose();
    _newMail2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentEmail = ref.watch(
      widget.provider.select(
        (it) => it.requireValue.email,
      ),
    );

    return Scaffold(
      appBar: FAppBar(
        title: context.l10n.settings_account_email_page__title,
        scrollController: _scrollController,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: updateValue,
        child: const Icon(MdiIcons.contentSave),
      ),
      body: SafeArea(
        child: FResponsive(
          controller: _scrollController,
          child: Column(
            spacing: PADDING,
            children: [
              FPageIntroduction(
                shape: .c4_sided_cookie,
                icon: MdiIcons.email,
                description:
                    context.l10n.settings_account_email_page__description,
              ),

              const SizedBox.shrink(),

              Form(
                key: _formKey,
                child: Column(
                  spacing: PADDING,
                  children: [
                    FTextFormField(
                      readOnly: true,
                      controller: TextEditingController.fromValue(
                        .new(text: currentEmail),
                      ),
                      suffix: const SizedBox.shrink(),
                      label: context
                          .l10n
                          .settings_account_email_page__current_email,
                    ),

                    FTextFormField(
                      label:
                          context.l10n.settings_account_email_page__new_email_1,
                      controller: _newMail1Controller,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      validators: (value) {
                        if (UValidator.isEmpty(value)) {
                          return context.l10n.validator__is_empty;
                        }

                        if (!UValidator.isMail(value!)) {
                          return context.l10n.validator__is_email;
                        }

                        return null;
                      },
                    ),
                    FTextFormField(
                      controller: _newMail2Controller,
                      label:
                          context.l10n.settings_account_email_page__new_email_2,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      validators: (value) {
                        if (UValidator.isEmpty(value)) {
                          return context.l10n.validator__is_empty;
                        }

                        if (!UValidator.isEqual(
                          value!,
                          _newMail1Controller.text,
                        )) {
                          return context.l10n.validator__is_equal;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateValue() async {
    if (!_formKey.currentState!.validate()) return;

    context.showLoadingDialog();

    final result = await ref
        .read(widget.provider.notifier)
        .putAccountsId(AccountUpdateDto(email: _newMail1Controller.text));

    if (!mounted) return;
    context.pop();

    if (!result.hasError) {
      _newMail1Controller.clear();
      _newMail2Controller.clear();

      context.showTextSnackBar(
        context.l10n.settings_account_email_page__change_email_success,
      );
    } else {
      context.showTextSnackBar(
        context.l10n.settings_account_email_page__change_email_failure,
      );
    }
  }
}
