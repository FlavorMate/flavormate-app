import 'package:collection/collection.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/presentation/common/dialogs/f_filter_dialog.dart';
import 'package:flutter/material.dart';

mixin FOrderMixin<T extends StatefulWidget> on State<T> {
  OrderBy get defaultOrderBy;

  OrderDirection get defaultOrderDirection => .Ascending;

  List<OrderBy> get allowedFilters => [];

  late OrderBy? orderBy = defaultOrderBy;
  late OrderDirection? orderDirection = defaultOrderDirection;

  int orderKeySeed = 1;

  ValueKey get orderKey => ValueKey((orderBy, orderDirection, orderKeySeed));

  void resetLazyList(VoidCallback callback) {
    setState(() {
      orderKeySeed++;
      callback.call();
    });
  }

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

  List<OrderBy> orderBySorted(BuildContext context, List<OrderBy> input) {
    return input.sortedBy((it) => it.getName(context));
  }

  List<OrderDirection> orderDirectionSorted(
    BuildContext context,
    List<OrderDirection> input,
  ) {
    return input.sortedBy((it) => it.getName(context));
  }

  Future<(OrderDirection, OrderBy)?> openFilterDialog() async {
    final result = await showDialog<(OrderDirection, OrderBy)>(
      context: context,
      builder: (_) => FFilterDialog(
        currentOrderBy: orderBy,
        currentOrderDirection: orderDirection,
        allowedOrderBys: orderBySorted(
          context,
          allowedFilters,
        ),
        setOrderBy: setOrderBy,
        setOrderDirection: setOrderDirection,
      ),
    );

    if (!mounted || result == null) return null;

    setOrderDirection(result.$1);
    setOrderBy(result.$2);

    return result;
  }
}
