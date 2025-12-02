import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/package_info/p_package_info_version.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_current_server.dart';
import 'package:flavormate/data/repositories/core/server/p_server_version.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_struct.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeAccountDialogInfoSection extends ConsumerWidget {
  const HomeAccountDialogInfoSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final server = ref.watch(pSPCurrentServerProvider);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: .circular(24),
        color: context.colorScheme.surfaceContainer,
      ),
      padding: const .all(PADDING),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              FText(
                L10n.of(context).home_account_dialog_info_section__server_url,
                style: .bodyMedium,
              ),
              FText(
                server!,
                style: .bodyMedium,
                fontFamily: .monospace,
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              FText(
                L10n.of(
                  context,
                ).home_account_dialog_info_section__server_version,
                style: .bodyMedium,
              ),
              FProviderStruct(
                provider: pServerVersionProvider,
                onError: FEmptyMessage(
                  title: L10n.of(
                    context,
                  ).home_account_dialog_info_section__on_error,
                  icon: StateIconConstants.login.errorIcon,
                ),
                builder: (context, data) => FText(
                  data.toString(),
                  style: .bodyMedium,
                  fontFamily: .monospace,
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              FText(
                L10n.of(context).home_account_dialog_info_section__app_version,
                style: .bodyMedium,
              ),
              FProviderStruct(
                provider: pPackageInfoVersionProvider,
                onError: FEmptyMessage(
                  title: L10n.of(
                    context,
                  ).home_account_dialog_info_section__on_error,
                  icon: StateIconConstants.login.errorIcon,
                ),
                builder: (context, data) => FText(
                  data.toString(),
                  style: .bodyMedium,
                  fontFamily: .monospace,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
