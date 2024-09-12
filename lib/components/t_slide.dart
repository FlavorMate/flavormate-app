import 'package:flavormate/components/t_image.dart';

class TSlide {
  final String? imageSrc;
  final TImageType type;
  final String? title;
  final String? description;
  final DateTime? date;
  final Function()? onTap;

  TSlide({
    required this.imageSrc,
    required this.type,
    this.title,
    this.onTap,
    this.description,
    this.date,
  });
}
