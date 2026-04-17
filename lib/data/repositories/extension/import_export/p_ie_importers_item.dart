import 'package:flavormate/data/models/extensions/importExport/ie_metadata.dart';
import 'package:flavormate/data/repositories/extension/import_export/p_ie_importers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_ie_importers_item.g.dart';

@Riverpod(keepAlive: true)
class PIeImportersItem extends _$PIeImportersItem {
  @override
  Future<IEMetadata> build(String id) async {
    return await ref.watch(
      pIeImportersProvider.selectAsync(
        (data) => data.firstWhere((it) => it.id == id),
      ),
    );
  }
}
