import 'package:flavormate/riverpod/features/p_features.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_feature_open_food_facts.g.dart';

@riverpod
class PFeatureOpenFoodFacts extends _$PFeatureOpenFoodFacts {
  @override
  bool build() {
    final features = ref.watch(pFeaturesProvider).requireValue;

    return features.features.contains('open-food-facts');
  }
}
