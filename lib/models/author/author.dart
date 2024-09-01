import 'package:flavormate/models/entity.dart';
import 'package:flavormate/models/user/user.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'author.mapper.dart';

@MappableClass()
class Author extends Entity with AuthorMappable {
  final User account;

  final List<Map<String, dynamic>>? books;

  final List<Map<String, dynamic>>? recipes;

  Author({
    required this.account,
    required this.books,
    required this.recipes,
    required super.id,
    required super.version,
    required super.createdOn,
    required super.lastModifiedOn,
  });
}
