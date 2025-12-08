import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FFullDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback submit;

  const FFullDialog({
    super.key,
    required this.title,
    required this.submit,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: FAppBar(title: title),
        body: FResponsive(child: child),
        bottomNavigationBar: SafeArea(
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: PADDING),
            child: Row(
              spacing: PADDING,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(context.l10n.btn_cancel),
                ),
                FilledButton(
                  onPressed: submit,
                  child: Text(context.l10n.btn_save),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
