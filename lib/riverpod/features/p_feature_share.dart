import 'package:flavormate/riverpod/features/p_features.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_feature_share.g.dart';

@riverpod
class PFeatureShare extends _$PFeatureShare {
  @override
  Future<bool> build() async {
    final features =
        await ref.watch(pFeaturesProvider.selectAsync((data) => data));
    return features.features.contains('share');
  }
}
