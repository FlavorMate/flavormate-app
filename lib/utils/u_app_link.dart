import 'package:flavormate/models/appLink/app_link.dart';

class UAppLink {
  static String createURL(AppLink appLink, String language) {
    return '${appLink.server}/v2/public/recipes/${appLink.id}?token=${appLink.token}&language=$language';
  }
}
