import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class FTextFormField extends StatelessWidget {
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
  final Function(String)? onFieldSubmitted;
  final VoidCallback? clear;
  final FocusNode? focusNode;
  final bool autocorrect;
  final Iterable<String>? autofillHints;
  final bool obscureText;
  final bool expands;

  const FTextFormField({
    super.key,
    required this.controller,
    this.onChanged,
    this.onTapOutside,
    this.onFieldSubmitted,
    this.label,
    this.suffix,
    this.prefix,
    this.validators,
    this.keyboardType,
    this.maxLines = 1,
    this.readOnly = false,
    this.focusNode,
    this.clear,
    this.autocorrect = true,
    this.autofillHints,
    this.obscureText = false,
    this.expands = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      autocorrect: autocorrect,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        label: label != null ? Text(label!) : null,
        suffix: suffix ?? _ClearButton(clear: clearField),
        prefixIcon: prefix,
      ),
      autofillHints: autofillHints,
      maxLines: maxLines,
      expands: expands,
      validator: validators,
      keyboardType: keyboardType,
      readOnly: readOnly,
      enabled: !readOnly,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      onTapOutside: onTapOutside,
      obscureText: obscureText,
      textAlignVertical: TextAlignVertical.top,
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
        child: Icon(MdiIcons.delete, color: context.blendedColors.error),
      ),
    );
  }
}
