import 'package:dart_mappable/dart_mappable.dart';

part 'changelog.mapper.dart';

@MappableClass()
class Changelog with ChangelogMappable {
  final String version;
  final List<String> changes;
  final String icon;

  Changelog({
    required this.version,
    required this.changes,
    required this.icon,
  });
}
