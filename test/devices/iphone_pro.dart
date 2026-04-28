import 'package:flutter/material.dart';
import 'package:golden_screenshot/golden_screenshot.dart';

import 'device.dart';

Device iPhone17ProBuilder(AssetBundle assets) => Device(
  label: 'iPhone 17 Pro',
  device: ScreenshotDevice(
    platform: TargetPlatform.iOS,
    resolution: const Size(1350, 2760),
    pixelRatio: 3,
    goldenSubFolder: 'iphone_17_pro/',
    frameBuilder:
        ({
          required device,
          frameColors,
          required child,
        }) => _IPhoneFrame(device: device, assets: assets, child: child),
  ),
);

class _IPhoneFrame extends StatelessWidget {
  final ScreenshotDevice device;
  final ScreenshotFrameColors? frameColors;
  final AssetBundle assets;
  final Widget child;

  const _IPhoneFrame({
    required this.device,
    required this.assets,
    required this.child,
    this.frameColors,
  });

  double get pixelRatio => device.pixelRatio;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1350 / pixelRatio,
      height: 2760 / pixelRatio,
      child: Stack(
        children: [
          Positioned(
            left: 72 / pixelRatio,
            top: 68 / pixelRatio,
            width: 1206 / pixelRatio,
            height: 2622 / pixelRatio,
            child: ClipRRect(
              borderRadius: .circular(64),
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: .new(1206 / pixelRatio, 192 / pixelRatio),
                  child: Image.asset(
                    Theme.brightnessOf(context) == .light
                        ? 'device_frames/iPhone_topbar_light.png'
                        : 'device_frames/iPhone_topbar_dark.png',
                    bundle: assets,
                  ),
                ),
                body: child,
              ),
            ),
          ),
          Image.asset(
            'device_frames/insert/iPhone_17_Pro.png',
            bundle: assets,
          ),
        ],
      ),
    );
  }
}
