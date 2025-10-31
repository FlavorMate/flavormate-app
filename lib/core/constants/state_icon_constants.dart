import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

abstract class StateIconConstants {
  static const books = StateIconConstant(
    MdiIcons.book,
    MdiIcons.bookAlert,
  );
  static const recipes = StateIconConstant(
    MdiIcons.food,
    MdiIcons.foodOff,
  );
  static const stories = StateIconConstant(
    MdiIcons.bookOpenPageVariant,
    MdiIcons.bookAlert,
  );
  static const authors = StateIconConstant(
    MdiIcons.account,
    MdiIcons.accountAlert,
  );
  static const search = StateIconConstant(
    MdiIcons.magnify,
    MdiIcons.alertCircle,
  );
  static const files = StateIconConstant(
    MdiIcons.file,
    MdiIcons.fileAlert,
  );
  static const drafts = StateIconConstant(
    MdiIcons.fileDocumentEdit,
    MdiIcons.fileDocumentAlert,
  );
  static const tags = StateIconConstant(MdiIcons.tag, MdiIcons.tagOff);
  static const suggestions = StateIconConstant(
    MdiIcons.lightbulb,
    MdiIcons.lightbulbAlert,
  );
  static const units = StateIconConstant(
    MdiIcons.scaleBalance,
    MdiIcons.scaleOff,
  );
  static const login = StateIconConstant(
    MdiIcons.accountKey,
    MdiIcons.accountAlert,
  );
  static const changelog = StateIconConstant(
    MdiIcons.textBox,
    MdiIcons.alertCircle,
  );
  static const categories = StateIconConstant(
    MdiIcons.folder,
    MdiIcons.folderAlert,
  );
  static const highlights = StateIconConstant(
    MdiIcons.star,
    MdiIcons.starOff,
  );
}

class StateIconConstant {
  final IconData emptyIcon;
  final IconData errorIcon;

  const StateIconConstant(this.emptyIcon, this.errorIcon);
}
