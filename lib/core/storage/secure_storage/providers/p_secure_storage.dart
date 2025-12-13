import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'p_secure_storage.g.dart';

@Riverpod(keepAlive: true)
class PSecureStorage extends _$PSecureStorage {
  @override
  FlutterSecureStorage build() {
    return const FlutterSecureStorage();
  }
}
