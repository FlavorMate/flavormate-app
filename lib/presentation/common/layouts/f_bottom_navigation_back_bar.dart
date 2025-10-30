import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FBottomNavigationBackBar extends StatelessWidget {
  const FBottomNavigationBackBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 48,
        child: Center(
          child: TextButton(
            onPressed: () => context.pop(),
            child: Text(L10n.of(context).btn_back),
          ),
        ),
      ),
    );
  }
}
