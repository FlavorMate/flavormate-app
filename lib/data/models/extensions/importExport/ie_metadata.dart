import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/data/models/extensions/importExport/ie_import_type.dart';

part 'ie_metadata.mapper.dart';

@MappableClass()
class IEMetadata with IEMetadataMappable {
  final String id;
  final String name;
  final String version;
  final String? author;
  final String? description;

  @MappableField(hook: _ImportTypeHook())
  final List<IEImportType> import;
  final bool export;
  final List<String> supportedMimeTypes;
  final List<String> supportedExtensions;

  const IEMetadata({
    required this.id,
    required this.name,
    required this.version,
    required this.author,
    required this.description,
    required this.import,
    required this.export,
    required this.supportedMimeTypes,
    required this.supportedExtensions,
  });
}

class _ImportTypeHook extends MappingHook {
  const _ImportTypeHook();

  @override
  Object? beforeDecode(Object? value) {
    if (value is List) {
      final allowed = IEImportType.values.map((it) => it.name);
      return value.where(allowed.contains);
    }
    return null;
  }
}
