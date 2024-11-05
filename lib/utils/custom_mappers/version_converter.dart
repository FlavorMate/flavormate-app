import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/models/version/version.dart';

class VersionConverter extends MappingHook {
  const VersionConverter();

  @override
  Object? beforeDecode(Object? value) {
    if (value is String) return Version.fromString(value);
    return null;
  }

  @override
  Object? beforeEncode(Object? value) {
    if (value is Version) return value.toString();
    return null;
  }
}
