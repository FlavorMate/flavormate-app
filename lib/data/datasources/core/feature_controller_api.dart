import 'package:flavormate/core/constants/api_constants.dart';
import 'package:flavormate/data/datasources/controller_api.dart';
import 'package:flavormate/data/models/core/features/feature_type.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';

class FeatureControllerApi extends ControllerApi {
  static const String _root = ApiConstants.CoreFeatures;

  const FeatureControllerApi(super.dio);

  Future<ApiResponse<List<FeatureType>>> getFeatures() async {
    return await get(
      url: '$_root/',
      mapper: (data) => List<dynamic>.from(
        data,
      ).map(FeatureTypeMapper.fromValue).toList(),
    );
  }
}
