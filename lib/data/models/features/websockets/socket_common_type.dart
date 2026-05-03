import 'package:dart_mappable/dart_mappable.dart';

part 'socket_common_type.mapper.dart';

@MappableEnum()
enum SocketCommonType { NewHighlights, NewStories, NewRecipes, Empty }
