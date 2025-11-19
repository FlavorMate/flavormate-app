import 'package:flavormate/core/storage/shared_preferences/enums/sp_settings_image_mode.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/settings/p_settings_full_image.dart';
import 'package:flavormate/data/models/shared/enums/image_resolution.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class UImage {
  /// Determines the appropriate ImageWideResolution based on the provided image
  /// metrics and display context.
  static ImageWideResolution getResolution(
    WidgetRef ref,
    BuildContext context,
    BoxConstraints constraints,
  ) {
    final useFullImage =
        ref.read(pSettingsFullImageProvider) == SpSettingsImageMode.FillMode;

    if (useFullImage) {
      return ImageWideResolution.Original;
    }

    final factor = MediaQuery.devicePixelRatioOf(context);

    final width = constraints.maxWidth * factor;

    /// Resolutions smaller than [ImageWideResolution.w480] are not used
    /// because the height is mostly 200px and lower resolutions would create a blurry image
    final resolution = switch (width) {
      // <= 160 => ImageWideResolution.w160,
      // <= 256 => ImageWideResolution.w256,
      // <= 320 => ImageWideResolution.w320,
      <= 480 => ImageWideResolution.W480,
      <= 640 => ImageWideResolution.W640,
      <= 960 => ImageWideResolution.W960,
      <= 1280 => ImageWideResolution.W1280,
      <= 1920 => ImageWideResolution.W1920,
      _ => ImageWideResolution.Original,
    };

    return resolution;
  }
}
