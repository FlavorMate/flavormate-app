import 'package:flavormate/utils/u_os.dart';
import 'package:flutter/material.dart';

class TScrollableH extends StatefulWidget {
  final Widget child;

  const TScrollableH({super.key, required this.child});

  @override
  State<StatefulWidget> createState() => _TScrollableHState();
}

class _TScrollableHState extends State<TScrollableH> {
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
