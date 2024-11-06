/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsDocumentsGen {
  const $AssetsDocumentsGen();

  /// Directory path: assets/documents/changelog
  $AssetsDocumentsChangelogGen get changelog =>
      const $AssetsDocumentsChangelogGen();
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/bring.png
  AssetGenImage get bring => const AssetGenImage('assets/icons/bring.png');

  /// File path: assets/icons/logo_transparent.png
  AssetGenImage get logoTransparent =>
      const AssetGenImage('assets/icons/logo_transparent.png');

  /// List of all assets
  List<AssetGenImage> get values => [bring, logoTransparent];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/no_image.png
  AssetGenImage get noImage =>
      const AssetGenImage('assets/images/no_image.png');

  /// List of all assets
  List<AssetGenImage> get values => [noImage];
}

class $AssetsWebGen {
  const $AssetsWebGen();

  /// File path: assets/web/backend_url.txt
  String get backendUrl => 'assets/web/backend_url.txt';

  /// List of all assets
  List<String> get values => [backendUrl];
}

class $AssetsDocumentsChangelogGen {
  const $AssetsDocumentsChangelogGen();

  /// File path: assets/documents/changelog/de.json
  String get de => 'assets/documents/changelog/de.json';

  /// File path: assets/documents/changelog/en.json
  String get en => 'assets/documents/changelog/en.json';

  /// List of all assets
  List<String> get values => [de, en];
}

class Assets {
  Assets._();

  static const $AssetsDocumentsGen documents = $AssetsDocumentsGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsWebGen web = $AssetsWebGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
