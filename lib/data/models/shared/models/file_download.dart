import 'package:flutter/foundation.dart';

class FileDownload {
  final Uint8List bytes;
  final String fileName;

  const FileDownload(this.bytes, this.fileName);
}
