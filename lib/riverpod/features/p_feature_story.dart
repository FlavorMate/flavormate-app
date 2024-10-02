import 'package:flavormate/riverpod/features/p_features.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_feature_story.g.dart';

@riverpod
class PFeatureStory extends _$PFeatureStory {
  @override
  Future<bool> build() async {
    final features =
        await ref.watch(pFeaturesProvider.selectAsync((data) => data));
    return features.features.contains('story');
  }
}
