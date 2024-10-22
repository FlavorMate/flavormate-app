import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class TTextFormField extends StatelessWidget {
  final String? label;
  final TextEditingController controller;
  final Widget? suffix;
  final Widget? prefix;
  final String? Function(String?)? validators;
  final TextInputType? keyboardType;
  final bool readOnly;

  const TTextFormField({
    super.key,
    required this.controller,
    this.label,
    this.suffix,
    this.prefix,
    this.validators,
    this.keyboardType,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        label: label != null ? Text(label!) : null,
        suffix: suffix ?? _ClearButton(clear: controller.clear),
        prefixIcon: prefix,
      ),
      validator: validators,
      keyboardType: keyboardType,
      readOnly: readOnly,
      enabled: !readOnly,
    );
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
        child: Icon(
          MdiIcons.delete,
          color: Theme.of(context).colorScheme.error,
        ),
      ),
    );
  }
}
