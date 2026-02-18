import 'package:flavormate/core/config/input_type/u_input_type_detector.dart';
import 'package:flutter/material.dart';

class FInputTypeAwareApp extends StatefulWidget {
  final Widget child;

  const FInputTypeAwareApp({super.key, required this.child});

  @override
  State<FInputTypeAwareApp> createState() => _FInputTypeAwareAppState();

  // Expose the input detector to child widgets via InheritedWidget
  static UInputTypeDetector of(BuildContext context) {
    final state = context.findAncestorStateOfType<_FInputTypeAwareAppState>();
    assert(state != null, 'FInputTypeAwareApp not found in context');
    return state!._inputDetector;
  }
}

class _FInputTypeAwareAppState extends State<FInputTypeAwareApp> {
  final UInputTypeDetector _inputDetector = UInputTypeDetector();

  @override
  Widget build(BuildContext context) {
    return Listener(
      // Capture all pointer down events in the app
      onPointerDown: _inputDetector.onPointerDown,
      child: widget.child,
    );
  }
}
