import 'package:dio/dio.dart';

class BringClient {
  final Dio httpClient;
  final String baseURL;

  BringClient({required this.httpClient, required this.baseURL});

  String get(String server, int id, int baseServing, int requestedServing) {
    final api = '$server$baseURL/$id/$requestedServing';

    return 'https://api.getbring.com/rest/bringrecipes/deeplink?url=$api&source=web&baseQuantity=$baseServing&requestedQuantity=$requestedServing';
  }
}
