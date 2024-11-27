extension EUri on Uri {
  String get socket {
    var response = host;

    if (port != 0) {
      response += ':$port';
    }

    if (path.isNotEmpty) {
      response += path;
    }

    return response;
  }
}
