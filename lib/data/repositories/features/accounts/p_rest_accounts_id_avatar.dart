import 'package:dio/dio.dart';
import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/data/datasources/features/account_controller_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_rest_accounts_id_avatar.g.dart';

@riverpod
class PRestAccountsIdAvatar extends _$PRestAccountsIdAvatar {
  @override
  void build(String accountId) {}

  Future<void> uploadAvatar(MultipartFile file) async {
    final dio = ref.read(pDioPrivateProvider);

    final client = AccountControllerApi(dio);

    await client.postAccountsIdAvatar(id: accountId, file: file);
  }

  Future<void> deleteAvatar() async {
    final dio = ref.read(pDioPrivateProvider);

    final client = AccountControllerApi(dio);

    await client.deleteAccountsIdAvatar(id: accountId);
  }
}
