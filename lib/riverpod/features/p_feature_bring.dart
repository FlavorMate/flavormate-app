import 'package:flavormate/riverpod/features/p_features.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_feature_bring.g.dart';

@riverpod
class PFeatureBring extends _$PFeatureBring {
  @override
  Future<bool> build() async {
    final features = await ref.watch(
      pFeaturesProvider.selectAsync((data) => data),
    );

    return features.features.contains('bring');
  }
}
