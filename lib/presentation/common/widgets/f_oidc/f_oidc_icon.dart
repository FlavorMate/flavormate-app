import 'dart:typed_data';

import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FOidcIcon extends ConsumerWidget {
  final Uint8List? data;
  final String label;
  final double height;
  final double width;

  const FOidcIcon({
    super.key,
    required this.data,
    required this.label,
    this.height = 40,
    this.width = 40,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(BORDER_RADIUS),
        child: data == null
            ? _errorBuilder(context, label)
            : Image.memory(
                data!,
                errorBuilder: (_, _, _) => _errorBuilder(context, label),
              ),
      ),
    );
  }

  Widget _errorBuilder(BuildContext context, String label) {
    final radius = width / 2;
    return CircleAvatar(
      backgroundColor: context.colorScheme.primary,
      radius: radius,
      child: CircleAvatar(
        minRadius: radius - (radius * 0.075),
        maxRadius: radius - (radius * 0.075),
        child: Text(
          label[0],
          style: context.textTheme.bodyMedium!.copyWith(
            fontSize: radius,
          ),
        ),
      ),
    );
  }
}
