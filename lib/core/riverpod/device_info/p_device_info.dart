import 'package:device_info_plus/device_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_device_info.g.dart';

@Riverpod(keepAlive: true)
class PDeviceInfo extends _$PDeviceInfo {
  @override
  Future<BaseDeviceInfo> build() async {
    return await DeviceInfoPlugin().deviceInfo;
  }
}
