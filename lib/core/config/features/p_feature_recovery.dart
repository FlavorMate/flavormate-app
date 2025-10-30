import 'package:flavormate/data/models/core/features/feature_type.dart';
import 'package:flavormate/data/repositories/core/features/p_features.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_feature_recovery.g.dart';

@riverpod
class PFeatureRecovery extends _$PFeatureRecovery {
  @override
  bool build() {
    final features = ref.watch(pFeaturesProvider).requireValue;

    return features.contains(FeatureType.Recovery);
  }
}
