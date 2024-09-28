import 'package:dio/dio.dart';
import 'package:flavormate/clients/authors_client.dart';
import 'package:flavormate/clients/categories_client.dart';
import 'package:flavormate/clients/category_group_client.dart';
import 'package:flavormate/clients/files_client.dart';
import 'package:flavormate/clients/highlights_client.dart';
import 'package:flavormate/clients/interceptor_methods.dart';
import 'package:flavormate/clients/library_client.dart';
import 'package:flavormate/clients/recipes_client.dart';
import 'package:flavormate/clients/stories_client.dart';
import 'package:flavormate/clients/tags_client.dart';
import 'package:flavormate/clients/units_client.dart';
import 'package:flavormate/clients/user_client.dart';
import 'package:flavormate/models/api/login.dart';
import 'package:flavormate/models/author/author.dart';
import 'package:flavormate/models/categories/category.dart';
import 'package:flavormate/models/categories/category_group.dart';
import 'package:flavormate/models/file/file.dart';
import 'package:flavormate/models/highlight.dart';
import 'package:flavormate/models/library/book.dart';
import 'package:flavormate/models/recipe/recipe.dart';
import 'package:flavormate/models/story.dart';
import 'package:flavormate/models/tag/tag.dart';
import 'package:flavormate/models/unit.dart';
import 'package:flavormate/models/user/token.dart';
import 'package:flavormate/models/user/user.dart';
import 'package:flavormate/utils/u_go_router.dart';

typedef ApiClientException = DioException;
typedef ApiClientResponse<T> = Response<T>;
typedef ApiClientRequestOptions = RequestOptions;

extension ApiClientExceptionX on ApiClientException {
  String? get responseMessage => response?.data?['message'] as String?;
}

_interceptors(InterceptorMethods handlers) => InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        // Do something before request is sent.
        // If you want to resolve the request with custom data,
        // you can resolve a `Response` using `handler.resolve(response)`.
        // If you want to reject the request with a error message,
        // you can reject with a `DioException` using `handler.reject(dioError)`.
        return handler.next(options);
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        // Do something with response data.
        // If you want to reject the request with a error message,
        // you can reject a `DioException` object using `handler.reject(dioError)`.
        return handler.next(response);
      },
      onError: (DioException error, ErrorInterceptorHandler handler) {
        // Do something with response error.
        // If you want to resolve the request with some custom data,
        // you can resolve a `Response` object using `handler.resolve(response)`.

        if (error.type == DioExceptionType.connectionError ||
            error.type == DioExceptionType.connectionTimeout) {
          if (!['/login', '/no_connection'].contains(currentRoute())) {
            handlers.onNoConnection();
            return;
          } else {
            return handler.next(error);
          }
        }

        if (error.response?.statusCode == 401) {
          if (error.requestOptions.path.contains('login')) throw error;
          handlers.onUnauthenticated();
          return;
        }

        return handler.next(error);
      },
    );

/// An API client that makes network requests.
///
/// This class is meant to be seen as a representation of the common API contract
/// or API list (such as Swagger or Postman) given by the backend.
///
/// This class does not maintain authentication state, but rather receive the token
/// from external source.
///
/// When a widget or provider wants to make a network request, it should not
/// instantiate this class, but instead call the provider that exposes an object
/// of this type.
class ApiClient {
  BaseOptions _defaultOptions(String server) => BaseOptions(
        baseUrl: server,
        headers: {'Content-Type': 'application/json'},
      );

  late Dio _httpClient;

  // late EntriesClient entriesClient;
  late AuthorsClient authorsClient;
  late CategoriesClient categoriesClient;
  late CategoryGroupClient categoryGroupClient;
  late FilesClient filesClient;
  late HighlightsClient highlightsClient;
  late LibraryClient libraryClient;
  late RecipesClient recipesClient;
  late StoriesClient storiesClient;
  late TagsClient tagsClient;
  late UnitsClient unitsClient;
  late UserClient userClient;

  /// Creates an [ApiClient] with default options.
  ApiClient(String server, InterceptorMethods handlers) {
    _httpClient = Dio(_defaultOptions(server));
    _httpClient.interceptors.add(_interceptors(handlers));

    authorsClient = AuthorsClient(
      httpClient: _httpClient,
      baseURL: '/v2/authors',
      parser: AuthorMapper.fromMap,
    );
    categoriesClient = CategoriesClient(
      httpClient: _httpClient,
      baseURL: '/v2/categories',
      parser: CategoryMapper.fromMap,
    );
    categoryGroupClient = CategoryGroupClient(
      httpClient: _httpClient,
      baseURL: '/v2/categoryGroups',
      parser: CategoryGroupMapper.fromMap,
    );
    filesClient = FilesClient(
      httpClient: _httpClient,
      baseURL: '/v2/files',
      parser: FileMapper.fromMap,
    );
    highlightsClient = HighlightsClient(
      httpClient: _httpClient,
      baseURL: '/v2/highlights',
      parser: HighlightMapper.fromMap,
    );
    libraryClient = LibraryClient(
      httpClient: _httpClient,
      baseURL: '/v2/books',
      parser: BookMapper.fromMap,
    );
    recipesClient = RecipesClient(
      httpClient: _httpClient,
      baseURL: '/v2/recipes',
      parser: RecipeMapper.fromMap,
    );
    storiesClient = StoriesClient(
      httpClient: _httpClient,
      baseURL: '/v2/stories',
      parser: StoryMapper.fromMap,
    );
    tagsClient = TagsClient(
      httpClient: _httpClient,
      baseURL: '/v2/tags',
      parser: TagMapper.fromMap,
    );
    unitsClient = UnitsClient(
      httpClient: _httpClient,
      baseURL: '/v2/units',
      parser: UnitMapper.fromMap,
    );
    userClient = UserClient(
      httpClient: _httpClient,
      baseURL: '/v2/accounts',
      parser: UserMapper.fromMap,
    );
  }

  /// Creates an [ApiClient] with [token] set for authorization.
  ApiClient.withToken(
    String server,
    String token,
    InterceptorMethods handlers,
  ) {
    _httpClient = Dio(
      _defaultOptions(server).copyWith()
        ..headers['Authorization'] = 'Bearer $token',
    );
    _httpClient.interceptors.add(_interceptors(handlers));

    authorsClient = AuthorsClient(
      httpClient: _httpClient,
      baseURL: '/v2/authors',
      parser: AuthorMapper.fromMap,
    );
    categoriesClient = CategoriesClient(
      httpClient: _httpClient,
      baseURL: '/v2/categories',
      parser: CategoryMapper.fromMap,
    );
    categoryGroupClient = CategoryGroupClient(
      httpClient: _httpClient,
      baseURL: '/v2/categoryGroups',
      parser: CategoryGroupMapper.fromMap,
    );
    filesClient = FilesClient(
      httpClient: _httpClient,
      baseURL: '/v2/files',
      parser: FileMapper.fromMap,
    );
    highlightsClient = HighlightsClient(
      httpClient: _httpClient,
      baseURL: '/v2/highlights',
      parser: HighlightMapper.fromMap,
    );
    libraryClient = LibraryClient(
      httpClient: _httpClient,
      baseURL: '/v2/books',
      parser: BookMapper.fromMap,
    );
    recipesClient = RecipesClient(
      httpClient: _httpClient,
      baseURL: '/v2/recipes',
      parser: RecipeMapper.fromMap,
    );
    storiesClient = StoriesClient(
      httpClient: _httpClient,
      baseURL: '/v2/stories',
      parser: StoryMapper.fromMap,
    );
    tagsClient = TagsClient(
      httpClient: _httpClient,
      baseURL: '/v2/tags',
      parser: TagMapper.fromMap,
    );
    unitsClient = UnitsClient(
      httpClient: _httpClient,
      baseURL: '/v2/units',
      parser: UnitMapper.fromMap,
    );
    userClient = UserClient(
      httpClient: _httpClient,
      baseURL: '/v2/accounts',
      parser: UserMapper.fromMap,
    );
  }

  @override
  String toString() {
    return "ApiClient(_httpClient.options.headers['Authorization']: ${_httpClient.options.headers['Authorization']})";
  }

  /// Attempts to login with the login [data], returns the token if success.
  Future<Tokens?> login(Login data) async {
    final response = await _httpClient.post(
      '/auth/login',
      data: data.toJson(),
    );

    return TokensMapper.fromMap(response.data);
  }
}
