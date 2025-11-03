import 'package:flavormate/data/models/core/features/feature_type.dart';
import 'package:flavormate/data/repositories/core/features/p_features.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_feature_open_food_facts.g.dart';

@riverpod
class PFeatureOpenFoodFacts extends _$PFeatureOpenFoodFacts {
  @override
  bool build() {
    final features = ref.watch(pFeaturesProvider).requireValue;

    return features.contains(FeatureType.OpenFoodFacts);
  }
}
