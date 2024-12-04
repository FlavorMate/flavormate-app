import 'package:flavormate/components/t_card.dart';
import 'package:flavormate/components/t_image.dart';
import 'package:flavormate/components/t_image_label.dart';
import 'package:flutter/material.dart';

class TComponentCard extends StatelessWidget {
  final void Function() onTap;
  final String? image;
  final String label;

  final double height;
  final double width;

  const TComponentCard({
    super.key,
    required this.onTap,
    required this.image,
    required this.label,
    this.height = 200,
    this.width = 450,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TCard(
        padding: 0,
        onTap: onTap,
        child: TImageLabel(
          imageSrc: image,
          type: TImageType.network,
          height: height,
          title: label,
          labelSize: 0.4,
        ),
      ),
    );
  }
}
