import 'package:flavormate/data/models/features/books/book_dto.dart';

class LibraryItemWrapper {
  final BookDto book;
  final bool isAdmin;
  final bool isOwner;
  final bool isSubscribed;

  LibraryItemWrapper({
    required this.book,
    required this.isAdmin,
    required this.isOwner,
    required this.isSubscribed,
  });
}
