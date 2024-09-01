import 'package:flavormate/interfaces/a_search_client.dart';
import 'package:flavormate/models/user/user.dart';

class UserClient extends ASearchClient<User> {
  UserClient({
    required super.httpClient,
    required super.baseURL,
    required super.parser,
  });

  Future<User> getUser() async {
    final response = await httpClient.get('$baseURL/info');

    return UserMapper.fromMap(response.data);
  }

  Future<bool> setPassword(int id, Map password) async {
    final response = await httpClient.put<bool>(
      '$baseURL/$id/password',
      data: password,
    );

    return response.data ?? false;
  }

  Future<bool> forcePassword(int id, Map password) async {
    final response = await httpClient.put<bool>(
      '$baseURL/$id/password/force',
      data: password,
    );

    return response.data ?? false;
  }
}
