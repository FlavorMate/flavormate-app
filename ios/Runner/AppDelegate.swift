import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {

    static let aliases = ["AppIcon", "Winter2025Icon"]

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        registerIconPlugin()

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
        //GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    }

    func registerIconPlugin() {
        GeneratedPluginRegistrant.register(with: self)
        let registry = self.registrar(forPlugin: "flavormate.icon")
        let iconChannel = FlutterMethodChannel(
            name: "flavormate/icon", binaryMessenger: registry!.messenger())

        iconChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: FlutterResult) -> Void in

            guard call.method == "changeIcon" else {
                result(false)
                return
            }

            let args = call.arguments as? [String: Any]
            let iconName = args?["iconName"] as? String

            guard iconName != nil && AppDelegate.aliases.contains(iconName!) else {
                result(false)
                return
            }

            let icon = (iconName! == "AppIcon") ? nil : iconName!

            print(icon)

            UIApplication.shared.setAlternateIconName(icon)
            result(true)
        })
    }
}
