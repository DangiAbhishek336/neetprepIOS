package com.neetprep.ios

import android.content.Context
import android.graphics.Color
import android.os.Build
import android.text.Html
import android.util.Base64
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.annotation.RequiresApi
import io.flutter.plugin.platform.PlatformView

import android.webkit.WebChromeClient
import android.webkit.WebResourceRequest
import android.webkit.WebView
import android.webkit.WebViewClient


@RequiresApi(Build.VERSION_CODES.N)
internal class NativeView(context: Context, id: Int, creationParams: Map<String?, Any?>?) : PlatformView {

    private val webView: WebView

    override fun getView(): View {
        return webView
    }

    override fun dispose() {}

    init {
        val isDarkMode = creationParams?.get("darkMode") as? Boolean ?: false
        webView = WebView(context)
        webView.settings.javaScriptEnabled = true
        if( isDarkMode ){
            webView.setBackgroundColor(Color.parseColor("#252525"))
        }
        else {
            webView.setBackgroundColor(Color.parseColor("#ffffff"))
        }

        webView.webViewClient = object : WebViewClient() {
            override fun shouldOverrideUrlLoading(view: WebView?, request: WebResourceRequest?): Boolean {
                view?.loadUrl(request?.url.toString())
                return true
            }
        }

        webView.isVerticalScrollBarEnabled = true
        webView.scrollBarStyle = WebView.SCROLLBARS_OUTSIDE_OVERLAY
        webView.isHorizontalScrollBarEnabled = true

        val htmlContent = creationParams?.get("html") as? String

        val darkModeCss = """
            <style>
            body {
                background-color: #252525;
                color: #ffffff;
            }
            </style>
        """.trimIndent()

        val newData = """
            <!DOCTYPE html>
            <html>
            <head>
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css" integrity="sha384-n8MVd4RsNIU0tAv4ct0nTaAbDJwPJzDEaqSD1odI+WdtXRGWt2kTvGFasHpSy3SV" crossorigin="anonymous">
                <script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js" integrity="sha384-XjKyOOlGwcjNTAIQHIpgOno0Hl1YQqzUOEleOLALmuqehneUG+vnGctmUb0ZY0l8" crossorigin="anonymous"></script>
                <script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/contrib/auto-render.min.js" integrity="sha384-+VBxd3r6XgURycqtZ117nYw44OOcIax56Z4dCRWbxyPt0Koah1uHoK0o4+/RRE05" crossorigin="anonymous" onload="renderMathInElement(document.body);"></script>
                <style>body { overflow: scroll; }</style>
                ${if (isDarkMode) darkModeCss else ""}
            </head>
            <body>${htmlContent ?: "<h1>Default Message (id: $id)</h1>"}</body>
            </html>
        """.trimIndent()

        val base64 = Base64.encodeToString(newData.toByteArray(), Base64.NO_PADDING)
        webView.loadData(base64, "text/html", "base64")
    }
}
