import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flutter/material.dart';

abstract class CustomColor {
  Color get color;
  String l10n(BuildContext context);
}

enum MiscColor implements CustomColor {
  flavormate,
  device
  ;

  @override
  String l10n(BuildContext context) => switch (this) {
    _ => context.l10n.color__event__winter_2025,
  };

  @override
  Color get color {
    return switch (this) {
      MiscColor.flavormate => const Color(0xFF7DB73B),
      MiscColor.device => Colors.transparent,
    };
  }
}

enum EventColor implements CustomColor {
  christmas2025
  ;

  @override
  String l10n(BuildContext context) => switch (this) {
    .christmas2025 => context.l10n.color__event__winter_2025,
  };

  @override
  Color get color => switch (this) {
    .christmas2025 => const Color(0xFFD6001C),
  };
}

enum DefaultColor implements CustomColor {
  red,
  pink,
  purple,
  deepPurple,
  indigo,
  blue,
  lightBlue,
  cyan,
  teal,
  green,
  lightGreen,
  lime,
  yellow,
  amber,
  orange,
  deepOrange,
  brown,
  grey,
  blueGrey
  ;

  @override
  String l10n(BuildContext context) => switch (this) {
    DefaultColor.red => context.l10n.color__default__red,

    DefaultColor.pink => context.l10n.color__default__pink,

    DefaultColor.purple => context.l10n.color__default__purple,

    DefaultColor.deepPurple => context.l10n.color__default__deep_purple,

    DefaultColor.indigo => context.l10n.color__default__indigo,

    DefaultColor.blue => context.l10n.color__default__blue,

    DefaultColor.lightBlue => context.l10n.color__default__light_blue,

    DefaultColor.cyan => context.l10n.color__default__cyan,

    DefaultColor.teal => context.l10n.color__default__teal,

    DefaultColor.green => context.l10n.color__default__green,

    DefaultColor.lightGreen => context.l10n.color__default__light_green,

    DefaultColor.lime => context.l10n.color__default__lime,

    DefaultColor.yellow => context.l10n.color__default__yellow,

    DefaultColor.amber => context.l10n.color__default__amber,

    DefaultColor.orange => context.l10n.color__default__orange,

    DefaultColor.deepOrange => context.l10n.color__default__deep_orange,

    DefaultColor.brown => context.l10n.color__default__brown,

    DefaultColor.grey => context.l10n.color__default__grey,

    DefaultColor.blueGrey => context.l10n.color__default__blue_grey,
  };

  @override
  Color get color => switch (this) {
    DefaultColor.red => Colors.red,

    DefaultColor.pink => Colors.pink,

    DefaultColor.purple => Colors.purple,

    DefaultColor.deepPurple => Colors.deepPurple,

    DefaultColor.indigo => Colors.indigo,

    DefaultColor.blue => Colors.blue,

    DefaultColor.lightBlue => Colors.lightBlue,

    DefaultColor.cyan => Colors.cyan,

    DefaultColor.teal => Colors.teal,

    DefaultColor.green => Colors.green,

    DefaultColor.lightGreen => Colors.lightGreen,

    DefaultColor.lime => Colors.lime,

    DefaultColor.yellow => Colors.yellow,

    DefaultColor.amber => Colors.amber,

    DefaultColor.orange => Colors.orange,

    DefaultColor.deepOrange => Colors.deepOrange,

    DefaultColor.brown => Colors.brown,

    DefaultColor.grey => Colors.grey,

    DefaultColor.blueGrey => Colors.blueGrey,
  };
}

abstract class ColorConstants {
  static const themeColors = <Color>[
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];

  static const eventColors = <String, Color>{'winter2025': Color(0xFFD6001C)};
}

Color calcColorForText(Color input) {
  // Compute the relative luminance of the color.
  final double luminance = input.computeLuminance();

  // Material recommends white text for dark colors and black text for light colors.
  // The threshold 0.5 is a commonly used heuristic that matches Material behavior.
  return luminance > 0.5 ? Colors.black : Colors.white;
}
