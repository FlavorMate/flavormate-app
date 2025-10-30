import 'package:flavormate/core/constants/api_constants.dart';
import 'package:flavormate/data/datasources/controller_api.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';

class VersionControllerApi extends ControllerApi {
  static const String _root = ApiConstants.CoreVersion;

  const VersionControllerApi(super.dio);

  Future<ApiResponse<String>> getVersion() async {
    return await get(url: '$_root/', mapper: (data) => data);
  }
}
