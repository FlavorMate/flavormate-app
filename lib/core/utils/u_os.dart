import 'dart:io';

import 'package:flutter/foundation.dart';

abstract class UOS {
  static bool get isWeb => kIsWeb;

  static bool get isAndroid => Platform.isAndroid;

  static bool get isIOS => Platform.isIOS;

  static bool get isDesktop => isWeb || (!isAndroid && !isIOS);
}
