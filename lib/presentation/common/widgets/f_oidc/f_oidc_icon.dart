import 'dart:typed_data';

import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/presentation/common/widgets/f_circular_avatar.dart';
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
            ? _errorBuilder(label)
            : Image.memory(
                data!,
                errorBuilder: (_, _, _) => _errorBuilder(label),
              ),
      ),
    );
  }

  Widget _errorBuilder(String label) {
    return FCircularAvatar(
      label: label[0],
      border: true,
    );
  }
}
