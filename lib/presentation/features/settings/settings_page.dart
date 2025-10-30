import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/riverpod/package_info/p_package_info.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_self.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_struct.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/features/settings/components/settings_account_section.dart';
import 'package:flavormate/presentation/features/settings/components/settings_admin_section.dart';
import 'package:flavormate/presentation/features/settings/components/settings_misc_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageInfo = ref.watch(pPackageInfoProvider).requireValue;
    return FResponsive(
      child: Column(
        spacing: PADDING,
        children: [
          const SettingsAccountSection(),
          const SettingsMiscSection(),
          FProviderStruct(
            provider: pRestAccountsSelfProvider,
            builder: (_, account) => account.isAdmin
                ? const SettingsAdminSection()
                : const SizedBox.shrink(),
            onError: FEmptyMessage(
              title: L10n.of(context).settings_page__on_error,
              icon: StateIconConstants.authors.errorIcon,
            ),
          ),

          Center(
            child: FText(packageInfo.version, style: FTextStyle.bodySmall),
          ),
        ],
      ),
    );
  }
}
