import 'dart:async';

import 'package:flavormate/core/auth/providers/p_auth.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/package_info/p_package_info_version.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_current_server.dart';
import 'package:flavormate/data/models/core/version/version.dart';
import 'package:flavormate/data/repositories/core/server/p_server_compatibility.dart';
import 'package:flavormate/data/repositories/core/server/p_server_version.dart';
import 'package:flavormate/presentation/common/widgets/f_button.dart';
import 'package:flavormate/presentation/common/widgets/f_card.dart';
import 'package:flavormate/presentation/common/widgets/f_page_introduction.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServerOutdatedPage extends ConsumerStatefulWidget {
  const ServerOutdatedPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ServerOutdatedPageState();
}

class _ServerOutdatedPageState extends ConsumerState<ServerOutdatedPage> {
  Timer? timer;

  @override
  void initState() {
    timer = Timer.periodic(
      const Duration(seconds: 5),
      _checkIfServerIsCompatible,
    );

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final server = ref.read(pSPCurrentServerProvider);

    final clientVersion = ref.watch(pPackageInfoVersionProvider);
    final serverVersion = ref.watch(pServerVersionProvider);

    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(PADDING),
        child: Stack(
          children: [
            Center(
              child: Column(
                spacing: PADDING,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FPageIntroduction(
                    shape: .burst,
                    icon: MdiIcons.cloudAlert,
                    description: context.l10n.server_outdated_page__hint_1,
                  ),
                  FCard(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            FText(
                              context
                                  .l10n
                                  .home_account_dialog_info_section__app_version,
                              style: .bodyMedium,
                            ),
                            Flexible(
                              child: FText(
                                clientVersion.value?.toString() ?? '...',
                                style: .bodyMedium,
                                textOverflow: .ellipsis,
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
                              context
                                  .l10n
                                  .home_account_dialog_info_section__server_version,
                              style: .bodyMedium,
                            ),
                            Flexible(
                              child: FText(
                                serverVersion.value?.toString() ?? '...',
                                style: .bodyMedium,
                                textOverflow: .ellipsis,
                                fontFamily: .monospace,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  FButton(
                    width: BUTTON_WIDTH,
                    onPressed: logout,
                    label: context.l10n.btn_logout,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: kToolbarHeight,
          child: Center(
            child: FText('☁ $server', style: FTextStyle.bodyMedium),
          ),
        ),
      ),
    );
  }

  Future<void> logout() async {
    await ref.read(pAuthProvider.notifier).logout();
  }

  Future<void> _checkIfServerIsCompatible(Timer timer) async {
    final response = await ref.read(pServerCompatibilityProvider.future);

    if (response != VersionComparison.majorIncompatible && mounted) {
      await context.routes.splash(replace: true);
    }
  }
}
