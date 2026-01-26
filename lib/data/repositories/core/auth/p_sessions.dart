import 'package:flavormate/core/apis/rest/p_dio_auth.dart';
import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/core/auth/providers/p_auth.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/data/datasources/core/auth_controller_api.dart';
import 'package:flavormate/data/models/core/auth/session_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_sessions.g.dart';

@riverpod
class PSessions extends _$PSessions {
  @override
  Future<PageableDto<SessionDto>> build({
    required String pageId,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final page = ref.watch(pPageableStateProvider(pageId));

    final dio = ref.watch(pDioPrivateProvider);

    final client = AuthControllerApi(dio);

    final response = await client.getAllSessions(
      page: page,
      orderBy: orderBy,
      orderDirection: orderDirection,
    );

    return response;
  }

  Future<ApiResponse<bool>> delete({required String id}) async {
    final dio = ref.read(pDioPrivateProvider);

    final client = AuthControllerApi(dio);

    final response = await client.deleteSession(id: id);

    ref.invalidateSelf();

    return response;
  }

  Future<ApiResponse<bool>> deleteAllSessionsButCurrent() async {
    final refreshToken = ref.read(pAuthProvider).refreshToken;

    final dio = ref.read(pDioAuthProvider(refreshToken));

    final client = AuthControllerApi(dio);

    final response = await client.deleteAllSessionsButCurrent();

    ref.invalidateSelf();

    return response;
  }
}
