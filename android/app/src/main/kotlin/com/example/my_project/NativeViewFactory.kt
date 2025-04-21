package com.neetprep.ios
import android.content.Context
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class NativeViewFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context?, id: Int, creationParams: Any?): PlatformView {
        return NativeView(context!!, id, creationParams as Map<String?, Any?>?)
    }
}