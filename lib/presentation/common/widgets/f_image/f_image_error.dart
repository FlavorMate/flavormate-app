import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:material_ui/material_ui.dart';

class FImageError extends StatelessWidget {
  const FImageError({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.lerp(
        context.colorScheme.inversePrimary,
        Colors.black,
        0.15,
      ),

      child: const Icon(
        Symbols.no_photography_rounded,
        size: 64,
        color: Colors.white,
      ),
    );
  }
}
