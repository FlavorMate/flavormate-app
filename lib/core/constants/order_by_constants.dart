import 'package:flavormate/data/models/shared/enums/order_by.dart';

abstract class OrderByConstants {
  static const account = [
    OrderBy.CreatedOn,
    OrderBy.DisplayName,
    OrderBy.Username,
  ];

  static const category = [
    OrderBy.Label,
  ];

  static const files = [OrderBy.CreatedOn];

  static const recipe = [
    OrderBy.CreatedOn,
    OrderBy.Label,
  ];

  static const tag = [
    OrderBy.Label,
  ];
}
