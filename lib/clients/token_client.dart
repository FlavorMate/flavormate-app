import 'package:flavormate/interfaces/a_base_client.dart';
import 'package:flavormate/models/user/token.dart';

class TokenClient extends ABaseClient<TToken> {
  TokenClient({
    required super.httpClient,
    required super.baseURL,
    required super.parser,
  });
}
