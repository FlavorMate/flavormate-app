import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_loading.dart';
import 'package:flutter/material.dart';

class FLoadingPage extends StatelessWidget {
  final bool showAppBar;

  const FLoadingPage({super.key, this.showAppBar = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar ? const FAppBar(title: '') : null,
      body: const FLoading(),
    );
  }
}
