import 'dart:io';

import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/theme/utils/u_app_icon.dart';
import 'package:flavormate/generated/flutter_gen/assets.gen.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_card.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/common/widgets/f_wrap.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsAppAppIconPage extends StatelessWidget {
  const SettingsAppAppIconPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FText(
          L10n.of(context).settings_app_app_icon_page__title,
          style: .bodyLarge,
        ),
      ),
      body: SafeArea(
        child: FResponsive(
          child: Column(
            spacing: PADDING,
            children: [
              FCard(
                child: FText(
                  L10n.of(
                    context,
                  ).settings_app_app_icon_page__hint,
                  style: .bodyMedium,
                ),
              ),
              FWrap(
                children: [
                  SettingsAppAppIconCard(
                    imagePath: Assets.appIcons.flavormate.path,
                    label: L10n.of(
                      context,
                    ).settings_app_app_icon_page__icon_flavormate,
                    onTap: () => setIcon(context, .appIcon),
                  ),
                  SettingsAppAppIconCard(
                    imagePath: Assets.appIcons.winter2025.path,
                    label: L10n.of(
                      context,
                    ).settings_app_app_icon_page__icon_winter_2025,
                    onTap: () => setIcon(context, .winter2025),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setIcon(BuildContext context, AppIcon icon) async {
    if (!Platform.isAndroid && !Platform.isIOS && !Platform.isMacOS) return;

    context.showLoadingDialog();

    bool success = true;
    try {
      await UAppIcon.changeIcon(icon);
    } catch (e) {
      success = false;
    }

    if (!context.mounted) return;
    context.pop();

    if (success) {
      context.showTextSnackBar(
        L10n.of(context).settings_app_app_icon_page__on_success,
      );
    } else {
      context.showErrorSnackBar(
        L10n.of(context).settings_app_app_icon_page__on_error,
      );
    }
  }
}

class SettingsAppAppIconCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;

  const SettingsAppAppIconCard({
    super.key,
    required this.imagePath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Card.outlined(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: PADDING / 2,
              children: [
                ClipRRect(
                  borderRadius: .circular(BORDER_RADIUS),
                  child: SizedBox(
                    height: 128,
                    width: 128,
                    child: Image.asset(imagePath),
                  ),
                ),
                FText(label, style: .bodyLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
