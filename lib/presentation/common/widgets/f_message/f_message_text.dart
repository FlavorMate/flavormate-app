import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/widgets/f_message/f_message.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FMessageText extends ConsumerWidget implements FMessage {
  final String content;

  final FTextStyle? textStyle;
  final FontWeight? fontWeight;

  const FMessageText({
    super.key,
    required this.content,
    this.textStyle,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: context.colorScheme.surfaceContainer,
      child: Container(
        padding: const .all(PADDING / 1.5),
        child: FText(
          content,
          style: textStyle ?? .bodyMedium,
          color: .onInverseSurface,
          weight: fontWeight,
        ),
      ),
    );
  }
}
