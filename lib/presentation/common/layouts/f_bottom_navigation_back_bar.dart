import 'package:flavormate/core/extensions/e_build_context.dart';
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
            child: Text(context.l10n.btn_back),
          ),
        ),
      ),
    );
  }
}
