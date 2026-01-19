import 'package:flavormate/data/models/core/features/feature_type.dart';
import 'package:flavormate/data/repositories/core/server/p_server_features.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_feature_oidc2.g.dart';

@riverpod
class PFeatureOidc2 extends _$PFeatureOidc2 {
  @override
  bool build() {
    final features = ref.watch(pServerFeaturesProvider).requireValue;

    return features.contains(FeatureType.Oidc2);
  }
}
