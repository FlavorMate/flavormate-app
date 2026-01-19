import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_date_time.dart';
import 'package:flavormate/data/models/core/auth/oidc/oidc_link_dto.dart';
import 'package:flavormate/presentation/common/dialogs/f_alert_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';

class SettingsAccountOidcLinkInfoDialog extends StatelessWidget {
  final OidcLinkDto link;

  const SettingsAccountOidcLinkInfoDialog({super.key, required this.link});

  @override
  Widget build(BuildContext context) {
    return FAlertDialog(
      title: context.l10n.settings_account_oidc_link_info_dialog__title,
      negativeLabel: context.l10n.btn_close,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: .circular(16),
          color: context.colorScheme.surfaceContainer,
        ),
        padding: const .all(PADDING),
        child: Column(
          mainAxisSize: .min,
          spacing: PADDING / 4,
          children: [
            _buildRow(
              context.l10n.settings_account_oidc_link_info_dialog__name,
              link.providerName,
            ),
            const Divider(),
            _buildRow(
              context.l10n.settings_account_oidc_link_info_dialog__id,
              link.providerId,
            ),
            const Divider(),
            _buildRow(
              context.l10n.settings_account_oidc_link_info_dialog__host,
              link.host,
            ),
            const Divider(),
            _buildRow(
              context.l10n.settings_account_oidc_link_info_dialog__issuer,
              link.issuer,
            ),
            const Divider(),
            _buildRow(
              context.l10n.settings_account_oidc_link_info_dialog__subject,
              link.subject,
            ),
            const Divider(),
            _buildRow(
              context.l10n.settings_account_oidc_link_info_dialog__user,
              link.name,
            ),
            const Divider(),
            _buildRow(
              context.l10n.settings_account_oidc_link_info_dialog__created_on,
              link.createdOn.toLocalDateTimeString(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String key, String value) {
    return Row(
      spacing: PADDING,
      mainAxisAlignment: .spaceBetween,
      children: [
        FText(
          key,
          style: .bodyMedium,
        ),
        Flexible(
          child: FText(
            value,
            style: .bodyMedium,
            fontFamily: .monospace,
            // textOverflow: .ellipsis,
            textAlign: .end,
          ),
        ),
      ],
    );
  }
}
