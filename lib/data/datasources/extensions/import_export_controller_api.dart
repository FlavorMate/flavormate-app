import 'package:dio/dio.dart';
import 'package:flavormate/core/constants/api_constants.dart';
import 'package:flavormate/data/datasources/controller_api.dart';
import 'package:flavormate/data/models/extensions/importExport/ie_import_wrapper.dart';
import 'package:flavormate/data/models/extensions/importExport/ie_metadata.dart';
import 'package:flavormate/data/models/shared/enums/language.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';

class ImportExportControllerApi extends ControllerApi {
  static const String _root = ApiConstants.ExtensionImportExport;

  const ImportExportControllerApi(super.dio);

  Future<List<IEMetadata>> getAvailableImporters(Language language) async {
    final response = await get(
      url: '$_root/import/',
      queryParameters: {'language': language.name},
      mapper: (data) => List<Map<String, dynamic>>.from(
        data,
      ).map(IEMetadataMapper.fromMap).toList(),
    );

    return response.data!;
  }

  Future<List<IEMetadata>> getAvailableExporters(Language language) async {
    final response = await get(
      url: '$_root/export/',
      queryParameters: {'language': language.name},
      mapper: (data) => List<Map<String, dynamic>>.from(
        data,
      ).map(IEMetadataMapper.fromMap).toList(),
    );

    return response.data!;
  }

  Future<ApiResponse<List<String>>> import(
    IEImportWrapper data,
  ) async {
    final formMap = <String, dynamic>{};

    if (data.files.isNotEmpty) {
      formMap['file'] = data.files
          .map((it) => MultipartFile.fromFileSync(it.path))
          .toList();
    }

    if (data.urls.isNotEmpty) {
      formMap['url'] = data.urls;
    }

    final form = FormData.fromMap(formMap);

    final response = await post(
      url: '$_root/import/${data.pluginId}',
      data: form,
      mapper: (data) => List.from(data).cast<String>(),
      timeout: const Duration(minutes: 5),
    );

    return response;
  }
}
