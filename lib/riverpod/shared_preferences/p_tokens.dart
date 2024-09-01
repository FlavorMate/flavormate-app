import 'package:flavormate/models/user/token.dart';
import 'package:flavormate/riverpod/shared_preferences/p_shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_tokens.g.dart';

@riverpod
class PTokens extends _$PTokens {
  @override
  Tokens? build() {
    final provider = ref.watch(pSharedPreferencesProvider).requireValue;
    final response = provider.get('token');
    if (response == null) return null;

    return TokensMapper.fromJson(response.toString());
  }
}
