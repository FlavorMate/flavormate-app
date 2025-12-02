import 'package:flavormate/core/riverpod/package_info/p_package_info_version.dart';
import 'package:flavormate/data/models/core/version/version.dart';
import 'package:flavormate/data/repositories/core/server/p_server_version.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_server_compatibility.g.dart';

@riverpod
class PServerCompatibility extends _$PServerCompatibility {
  @override
  Future<VersionComparison> build() async {
    final clientVersion = await ref.watch(pPackageInfoVersionProvider.future);

    final serverVersion = await ref.watch(pServerVersionProvider.future);

    /// if response is successful, cache the response
    if (ref.mounted) {
      ref.keepAlive();
    }

    return clientVersion.compare(serverVersion);
  }
}
