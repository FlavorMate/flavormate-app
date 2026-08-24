import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

class FBottomNavigationBackBar extends StatelessWidget {
  const FBottomNavigationBackBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: .center,
      heightFactor: 1,
      child: M3EButton(
        style: .text,
        onPressed: () => context.pop(),
        child: Text(context.l10n.btn_back),
      ),
    );
  }
}
