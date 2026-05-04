import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/widgets/f_card.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';

class FIconCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final double width;
  final double iconSize;

  final VoidCallback? onTap;

  const FIconCard({
    required this.icon,
    required this.label,
    this.width = 125,
    this.iconSize = 48,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: FCard(
        onTap: onTap,
        child: Column(
          spacing: PADDING / 2,
          children: [
            Icon(
              color: context.colorScheme.primary,
              icon,
              size: iconSize,
            ),
            Expanded(
              child: Center(
                child: FText(
                  label,
                  style: FTextStyle.bodyMedium,
                  textAlign: TextAlign.center,
                  color: FTextColor.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
