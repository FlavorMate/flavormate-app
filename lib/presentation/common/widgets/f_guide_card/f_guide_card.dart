import 'package:flavormate/presentation/common/widgets/f_card.dart';
import 'package:flutter/material.dart';

abstract class FGuideCard extends StatelessWidget {
  final String id;

  const FGuideCard({
    super.key,
    required this.id,
  });

  @override
  ValueKey get key => ValueKey(id);

  Widget builder(BuildContext context, Widget child) {
    return FCard(
      key: key,
      child: child,
    );
  }
}
