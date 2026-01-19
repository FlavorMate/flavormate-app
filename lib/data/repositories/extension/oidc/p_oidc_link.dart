import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/data/datasources/extensions/oidc_controller_api.dart';
import 'package:flavormate/data/models/core/auth/oidc/oidc_link_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_oidc_link.g.dart';

@riverpod
class POidcLink extends _$POidcLink {
  @override
  Future<PageableDto<OidcLinkDto>> build({
    required String pageId,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final page = ref.watch(pPageableStateProvider(pageId));

    final dio = ref.watch(pDioPrivateProvider);

    final client = OIDCControllerApi(dio);

    final data = await client.getLinks(
      page: page,
      orderBy: orderBy,
      orderDirection: orderDirection,
    );

    return data;
  }

  Future<ApiResponse<bool>> deleteLink(OidcLinkDto link) async {
    final dio = ref.read(pDioPrivateProvider);
    final client = OIDCControllerApi(dio);

    final response = await client.deleteLink(providerId: link.providerId);

    ref.invalidateSelf();

    return response;
  }
}
