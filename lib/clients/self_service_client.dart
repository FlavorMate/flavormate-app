import 'package:dio/dio.dart';

class SelfServiceClient {
  final Dio httpClient;
  final String baseURL;

  SelfServiceClient({required this.httpClient, required this.baseURL});

  Future<bool> recovery(String mail) async {
    try {
      final response = await httpClient.put<bool>(
        '$baseURL/recovery/$mail/password/reset',
      );
      return response.data!;
    } catch (_) {
      return false;
    }
  }

  Future<bool> registration({
    required String displayName,
    required String username,
    required String mail,
    required String password,
  }) async {
    try {
      final response = await httpClient.post<bool>(
        '$baseURL/registration/',
        data: {
          'displayName': displayName,
          'username': username,
          'mail': mail,
          'password': password,
        },
      );
      return response.data!;
    } catch (e) {
      return false;
    }
  }
}
