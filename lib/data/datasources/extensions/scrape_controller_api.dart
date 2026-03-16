import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flavormate/core/constants/api_constants.dart';
import 'package:flavormate/data/datasources/controller_api.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';

class ScrapeControllerApi extends ControllerApi {
  final _root = ApiConstants.ExtensionScrape;

  const ScrapeControllerApi(super._dio);

  Future<ApiResponse<String>> scrape({required String url}) async {
    final uri = Uri.encodeComponent(url);
    var base64 = base64Encode(utf8.encode(uri));

    return await get(
      url: '$_root/$base64',
      mapper: (data) => data as String,
      timeout: const Duration(minutes: 1),
    );
  }

  Future<ApiResponse<String>> import({
    required MultipartFile file,
    required String language,
  }) async {
    final data = FormData.fromMap({'file': file});

    return await post(
      url: '$_root/ld+json',
      data: data,
      queryParameters: {'language': language},
      mapper: (data) => data as String,
      timeout: const Duration(minutes: 1),
    );
  }
}
