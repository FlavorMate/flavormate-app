import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_error.dart';
import 'package:flutter/material.dart';

class FErrorPage extends StatelessWidget {
  final bool showAppBar;
  final FEmptyMessage onError;

  const FErrorPage({
    super.key,
    required this.onError,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              backgroundColor: context.colorScheme.inversePrimary,
            )
          : null,
      body: FError(
        onError: onError,
      ),
    );
  }
}
