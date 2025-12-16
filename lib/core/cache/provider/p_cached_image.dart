import 'package:dio/dio.dart';
import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/core/cache/cache_image_provider.dart';
import 'package:flavormate/core/cache/provider/p_cached_image_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_cached_image.g.dart';

@riverpod
class PCachedImage extends _$PCachedImage {
  @override
  CacheImageProvider build(String url) {
    final dio = ref.watch(pDioPrivateProvider);
    final db = ref.watch(pCachedImageManagerProvider.notifier);

    return CacheImageProvider(
      url: url,
      imageLoader: (url) => _fetchImage(dio, db, url),
    );
  }

  Future<Uint8List> _fetchImage(
    Dio dio,
    PCachedImageManager db,
    String url,
  ) async {
    final dbRecord = await db.getImage(url);

    if (dbRecord != null) return dbRecord;

    final options = Options(responseType: .bytes);
    final response = await dio.get(url, options: options);

    await db.insertImage(url, response.data);

    return response.data;
  }
}
