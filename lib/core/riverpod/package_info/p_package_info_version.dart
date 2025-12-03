import 'package:flavormate/core/riverpod/package_info/p_package_info.dart';
import 'package:flavormate/data/models/core/version/version.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_package_info_version.g.dart';

@riverpod
class PPackageInfoVersion extends _$PPackageInfoVersion {
  @override
  Future<Version> build() async {
    final pi = await ref.watch(pPackageInfoProvider.future);

    return Version.fromString(pi.version);
  }
}
