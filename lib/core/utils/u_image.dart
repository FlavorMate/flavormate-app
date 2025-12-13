import 'package:flavormate/core/config/features/p_feature_enhanced_resolutions.dart';
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
    final enableMoreResolutions = ref.read(pFeatureEnhancedResolutionsProvider);

    return switch (imageMode) {
      ImageMode.Wide => getWideResolution(
        context,
        width,
        enableMoreResolutions,
      ),
      ImageMode.Scale => getScaledResolution(
        context,
        width,
        enableMoreResolutions,
      ),
      ImageMode.Plane => getPlaneResolution(
        context,
        width,
        enableMoreResolutions,
      ),
    };
  }

  static ImageResolution getPlaneResolution(
    BuildContext context,
    double width,
    bool enableMoreResolutions,
  ) {
    var resolutions = ImageResolution.planeResolutions;

    if (!enableMoreResolutions) {
      resolutions.remove(ImageResolution.P2048);
      resolutions.remove(ImageResolution.P3072);
    }

    final factor = MediaQuery.devicePixelRatioOf(context);

    final realWidth = width * factor;

    return _findBestMatchByWidth(resolutions, realWidth);
  }

  static ImageResolution getScaledResolution(
    BuildContext context,
    double width,
    bool enableMoreResolutions,
  ) {
    var resolutions = enableMoreResolutions
        ? ImageResolution.scaledResolutions
        : [ImageResolution.Original];

    final factor = MediaQuery.devicePixelRatioOf(context);

    final realWidth = width * factor;

    return _findBestMatchByWidth(resolutions, realWidth);
  }

  static ImageResolution getWideResolution(
    BuildContext context,
    double width,
    bool enableMoreResolutions,
  ) {
    var resolutions = ImageResolution.wideResolutions;

    if (!enableMoreResolutions) {
      resolutions.remove(ImageResolution.W2560);
      resolutions.remove(ImageResolution.W3840);
    }

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
