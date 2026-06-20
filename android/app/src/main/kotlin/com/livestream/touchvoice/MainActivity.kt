package com.livestream.touchvoice

import android.content.Context
import android.view.WindowManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "com.livestream.touchvoice/context_channel"
    private val WAKELOCK_CHANNEL = "com.livestream.touchvoice/wakelock"
    private var flutterContext: Context? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "passContext") {
                    val context = call.argument<Context>("context")
                    if (context != null) {
                        flutterContext = context
                        registerNativeAdFactories(flutterEngine)
                        result.success(true)
                    } else {
                        result.error("CONTEXT_ERROR", "Failed to receive context from Flutter.", null)
                    }
                } else {
                    result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, WAKELOCK_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "enable" -> {
                        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                        result.success(null)
                    }
                    "disable" -> {
                        window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun registerNativeAdFactories(flutterEngine: FlutterEngine) {
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine, "listTile", ListTileNativeAdFactory(flutterContext!!)
        )

        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine, "gridTile", GridTileNativeAdFactory(flutterContext!!)
        )
    }
}
