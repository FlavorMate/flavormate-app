import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/generated/flutter_gen/assets.gen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_rb_backend_url.g.dart';

/// Provides the backend url to use. Once this string is set, the user is unable to change it.
/// On iOS, Android, Linux, macOS and Windows this should always be null.
/// On Web it's recommended to provide a url via the file
@Riverpod(keepAlive: true)
class PRBBackendUrl extends _$PRBBackendUrl {
  @override
  Future<String?> build() async {
    // Static backend url is only supported on web.
    if (!kIsWeb) return null;

    final path = Assets.web.backendUrl;
    final value = await rootBundle.loadString(path).catchError((_) => '');
    return EString.trimToNull(value);
  }
}
