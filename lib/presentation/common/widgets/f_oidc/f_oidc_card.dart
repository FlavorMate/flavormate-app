import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/data/models/core/auth/oidc/oidc_provider.dart';
import 'package:flavormate/presentation/common/widgets/f_card.dart';
import 'package:flavormate/presentation/common/widgets/f_oidc/f_oidc_icon.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';

class FOidcCard extends StatelessWidget {
  final OIDCProvider provider;
  final VoidCallback onTap;

  const FOidcCard({super.key, required this.provider, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: FCard(
        onTap: onTap,
        child: Column(
          spacing: PADDING / 4,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FOidcIcon(provider: provider),
            FText(
              provider.name,
              style: FTextStyle.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
}
