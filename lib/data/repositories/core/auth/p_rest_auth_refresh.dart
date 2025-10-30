import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/data/datasources/core/auth_controller_api.dart';
import 'package:flavormate/data/models/core/auth/tokens_dto.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_rest_auth_refresh.g.dart';

@riverpod
class PRestAuthRefresh extends _$PRestAuthRefresh {
  @override
  void build() {}

  Future<ApiResponse<TokensDto>> refresh() async {
    final dio = ref.watch(pDioPrivateProvider);

    final client = AuthControllerApi(dio);

    final response = await client.postRefreshToken();

    return response;
  }
}
