import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/extensions/e_duration.dart';
import 'package:flavormate/utils/u_duration.dart';

part 'duration_mapper.dart';
part 'uri_mapper.dart';

final Iterable<MapperBase<Object>> customMappers = [
  _DurationMapper(),
  _UriMapper(),
];
