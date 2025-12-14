import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/core/storage/secure_storage/providers/p_secure_storage.dart';
import 'package:flavormate/core/storage/shared_preferences/enums/sp_key.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp.dart';
import 'package:flavormate/data/models/core/auth/tokens_dto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_ss_jwt.g.dart';

final _key = SPKey.JWT.name;

@Riverpod(keepAlive: true)
class PSSJwt extends _$PSSJwt {
  @override
  Future<TokensDto?> build() async {
    final securedStorage = ref.watch(pSecureStorageProvider);

    await _migrateTokenFromSharedPreferences(securedStorage);

    final response = await securedStorage.read(key: _key);

    if (response == null) return null;
    try {
      return TokensDtoMapper.fromJson(response.toString());
    } catch (_) {
      await securedStorage.delete(key: _key);
      ref.invalidateSelf();
      return null;
    }
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

  Future<void> _migrateTokenFromSharedPreferences(
    FlutterSecureStorage securedStorage,
  ) async {
    final sharedPreferences = await ref.watch(pSPProvider.future);

    final oldJwt = sharedPreferences.getString(SPKey.JWT.name);
    if (oldJwt.isNotBlank) {
      await securedStorage.write(key: SPKey.JWT.name, value: oldJwt!);
      await sharedPreferences.remove(SPKey.JWT.name);
    }
  }
}
