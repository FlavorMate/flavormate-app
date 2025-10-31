import 'package:flavormate/core/apis/rest/p_dio_public.dart';
import 'package:flavormate/data/datasources/core/version_controller_api.dart';
import 'package:flavormate/data/models/core/version/version.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_compatibility.g.dart';

@riverpod
class PCompatibility extends _$PCompatibility {
  @override
  Future<VersionComparison> build() async {
    final clientInfo = await PackageInfo.fromPlatform();
    final clientVersion = Version.fromString(clientInfo.version);

    final dio = ref.watch(pDioPublicProvider);
    final client = VersionControllerApi(dio);

    final response = await client.getVersion();

    final serverVersion = Version.fromString(response.data!);

    /// if response is successful, cache the response
    if (ref.mounted) {
      ref.keepAlive();
    }

    return clientVersion.compare(serverVersion);
  }
}
