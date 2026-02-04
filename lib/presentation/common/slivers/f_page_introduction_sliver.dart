import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/presentation/common/slivers/f_sized_box_sliver.dart';
import 'package:flavormate/presentation/common/widgets/f_badge.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_m3shapes/flutter_m3shapes.dart';

class FPageIntroductionSliver extends StatelessWidget {
  final Shapes shape;
  final IconData icon;

  final String description;

  const FPageIntroductionSliver({
    super.key,
    required this.shape,
    required this.icon,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: FBadge(
            shape: shape,
            icon: icon,
          ),
        ),

        const FSizedBoxSliver(height: PADDING),

        SliverToBoxAdapter(
          child: FText(
            description,
            style: .bodyLarge,
          ),
        ),
      ],
    );
  }
}
