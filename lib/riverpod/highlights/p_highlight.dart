import 'package:flavormate/models/highlight.dart';
import 'package:flavormate/models/pageable/pageable.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/riverpod/user/p_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_highlight.g.dart';

@riverpod
class PHighlight extends _$PHighlight {
  @override
  Future<Pageable<Highlight>> build() async {
    final user = await ref.watch(pUserProvider.selectAsync((data) => data));

    return await ref
        .watch(pApiProvider)
        .highlightsClient
        .findAllByDiet(filter: user.diet!, size: 14, sortBy: 'createdOn');
  }
}
