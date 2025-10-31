import 'package:flavormate/presentation/common/widgets/f_states/f_loading.dart';
import 'package:flutter/material.dart';

class FLoadingPage extends StatelessWidget {
  final bool showAppBar;

  const FLoadingPage({super.key, this.showAppBar = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            )
          : null,
      body: const FLoading(),
    );
  }
}
