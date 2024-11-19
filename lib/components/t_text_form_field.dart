import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class TTextFormField extends StatelessWidget {
  final String? label;
  final TextEditingController controller;
  final Widget? suffix;
  final Widget? prefix;
  final String? Function(String?)? validators;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool readOnly;
  final Function(String)? onChanged;
  final Function(PointerDownEvent)? onTapOutside;
  final VoidCallback? clear;
  final FocusNode? focusNode;

  const TTextFormField({
    super.key,
    required this.controller,
    this.onChanged,
    this.onTapOutside,
    this.label,
    this.suffix,
    this.prefix,
    this.validators,
    this.keyboardType,
    this.maxLines = 1,
    this.readOnly = false,
    this.focusNode,
    this.clear,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        label: label != null ? Text(label!) : null,
        suffix: suffix ?? _ClearButton(clear: clearField),
        prefixIcon: prefix,
      ),
      maxLines: maxLines,
      validator: validators,
      keyboardType: keyboardType,
      readOnly: readOnly,
      enabled: !readOnly,
      onChanged: onChanged,
      onTapOutside: onTapOutside,
    );
  }

  void clearField() {
    clear?.call();
    controller.clear();
  }
}

class _ClearButton extends StatelessWidget {
  final VoidCallback clear;

  const _ClearButton({required this.clear});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: clear,
        child: Icon(MdiIcons.delete, color: Colors.red),
      ),
    );
  }
}
