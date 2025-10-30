import 'package:flavormate/data/models/core/version/version.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_admonition.dart';
import 'package:flutter/material.dart';

class LoginCompatibilityAdmonition extends StatelessWidget {
  final VersionComparison compatibility;

  const LoginCompatibilityAdmonition({super.key, required this.compatibility});

  @override
  Widget build(BuildContext context) {
    return switch (compatibility) {
      VersionComparison.majorIncompatible => FAdmonition.error(
        content: L10n.of(
          context,
        ).login_compatibility_admonition__major.replaceAll('\\n', '\n'),
      ),
      VersionComparison.minorIncompatible => FAdmonition.warning(
        content: L10n.of(
          context,
        ).login_compatibility_admonition__minor.replaceAll('\\n', '\n'),
      ),
      VersionComparison.fullyCompatible => const SizedBox.shrink(),
    };
  }
}
