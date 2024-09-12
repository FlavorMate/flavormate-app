import 'package:flavormate/interfaces/a_base_client.dart';
import 'package:flavormate/models/unit.dart';

class UnitsClient extends ABaseClient<Unit> {
  UnitsClient({
    required super.httpClient,
    required super.baseURL,
    required super.parser,
  });
}
