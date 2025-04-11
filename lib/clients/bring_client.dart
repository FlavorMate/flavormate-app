import 'package:dio/dio.dart';

class BringClient {
  final Dio httpClient;
  final String baseURL;

  BringClient({required this.httpClient, required this.baseURL});

  Future<String> post(
    String server,
    int id,
    int baseServing,
    int requestedServing,
  ) async {
    final api = '$server$baseURL/$id/$requestedServing';

    final response = await httpClient.post(
      'https://api.getbring.com/rest/bringrecipes/deeplink',
      data: {
        'url': api,
        'baseQuantity': requestedServing,
        'requestedQuantity': requestedServing,
        'source': 'app',
      },
    );

    return response.data['deeplink'];
  }
}
