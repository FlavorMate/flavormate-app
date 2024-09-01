class Pageable<T> {
  final List<T> content;
  final Page page;

  Pageable({required this.content, required this.page});

  factory Pageable.fromMap(
    Map<String, dynamic> data,
    T Function(Map<String, dynamic>) parser,
  ) {
    List<Map<String, dynamic>> content = List.from(data['content']);
    return Pageable(
      content: content.map(parser).toList(),
      page: Page.fromMap(data['page']),
    );
  }
}

class Page {
  /// current page
  final int number;

  /// current page size
  final int size;
  final int totalElements;
  final int totalPages;

  Page({
    required this.number,
    required this.size,
    required this.totalElements,
    required this.totalPages,
  });

  bool get empty => totalElements == 0;

  bool get first => number == 0;

  bool get last => totalPages == number;

  factory Page.fromMap(Map<String, dynamic> data) {
    return Page(
      number: data['number'] as int,
      size: data['size'] as int,
      totalElements: data['totalElements'] as int,
      totalPages: data['totalPages'] as int,
    );
  }
}
