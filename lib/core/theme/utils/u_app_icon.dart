import 'package:flutter/services.dart';

class UAppIcon {
  static Future<dynamic> changeIcon(AppIcon icon) async {
    const platform = MethodChannel('flavormate/icon');

    final response = await platform.invokeMethod('changeIcon', {
      'iconName': icon.value,
    });

    return response;
  }
}

enum AppIcon {
  appIcon('AppIcon'),
  winter2025('Winter2025Icon')
  ;

  final String value;

  const AppIcon(this.value);
}
