import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/data/datasources/features/account_controller_api.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/data/models/features/accounts/account_update_dto.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_rest_accounts_self.g.dart';

@riverpod
class PRestAccountsSelf extends _$PRestAccountsSelf {
  @override
  Future<AccountFullDto> build() async {
    final dio = ref.watch(pDioPrivateProvider);

    final client = AccountControllerApi(dio);

    final response = await client.getAccountsSelf();

    return response;
  }

  Future<ApiResponse<void>> deleteAvatar() async {
    final id = state.value!.id;

    final dio = ref.read(pDioPrivateProvider);

    final client = AccountControllerApi(dio);

    final response = await client.deleteAccountsIdAvatar(
      id: id,
    );

    ref.invalidateSelf();

    return response;
  }

  Future<ApiResponse<void>> updateAvatar(Uint8List bytes) async {
    final id = state.value!.id;

    final file = MultipartFile.fromBytes(
      bytes,
      contentType: DioMediaType.parse('application/octet-stream'),
    );

    final dio = ref.read(pDioPrivateProvider);

    final client = AccountControllerApi(dio);

    final response = await client.postAccountsIdAvatar(id: id, file: file);

    ref.invalidateSelf();

    return response;
  }

  Future<ApiResponse<void>> putAccountsId(AccountUpdateDto form) async {
    final id = state.value!.id;

    final dio = ref.read(pDioPrivateProvider);

    final client = AccountControllerApi(dio);

    final response = await client.putAccountsId(
      id: id,
      form: form,
    );

    ref.invalidateSelf();

    return response;
  }
}
