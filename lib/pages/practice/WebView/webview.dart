import 'dart:async';
import 'dart:collection';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neetprep_essential/app_state.dart';
import 'package:neetprep_essential/components/drawer/darwer_widget.dart';
import 'package:neetprep_essential/components/theme_notifier/theme_notifier.dart';
import 'package:neetprep_essential/flutter_flow/flutter_flow_icon_button.dart';
import 'package:neetprep_essential/flutter_flow/flutter_flow_theme.dart';
import 'package:neetprep_essential/flutter_flow/flutter_flow_util.dart';
import 'package:neetprep_essential/utlis/text.dart';
import 'package:provider/provider.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart' show Factory, kIsWeb;
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart'
    as Android;
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

// #enddocregion platform_imports

class FlutterWebView extends StatefulWidget {
  final String webUrl;
  final String title;
  const FlutterWebView({required this.webUrl, required this.title});

  @override
  State<FlutterWebView> createState() => _FlutterWebViewState();
}

class _FlutterWebViewState extends State<FlutterWebView> {
  ///web

  final GlobalKey webViewKey = GlobalKey();
  // final cookieManager = WebviewCookieManager();
  String idToken = FFAppState().subjectToken; // Your id_token value here

  ///

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      javaScriptEnabled: true,
      sharedCookiesEnabled: true,
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: true);

  late ContextMenu contextMenu;
  String url = "";
  bool isAttemptResetApiSucceeded = false;
  final urlController = TextEditingController();
  bool haveAccess = false;
  bool kisweb = false;
  bool show = false;
  String questionStr = "";
  bool optionSelected = false;
  bool isBookmarked = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _setCookie(InAppWebViewController controller) async {
    // Ensure you're setting cookies on the correct domain
    await CookieManager.instance().setCookie(
      url: WebUri("https://neetprep.com"), // Ensure the domain is correct
      name: 'id_token',
      value: '${FFAppState().subjectToken}',
      domain: ".neetprep.com", // Use domain with subdomain
      isHttpOnly: false,
      isSecure: true,
    );

    print("Cookie added: id_token = ${FFAppState().subjectToken}");
    List<Cookie> cookies = await CookieManager.instance()
        .getCookies(url: WebUri("https://neetprep.com"));
    print("Cookies after setting: $cookies");
  }

  ///

  ///Android

  late final WebViewController _controller;

  // Function to call setTokenCookie inside try-catch
  Future<void> _setTokenCookieSafely() async {
    try {
      await setTokenCookie();
      print('Token cookie set successfully');
    } catch (e) {
      print('Failed to set token cookie: $e');
    }
  }

  // Function to set the token in the cookies
  Future<void> setTokenCookie() async {
    final cookieManager = CookieManager.instance();

    await cookieManager.setCookie(
      url: WebUri(widget.webUrl), // Set cookie for this URL
      name: "id_token", // Cookie name
      value: FFAppState().subjectToken, // The token to set
      domain: "www.neetprep.com", // The domain for the cookie
      isSecure: true, // Use secure if the domain is https
      isHttpOnly: true, // Cookie is only accessible via HTTP
    );
  }

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _setTokenCookieSafely();
    }

    print("${widget.webUrl}?id_token=${FFAppState().subjectToken}");
    if (!kIsWeb) {
      WebViewCookieManager().clearCookies();
      WebViewCookieManager().setCookie(
        WebViewCookie(
          name: 'id_token',
          value: '${FFAppState().subjectToken}',
          domain: 'www.neetprep.com',
        ),
      );
      late final PlatformWebViewControllerCreationParams params;
      if (WebViewPlatform.instance is WebKitWebViewPlatform) {
        params = WebKitWebViewControllerCreationParams(
          allowsInlineMediaPlayback: true,
          mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
        );
      } else {
        params = const PlatformWebViewControllerCreationParams();
      }

      final WebViewController controller =
          WebViewController.fromPlatformCreationParams(params);
      // #enddocregion platform_features

      controller
          .runJavaScript("document.body.style.backgroundColor = '#${000000}';");

      controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Color(0xffffffff))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              debugPrint('WebView is loading (progress : $progress%)');
            },
            onPageStarted: (String url) {
              debugPrint('Page started loading: $url');
            },
            onPageFinished: (String url) {
              debugPrint('Page finished loading: $url');
            },
            onWebResourceError: (Android.WebResourceError error) {
              debugPrint('''
            Page resource error:
            code: ${error.errorCode}
            description: ${error.description}s
            errorType: ${error.errorType}
            isForMainFrame: ${error.isForMainFrame}
          ''');
            },
          ),
        )
        ..addJavaScriptChannel(
          'Toaster',
          onMessageReceived: (JavaScriptMessage message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message.message)),
            );
          },
        )
        ..loadRequest(
          Uri.parse('${widget.webUrl}&id_token=${FFAppState().subjectToken}'),
          // '  FFAppState().baseUrl/ncert-book?embed=1&id_token=${Uri.encodeComponent(FFAppState().subjectToken)}&android=${kIsWeb ? 0 : 1}'),
        );

      // #docregion platform_features
      if (controller.platform is AndroidWebViewController) {
        AndroidWebViewController.enableDebugging(true);
        (controller.platform as AndroidWebViewController)
            .setMediaPlaybackRequiresUserGesture(false);
      }
      // #enddocregion platform_features

      _controller = controller;
    } else {
      print("making context");
      contextMenu = ContextMenu(
          menuItems: [
            ContextMenuItem(
                id: 1,
                title: "Special",
                action: () async {
                  print("Menu item Special clicked!");
                  print(await webViewController?.getSelectedText());
                  await webViewController?.clearFocus();
                })
          ],
          settings:
              ContextMenuSettings(hideDefaultSystemContextMenuItems: false),
          onCreateContextMenu: (hitTestResult) async {
            print("onCreateContextMenu");
            print(hitTestResult.extra);
            print(await webViewController?.getSelectedText());
          },
          onHideContextMenu: () {
            print("onHideContextMenu");
          },
          onContextMenuActionItemClicked: (contextMenuItemClicked) async {
            var id = contextMenuItemClicked.id;
            print("onContextMenuActionItemClicked: " +
                id.toString() +
                " " +
                contextMenuItemClicked.title);
          });

      // if (kIsWeb) {
      //   html.window.onMessage.listen((event) async {
      //     try {
      //       var datum = event.data;
      //       print("Received snapshot.data: $datum");
      //
      //       // Assuming that snapshot.data is already in JSON format
      //       final Map<String, dynamic> maps = jsonDecode(datum);
      //
      //       maps.forEach((key, value) async {
      //         print('$key: $value');
      //         if (!show) {
      //           show = true;
      //           setState(() {});
      //         }
      //       });
      //     } catch (e) {
      //       print("Error processing snapshot.data: $e");
      //     }
      //   });
      // }
    }
  }

  CookieManager cookie = CookieManager.instance();

  Future<void> _injectJavaScriptForCookies(
      InAppWebViewController controller) async {
    String jsToInject = """
    document.cookie = 'id_token=${FFAppState().subjectToken};domain=.neetprep.com;path=/;SameSite=None;secure';
    console.log("Cookie injected: id_token=${FFAppState().subjectToken}");
  """;

    // Inject JavaScript to set the cookie
    await controller.evaluateJavascript(source: jsToInject);

    print("JavaScript for setting cookie injected");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(builder: (context, themeNotifier, child) {
      return Scaffold(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          key: _scaffoldKey,
          drawer: DrawerWidget(DrawerStrings.abhyasBatch),
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            automaticallyImplyLeading: false,
            title: Align(
              alignment: AlignmentDirectional(-0.35, 0.2),
              child: Text(
                widget.title,
                textAlign: TextAlign.start,
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      fontFamily:
                          FlutterFlowTheme.of(context).headlineMediumFamily,
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context).headlineMediumFamily),
                    ),
              ),
            ),
            leading: Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu,
                    color: FlutterFlowTheme.of(context).primaryText),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            actions: [],
            centerTitle: false,
            elevation: 1.0,
          ),
          body: kIsWeb
              ? Container(
                  height: 500,
                  width: 500,
                  child: InAppWebView(
                    key: webViewKey,
                    initialUrlRequest: URLRequest(
                      url: WebUri(
                          '${widget.webUrl}&id_token=${FFAppState().subjectToken}'),
                    ),
                    initialUserScripts: UnmodifiableListView<UserScript>([]),
                    initialSettings: settings,
                    contextMenu: contextMenu,
                    onWebViewCreated: (controller) async {
                      webViewController = controller;
                      // Inject the JavaScript to set the cookies
                      await _injectJavaScriptForCookies(controller);
                    },
                    onLoadStart: (controller, url) async {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    onLoadStop: (controller, url) async {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });

                      await controller.injectJavascriptFileFromUrl(
                          urlFile: WebUri(
                              'https://code.jquery.com/jquery-3.3.1.min.js'),
                          scriptHtmlTagAttributes: ScriptHtmlTagAttributes(
                              id: 'jquery',
                              onLoad: () {
                                print("jQuery loaded and ready to be used!");
                              },
                              onError: () {
                                print(
                                    "jQuery not available! Some error occurred.");
                              }));

                      // Ensure the JavaScript is injected after the page loads
                      await _injectJavaScriptForCookies(controller);
                      print("Cookies set after onLoadStop");
                    },
                    onPermissionRequest: (controller, request) async {
                      return PermissionResponse(
                          resources: request.resources,
                          action: PermissionResponseAction.GRANT);
                    },
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
                      var uri = navigationAction.request.url!;
                      return NavigationActionPolicy.ALLOW;
                    },
                    initialOptions: InAppWebViewGroupOptions(
                      ios: IOSInAppWebViewOptions(
                        sharedCookiesEnabled: true,
                      ),
                      android: AndroidInAppWebViewOptions(
                        useHybridComposition: true,
                      ),
                      crossPlatform: InAppWebViewOptions(
                        javaScriptEnabled: true,
                        supportZoom: false,
                      ),
                    ),
                    onReceivedError: (controller, request, error) {
                      print('Error: ${error.description}');
                    },
                    onConsoleMessage: (controller, consoleMessage) {
                      print('Console Message: ${consoleMessage.message}');
                    },
                  ),
                )
              : SizedBox(
                  child: WebViewWidget(
                    controller: _controller,
                  ),
                ));
    });
  }
}
