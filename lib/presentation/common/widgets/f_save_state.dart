import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/timer/p_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FSaveState extends ConsumerWidget {
  final PTimerProvider provider;

  const FSaveState({super.key, required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autosave = ref.watch(provider);
    return SizedBox(
      width: 40,
      child: Icon(
        autosave == null
            ? MdiIcons.contentSaveCheck
            : MdiIcons.contentSaveAlert,
        color: context.colorScheme.onSurface,
      ),
    );
  }
}
