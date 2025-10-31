import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/presentation/common/widgets/f_order_by_menu.dart';
import 'package:flavormate/presentation/common/widgets/f_order_direction_menu.dart';
import 'package:flavormate/presentation/common/widgets/f_scrollable_h.dart';
import 'package:flutter/material.dart';

class FPageableSort extends StatelessWidget {
  final OrderBy? currentOrderBy;
  final OrderDirection? currentDirection;

  final List<OrderBy> options;

  final Function(OrderBy?) setOrderBy;
  final Function(OrderDirection?) setOrderDirection;

  final EdgeInsets padding;

  const FPageableSort({
    super.key,
    required this.currentOrderBy,
    required this.currentDirection,
    required this.setOrderBy,
    required this.setOrderDirection,
    required this.options,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: FScrollableH(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: PADDING,
          children: [
            FOrderDirectionMenu(
              current: currentDirection,
              onTap: setOrderDirection,
            ),
            FOrderByMenu(
              current: currentOrderBy,
              options: options,
              onTap: setOrderBy,
            ),
          ],
        ),
      ),
    );
  }
}
