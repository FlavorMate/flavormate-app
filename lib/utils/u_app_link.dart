import 'package:flavormate/models/appLink/app_link.dart';

class UAppLink {
  static String createURL(AppLinkMode mode, AppLink appLink) {
    var url = 'flavormate://${mode.name}';

    url += '?${appLink.encode()}';

    return url;
  }
}
