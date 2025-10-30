import 'package:flavormate/core/utils/u_riverpod.dart';
import 'package:flavormate/presentation/common/widgets/f_progress/f_progress_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class FProgress<T> extends ConsumerStatefulWidget {
  final bool optional;
  final double Function(T) getProgress;
  final $AsyncNotifierProvider<dynamic, T> provider;
  final Color color;
  final bool dynamicColors;

  const FProgress({
    super.key,
    this.optional = false,
    required this.getProgress,
    required this.provider,
    this.color = Colors.white,
    this.dynamicColors = false,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProgressState<T>();
}

class _ProgressState<T> extends ConsumerState<FProgress<T>> {
  double _state = 0.0;

  @override
  void initState() {
    URiverpod.listenManual(ref, widget.provider, (data) {
      setState(() {
        _state = widget.getProgress(data);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FProgressColor(
      state: _state,
      optional: widget.optional,
      color: widget.color,
      dynamicColors: widget.dynamicColors,
    );
  }
}
