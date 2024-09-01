import 'package:flavormate/interfaces/a_base_client.dart';
import 'package:flavormate/models/file/file.dart';

class FilesClient extends ABaseClient<File> {
  FilesClient({
    required super.httpClient,
    required super.baseURL,
    required super.parser,
  });
}
