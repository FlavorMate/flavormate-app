import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

class FMenuAnchor extends StatelessWidget {
  final List<M3EMenuEntry> children;

  const FMenuAnchor({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return M3EMenu.entries(
      anchorBuilder: (_, open) => M3EIconButton(
        icon: const Icon(Symbols.more_vert_rounded),
        onPressed: open,
      ),
      entries: children,
    );
  }
}
