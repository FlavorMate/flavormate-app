import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/presentation/common/widgets/f_order_by_menu.dart';
import 'package:flavormate/presentation/common/widgets/f_order_direction_menu.dart';
import 'package:flutter/material.dart';

class FPaginatedSortDelegate extends SliverPersistentHeaderDelegate {
  final FPaginatedSort Function() sortBuilder;
  final double height = 36 + 2 * 16;

  const FPaginatedSortDelegate(this.sortBuilder);

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: context.colorScheme.surface,
      child: Center(child: sortBuilder.call()),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class FPaginatedSort extends StatelessWidget {
  final OrderBy? currentOrderBy;
  final OrderDirection? currentDirection;

  final List<OrderBy> options;

  final Function(OrderBy?) setOrderBy;
  final Function(OrderDirection?) setOrderDirection;

  const FPaginatedSort({
    super.key,
    required this.currentOrderBy,
    required this.currentDirection,
    required this.setOrderBy,
    required this.setOrderDirection,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: .horizontal,
      child: Row(
        mainAxisAlignment: .center,
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
    );
  }
}
