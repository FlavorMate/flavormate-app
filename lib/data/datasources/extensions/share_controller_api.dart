import 'package:flavormate/core/constants/api_constants.dart';
import 'package:flavormate/data/datasources/controller_api.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:flutter/foundation.dart';

@immutable
class ShareControllerApi extends ControllerApi {
  static const _root = ApiConstants.ExtensionShare;

  const ShareControllerApi(super.dio);

  Future<ApiResponse<String>> postCreateRecipeShare({
    required String id,
  }) async {
    return await post(url: '$_root/$id', mapper: (val) => val);
  }
}
