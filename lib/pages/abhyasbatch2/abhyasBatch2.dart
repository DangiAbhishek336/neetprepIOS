import 'dart:collection';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neetprep_essential/flutter_flow/flutter_flow_util.dart';
import 'package:neetprep_essential/pages/abhyasbatch2/abhyasBatch2InfoPage.dart';
import 'package:neetprep_essential/pages/flutter_webview/flutter_webview.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import '../../app_state.dart';
import '../../backend/api_requests/api_calls.dart';
import '../../clevertap/clevertap_service.dart';
import '../../components/drawer/darwer_widget.dart';
import '../../custom_code/actions/image_upload_s3.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/nav/serialization_util.dart';
import '../../utlis/text.dart';
import '../payment/order_page/order_page_widget.dart';

class AbhyasBatch2 extends StatefulWidget {
  const AbhyasBatch2({super.key});

  @override
  State<AbhyasBatch2> createState() => _AbhyasBatch2State();
}

class _AbhyasBatch2State extends State<AbhyasBatch2> {
  final GlobalKey webViewKey = GlobalKey();
  String idToken = FFAppState().subjectToken;


  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      javaScriptEnabled: true,
      transparentBackground: true,
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: true);

  late ContextMenu contextMenu;
  bool isLoading = true;
  bool isError = false;
  var apiResponse;
  String url = "";

  @override
  void initState() {
    super.initState();
    _initializeWebViewController();
    _fetchCourseAccess();
  }


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
      url: WebUri('${FFAppState().baseUrl}/newui/essential/customPageWiseTest/practiceSelection?courseId=4775&disable=home_btn&id_token=${FFAppState().subjectToken}'), // Set cookie for this URL
      name: "id_token", // Cookie name
      value: FFAppState().subjectToken, // The token to set
      domain: "www.neetprep.com", // The domain for the cookie
      isSecure: true, // Use secure if the domain is https
      isHttpOnly: true, // Cookie is only accessible via HTTP
    );
  }




  void _initializeWebViewController() {
    if(kIsWeb){
      _setTokenCookieSafely();
    }

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

  Future<void> _fetchCourseAccess() async {
    try {
      var response = await SignupGroup.loggedInUserInformationAndCourseAccessCheckingApiCall.call(
        authToken: FFAppState().subjectToken,
        courseIdInt: FFAppState().abhyas2CourseIdInt,
        altCourseIds: FFAppState().abhyas2CourseIdInts,
      );

      setState(() {
        apiResponse = response;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      print('API call failed: $error');
    }
  }

  bool _isDrawerOpen = false; // Tracks drawer's open/close state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(DrawerStrings.abhyasBatch2),
      onDrawerChanged: (isOpen) {
        setState(() {
          _isDrawerOpen = isOpen; // Update drawer state
        });
      },
      appBar: AppBar(
        iconTheme: IconThemeData(color: FlutterFlowTheme.of(context).accent1),
        elevation: 1.2,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        title: Text(
          'Custom Abhyas',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
            fontSize: 16.0,
            useGoogleFonts:
            GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (webViewController != null) {
            bool canGoBack = await webViewController!.canGoBack();
            if (canGoBack) {
              webViewController?.goBack();
              return false;
            }
          }
          return true;
        },
        child: isLoading
            ? Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              FlutterFlowTheme.of(context).primary,
            ),
          ),
        )
            : isError
            ? Center(
          child: Text('An error occurred. Please try again later.'),
        )
            : _buildContent(),
      ),
    );
  }

  Future<void> _injectJavaScriptForCookies(InAppWebViewController controller) async {
    String jsToInject = """
    document.cookie = 'id_token=${FFAppState().subjectToken}; domain=.neetprep.com; path=/; secure';
    console.log("Cookie injected: id_token=${FFAppState().subjectToken}");
  """;

    // Inject JavaScript to set the cookie
    await controller.evaluateJavascript(source: jsToInject);

    print("JavaScript for setting cookie injected");
  }

  Widget _buildContent() {
    // Determine content based on the API response
    final bool hasAccess = apiResponse?.jsonBody != null &&
        SignupGroup.loggedInUserInformationAndCourseAccessCheckingApiCall.courses(apiResponse.jsonBody).length > 0;

    if (hasAccess) {
      FirebaseAnalytics.instance.setCurrentScreen(screenName: "Abhyas2.0");
      CleverTapService.recordPageView("Abhyas2.0");
      return  Stack(
            children: [
              IgnorePointer(
                ignoring: _isDrawerOpen,
                child: InAppWebView(
                        key: webViewKey,
                        initialUrlRequest: URLRequest(
                url: WebUri(
                     '${FFAppState().baseUrl}/newui/essential/customPageWiseTest/practiceSelection?courseId=4775&disable=home_btn&id_token=${FFAppState().subjectToken}'),
                        ),
                        initialSettings: settings,
                        contextMenu: contextMenu,
                  onWebViewCreated: (controller) {
                          webViewController = controller;
                          webViewController?.addJavaScriptHandler(handlerName: 'uploadDocs', callback: (args) async{
                      // return data to the JavaScript side!

                      try {
                        String? filePath;
                        FilePickerResult? result = await FilePicker.platform.pickFiles();

                        if (result != null) {
                          // Get the selected file path
                          filePath = result.files.single.path;
                          PlatformFile file = result.files.single;
                          String res = await S3FileUploader().uploadFile(file,"profile-images");


                          if (res.isNotEmpty) {
                            return {
                              'file': res
                            };
                            // it will print: [1, true, [bar, 5], {foo: baz}, {bar: bar_value, baz: baz_value}]

                            setState(() {});
                          }
                        } else {
                          // User canceled the picker

                          return {
                            'file': null
                          };
                          print("No file selected");
                        }
                      } catch (e) {
                        print("Error picking file: $e");
                      }


                    });

                  },



                        onLoadStop: (controller, url) async{
                setState(() {
                  this.url = url.toString();
                });
                await _injectJavaScriptForCookies(controller);
                print("Cookies set after onLoadStop");
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
                    transparentBackground: true
                ),
                        ),
                        onPermissionRequest: (controller, request) async {
                return PermissionResponse(
                    resources: request.resources, action: PermissionResponseAction.GRANT);
                        },
                      ),
              ),
            ],
          );

    } else {
      return OrderPageWidget(
        courseId: serializeParam(
          FFAppState().courseId,
          ParamType.String,
        )??"",
        courseIdInt: serializeParam(
          FFAppState().courseIdInt.toString(),
          ParamType.String,
        )??"",
     );
    }
  }
}
