import 'package:file_selector/file_selector.dart';

extension EXTypeGroup on XTypeGroup {
  static String toUniformTypeIdentifier(String extension) {
    return switch (extension.toLowerCase()) {
      'zip' => 'public.zip-archive',
      'json' || 'jsonld' => 'public.json',
      _ => 'public.data',
    };
  }
}
