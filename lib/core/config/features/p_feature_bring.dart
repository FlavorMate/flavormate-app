import 'package:flavormate/data/models/core/features/feature_type.dart';
import 'package:flavormate/data/repositories/core/features/p_features.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_feature_bring.g.dart';

@riverpod
class PFeatureBring extends _$PFeatureBring {
  @override
  bool build() {
    final features = ref.watch(pFeaturesProvider).requireValue;

    return features.contains(FeatureType.Bring);
  }
}
