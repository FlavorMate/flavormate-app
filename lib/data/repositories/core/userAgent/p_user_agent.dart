import 'package:device_info_plus/device_info_plus.dart';
import 'package:flavormate/core/riverpod/device_info/p_device_info.dart';
import 'package:flavormate/core/riverpod/package_info/p_package_info_version.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_user_agent.g.dart';

/// Created an user-agent in the following form:
/// FlavorMate/AppVersion (Device; OS)
/// e.g. FlavorMate/3.0.0 (iPhone 14; iOS 15.4.1)
@riverpod
class PUserAgent extends _$PUserAgent {
  @override
  Future<String?> build() async {
    final pi = await ref.watch(pDeviceInfoProvider.future);
    final appVersion = await ref.watch(pPackageInfoVersionProvider.future);

    var device = '';
    var os = '';

    if (pi is MacOsDeviceInfo) {
      device = pi.modelName;
      os = 'macOS ${pi.majorVersion}.${pi.minorVersion}';
    } else if (pi is IosDeviceInfo) {
      device = pi.name;
      os = '${pi.systemName} ${pi.systemVersion}';
    } else if (pi is AndroidDeviceInfo) {
      device = pi.model;
      os = 'Android ${pi.version.release}';
    } else if (pi is WebBrowserInfo) {
      device = pi.browserName.name;
      os = pi.productSub ?? '-';
    } else if (pi is WindowsDeviceInfo) {
      device = 'Windows PC';
      os = '${pi.productName} (${pi.displayVersion})';
    } else {
      return null;
    }

    return 'FlavorMate/${appVersion.toString()} ($device; $os)';
  }
}
