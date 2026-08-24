import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

class FConfirmDialog extends StatelessWidget {
  final String title;
  final String? content;

  const FConfirmDialog({
    super.key,
    required this.title,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return M3EDialog(
      title: title,
      content: content != null
          ? MarkdownBody(
              data: content!,
              shrinkWrap: true,
            )
          : null,
      actions: [
        M3EButton(
          style: .text,
          onPressed: () => context.pop(false),
          child: Text(context.l10n.btn_cancel),
        ),
        M3EButton(
          onPressed: () => context.pop(true),
          child: Text(context.l10n.btn_yes),
        ),
      ],
    );
  }
}

Future<bool?> openConfirmDialog(
  BuildContext context, {
  required String title,
  String? content,
}) async {
  return await M3EDialog.show<bool>(
    context,
    dialog: FConfirmDialog(
      title: title,
      content: content,
    ),
  );
}
