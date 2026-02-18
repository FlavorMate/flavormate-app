import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/models/features/search/search_dto.dart';
import 'package:flavormate/presentation/common/dialogs/f_alert_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_m3shapes/flutter_m3shapes.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';

class SearchPageFilterDialog extends StatefulWidget {
  final Set<SearchDtoSource> currentFilters;

  const SearchPageFilterDialog({
    super.key,
    required this.currentFilters,
  });

  @override
  State<StatefulWidget> createState() => _SearchPageFilterDialogState();
}

class _SearchPageFilterDialogState extends State<SearchPageFilterDialog> {
  late Set<SearchDtoSource> filters;

  @override
  void initState() {
    filters = widget.currentFilters.toSet();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FAlertDialog(
      title: context.l10n.search_page_dialog__title,
      negativeLabel: context.l10n.btn_close,
      positiveLabel: context.l10n.btn_apply,
      submit: _applyFilters,
      // height: 350,
      child: Column(
        spacing: PADDING,
        mainAxisSize: .min,
        children: [
          FWrap(
            children: [
              for (final source in SearchDtoSource.values)
                _buildChoiceChip(context, source),
            ],
          ),
        ],
      ),
    );
  }

  ChoiceChip _buildChoiceChip(BuildContext context, SearchDtoSource source) {
    final isSelected = filters.contains(source);
    return ChoiceChip(
      avatar: M3Container(
        source.shape,
        width: 20,
        height: 20,
        color: context.colorScheme.onPrimaryContainer,
        child: isSelected
            ? Icon(
                MdiIcons.checkBold,
                color: context.colorScheme.primaryContainer,
                size: 14,
              )
            : M3Container(
                source.shape,
                width: 18,
                height: 18,
                color: context.colorScheme.surfaceContainer,
                child: const SizedBox.expand(),
              ),
      ),
      label: Text(
        source.getName(context),
      ),
      showCheckmark: false,
      selected: isSelected,
      onSelected: (_) => _toggleItem(source),
    );
  }

  void _toggleItem(SearchDtoSource val) {
    setState(() {
      if (!filters.remove(val)) {
        filters.add(val);
      }
    });
  }

  void _applyFilters() {
    context.pop(filters);
  }
}
