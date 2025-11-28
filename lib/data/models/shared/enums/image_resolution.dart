enum ImageSquareResolution {
  P16(
    width: 16,
    height: 16,
  ),
  P32(
    width: 32,
    height: 32,
  ),
  P64(
    width: 64,
    height: 64,
  ),
  P128(
    width: 128,
    height: 128,
  ),
  P256(
    width: 256,
    height: 256,
  ),
  P512(
    width: 512,
    height: 512,
  ),
  P1024(
    width: 1024,
    height: 1024,
  ),
  Original(
    width: 4096,
    height: 4096,
  )
  ;

  final int width;
  final int height;

  const ImageSquareResolution({required this.width, required this.height});

  String get resolution => '${width}x$height';
}

enum ImageWideResolution {
  W160(
    width: 160,
    height: 90,
  ),
  W256(width: 256, height: 144),
  W320(width: 320, height: 180),
  W480(width: 480, height: 270),
  W640(width: 640, height: 360),
  W960(width: 960, height: 540),
  W1280(
    width: 1280,
    height: 720,
  ),
  W1920(
    width: 1920,
    height: 1080,
  ),
  Original(
    width: 4096,
    height: 4096,
  )
  ;

  final int width;
  final int height;

  const ImageWideResolution({required this.width, required this.height});

  String get resolution => '${width}x$height';
}
