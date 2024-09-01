class TSlide {
  final String? imageSrc;
  final String? title;
  final String? description;
  final DateTime? date;
  final Function()? onTap;

  TSlide({
    required this.imageSrc,
    this.title,
    this.onTap,
    this.description,
    this.date,
  });
}
