import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_package_info.g.dart';

@riverpod
class PPackageInfo extends _$PPackageInfo {
  @override
  Future<PackageInfo> build() async {
    return await PackageInfo.fromPlatform();
  }
}
