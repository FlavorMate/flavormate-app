import 'package:flavormate/interfaces/a_base_client.dart';
import 'package:flavormate/models/features/features_response.dart';

class FeaturesClient extends ABaseClient<FeaturesResponse> {
  FeaturesClient({
    required super.httpClient,
    required super.baseURL,
    required super.parser,
  });

  Future<FeaturesResponse> get() async {
    final response = await httpClient.get('$baseURL/');
    return FeaturesResponseMapper.fromMap(response.data!);
  }
}
