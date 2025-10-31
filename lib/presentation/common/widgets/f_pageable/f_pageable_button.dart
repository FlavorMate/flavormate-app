import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable_type.dart';
import 'package:flutter/material.dart';

class FPageableButton extends StatelessWidget {
  final String label;
  final double width;
  final FPageableType type;
  final VoidCallback onPressed;

  const FPageableButton({
    super.key,
    required this.label,
    required this.width,
    required this.type,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: type == FPageableType.current
          ? FilledButton(
              style: FilledButton.styleFrom(padding: EdgeInsets.zero),
              onPressed: onPressed,
              child: Text(label),
            )
          : FilledButton.tonal(
              style: FilledButton.styleFrom(padding: EdgeInsets.zero),
              onPressed: onPressed,
              child: Text(label),
            ),
    );
  }
}
