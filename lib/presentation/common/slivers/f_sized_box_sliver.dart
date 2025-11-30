import 'package:flutter/material.dart';

class FSizedBoxSliver extends StatelessWidget {
  final double? height;
  final double? width;

  const FSizedBoxSliver({super.key, this.height, this.width});
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: height,
        width: width,
      ),
    );
  }
}
