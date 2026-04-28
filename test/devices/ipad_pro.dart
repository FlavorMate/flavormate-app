import 'package:flutter/material.dart';
import 'package:golden_screenshot/golden_screenshot.dart';

import 'device.dart';

Device iPadProM513InchBuilder(AssetBundle assets) => Device(
  label: 'iPad Pro M5 (13")',
  device: ScreenshotDevice(
    platform: TargetPlatform.iOS,
    resolution: const Size(3000, 2300),
    pixelRatio: 2,
    goldenSubFolder: 'ipad_pro_m5_13/',
    frameBuilder:
        ({
          required device,
          frameColors,
          required child,
        }) => _IPadFrame(device: device, assets: assets, child: child),
  ),
);

class _IPadFrame extends StatelessWidget {
  final ScreenshotDevice device;
  final ScreenshotFrameColors? frameColors;
  final AssetBundle assets;
  final Widget child;

  const _IPadFrame({
    required this.device,
    required this.assets,
    required this.child,
    this.frameColors,
  });

  double get pixelRatio => device.pixelRatio;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 3000 / pixelRatio,
      height: 2300 / pixelRatio,
      child: Stack(
        children: [
          Positioned(
            left: 124 / pixelRatio,
            top: 118 / pixelRatio,
            width: 2752 / pixelRatio,
            height: 2064 / pixelRatio,
            child: ClipRRect(
              borderRadius: .circular(16),
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: .new(2752 / pixelRatio, 64 / pixelRatio),
                  child: Image.asset(
                    Theme.brightnessOf(context) == .light
                        ? 'device_frames/iPad_topbar_light.png'
                        : 'device_frames/iPad_topbar_dark.png',
                    bundle: assets,
                  ),
                ),
                body: child,
              ),
            ),
          ),
          Image.asset(
            'device_frames/insert/iPad_Pro_M5_13.png',
            bundle: assets,
          ),
        ],
      ),
    );
  }
}
