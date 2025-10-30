import 'dart:convert';

import 'package:flavormate/core/constants/api_constants.dart';
import 'package:flavormate/data/datasources/controller_api.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/data/models/features/books/book_dto.dart';
import 'package:flavormate/data/models/features/books/book_update_dto.dart';
import 'package:flavormate/data/models/features/recipes/recipe_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:flutter/foundation.dart';

@immutable
class BookControllerApi extends ControllerApi {
  static const _root = ApiConstants.FeatureBooks;

  const BookControllerApi(super.dio);

  Future<PageableDto<BookDto>> getBooks({
    int? page,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final response = await get(
      url: '$_root/',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        'orderBy': orderBy?.name,
        'orderDirection': orderDirection?.name,
      },
      mapper: (data) => PageableDto.fromAPI<BookDto>(data, BookDto),
    );

    return response.data!;
  }

  Future<PageableDto<BookDto>> getBooksOwn({
    int? page,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final response = await get(
      url: '$_root/own',
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

  Future<BookDto> getBooksId({required String bookId}) async {
    final response = await get(
      url: '$_root/$bookId',
      mapper: (data) => BookDtoMapper.fromMap(data),
    );

    return response.data!;
  }

  Future<PageableDto<RecipePreviewDto>> getBooksIdRecipes({
    required String bookId,
    required int page,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final response = await get(
      url: '$_root/$bookId/recipes',
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

  Future<bool> getBooksIdContainsRecipe({
    required String bookId,
    required String recipeId,
  }) async {
    final response = await get(
      url: '$_root/$bookId/recipes/$recipeId',

      mapper: (data) => bool.parse(data),
    );

    return response.data!;
  }

  Future<ApiResponse<void>> putBooksIdRecipe({
    required String bookId,
    required String recipeId,
  }) async {
    final response = await put(
      url: '$_root/$bookId/recipes/$recipeId',

      mapper: ControllerApi.nullMapper,
    );

    return response;
  }

  Future<PageableDto<BookDto>> getBooksSearch({
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
      mapper: (data) => PageableDto.fromAPI<BookDto>(
        data,
        BookDto,
      ),
    );

    return response.data!;
  }

  Future<String> postBooks({required String label}) async {
    final response = await post<String>(
      url: '$_root/',
      data: jsonEncode({'label': label}),
      mapper: (data) => data,
    );

    return response.data!;
  }

  Future<ApiResponse<void>> deleteBooksId({
    required String id,
  }) async {
    return await delete(url: '$_root/$id', mapper: ControllerApi.nullMapper);
  }

  Future<ApiResponse<void>> putBooksId({
    required String id,
    required BookUpdateDto form,
  }) async {
    return put(
      url: '$_root/$id',
      data: form.toJson(),
      mapper: ControllerApi.nullMapper,
    );
  }

  Future<ApiResponse<void>> putBooksIdSubscriber({required String id}) async {
    return put(url: '$_root/$id/subscriber', mapper: ControllerApi.nullMapper);
  }

  Future<PageableDto<AccountPreviewDto>> getBooksIdSubscribers({
    required String bookId,
    int? page,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final response = await get(
      url: '$_root/$bookId/subscribers',
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

  Future<bool> getBooksIdSubscriber({required String bookId}) async {
    final response = await get(
      url: '$_root/$bookId/subscriber',
      mapper: (data) => bool.parse(data),
    );

    return response.data!;
  }
}
