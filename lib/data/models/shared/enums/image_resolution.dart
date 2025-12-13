import 'package:collection/collection.dart';

enum ImageResolution {
  // defines the upper bounds
  Original(4096, 4096),

  // 1:1 - Square / Plane
  P16(16, 16),
  P32(32, 32),
  P64(64, 64),
  P128(128, 128),
  P256(256, 256),
  P512(512, 512),
  P1024(1024, 1024),
  P2048(2048, 2048),
  P3072(3072, 3072),

  // 16:9 - Wide
  W160(160, 90),
  W256(256, 144),
  W320(320, 180),
  W480(480, 270),
  W640(640, 360),
  W960(960, 540),
  W1280(1280, 720),
  W1920(1920, 1080),
  W2560(2560, 1440),
  W3840(3840, 2160),

  // Original - Scaled
  S32(32, 32),
  S64(64, 64),
  S128(128, 128),
  S256(256, 256),
  S512(512, 512),
  S1024(1024, 1024),
  S2048(2048, 2048),
  S3072(3072, 3072)
  ;

  final int width;
  final int height;

  const ImageResolution(this.width, this.height);

  String get resolution => '${width}x$height';

  static List<ImageResolution> planeResolutions = ImageResolution.values
      .where((it) => it.name.startsWith('P'))
      .sortedBy((it) => it.width)
      .toList();

  static List<ImageResolution> scaledResolutions = ImageResolution.values
      .where((it) => it.name.startsWith('S'))
      .sortedBy((it) => it.width)
      .toList();

  static List<ImageResolution> wideResolutions = ImageResolution.values
      .where((it) => it.name.startsWith('W'))
      .sortedBy((it) => it.width)
      .toList();
}
