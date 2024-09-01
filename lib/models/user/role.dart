import 'package:dart_mappable/dart_mappable.dart';

part 'role.mapper.dart';

@MappableClass()
class Role with RoleMappable {
  final String label;

  const Role({required this.label});
}
