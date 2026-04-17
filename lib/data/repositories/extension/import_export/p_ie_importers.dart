import 'package:collection/collection.dart';
import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/data/datasources/extensions/import_export_controller_api.dart';
import 'package:flavormate/data/models/extensions/importExport/ie_metadata.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_ie_importers.g.dart';

@Riverpod(keepAlive: true)
class PIeImporters extends _$PIeImporters {
  @override
  Future<List<IEMetadata>> build() async {
    final dio = ref.watch(pDioPrivateProvider);
    final client = ImportExportControllerApi(dio);

    final response = await client.getAvailableImporters();

    return response.sortedBy((a) => a.title);
  }
}
