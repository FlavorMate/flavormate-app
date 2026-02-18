import 'package:flavormate/core/storage/shared_preferences/enums/image_mode.dart';
import 'package:flavormate/data/models/shared/enums/image_resolution.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
}
