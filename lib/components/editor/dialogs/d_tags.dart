import 'package:flavormate/components/dialogs/t_full_dialog.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/tag_draft/tag_draft.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flavormate/utils/u_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';

class DTags extends StatefulWidget {
  final List<TagDraft> tags;

  const DTags({
    super.key,
    required this.tags,
  });

  @override
  State<StatefulWidget> createState() => _DTagsState();
}

class _DTagsState extends State<DTags> {
  final _formKey = GlobalKey<FormState>();
  final _tagController = TextEditingController();
  late List<TagDraft> _tags;

  @override
  void initState() {
    _tags = widget.tags.map((tag) => tag.copyWith()).toList();
    super.initState();
  }

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TFullDialog(
      title: L10n.of(context).d_editor_tags_title,
      submit: submit,
      child: TColumn(
        children: [
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _tagController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: Text(L10n.of(context).d_editor_tags_tag),
                suffixIcon: IconButton(
                  onPressed: addTag,
                  icon: const Icon(MdiIcons.plus),
                ),
              ),
              onEditingComplete: addTag,
              validator: (input) {
                if (UValidator.isEmpty(input))
                  return L10n.of(context).v_isEmpty;
                if (_tags.any((tag) => tag.label == input)) {
                  return L10n.of(context).v_duplicate;
                }

                return null;
              },
            ),
          ),
          Wrap(
            spacing: PADDING,
            runSpacing: PADDING,
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            children: [
              for (final tag in _tags)
                Chip(
                  label: Text(tag.label),
                  onDeleted: () => deleteTag(tag.label),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void addTag() {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _tags.add(TagDraft(label: _tagController.text.trim()));
      _tagController.clear();
    });
  }

  void deleteTag(String label) {
    final index = _tags.indexWhere((tag) => tag.label == label);
    if (index < 0) return;
    setState(() {
      _tags.removeAt(index);
    });
  }

  void submit() {
    context.pop(_tags);
  }
}
