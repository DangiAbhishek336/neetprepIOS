package com.neetprep.ios

import android.os.Bundle
import androidx.appcompat.app.AppCompatDelegate
import android.os.Build
import android.text.Html
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory("com.neetprep.ios/nativeview",
                NativeViewFactory()
            )

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "def").setMethodCallHandler { call, result ->
            when (call.method) {
                "setHtmlContent" -> {
                    val htmlContent = call.argument<String>("htmlContent")
                    if (htmlContent != null) {
                        // setHtmlContent(htmlContent)
                        Log.d("YourTag", "Received HTML content: $htmlContent")
                        result.success(true)
                    } else {
                        result.error("INVALID_ARGUMENT", "HTML content is null", null)
                    }
                }
                "setLauncherIcon" -> {
                    val isDarkMode = call.argument<Boolean>("isDarkMode") ?: false
                    if (isDarkMode) {
                        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_YES)
                    } else {
                        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO)
                    }
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }


    }

}