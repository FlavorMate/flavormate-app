import 'package:flutter/material.dart';

class FDenseTextButton extends TextButton {
  FDenseTextButton({super.key, required super.onPressed, required super.child})
    : super(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(0),
          overlayColor: Colors.transparent,
        ),
      );
}
