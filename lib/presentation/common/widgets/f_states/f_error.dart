import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flutter/material.dart';

class FError extends StatelessWidget {
  final FEmptyMessage onError;

  const FError({super.key, required this.onError});

  @override
  Widget build(BuildContext context) {
    return Center(child: onError);
  }
}
