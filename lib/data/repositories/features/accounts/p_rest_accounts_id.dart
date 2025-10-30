import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/data/datasources/features/account_controller_api.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
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
}
