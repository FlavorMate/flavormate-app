// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

const double PADDING = 16.0;
const double BORDER_RADIUS = 12;
const double TABLE_ICON_WIDTH = 48;
const double WIDGET_WIDTH = 450;

const FLAVORMATE_GETTING_STARTED =
    'https://github.com/FlavorMate/flavormate-server?tab=readme-ov-file#getting-started';

const FLAVORMATE_COLOR = Colors.lightGreen;

abstract class Breakpoints {
  static const double sm = 600;
  static const double m = 840;
  static const double l = 1200;
  static const double xl = 1600;

  static bool gt(BuildContext context, double bp) {
    return MediaQuery.sizeOf(context).width >= bp;
  }

  static bool lt(BuildContext context, double bp) {
    return MediaQuery.sizeOf(context).width < bp;
  }
}
