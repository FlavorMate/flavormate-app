import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/utils/u_validator.dart';
import 'package:flavormate/data/models/features/accounts/account_update_dto.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_self.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_page_introduction.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/common/widgets/f_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsAccountPasswordPage extends ConsumerStatefulWidget {
  const SettingsAccountPasswordPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SettingsAccountPasswordPageState();

  PRestAccountsSelfProvider get provider => pRestAccountsSelfProvider;
}

class _SettingsAccountPasswordPageState
    extends ConsumerState<SettingsAccountPasswordPage> {
  final _scrollController = ScrollController();

  final _oldPasswordController = TextEditingController();
  final _newPassword1Controller = TextEditingController();
  final _newPassword2Controller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool validLength = false;

  bool validUppercase = false;

  bool validLowercase = false;

  bool validNumber = false;

  bool validChars = false;

  @override
  void dispose() {
    _scrollController.dispose();
    _oldPasswordController.dispose();
    _newPassword1Controller.dispose();
    _newPassword2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar(
        title: context.l10n.settings_account_password_page__title,
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
                shape: .c12_sided_cookie,
                icon: MdiIcons.formTextboxPassword,
                description:
                    context.l10n.settings_account_password_page__description,
              ),

              const SizedBox.shrink(),

              Form(
                key: _formKey,
                child: Column(
                  spacing: PADDING,
                  children: [
                    FTextFormField(
                      controller: _oldPasswordController,
                      label: context
                          .l10n
                          .settings_account_password_page__old_password,
                      obscureText: true,
                      validators: (value) {
                        if (UValidator.isEmpty(value)) {
                          return context.l10n.validator__is_empty;
                        }

                        return null;
                      },
                    ),
                    const Divider(),

                    Column(
                      spacing: PADDING / 2,
                      children: [
                        _RequirementCard(
                          selected: validLength,
                          label: context
                              .l10n
                              .settings_account_password_page__length,
                        ),
                        _RequirementCard(
                          selected: validUppercase,
                          label: context
                              .l10n
                              .settings_account_password_page__uppercase,
                        ),
                        _RequirementCard(
                          selected: validLowercase,
                          label: context
                              .l10n
                              .settings_account_password_page__lowercase,
                        ),
                        _RequirementCard(
                          selected: validNumber,
                          label: context
                              .l10n
                              .settings_account_password_page__number,
                        ),
                        _RequirementCard(
                          selected: validChars,
                          label: context
                              .l10n
                              .settings_account_password_page__special_character,
                        ),
                      ],
                    ),

                    const SizedBox.shrink(),

                    FTextFormField(
                      controller: _newPassword1Controller,

                      label: context
                          .l10n
                          .settings_account_password_page__new_password_1,
                      obscureText: true,
                      onChanged: (_) {
                        setState(() {
                          validLength = RegExp(
                            r'.{8,}',
                          ).hasMatch(_newPassword1Controller.text);

                          validUppercase = RegExp(
                            r'(?=.*[A-Z])',
                          ).hasMatch(_newPassword1Controller.text);

                          validLowercase = RegExp(
                            r'(?=.*[a-z])',
                          ).hasMatch(_newPassword1Controller.text);

                          validNumber = RegExp(
                            r'(?=.*[0-9])',
                          ).hasMatch(_newPassword1Controller.text);

                          validChars = RegExp(
                            r'(?=.*\W)',
                          ).hasMatch(_newPassword1Controller.text);
                        });
                      },
                      validators: (value) {
                        if (UValidator.isEmpty(value)) {
                          return context.l10n.validator__is_empty;
                        }

                        if (!UValidator.isSecure(value!)) {
                          return context.l10n.validator__is_secure;
                        }

                        return null;
                      },
                    ),
                    FTextFormField(
                      controller: _newPassword2Controller,

                      label: context
                          .l10n
                          .settings_account_password_page__new_password_2,
                      obscureText: true,
                      validators: (value) {
                        if (UValidator.isEmpty(value)) {
                          return context.l10n.validator__is_empty;
                        }

                        if (!UValidator.isEqual(
                          value!,
                          _newPassword1Controller.text,
                        )) {
                          return context.l10n.validator__is_equal;
                        }

                        if (!UValidator.isSecure(value)) {
                          return context.l10n.validator__is_secure;
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
        .putAccountsId(
          AccountUpdateDto(
            oldPassword: _oldPasswordController.text,
            newPassword: _newPassword1Controller.text,
          ),
        );

    if (!mounted) return;
    context.pop();

    if (!result.hasError) {
      _oldPasswordController.clear();
      _newPassword1Controller.clear();
      _newPassword2Controller.clear();

      context.showTextSnackBar(
        context.l10n.settings_account_page__change_password_success,
      );
    } else {
      context.showTextSnackBar(
        context.l10n.settings_account_page__change_password_failure,
      );
    }
  }
}

class _RequirementCard extends StatelessWidget {
  final bool selected;
  final String label;

  const _RequirementCard({required this.selected, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: PADDING / 2,
      children: [
        Icon(selected ? MdiIcons.checkCircle : MdiIcons.circleOutline),
        FText(
          label,
          style: .bodyMedium,
        ),
      ],
    );
  }
}
