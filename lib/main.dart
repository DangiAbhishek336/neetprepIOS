import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'dart:io' show Platform;
import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/scheduler.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:neetprep_essential/firebase/firebase_push_notification.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:uni_links/uni_links.dart';
import 'auth/firebase_auth/firebase_user_provider.dart';
import 'auth/firebase_auth/auth_util.dart';

import 'backend/firebase/firebase_config.dart';
import 'components/theme_notifier/theme_notifier.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import '/flutter_flow/custom_functions.dart' as functions;

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}


void inAppNotificationShow(Map<String, dynamic> map) {
  print("inAppNotificationShow called = ${map.toString()}");
}

final bool testWithWorkManager = false;

@pragma('vm:entry-point')
void onKilledStateNotificationClickedHandler(Map<String, dynamic> map) async {
  print("onKilledStateNotificationClickedHandler called from headless task!");
  print("Notification Payload received: " + map.toString());
}

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    usePathUrlStrategy();
    await initFirebase();
    final appState = FFAppState(); // Initialize FFAppState
    await appState.initializePersistedState();
    GoRouter.optionURLReflectsImperativeAPIs = true;
    if (!kIsWeb) {
      await Firebase.initializeApp();
      await FirebaseApi.initNotifications();
    }
    if (kIsWeb) {
      CleverTapPlugin.init("884-767-6K7Z");
    }
    // if (!kIsWeb) {
    //   if (kIsWeb) {
    //     await FirebaseCrashlytics.instance
    //         .setCrashlyticsCollectionEnabled(false);
    //   } else {
    //     await FirebaseCrashlytics.instance
    //         .setCrashlyticsCollectionEnabled(true);
    //     FirebaseCrashlytics.instance.setUserIdentifier(currentUserUid);

    //     // Pass all uncaught "fatal" errors from the framework to Crashlytics
    //     FlutterError.onError =
    //         FirebaseCrashlytics.instance.recordFlutterFatalError;

    //     FlutterError.onError = (errorDetails) {
    //       FirebaseCrashlytics.instance.setUserIdentifier(currentUserUid);
    //       FirebaseCrashlytics.instance.setCustomKey('userID', currentUserUid);
    //       FirebaseCrashlytics.instance.log(errorDetails.toString());
    //       FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    //       FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    //     };
    //     // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    //     PlatformDispatcher.instance.onError = (error, stack) {
    //       FirebaseCrashlytics.instance.setUserIdentifier(currentUserUid);
    //       FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    //       return true;
    //     };
    //   }
    // }
    // if (!kIsWeb && !kDebugMode) {
    //   Isolate.current.addErrorListener(RawReceivePort((pair) async {
    //     FirebaseCrashlytics.instance.setUserIdentifier(currentUserUid);
    //     final List<dynamic> errorAndStacktrace = pair;
    //     await FirebaseCrashlytics.instance.recordError(
    //       errorAndStacktrace.first,
    //       errorAndStacktrace.last,
    //       fatal: true,
    //     );
    //   }).sendPort);
    // }

    runApp(
        ChangeNotifierProvider(create: (context) => appState, child: MyApp()));
  }, (error, stackTrace) {
    // FlutterError.onError = (errorDetails) {
    //   FirebaseCrashlytics.instance.log("Higgs-Boson detected! Bailing out");
    //   FirebaseCrashlytics.instance.setUserIdentifier(currentUserUid);
    //   FirebaseCrashlytics.instance.setCustomKey('userID', currentUserUid);
    //   FirebaseCrashlytics.instance.log(errorDetails.toString());
    //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    //   FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    // };
    // PlatformDispatcher.instance.onError = (error, stack) {
    //   FirebaseCrashlytics.instance.setUserIdentifier(currentUserUid);
    //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    //   return true;
    // };
  });

  // CleverTapPlugin.onKilledStateNotificationClicked(
  //     onKilledStateNotificationClickedHandler);
  // _clevertapPlugin = new CleverTapPlugin();
  // _clevertapPlugin
  //     .setCleverTapInAppNotificationShowHandler(inAppNotificationShow);
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  AppUpdateInfo? _updateInfo;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  bool _flexibleUpdateAvailable = false;

  // Platform messages are asynchronous, so we initialize in an async method.

  Locale? _locale;
  ThemeMode _themeMode =
      //ThemeMode.light;
      FlutterFlowTheme.themeMode;

  late Stream<BaseAuthUser> userStream;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  late final StreamSubscription<InternetConnectionStatus> listener;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  Future<void> startUpApiRequest() async {
    final response = await http.post(
      Uri.parse('${FFAppState().baseUrl}/startup_api'),
      headers: {
        'Authorization': 'Bearer ${FFAppState().subjectToken}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('Request successful');
      print(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  // Parse the link and navigate accordingly
  void _parseLink(String link) {
    log("inside parse link");
    Uri uri = Uri.parse(link);
    if (uri.pathSegments.isNotEmpty) {
      if (uri.pathSegments.first == 'orderpage') {
        String? courseIdInt = uri.queryParameters['courseIdInt'] ?? '';
        log("courseIdInt" + courseIdInt.toString());
        context.pushNamed(
          'OrderPage',
          queryParameters: {
            'courseId': functions.getBase64OfCourseId(courseIdInt).toString(),
            'courseIdInt': courseIdInt.toString(),
          },
        );
      } else if (uri.pathSegments.first == 'startTestPage') {
        String? testId = uri.queryParameters['testId'];
        String? courseIdInt = uri.queryParameters['courseIdInt'];

        context.goNamed(
          'StartTestPage',
          queryParameters: {
            'testId': functions.getBase64OfTestId(testId!),
            'courseIdInt': serializeParam(
              courseIdInt.toString(),
              ParamType.String,
            ),
          },
        );
      }
    }
  }

  void initDeepLink() async {
    try {
      // For app launch from background

      getInitialLink().then((link) {
        log(link.toString());
        if (link != null) {
          _parseLink(link);
        }
      });

      // For runtime deep link handling
      linkStream.listen((link) {
        log(link.toString());
        if (link != null) {
          _parseLink(link);
        }
      });
    } catch (e) {
      print('Error initializing deep link: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _appStateNotifier = AppStateNotifier.instance;
    print(FFAppState().userIdInt);
    print(functions.getBase64OfUserId(FFAppState().userIdInt));
    print(FFAppState().subjectToken);
    _router = createRouter(_appStateNotifier);
    userStream = neetprepEssentialFirebaseUserStream()
      ..listen((user) => _appStateNotifier.update(user));
    jwtTokenStream.listen((_) {});
    Future.delayed(
      Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
    InAppUpdate.checkForUpdate().then((updateInfo) {
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        InAppUpdate.performImmediateUpdate().then((appUpdateResult) {
          if (appUpdateResult == AppUpdateResult.success) {
            InAppUpdate.performImmediateUpdate();
          }
        });
      }
    });
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await ScreenProtector.preventScreenshotOn();
      //  await startUpApiRequest();
    });

    Future<void> initPlatformState() async {
      var deviceData = <String, dynamic>{};

      try {
        if (kIsWeb) {
          deviceData =
              _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
        } else {
          if (defaultTargetPlatform == TargetPlatform.android) {
            deviceData =
                _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
          } else if (defaultTargetPlatform == TargetPlatform.iOS) {
            deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
          } else {
            deviceData = {};
          }
        }
        deviceData['version'] = _packageInfo.version;
        deviceData['buildNumber'] = _packageInfo.buildNumber;
        FFAppState().deviceData = deviceData.toString();
      } on PlatformException {
        deviceData = <String, dynamic>{
          'Error:': 'Failed to get platform version.'
        };
      }

      if (!mounted) return;
    }

    Future<void> _initPackageInfo() async {
      final info = await PackageInfo.fromPlatform();
      setState(() {
        _packageInfo = info;
      });
    }

    _initPackageInfo();
    initPlatformState();
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  void setLocale(String language) {
    setState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
      });

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'device': build.device,
      'model': build.model,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
    };
  }

  Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
    return <String, dynamic>{
      'browserName': data.browserName.name,
      'appName': data.appName,
      'appVersion': data.appVersion,
      'userAgent': data.userAgent,
    };
  }

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeNotifier(
              FFAppState().isDarkMode ? ThemeMode.dark : ThemeMode.light),
        ),
      ],
      child: Consumer<ThemeNotifier>(builder: (context, themeNotifier, _) {
        return MaterialApp.router(
          title: 'neetprep essential',
          localizationsDelegates: [
            FFLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: _locale,
          supportedLocales: const [
            Locale('en'),
          ],
          theme: ThemeData(
            useMaterial3: false,
            brightness: Brightness.light,
            scrollbarTheme: ScrollbarThemeData(),
          ),
          darkTheme: ThemeData(
            useMaterial3: false,
            brightness: Brightness.dark,
            scrollbarTheme: ScrollbarThemeData(),
          ),
          themeMode: themeNotifier.value,
          routerConfig: _router,
        );
      }),
    );
  }
}
