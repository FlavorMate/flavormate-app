import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

class FAlertDialog extends StatelessWidget {
  final bool scrollable;

  final String title;
  final Widget child;
  final List<Widget>? actions;

  final double width;
  final double? height;

  final VoidCallback? submit;

  final String? negativeLabel;
  final String? positiveLabel;

  const FAlertDialog({
    super.key,
    this.scrollable = false,
    required this.title,
    required this.child,
    this.actions,
    this.width = 450,
    this.height,
    this.submit,
    this.negativeLabel,
    this.positiveLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: M3EDialog(
        title: title,
        topDivider: true,
        bottomDivider: true,
        content: child,
        actions: [
          ...?actions,
          M3EButton.text(
            onPressed: () => context.pop(),
            child: Text(negativeLabel ?? context.l10n.btn_cancel),
          ),
          if (submit != null)
            M3EButton(
              onPressed: submit,
              child: Text(positiveLabel ?? context.l10n.btn_save),
            ),
        ],
      ),
    );
  }
}

Future<T?> openAlertDialog<T>(
  BuildContext context, {
  required Widget dialog,
  // required String title,
  // required Widget child,
  // List<Widget>? actions,
  // VoidCallback? submit,
  // String? negativeLabel,
  // String? positiveLabel,
}) async {
  return M3EDialog.show<T>(context, dialog: dialog);
}
