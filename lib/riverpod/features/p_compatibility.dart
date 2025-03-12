import 'package:flavormate/models/version/version.dart';
import 'package:flavormate/riverpod/features/p_features.dart';
import 'package:flavormate/riverpod/package_info/p_package_info.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_compatibility.g.dart';

@riverpod
class PCompatibility extends _$PCompatibility {
  @override
  Future<VersionComparison> build() async {
    final serverInfo = await ref.watch(
      pFeaturesProvider.selectAsync((data) => data),
    );

    final clientInfo = await ref.watch(
      pPackageInfoProvider.selectAsync((data) => data),
    );

    final serverVersion = Version.fromString(serverInfo.version);
    final clientVersion = Version.fromString(clientInfo.version);

    return clientVersion.compare(serverVersion);
  }
}
