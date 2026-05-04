import 'package:flavormate/presentation/common/widgets/f_input_type/f_input_type_aware_app.dart';
import 'package:flutter/material.dart';

class FScrollable extends StatefulWidget {
  final Widget child;
  final Axis axis;

  const FScrollable({super.key, required this.child, this.axis = .horizontal});

  @override
  State<StatefulWidget> createState() => _FScrollableState();
}

class _FScrollableState extends State<FScrollable> {
  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (FInputTypeAwareApp.of(context).isMouse) {
      return Scrollbar(
        controller: _controller,
        trackVisibility: true,
        thumbVisibility: true,
        thickness: 8,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildChild(),
        ),
      );
    } else {
      return _buildChild();
    }
  }

  Widget _buildChild() {
    return SingleChildScrollView(
      controller: _controller,
      scrollDirection: widget.axis,
      child: widget.child,
    );
  }
}
