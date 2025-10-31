import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flutter/material.dart';

mixin FOrderMixin<T extends StatefulWidget> on State<T> {
  OrderBy get defaultOrderBy;

  late OrderBy? orderBy = defaultOrderBy;
  late OrderDirection? orderDirection = OrderDirection.Ascending;

  void setOrderBy(OrderBy? value) => setState(() {
    if (value == null) {
      orderDirection = null;
    } else {
      orderDirection ??= OrderDirection.Ascending;
    }
    orderBy = value;
  });

  void setOrderDirection(OrderDirection? value) => setState(() {
    if (value == null) {
      orderBy = null;
    } else {
      orderBy ??= defaultOrderBy;
    }
    orderDirection = value;
  });
}
