import 'dart:convert';

import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/data/datasources/extensions/bring_controller_api.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_bring.g.dart';

@Riverpod(keepAlive: false)
class PBring extends _$PBring {
  @override
  Future<Uri?> build(String recipeId) async {
    try {
      final dio = ref.watch(pDioPrivateProvider);

      final client = BringControllerApi(dio);

      final response = await client.postBringUrl(recipeId: recipeId);

      // TODO: handle this case
      if (response.hasError) return null;

      final deepLink = await http.post(
        Uri.parse('https://api.getbring.com/rest/bringrecipes/deeplink'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'url': response.data,
          'source': 'app',
        }),
      );

      final url = jsonDecode(deepLink.body)['deeplink'];

      final uri = Uri.parse(url);

      return uri;
    } catch (_) {
      return null;
    }
  }
}
