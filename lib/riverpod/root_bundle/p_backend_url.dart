import 'package:flavormate/extensions/e_string.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_backend_url.g.dart';

/// Provides the backend url to use. Once this string is set, the user is unable to change it.
/// On iOS, Android, Linux, macOS and Windows this should always be null.
/// On Web it's recommended to provide a url via the file
@riverpod
class PBackendUrl extends _$PBackendUrl {
  @override
  Future<String?> build() async {
    final value = await rootBundle
        .loadString('assets/web/backend_url.txt')
        .catchError((_) => '');
    return EString.trimToNull(value);
  }
}
