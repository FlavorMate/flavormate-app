import 'package:flavormate/models/features/features_response.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_features.g.dart';

@riverpod
class PFeatures extends _$PFeatures {
  @override
  Future<FeaturesResponse> build() async {
    final response = await ref.watch(pApiProvider).featuresClient.get();

    return response;
  }
}
