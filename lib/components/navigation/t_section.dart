import 'package:flutter/material.dart';

class TSection extends StatelessWidget {
  final bool active;
  final Widget child;

  const TSection({super.key, required this.active, required this.child});

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !active,
      child: TickerMode(
        enabled: active,
        child: child,
      ),
    );
  }
}
