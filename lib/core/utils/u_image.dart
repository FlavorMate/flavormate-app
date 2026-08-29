import 'package:flavormate/core/storage/shared_preferences/enums/image_mode.dart';
import 'package:flavormate/data/models/shared/enums/image_resolution.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

abstract class UImage {
  /// Determines the appropriate [ImageResolution] based on the provided image
  /// metrics and display context.
  static ImageResolution getResolution(
    WidgetRef ref,
    BuildContext context,
    ImageMode imageMode,
    double width,
  ) {
    return switch (imageMode) {
      ImageMode.Wide => getWideResolution(
        context,
        width,
      ),
      ImageMode.Scale => getScaledResolution(
        context,
        width,
      ),
      ImageMode.Plane => getPlaneResolution(
        context,
        width,
      ),
    };
  }

  static ImageResolution getPlaneResolution(
    BuildContext context,
    double width,
  ) {
    var resolutions = ImageResolution.planeResolutions;

    final factor = MediaQuery.devicePixelRatioOf(context);

    final realWidth = width * factor;

    return _findBestMatchByWidth(resolutions, realWidth);
  }

  static ImageResolution getScaledResolution(
    BuildContext context,
    double width,
  ) {
    var resolutions = ImageResolution.scaledResolutions;

    final factor = MediaQuery.devicePixelRatioOf(context);

    final realWidth = width * factor;

    return _findBestMatchByWidth(resolutions, realWidth);
  }

  static ImageResolution getWideResolution(
    BuildContext context,
    double width,
  ) {
    var resolutions = ImageResolution.wideResolutions;

    final factor = MediaQuery.devicePixelRatioOf(context);

    final realWidth = width * factor;

    return _findBestMatchByWidth(resolutions, realWidth);
  }

  static ImageResolution _findBestMatchByWidth(
    List<ImageResolution> resolutions,
    double targetWidth,
  ) {
    ImageResolution bestMatch = resolutions[0];
    for (final resolution in resolutions.skip(1)) {
      if (bestMatch.width >= targetWidth) break;
      bestMatch = resolution;
    }
    return bestMatch;
  }

  static Widget buildLoadingWidget({required ImageChunkEvent? chunk}) {
    final progress = _calcProgress(chunk);
    return Center(
      child: progress == null
          ? const M3ELoadingIndicator()
          : M3EProgressIndicator.circularWavy(value: progress),
    );
  }

  static double? _calcProgress(ImageChunkEvent? progress) {
    if (progress == null || progress.expectedTotalBytes == null) return null;

    return progress.cumulativeBytesLoaded.toDouble() /
        progress.expectedTotalBytes!.toDouble();
  }
}
