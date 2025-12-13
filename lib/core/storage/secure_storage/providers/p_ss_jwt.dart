import 'package:flavormate/core/storage/secure_storage/providers/p_secure_storage.dart';
import 'package:flavormate/core/storage/shared_preferences/enums/sp_key.dart';
import 'package:flavormate/data/models/core/auth/tokens_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_ss_jwt.g.dart';

final _key = SPKey.JWT.name;

@Riverpod(keepAlive: true)
class PSSJwt extends _$PSSJwt {
  @override
  Future<TokensDto?> build() async {
    final instance = ref.watch(pSecureStorageProvider);
    final response = await instance.read(key: _key);
    if (response == null) return null;
    try {
      return TokensDtoMapper.fromJson(response.toString());
    } catch (_) {
      await instance.delete(key: _key);
      ref.invalidateSelf();
    }
    return null;
  }

  Future<void> setValue(TokensDto? data) async {
    final instance = ref.read(pSecureStorageProvider);
    if (data == null) {
      await instance.delete(key: _key);
    } else {
      await instance.write(key: _key, value: data.toJson());
    }

    ref.invalidateSelf();
  }
}
