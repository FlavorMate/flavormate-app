import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/data/datasources/features/account_controller_api.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/data/models/features/accounts/account_update_dto.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_rest_accounts_id.g.dart';

@riverpod
class PRestAccountsId extends _$PRestAccountsId {
  @override
  Future<AccountPreviewDto> build(String id) async {
    final dio = ref.watch(pDioPrivateProvider);

    final client = AccountControllerApi(dio);

    final response = await client.getAccountsId(id: id);

    return response;
  }

  Future<ApiResponse<void>> deleteAvatar() async {
    final dio = ref.read(pDioPrivateProvider);

    final client = AccountControllerApi(dio);

    final response = await client.deleteAccountsIdAvatar(
      id: id,
    );

    if (ref.mounted) {
      ref.invalidateSelf();
    }

    return response;
  }

  Future<ApiResponse<void>> updateAvatar(Uint8List bytes) async {
    final file = MultipartFile.fromBytes(
      bytes,
      contentType: DioMediaType.parse('application/octet-stream'),
    );

    final dio = ref.read(pDioPrivateProvider);

    final client = AccountControllerApi(dio);

    final response = await client.postAccountsIdAvatar(id: id, file: file);

    if (ref.mounted) {
      ref.invalidateSelf();
    }

    return response;
  }

  Future<ApiResponse<void>> putAccountsId(AccountUpdateDto form) async {
    final dio = ref.read(pDioPrivateProvider);

    final client = AccountControllerApi(dio);

    final response = await client.putAccountsId(
      id: id,
      form: form,
    );

    if (ref.mounted) {
      ref.invalidateSelf();
    }

    return response;
  }
}
