import 'package:flavormate/core/apis/rest/p_dio_public.dart';
import 'package:flavormate/data/datasources/core/feature_controller_api.dart';
import 'package:flavormate/data/models/core/features/feature_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_features.g.dart';

@Riverpod(keepAlive: true)
class PFeatures extends _$PFeatures {
  @override
  Future<List<FeatureType>> build() async {
    final dio = ref.watch(pDioPublicProvider);

    final client = FeatureControllerApi(dio);

    final response = await client.getFeatures();

    if (ref.mounted && !response.hasError) {
      ref.keepAlive();
    }

    return response.hasError ? [] : response.data!;
  }
}
