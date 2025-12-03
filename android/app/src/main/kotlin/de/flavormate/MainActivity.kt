package de.flavormate

import android.content.ComponentName
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    val aliases = listOf("AppIcon", "Winter2025Icon")

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        registerIconPlugin(flutterEngine)
    }

    fun registerIconPlugin(flutterEngine: FlutterEngine) {
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "flavormate/icon"
        ).setMethodCallHandler { call: MethodCall?, result: MethodChannel.Result? ->
                if (call!!.method != "changeIcon") {
                    result!!.notImplemented()
                    return@setMethodCallHandler
                }

                val iconName = call.argument<String?>("iconName")

                if (iconName == null || !aliases.contains(iconName)) {
                    result!!.error("404", "Unknown icon", null)
                    return@setMethodCallHandler
                }

                changeAppIcon(iconName)
                result!!.success(null)
            }
    }

    fun changeAppIcon(newIcon: String) {
        val pm = packageManager

        for (alias in aliases) {
            val enabled = if (alias == newIcon) PackageManager.COMPONENT_ENABLED_STATE_ENABLED
            else PackageManager.COMPONENT_ENABLED_STATE_DISABLED

            pm.setComponentEnabledSetting(
                ComponentName(this, "$packageName.$alias"), enabled, PackageManager.DONT_KILL_APP
            )
        }
    }
}
