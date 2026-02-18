import 'package:flutter/gestures.dart';

class UInputTypeDetector {
  // Track the last detected input type
  PointerDeviceKind? _lastInputType;

  // Getter to expose the current input type
  PointerDeviceKind? get currentInputType => _lastInputType;

  // Reset input type (optional: use if needed)
  void reset() => _lastInputType = null;

  // Listener callback to update input type on pointer events
  void onPointerDown(PointerDownEvent event) {
    _lastInputType = event.kind;
  }

  bool get isMouse => _lastInputType == .mouse;

  bool get isTouch => _lastInputType == .touch;
}
