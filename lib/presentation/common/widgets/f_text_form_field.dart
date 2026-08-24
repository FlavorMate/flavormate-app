import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:material_ui/material_ui.dart';

class FTextFormField extends StatefulWidget {
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
  State<FTextFormField> createState() => _FTextFormFieldState();
}

class _FTextFormFieldState extends State<FTextFormField> {
  final focusNode = FocusNode();

  FocusNode get activeFocusNode => widget.focusNode ?? focusNode;

  void update() => setState(() {});

  @override
  void initState() {
    activeFocusNode.addListener(update);
    widget.controller.addListener(update);

    super.initState();
  }

  @override
  void dispose() {
    activeFocusNode.removeListener(update);
    widget.controller.removeListener(update);
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showClear =
        activeFocusNode.hasFocus && widget.controller.text.isNotEmpty;

    final suffix = widget.suffix ?? _ClearButton(clear: clearField);

    return TextFormField(
      focusNode: widget.focusNode ?? focusNode,
      controller: widget.controller,
      autocorrect: widget.autocorrect,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        label: widget.label != null ? Text(widget.label!) : null,
        suffixIcon: showClear ? suffix : null,
        prefixIcon: widget.prefix,
      ),
      autofillHints: widget.autofillHints,
      maxLines: widget.maxLines,
      expands: widget.expands,
      validator: widget.validators,
      keyboardType: widget.keyboardType,
      readOnly: widget.readOnly,
      enabled: !widget.readOnly,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      onTapOutside: widget.onTapOutside,
      obscureText: widget.obscureText,
      textAlignVertical: TextAlignVertical.top,
    );
  }

  void clearField() {
    widget.clear?.call();
    widget.controller.clear();
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
        child: Icon(Symbols.delete_rounded, color: context.blendedColors.error),
      ),
    );
  }
}
