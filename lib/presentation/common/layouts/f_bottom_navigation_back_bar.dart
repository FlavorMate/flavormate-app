import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/widgets/f_text_button.dart';
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
          child: FTextButton(
            onPressed: () => context.pop(),
            value: context.l10n.btn_back,
          ),
        ),
      ),
    );
  }
}
