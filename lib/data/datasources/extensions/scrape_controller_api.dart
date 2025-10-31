import 'dart:convert';

import 'package:flavormate/core/constants/api_constants.dart';
import 'package:flavormate/data/datasources/controller_api.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';

class ScrapeControllerApi extends ControllerApi {
  final _root = ApiConstants.ExtensionScrape;

  const ScrapeControllerApi(super._dio);

  Future<ApiResponse<String>> scrape({required String url}) async {
    final base64 = base64Encode(utf8.encode(url));
    return await get(
      url: '$_root/$base64',
      mapper: (data) => data as String,
    );
  }
}
