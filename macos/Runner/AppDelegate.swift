import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  static let aliases = ["AppIcon", "Winter2025Icon"]

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  override func applicationDidFinishLaunching(_ notification: Notification) {
    registerIconPlugin()
  }

  func registerIconPlugin() {
    let controller = mainFlutterWindow?.contentViewController as! FlutterViewController
    let iconChannel = FlutterMethodChannel(
      name: "flavormate/icon", binaryMessenger: controller.engine.binaryMessenger)

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

      NSApplication.shared.applicationIconImage = NSImage(named: iconName!)
      NSWorkspace.shared.setIcon(
        NSImage(named: iconName!), forFile: Bundle.main.bundlePath, options: [])
    })
  }
}
