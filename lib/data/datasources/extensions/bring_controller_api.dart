import 'package:flavormate/core/constants/api_constants.dart';
import 'package:flavormate/data/datasources/controller_api.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';

class BringControllerApi extends ControllerApi {
  static const String _root = ApiConstants.ExtensionBring;

  const BringControllerApi(super.dio);

  Future<ApiResponse<String>> postBringUrl({required String recipeId}) async {
    return await post(url: '$_root/$recipeId', mapper: (data) => data);
  }
}
