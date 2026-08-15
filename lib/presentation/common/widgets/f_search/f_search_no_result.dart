import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:material_ui/material_ui.dart';

class FSearchNoResult extends StatelessWidget {
  const FSearchNoResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FEmptyMessage(
        title: context.l10n.f_search_no_result__title,
        icon: Symbols.search_off_rounded,
      ),
    );
  }
}
