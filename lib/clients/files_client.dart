import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flavormate/interfaces/a_base_client.dart';
import 'package:flavormate/models/file/file.dart';

class FilesClient extends ABaseClient<File> {
  FilesClient({
    required super.httpClient,
    required super.baseURL,
    required super.parser,
  });

  Future<String> downloadRaw(String url) async {
    final response = await httpClient.get(
      url,
      options: Options(responseType: ResponseType.bytes),
    );

    return base64Encode(response.data);
  }
}
