import 'package:flavormate/interfaces/a_search_client.dart';
import 'package:flavormate/models/story.dart';

class StoriesClient extends ASearchClient<Story> {
  StoriesClient({
    required super.httpClient,
    required super.baseURL,
    required super.parser,
  });
}
