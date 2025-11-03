import 'package:dart_mappable/dart_mappable.dart';

part 'book_update_dto.mapper.dart';

@MappableClass()
class BookUpdateDto with BookUpdateDtoMappable {
  final String? label;
  final bool? visible;

  const BookUpdateDto({this.label, this.visible});
}
