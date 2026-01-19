import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/core/extensions/e_duration.dart';
import 'package:flavormate/core/utils/u_duration.dart';

part 'duration_mapper.dart';
part 'uint8list_mapper.dart';
part 'uri_mapper.dart';

const Iterable<MapperBase<Object>> customMappers = [
  _DurationMapper(),
  _UriMapper(),
  _UInt8ListMapper(),
];
