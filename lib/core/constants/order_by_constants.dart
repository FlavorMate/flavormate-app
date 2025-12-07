import 'package:flavormate/data/models/shared/enums/order_by.dart';

abstract class OrderByConstants {
  static const account = [
    OrderBy.CreatedOn,
    OrderBy.DisplayName,
    OrderBy.Username,
  ];

  static const book = [
    OrderBy.Label,
    OrderBy.CreatedOn,
    OrderBy.Visible,
  ];

  static const category = [
    OrderBy.Label,
  ];

  static const files = [OrderBy.CreatedOn];

  static const recipe = [
    OrderBy.CreatedOn,
    OrderBy.Label,
  ];

  static const story = [OrderBy.Label, OrderBy.CreatedOn];

  static const tag = [
    OrderBy.Label,
  ];
}
