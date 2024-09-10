import 'dart:convert';
import 'dart:math';

import 'package:flavormate/components/t_button.dart';
import 'package:flavormate/components/t_card.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_full_dialog.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/draft/draft.dart';
import 'package:flavormate/models/file/file.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flavormate/utils/u_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class DImages extends StatefulWidget {
  final Draft draft;

  const DImages({
    super.key,
    required this.draft,
  });

  @override
  State<StatefulWidget> createState() => _DImagesState();
}

class _DImagesState extends State<DImages> {
  late Draft _draft;

  @override
  void initState() {
    _draft = widget.draft.copyWith();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TFullDialog(
      title: L10n.of(context).d_editor_images_title,
      submit: submit,
      child: TColumn(
        children: [
          TButton(
            leading: const Icon(MdiIcons.plus),
            onPressed: addImage,
            label: L10n.of(context).d_editor_images_add_image,
          ),
          Wrap(
            spacing: PADDING,
            runSpacing: PADDING,
            children: [
              for (final image in _draft.displayImages)
                SizedBox(
                  width: 250,
                  height: 140,
                  child: TCard(
                    padding: 0,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(BORDER_RADIUS),
                          child: Image.memory(
                            base64Decode(image.content!.split(',')[1]),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: PADDING,
                          right: PADDING,
                          child: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                            child: IconButton(
                              color: Colors.white,
                              icon: const Icon(MdiIcons.delete),
                              onPressed: () => deleteImage(image),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }

  void submit() {
    context.pop(_draft);
  }

  addImage() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final bytes = await image.readAsBytes();

    final cropped = UImage.resizeImage(bytes: bytes, width: 1280, height: 720);

    final file = File(
      id: Random().nextInt(1000),
      type: 'IMAGE',
      category: 'RECIPE',
      owner: _draft.id,
      content: cropped,
      fileName: image.name,
    );

    setState(() {
      _draft.addedImages.add(file);
    });
  }

  void deleteImage(File image) {
    setState(() {
      if (_draft.images.contains(image)) {
        _draft.removedImages.add(image);
      } else {
        _draft.addedImages.remove(image);
      }
    });
  }
}
