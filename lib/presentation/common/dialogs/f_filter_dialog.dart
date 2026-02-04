import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/presentation/common/dialogs/f_alert_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_wrap.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FFilterDialog extends StatefulWidget {
  final OrderBy? currentOrderBy;
  final OrderDirection? currentOrderDirection;

  final List<OrderBy> allowedOrderBys;

  final void Function(OrderBy) setOrderBy;
  final void Function(OrderDirection) setOrderDirection;

  const FFilterDialog({
    super.key,
    required this.currentOrderBy,
    required this.currentOrderDirection,
    required this.allowedOrderBys,
    required this.setOrderBy,
    required this.setOrderDirection,
  });

  @override
  State<StatefulWidget> createState() => _FFilterDialogState();
}

class _FFilterDialogState extends State<FFilterDialog> {
  late OrderBy? orderBy;
  late OrderDirection? orderDirection;

  @override
  void initState() {
    orderBy = widget.currentOrderBy;
    orderDirection = widget.currentOrderDirection;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FAlertDialog(
      title: context.l10n.f_filter_dialog__title,
      negativeLabel: context.l10n.btn_close,
      positiveLabel: context.l10n.btn_apply,
      submit: applyFilters,
      // height: 350,
      child: Column(
        spacing: PADDING,
        mainAxisSize: .min,
        children: [
          FWrap(
            children: [
              for (final orderDirection in OrderDirection.values)
                ChoiceChip(
                  // avatar: Icon(orderDirection.icon),
                  label: Text(
                    orderDirection.getName(context),
                  ),
                  selected: this.orderDirection == orderDirection,
                  onSelected: (_) =>
                      setState(() => this.orderDirection = orderDirection),
                ),
            ],
          ),
          const Divider(),
          FWrap(
            children: [
              for (final orderBy in widget.allowedOrderBys)
                ChoiceChip(
                  // avatar: Icon(orderBy.icon),
                  label: Text(orderBy.getName(context)),
                  selected: this.orderBy == orderBy,
                  onSelected: (_) => setState(() => this.orderBy = orderBy),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void applyFilters() {
    if (orderDirection == widget.currentOrderDirection &&
        orderBy == widget.currentOrderBy) {
      context.pop();
    } else {
      context.pop((orderDirection, orderBy));
    }
  }
}
