import 'package:dart_mappable/dart_mappable.dart';

part 'unit.mapper.dart';

@MappableClass()
class Unit with UnitMappable {
  final int id;
  final String label;
  final String? shortLabel;

  Unit({required this.id, required this.label, this.shortLabel});

  String beautify() {
    return shortLabel?.isNotEmpty == true ? shortLabel! : label;
  }
}
