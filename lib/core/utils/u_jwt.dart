import 'dart:convert';

import 'package:crypto/crypto.dart';

abstract class UJWT {
  static String hashToken(String token) {
    final bytes = utf8.encode(token);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
