import 'package:flavormate/core/auth/providers/p_auth.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/route_constants.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_current_server.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_button.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FEmptyMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool showLogoutButton;

  const FEmptyMessage({
    super.key,
    required this.title,
    required this.icon,
    this.subtitle,
    this.showLogoutButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: PADDING,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 96),
        FText(title, style: FTextStyle.titleLarge, textAlign: TextAlign.center),
        if (subtitle != null)
          FText(
            subtitle!,
            style: FTextStyle.titleSmall,
            textAlign: TextAlign.center,
          ),
        if (showLogoutButton)
          Consumer(
            builder: (context, ref, child) {
              return FButton(
                width: BUTTON_WIDTH,
                label: L10n.of(context).btn_logout,
                onPressed: () => logout(context, ref),
              );
            },
          ),
      ],
    );
  }

  void logout(BuildContext context, WidgetRef ref) async {
    await ref.read(pAuthProvider.notifier).logout();
    await ref.read(pSPCurrentServerProvider.notifier).set(null);

    if (!context.mounted) return;
    context.pushReplacementNamed(RouteConstants.Server.name);
  }
}
