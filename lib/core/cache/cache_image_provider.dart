import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CacheImageProvider extends ImageProvider<String> {
  final String url;

  final Future<Uint8List> Function(String) imageLoader;

  /// Listener to be called when images fails to load.
  final void Function(Object)? errorListener;

  CacheImageProvider({
    required this.url,
    this.errorListener,
    required this.imageLoader,
  });

  @override
  Future<String> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture(url);
  }

  @override
  ImageStreamCompleter loadImage(
    String key,
    ImageDecoderCallback decode,
  ) {
    final chunkEvents = StreamController<ImageChunkEvent>();

    final codecFuture = imageLoader
        .call(key)
        .then<ImmutableBuffer>(ImmutableBuffer.fromUint8List)
        .then<Codec>(decode)
        .whenComplete(() => scheduleMicrotask(() => chunkEvents.close()));

    return MultiFrameImageStreamCompleter(
      codec: codecFuture,
      chunkEvents: chunkEvents.stream,
      scale: 1,
      debugLabel: 'CacheImage("$key") ',
      informationCollector: () => <DiagnosticsNode>[
        DiagnosticsProperty<ImageProvider>('Image provider', this),
        DiagnosticsProperty<String>('URL', key),
      ],
    );
  }

  // Make instances with same url behave as the same key
  @override
  bool operator ==(Object other) {
    return other is CacheImageProvider &&
        other.url == url &&
        identical(other.imageLoader, imageLoader);
  }

  @override
  int get hashCode => Object.hash(url, imageLoader);
}
