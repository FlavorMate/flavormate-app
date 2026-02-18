import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_date_time.dart';
import 'package:flavormate/data/models/core/auth/session_dto.dart';
import 'package:flavormate/presentation/common/dialogs/f_alert_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';

class SettingsAccountSessionsInfoDialog extends StatelessWidget {
  final SessionDto session;

  const SettingsAccountSessionsInfoDialog({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return FAlertDialog(
      title: context.l10n.settings_account_sessions_info_dialog__title,
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
              context.l10n.settings_account_sessions_info_dialog__id,
              session.id,
            ),
            const Divider(),
            _buildRow(
              context.l10n.settings_account_sessions_info_dialog__created_at,
              session.createdAt.formatter.dateTime.yyMMddHHmm(context),
            ),
            const Divider(),
            _buildRow(
              context
                  .l10n
                  .settings_account_sessions_info_dialog__last_modified_at,
              session.lastModifiedAt.formatter.dateTime.yyMMddHHmm(context),
            ),
            const Divider(),
            _buildRow(
              context.l10n.settings_account_sessions_info_dialog__expires_at,
              session.expiresAt.formatter.dateTime.yyMMddHHmm(context),
            ),
            const Divider(),
            _buildRow(
              context.l10n.settings_account_sessions_info_dialog__revoked,
              session.revoked ? context.l10n.btn_yes : context.l10n.btn_no,
            ),
            if (session.userAgent != null) ...[
              const Divider(),
              _buildRow(
                context.l10n.settings_account_sessions_info_dialog__device,
                session.userAgent!.device,
              ),
              const Divider(),
              _buildRow(
                context.l10n.settings_account_sessions_info_dialog__os,
                session.userAgent!.os,
              ),
              const Divider(),
              _buildRow(
                context.l10n.settings_account_sessions_info_dialog__version,
                session.userAgent!.version,
              ),
            ],
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
