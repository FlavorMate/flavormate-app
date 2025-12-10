import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class FConfirmDialog extends StatelessWidget {
  final String title;
  final String? content;
  final double width;

  const FConfirmDialog({
    super.key,
    required this.title,
    this.content,
    this.width = 450,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: content != null
          ? SizedBox(
              width: width,
              child: MarkdownBody(
                data: content!,
                shrinkWrap: true,
              ),
            )
          : null,
      actions: [
        TextButton(
          onPressed: () => context.pop(false),
          child: Text(context.l10n.btn_cancel),
        ),
        FilledButton(
          onPressed: () => context.pop(true),
          child: Text(context.l10n.btn_yes),
        ),
      ],
    );
  }
}
