import 'package:flavormate/core/storage/shared_preferences/enums/sp_key.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp.dart';
import 'package:flavormate/data/models/core/auth/tokens_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_sp_jwt.g.dart';

final _key = SPKey.JWT.name;

@Riverpod(keepAlive: true)
class PSPJwt extends _$PSPJwt {
  @override
  TokensDto? build() {
    final instance = ref.watch(pSPProvider).requireValue;
    final response = instance.getString(_key);
    if (response == null) return null;
    try {
      return TokensDtoMapper.fromJson(response.toString());
    } catch (_) {
      instance.remove(_key);
      ref.invalidateSelf();
    }
    return null;
  }

  Future<void> setValue(TokensDto? data) async {
    final instance = ref.read(pSPProvider).requireValue;
    if (data == null) {
      await instance.remove(_key);
    } else {
      await instance.setString(_key, data.toJson());
    }

    ref.invalidateSelf();
  }
}
