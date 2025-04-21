import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neetprep_essential/flutter_flow/flutter_flow_icon_button.dart';
import 'package:neetprep_essential/flutter_flow/flutter_flow_theme.dart';
import 'package:neetprep_essential/flutter_flow/flutter_flow_util.dart';

import '../../clevertap/clevertap_service.dart';
import '../../custom_code/actions/image_upload_s3.dart';

class FlutterWebView extends StatefulWidget {

  final String webUrl;
  final String title;
  const FlutterWebView({super.key,required this.webUrl, required this.title});

  @override
  State<FlutterWebView> createState() => _FlutterWebViewState();
}

class _FlutterWebViewState extends State<FlutterWebView> {
  ///web

  final GlobalKey webViewKey = GlobalKey();

  String idToken = FFAppState().subjectToken;


  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      userAgent: kIsWeb? "Essential/web-221":Platform.isIOS?"Essential/ios-221" :"Essential/android-221",
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      javaScriptEnabled: true,
      iframeAllow: "camera; microphone",
      transparentBackground: true,
      defaultFixedFontSize: 15,
      iframeAllowFullscreen: true);
  late ContextMenu contextMenu;
  String url = "";
  final urlController = TextEditingController();

  // Function to set the token in the cookies
  Future<void> setTokenCookie() async {
    final cookieManager = CookieManager.instance();

    await cookieManager.setCookie(
      url: WebUri(widget.webUrl),
      // Set cookie for this URL
      name: "id_token",
      // Cookie name
      value: FFAppState().subjectToken,
      // The token to set
      domain: "www.neetprep.com",
      // The domain for the cookie
      isSecure: true,
      // Use secure if the domain is https
      isHttpOnly: true, // Cookie is only accessible via HTTP
    );
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await FirebaseAnalytics.instance.logEvent(
        name: 'FlutterWebview',
        parameters: {
          'webUrl': widget.webUrl,
          'title': widget.title,
        },
      );

      CleverTapService.recordEvent("Flutter WebView Opened",
          {"webUrl": widget.webUrl, "title": widget.title});
    });
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
        settings: ContextMenuSettings(hideDefaultSystemContextMenuItems: false),
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
  }

  CookieManager cookie = CookieManager.instance();

  Future<void> _injectJavaScriptForCookies(
      InAppWebViewController controller) async {
    String jsToInject = """
    document.cookie = 'id_token=${FFAppState().subjectToken}; domain=.neetprep.com; path=/; secure';
    console.log("Cookie injected: id_token=${FFAppState().subjectToken}");
  """;

    await controller.evaluateJavascript(source: jsToInject);
    print("JavaScript for setting cookie injected");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24.0,
            ),
            onPressed: () async {
              print("hellooo");
              Navigator.pop(context);
            },
          ),
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
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: InAppWebView(
          key: webViewKey,
          initialUrlRequest: URLRequest(
            url: WebUri(
                '${widget.webUrl}&id_token=${FFAppState().subjectToken}'),
          ),
          initialUserScripts: UnmodifiableListView<UserScript>([]),
          initialSettings: settings,
          contextMenu: contextMenu,
          onWebViewCreated: (controller) {
            webViewController = controller;
            webViewController!.addJavaScriptHandler(
                handlerName: 'uploadDocs',
                callback: (args) async {
                  // return data to the JavaScript side!

                  try {
                    String? filePath;
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();

                    if (result != null) {
                      // Get the selected file path
                      filePath = result.files.single.path;
                      PlatformFile file = result.files.single;
                      String res = await S3FileUploader()
                          .uploadFile(file, "profile-images");

                      if (res.isNotEmpty) {
                        return {'file': res};
                        // it will print: [1, true, [bar, 5], {foo: baz}, {bar: bar_value, baz: baz_value}]

                        setState(() {});
                      }
                    } else {
                      // User canceled the picker

                      return {'file': null};
                      print("No file selected");
                    }
                  } catch (e) {
                    print("Error picking file: $e");
                  }
                });

            webViewController!.addJavaScriptHandler(
                handlerName: 'otpVerified',
                callback: (args) {
                  print(args);
                  if (args[0] == true) {
                    print("i am inside");
                    context.pop();
                    Navigator.pop(context);
                  }
                  // it will print: [1, true, [bar, 5], {foo: baz}, {bar: bar_value, baz: baz_value}]
                });
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
            // Ensure the JavaScript is injected after the page loads
            await _injectJavaScriptForCookies(controller);
            print("Cookies set after onLoadStop");
          },
          onPermissionRequest: (controller, request) async {
            return PermissionResponse(
                resources: request.resources,
                action: PermissionResponseAction.GRANT);
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
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
                transparentBackground: true),
          ),
          onReceivedError: (controller, request, error) {
            print('Error: ${error.description}');
          },
          onConsoleMessage: (controller, consoleMessage) {
            print('Console Message: ${consoleMessage.message}');
          },
        ));
  }
}
