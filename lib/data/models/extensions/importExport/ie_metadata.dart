import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/core/utils/u_localizations.dart';
import 'package:flavormate/data/models/extensions/importExport/ie_import_type.dart';
import 'package:flavormate/data/models/shared/enums/language.dart';

part 'ie_metadata.mapper.dart';

@MappableClass()
class IEMetadata with IEMetadataMappable {
  final String id;

  @MappableField(hook: _NameHook())
  final Map<Language, String> name;

  final String version;

  final String? author;

  @MappableField(hook: _NameHook())
  final Map<Language, String>? description;

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

  String get title => name[currentLanguage()] ?? name[Language.en]!;

  String? get desc => description?[currentLanguage()];
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

class _NameHook extends MappingHook {
  const _NameHook();

  @override
  Object? beforeDecode(Object? value) {
    if (value is Map) {
      final allowed = {
        for (final lang in Language.values) lang.name.toLowerCase(): lang,
      };

      final newMap = {
        for (final entry in value.entries)
          if (allowed.containsKey(entry.key.toLowerCase()))
            allowed[entry.key.toLowerCase()]!: entry.value,
      };

      return newMap;
    }
    return null;
  }
}
