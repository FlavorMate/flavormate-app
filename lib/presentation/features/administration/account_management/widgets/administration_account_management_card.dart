import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_date_time.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_card.dart';
import 'package:flavormate/presentation/common/widgets/f_chip/f_state_chip.dart';
import 'package:flavormate/presentation/common/widgets/f_circular_avatar_viewer.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/common/widgets/f_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class AdministrationAccountManagementCard extends StatelessWidget {
  final AccountFullDto account;
  final bool isOwnAccount;
  final Function(AccountFullDto) onTap;

  const AdministrationAccountManagementCard({
    super.key,
    required this.account,
    required this.isOwnAccount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 450,
      child: FCard(
        onTap: isOwnAccount ? null : () => onTap.call(account),
        child: Row(
          spacing: PADDING,
          children: [
            FCircularAvatarViewer(
              account: account,
              border: true,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FText(
                    account.displayName,
                    style: FTextStyle.titleMedium,
                  ),
                  const SizedBox(height: PADDING / 2),
                  FText(
                    '@${account.username}',
                    style: FTextStyle.bodyMedium,
                  ),
                  const SizedBox(height: PADDING / 2),
                  FText(
                    account.email,
                    style: FTextStyle.bodyMedium,
                  ),
                  const SizedBox(height: PADDING),
                  SizedBox(
                    width: double.infinity,
                    child: FWrap(
                      children: [
                        FStateChip(
                          active: account.enabled,
                          label: account.enabled
                              ? L10n.of(
                                  context,
                                ).administration_account_management_page__account_enabled
                              : L10n.of(
                                  context,
                                ).administration_account_management_page__account_disabled,
                        ),
                        FStateChip(
                          active: account.verified,
                          label: account.verified
                              ? L10n.of(
                                  context,
                                ).administration_account_management_page__account_verified
                              : L10n.of(
                                  context,
                                ).administration_account_management_page__account_unverified,
                        ),
                        Chip(
                          avatar: const Icon(
                            MdiIcons.calendarAccount,
                          ),
                          label: Text(
                            account.createdOn.toLocalDateString(
                              context,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
