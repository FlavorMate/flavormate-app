import 'dart:convert';

class AppLink {
  final String server;
  final String token;
  final String page;
  final int id;

  AppLink({
    required this.server,
    required this.token,
    required this.page,
    required this.id,
  });

  factory AppLink.decode(Map<String, String> input) {
    final s = utf8.decode(base64Decode(input['server']!));

    return AppLink(
      server: s,
      token: input['token']!,
      page: input['page']!,
      id: int.parse(input['id']!),
    );
  }

  String encode() {
    final s = base64Encode(utf8.encode(server));

    return 'server=$s&page=${Uri.encodeComponent(page)}&id=${Uri.encodeComponent(id.toString())}&token=${Uri.encodeComponent(token)}';
  }
}

enum AppLinkMode { open }
