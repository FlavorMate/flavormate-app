import 'dart:typed_data';

import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/data/datasources/features/account_controller_api.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/data/models/features/accounts/account_update_dto.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_rest_accounts_self.g.dart';

@riverpod
class PRestAccountsSelf extends _$PRestAccountsSelf {
  String get _id => state.requireValue.id;

  PRestAccountsIdProvider get _restProvider => pRestAccountsIdProvider(_id);

  @override
  Future<AccountFullDto> build() async {
    final dio = ref.watch(pDioPrivateProvider);

    final client = AccountControllerApi(dio);

    final response = await client.getAccountsSelf();

    await ref.watch(pRestAccountsIdProvider(response.id).future);

    return response;
  }

  Future<ApiResponse<void>> deleteAvatar() async {
    final response = await ref.read(_restProvider.notifier).deleteAvatar();

    return response;
  }

  Future<ApiResponse<void>> updateAvatar(Uint8List bytes) async {
    final response = await ref.read(_restProvider.notifier).updateAvatar(bytes);

    return response;
  }

  Future<ApiResponse<void>> putAccountsId(AccountUpdateDto form) async {
    final response = await ref.read(_restProvider.notifier).putAccountsId(form);

    return response;
  }
}
