import 'package:flavormate/core/utils/u_os.dart';
import 'package:flutter/material.dart';

class FScrollableH extends StatefulWidget {
  final Widget child;

  const FScrollableH({super.key, required this.child});

  @override
  State<StatefulWidget> createState() => _FScrollableHState();
}

class _FScrollableHState extends State<FScrollableH> {
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _controller,
      trackVisibility: UOS.isDesktop,
      thumbVisibility: UOS.isDesktop,
      thickness: 8,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: SingleChildScrollView(
          controller: _controller,
          scrollDirection: Axis.horizontal,
          child: widget.child,
        ),
      ),
    );
  }
}
