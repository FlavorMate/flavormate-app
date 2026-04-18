import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/data/models/extensions/importExport/ie_import_type.dart';
import 'package:flavormate/data/models/shared/enums/language.dart';

part 'ie_metadata.mapper.dart';

@MappableClass()
class IEMetadata with IEMetadataMappable {
  final String id;

  final String name;

  final String version;

  final String author;

  @MappableField(hook: _ImportTypeHook())
  final List<IEImportType> import;
  final List<String> importMimeTypes;
  final List<String> importExtensions;

  final String importShortDescription;
  final String importLongDescription;

  final bool export;
  final String exportShortDescription;
  final String exportLongDescription;

  const IEMetadata(
    this.id,
    this.name,
    this.version,
    this.author,
    this.import,
    this.importMimeTypes,
    this.importExtensions,
    this.importShortDescription,
    this.importLongDescription,
    this.export,
    this.exportShortDescription,
    this.exportLongDescription,
  );
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
