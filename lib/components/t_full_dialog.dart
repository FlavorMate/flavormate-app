import 'package:flavormate/components/t_app_bar.dart';
import 'package:flavormate/components/t_responsive.dart';
import 'package:flavormate/components/t_row.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/constants.dart';

class TFullDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback submit;

  const TFullDialog({
    super.key,
    required this.title,
    required this.submit,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: TAppBar(title: title),
        body: TResponsive(child: child),
        bottomNavigationBar: SafeArea(
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: PADDING),
            child: TRow(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(L10n.of(context).btn_cancel),
                ),
                FilledButton(
                  onPressed: submit,
                  child: Text(L10n.of(context).btn_save),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
