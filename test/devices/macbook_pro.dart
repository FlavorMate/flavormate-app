import 'package:flutter/material.dart';
import 'package:golden_screenshot/golden_screenshot.dart';

import 'device.dart';

Device macBookProM516InchBuilder(AssetBundle assets) => Device(
  label: 'macBook Pro M5 (16")',
  device: ScreenshotDevice(
    platform: TargetPlatform.macOS,
    resolution: const Size(4260, 2840),
    pixelRatio: 2,
    goldenSubFolder: 'macBook_pro_m5_16/',
    frameBuilder:
        ({
          required device,
          frameColors,
          required child,
        }) => _MacBookFrame(device: device, assets: assets, child: child),
  ),
);

class _MacBookFrame extends StatelessWidget {
  final ScreenshotDevice device;
  final ScreenshotFrameColors? frameColors;
  final AssetBundle assets;
  final Widget child;

  const _MacBookFrame({
    required this.device,
    required this.assets,
    required this.child,
    this.frameColors,
  });

  double get pixelRatio => device.pixelRatio;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 4260 / pixelRatio,
      height: 2840 / pixelRatio,
      child: Stack(
        children: [
          Positioned(
            left: 402 / pixelRatio,
            top: 303 / pixelRatio,
            width: 3456 / pixelRatio,
            height: 2234 / pixelRatio,
            child: ClipRRect(
              borderRadius: .circular(16),
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: .new(3456 / pixelRatio, 64 / pixelRatio),
                  child: const SizedBox.expand(),
                ),
                body: child,
              ),
            ),
          ),
          Image.asset(
            'device_frames/insert/macBook_pro_M5_16.png',
            bundle: assets,
          ),
        ],
      ),
    );
  }
}
