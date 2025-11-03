import 'package:dio/dio.dart';
import 'package:flavormate/core/constants/api_constants.dart';
import 'package:flavormate/data/datasources/controller_api.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/data/models/features/accounts/account_update_dto.dart';
import 'package:flavormate/data/models/features/books/book_dto.dart';
import 'package:flavormate/data/models/features/recipes/recipe_dto.dart';
import 'package:flavormate/data/models/features/stories/story_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:flutter/foundation.dart';

@immutable
class AccountControllerApi extends ControllerApi {
  static const _root = ApiConstants.FeatureAccounts;

  const AccountControllerApi(super.dio);

  Future<PageableDto<AccountPreviewDto>> getAccounts({
    int? page,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final response = await get(
      url: _root,
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        'orderBy': orderBy?.name,
        'orderDirection': orderDirection?.name,
      },
      mapper: (data) => PageableDto.fromAPI<AccountPreviewDto>(
        data,
        AccountPreviewDto,
      ),
    );

    return response.data!;
  }

  Future<AccountFullDto> getAccountsSelf() async {
    final response = await get(
      url: '$_root/self',
      mapper: (data) => AccountFullDtoMapper.fromMap(data),
    );

    return response.data!;
  }

  Future<AccountPreviewDto> getAccountsId({
    required String id,
  }) async {
    final response = await get(
      url: '$_root/$id',
      mapper: (data) => AccountPreviewDtoMapper.fromMap(data),
    );

    return response.data!;
  }

  Future<ApiResponse<void>> postAccountsIdAvatar({
    required String id,
    required MultipartFile file,
  }) async {
    final data = FormData.fromMap({'file': file});
    return await post(
      url: '$_root/$id/avatar',
      data: data,
      mapper: ControllerApi.nullMapper,
    );
  }

  Future<ApiResponse<void>> deleteAccountsIdAvatar({required String id}) async {
    return await delete(
      url: '$_root/$id/avatar',
      mapper: ControllerApi.nullMapper,
    );
  }

  Future<PageableDto<BookDto>> getAccountsIdBooks({
    required String accountId,
    required page,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final response = await get(
      url: '$_root/$accountId/books',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        'orderBy': orderBy?.name,
        'orderDirection': orderDirection?.name,
      },
      mapper: (data) => PageableDto.fromAPI<BookDto>(
        data,
        BookDto,
      ),
    );

    return response.data!;
  }

  Future<PageableDto<RecipePreviewDto>> getAccountsIdRecipes({
    required String accountId,
    required page,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final response = await get(
      url: '$_root/$accountId/recipes',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        'orderBy': orderBy?.name,
        'orderDirection': orderDirection?.name,
      },
      mapper: (data) => PageableDto.fromAPI<RecipePreviewDto>(
        data,
        RecipePreviewDto,
      ),
    );

    return response.data!;
  }

  Future<PageableDto<StoryPreviewDto>> getAccountsIdStories({
    required String accountId,
    required page,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final response = await get(
      url: '$_root/$accountId/stories',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        'orderBy': orderBy?.name,
        'orderDirection': orderDirection?.name,
      },
      mapper: (data) => PageableDto.fromAPI<StoryPreviewDto>(
        data,
        StoryPreviewDto,
      ),
    );

    return response.data!;
  }

  Future<PageableDto<AccountPreviewDto>> getAccountsSearch({
    required String query,
    required int page,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final response = await get(
      url: '$_root/search',
      queryParameters: {
        'query': query,
        'page': page,
        'pageSize': pageSize,
        'orderBy': orderBy?.name,
        'orderDirection': orderDirection?.name,
      },
      mapper: (data) => PageableDto.fromAPI<AccountPreviewDto>(
        data,
        AccountPreviewDto,
      ),
    );

    return response.data!;
  }

  Future<ApiResponse<void>> putAccountsId({
    required String id,
    required AccountUpdateDto form,
  }) async {
    return await put(
      url: '$_root/$id',
      data: form.toJson(),
      mapper: ControllerApi.nullMapper,
    );
  }
}
