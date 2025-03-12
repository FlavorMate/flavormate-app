import 'package:flavormate/riverpod/features/p_features.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_feature_registration.g.dart';

@riverpod
class PFeatureRegistration extends _$PFeatureRegistration {
  @override
  Future<bool> build() async {
    final features = await ref.watch(
      pFeaturesProvider.selectAsync((data) => data),
    );
    return features.features.contains('registration');
  }
}
