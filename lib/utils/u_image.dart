import 'dart:convert';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

abstract class UImage {
  static String resizeImage({
    required Uint8List bytes,
    required int width,
    required int height,
    int blur = 15,
    double offset = 15 * 2,
    double quality = 0.75,
  }) {
    final image = img.decodeImage(bytes)!;

    List<List<double>> imageCords = [[]];

    // calculate the image pixels on the new picture
    if (width >= height) {
      imageCords = _landscape(width, height, image.width, image.height, offset);
    } else {
      imageCords = _portrait(width, height, image.width, image.height, offset);
    }

    final canvas = img.Image(width: width, height: height);

    var blurredImg = img.copyResize(image, width: width, height: height);
    blurredImg = img.gaussianBlur(blurredImg, radius: blur);

    var c = imageCords[0];
    img.compositeImage(
      canvas,
      blurredImg,
      dstX: c[0].toInt(),
      dstY: c[1].toInt(),
      dstW: c[2].toInt(),
      dstH: c[3].toInt(),
    );

    c = imageCords[1];
    img.compositeImage(
      canvas,
      image,
      dstX: c[0].toInt(),
      dstY: c[1].toInt(),
      dstW: c[2].toInt(),
      dstH: c[3].toInt(),
    );

    return 'data:image/jpeg;base64,${base64Encode(img.encodeJpg(canvas))}';
  }

  static List<List<double>> _portrait(
    int cw,
    int ch,
    int iw,
    int ih,
    double offset,
  ) {
    // transformation for primary picture
    // iw           = 2637  px
    // cw           = 720   px
    // --> ratio    = 27.30 %

    // ratio: 720  px / 2637 px => 27.30 %
    // ih1  : 2112 px * 27.30 % => 576   px
    // iw1  : 2637 px * 27.30 % => 720   px
    final ratio = cw / iw;
    final ih1 = ih * ratio;
    final iw1 = iw * ratio;

    final x1 = 0.0;
    final y1 = ch / 2 - ih1 / 2;

    // transformation for background picture
    // ih           = 2112  px
    // ch           = 1280  px
    // --> ratio    = 60.60 %

    // ratio2: 1280 px / 2112 px => 60.60 %
    // ih2   : 2112 px * 60.60 % => 1280  px
    // iw2   : 2637 px * 60.60 % => 1598  px
    final ratio2 = ch / ih;
    final ih2 = ih * ratio2;
    final iw2 = iw * ratio2;

    final x2 = cw / 2 - iw2 / 2;
    final y2 = 0.0;

    // if ih1 height exceeds canvas height, change primary and background image
    if (ih1 <= ch) {
      return [
        [x2 - offset / 2, y2 - offset / 2, iw2 + offset, ih2 + offset],
        [x1, y1, iw1, ih1],
      ];
    } else {
      return [
        [x1, y1, iw1, ih1],
        [x2.abs(), y2, iw2, ih2],
      ];
    }
  }

  static List<List<double>> _landscape(
    int cw,
    int ch,
    int iw,
    int ih,
    double offset,
  ) {
    // transformation for primary picture
    // ih           = 2112  px
    // ch           = 720   px
    // --> ratio    = 34.09 %

    // ratio: 720  px / 2112 px => 34.09 %
    // ih1  : 2112 px * 34.09 % => 720   px
    // iw1  : 2637 px * 34.09 % => 617   px
    final ratio1 = ch / ih;
    final ih1 = ih * ratio1;
    final iw1 = iw * ratio1;

    // transformation for background picture
    // iw          = 2637  px
    // c2          = 1280  px
    // --> ratio   = 48.54 %

    // ratio: 1280 px / 2637 px => 48.54 %
    // ih2  : 2637 px * 48.54 % => 1280  px
    // iw2  : 2112 px * 48.54 % => 1025  px
    final ratio2 = cw / iw;
    final ih2 = ih * ratio2;
    final iw2 = iw * ratio2;

    final x2 = 0.0;
    final y2 = ch / 2 - ih2 / 2;

    final x1 = cw / 2 - iw1 / 2;
    final y1 = 0.0;

    // if iw2 height exceeds canvas width, change primary and background image
    if (iw2 <= cw) {
      return [
        [x2 - offset / 2, y2 - offset / 2, iw2 + offset, ih2 + offset],
        [x1, y1, iw1, ih1],
      ];
    } else {
      return [
        [x1, y1, iw1, ih1],
        [x2, y2.abs(), iw2, ih2],
      ];
    }
  }
}
