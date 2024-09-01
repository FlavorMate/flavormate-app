import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';

class TPageableContent extends StatelessWidget {
  final Widget child;

  const TPageableContent({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(PADDING),
            child: child,
          ),
        ),
      ),
    );
  }
}
