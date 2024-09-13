import 'package:flavormate/components/t_card.dart';
import 'package:flavormate/components/t_image_label.dart';
import 'package:flavormate/components/t_slide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:intl/intl.dart';

class TCarousel extends StatefulWidget {
  final List<TSlide> slides;

  final double height;

  const TCarousel({required this.slides, this.height = 400, super.key});

  @override
  State<StatefulWidget> createState() => _TCarouselState();
}

class _TCarouselState extends State<TCarousel> {
  final _controller = CarouselControllerImpl();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          if (widget.slides.length < 2)
            SlideCard(slide: widget.slides[0], height: widget.height)
          else
            FlutterCarousel.builder(
              options: CarouselOptions(
                height: double.infinity,
                viewportFraction: 1,
                showIndicator: true,
                slideIndicator: const CircularSlideIndicator(),
                enlargeCenterPage: true,
                controller: _controller,
                enableInfiniteScroll: true,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
              ),
              itemCount: widget.slides.length,
              itemBuilder: (_, i, ___) {
                final slide = widget.slides[i];
                return SlideCard(slide: slide, height: widget.height);
              },
            ),
          if (widget.slides.length > 1)
            Positioned(
              left: 16,
              child: CircleAvatar(
                child: IconButton(
                  icon: const Icon(MdiIcons.chevronLeft),
                  onPressed: _controller.previousPage,
                ),
              ),
            ),
          if (widget.slides.length > 1)
            Positioned(
              right: 16,
              child: CircleAvatar(
                child: IconButton(
                  icon: const Icon(MdiIcons.chevronRight),
                  onPressed: _controller.nextPage,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class SlideCard extends StatelessWidget {
  const SlideCard({
    super.key,
    required this.slide,
    required this.height,
  });

  final TSlide slide;
  final double height;

  @override
  Widget build(BuildContext context) {
    return TCard(
      padding: 0,
      onTap: slide.onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          TImageLabel(
            imageSrc: slide.imageSrc,
            type: slide.type,
            height: height,
            title: slide.title,
          ),
          if (slide.date != null)
            Positioned(
              right: 8,
              top: 8,
              child: Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                //const Color.fromARGB(200, 255, 255, 255),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    DateFormat(
                      'yMd',
                      Localizations.localeOf(context).languageCode,
                    ).format(slide.date!),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
