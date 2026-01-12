import 'package:flavormate/core/config/input_type/input_type_detector.dart';
import 'package:flutter/material.dart';

class InputTypeAwareApp extends StatefulWidget {
  final Widget child;

  const InputTypeAwareApp({super.key, required this.child});

  @override
  State<InputTypeAwareApp> createState() => _InputTypeAwareAppState();

  // Expose the input detector to child widgets via InheritedWidget
  static InputTypeDetector of(BuildContext context) {
    final state = context.findAncestorStateOfType<_InputTypeAwareAppState>();
    assert(state != null, 'InputTypeAwareApp not found in context');
    return state!._inputDetector;
  }
}

class _InputTypeAwareAppState extends State<InputTypeAwareApp> {
  final InputTypeDetector _inputDetector = InputTypeDetector();

  @override
  Widget build(BuildContext context) {
    return Listener(
      // Capture all pointer down events in the app
      onPointerDown: _inputDetector.onPointerDown,
      child: widget.child,
    );
  }
}
