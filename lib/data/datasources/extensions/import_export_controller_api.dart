import 'package:dio/dio.dart';
import 'package:flavormate/core/constants/api_constants.dart';
import 'package:flavormate/data/datasources/controller_api.dart';
import 'package:flavormate/data/models/extensions/importExport/ie_metadata.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:flavormate/presentation/features/recipe_editor/dialogs/recipe_editor_import_dialog_result.dart';

class ImportExportControllerApi extends ControllerApi {
  static const String _root = ApiConstants.ExtensionImportExport;

  const ImportExportControllerApi(super.dio);

  Future<List<IEMetadata>> getAvailableImporters() async {
    final response = await get(
      url: '$_root/importers',
      mapper: (data) => List<Map<String, dynamic>>.from(
        data,
      ).map(IEMetadataMapper.fromMap).toList(),
    );

    return response.data!;
  }

  Future<List<IEMetadata>> getAvailableExporters() async {
    final response = await get(
      url: '$_root/exporters',
      mapper: (data) => List<Map<String, dynamic>>.from(
        data,
      ).map(IEMetadataMapper.fromMap).toList(),
    );

    return response.data!;
  }

  Future<ApiResponse<List<String>>> import(
    RecipeEditorImportDialogResult data,
  ) async {
    final files = data.files
        ?.map((it) => MultipartFile.fromFileSync(it.path))
        .toList();

    final form = FormData.fromMap({'file': files, 'url': data.urls});

    final response = await post(
      url: '$_root/import/${data.pluginId}',
      data: form,
      mapper: (data) => List.from(data).cast<String>(),
      timeout: const Duration(minutes: 5),
    );

    return response;
  }
}
