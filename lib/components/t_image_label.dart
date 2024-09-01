import 'package:flavormate/components/t_image.dart';
import 'package:flutter/material.dart';

class TImageLabel extends StatelessWidget {
  final String? imageSrc;
  final double height;
  final String? title;
  final double radius;
  final double labelSize;

  const TImageLabel({
    required this.imageSrc,
    required this.height,
    this.title,
    this.radius = 8,
    this.labelSize = 0.25,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: TImage(imageSrc: imageSrc),
          ),
          if (title != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(100, 0, 0, 0),
                  borderRadius: BorderRadius.circular(radius),
                ),
                height: height * labelSize,
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      title!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 100,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
