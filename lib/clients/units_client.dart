import 'package:flavormate/interfaces/a_base_client.dart';
import 'package:flavormate/models/recipe/unit_ref/unit_localized.dart';

class UnitsClient extends ABaseClient<UnitLocalized> {
  UnitsClient({
    required super.httpClient,
    required super.baseURL,
    required super.parser,
  });
}
