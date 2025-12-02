import 'package:flavormate/core/apis/rest/p_dio_public.dart';
import 'package:flavormate/data/datasources/core/version_controller_api.dart';
import 'package:flavormate/data/models/core/version/version.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_server_version.g.dart';

@riverpod
class PServerVersion extends _$PServerVersion {
  @override
  Future<Version> build() async {
    final dio = ref.watch(pDioPublicProvider);
    final client = VersionControllerApi(dio);

    final response = await client.getVersion();

    return Version.fromString(response.data!);
  }
}
