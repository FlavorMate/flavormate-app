import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/data/datasources/features/book_controller_api.dart';
import 'package:flavormate/data/models/features/books/book_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:flavormate/data/repositories/features/books/p_rest_books.dart';
import 'package:flavormate/data/repositories/features/books/p_rest_books_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_rest_books_own.g.dart';

@riverpod
class PRestBooksOwn extends _$PRestBooksOwn {
  @override
  Future<PageableDto<BookDto>> build({
    required String pageProviderId,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final dio = ref.watch(pDioPrivateProvider);

    final page = ref.watch(pPageableStateProvider(pageProviderId));

    final client = BookControllerApi(dio);

    final response = await client.getBooksOwn(
      page: page,
      pageSize: pageSize,
      orderBy: orderBy,
      orderDirection: orderDirection,
    );

    return response;
  }

  Future<ApiResponse<void>> toggleRecipeInBook(
    String bookId,
    String recipeId,
  ) async {
    final dio = ref.watch(pDioPrivateProvider);

    final client = BookControllerApi(dio);

    final response = await client.putBooksIdRecipe(
      bookId: bookId,
      recipeId: recipeId,
    );

    ref.invalidateSelf();
    ref.invalidate(pRestBooksProvider);
    ref.invalidate(pRestBooksIdProvider);
    return response;
  }

  Future<bool> isRecipeInBook(String bookId, String recipeId) async {
    final dio = ref.watch(pDioPrivateProvider);

    final client = BookControllerApi(dio);

    final response = await client.getBooksIdContainsRecipe(
      bookId: bookId,
      recipeId: recipeId,
    );

    return response;
  }
}
