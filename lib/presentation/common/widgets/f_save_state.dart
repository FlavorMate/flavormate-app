import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/timer/p_timer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:material_ui/material_ui.dart';

class FSaveState extends ConsumerWidget {
  final PTimerProvider provider;

  const FSaveState({super.key, required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autosave = ref.watch(provider);
    return SizedBox(
      width: 40,
      child: Icon(
        autosave == null ? Symbols.save_rounded : Symbols.save_clock_rounded,
        color: context.colorScheme.onSurface,
      ),
    );
  }
}
