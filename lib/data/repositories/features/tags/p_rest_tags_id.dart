import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/data/datasources/features/tag_controller_api.dart';
import 'package:flavormate/data/models/features/tags/tag_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_rest_tags_id.g.dart';

@riverpod
class PRestTagsId extends _$PRestTagsId {
  @override
  Future<TagDto> build(String tagId) async {
    final dio = ref.watch(pDioPrivateProvider);

    final client = TagControllerApi(dio);

    final response = await client.getTagsId(id: tagId);

    return response;
  }
}
