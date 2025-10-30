import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/core/mappers/version_converter.dart';
import 'package:flavormate/data/models/core/version/version.dart';

part 'changelog.mapper.dart';

class Changelog {
  final Map<Version, ChangelogVersion> entries;

  Changelog({required this.entries});

  List<ChangelogVersion> get sorted => entries.values.toList();
}

@MappableClass()
class ChangelogVersion with ChangelogVersionMappable {
  @MappableField(hook: VersionConverter())
  final Version version;

  final List<ChangelogDetail> details;

  ChangelogVersion({required this.version, required this.details});
}

@MappableClass()
class ChangelogDetail with ChangelogDetailMappable {
  final String icon;
  final String change;

  ChangelogDetail({required this.icon, required this.change});
}
