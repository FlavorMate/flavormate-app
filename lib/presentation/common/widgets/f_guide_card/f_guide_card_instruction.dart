import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/presentation/common/widgets/f_guide_card/f_guide_card.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';

class FGuideCardInstruction extends FGuideCard {
  final String? currentStepLabel;
  final int currentGroup;
  final int lastGroup;
  final int currentStep;
  final int lastStep;
  final String content;
  final double fontSize;

  const FGuideCardInstruction({
    super.key,
    required super.id,
    required this.content,
    required this.currentStepLabel,
    required this.currentGroup,
    required this.lastGroup,
    required this.currentStep,
    required this.lastStep,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return super.builder(
      context,
      Column(
        mainAxisSize: .max,
        spacing: PADDING,
        children: [
          if (currentStepLabel.isNotBlank) ...[
            FText(
              '$currentStepLabel ($currentGroup / $lastGroup)',
              style: .titleMedium,
            ),
            const Divider(),
          ],
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: FText(
                  content,
                  style: .titleMedium,
                  fontWeight: .normal,
                  textAlign: .center,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
          FText('$currentStep / $lastStep', style: .bodyMedium),
        ],
      ),
    );
  }
}
