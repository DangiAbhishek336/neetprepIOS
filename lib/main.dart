import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'dart:io' show Platform;
import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      await FirebaseApi.initNotifications();
    }

    runApp(
      ChangeNotifierProvider(
        create: (context) => appState,
        child: MyApp(),
      ),
    );
  }, (error, stackTrace) {});
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // Platform messages are asynchronous, so we initialize in an async method.

  Locale? _locale;
  ThemeMode _themeMode =
      //ThemeMode.light;
      FlutterFlowTheme.themeMode;

  late Stream<BaseAuthUser> userStream;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  late final StreamSubscription<InternetConnectionStatus> listener;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);

    userStream = neetprepEssentialFirebaseUserStream()
      ..listen((user) {
        log('Auth State Changed: ${user?.loggedIn}');
        _appStateNotifier.setRedirectLocationIfUnset('/flutterWebView');

        _appStateNotifier.update(user);
      }).onError((error) {
        log('Auth State Error: $error');
      });

    jwtTokenStream.listen((_) {});
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeNotifier(
              FFAppState().isDarkMode ? ThemeMode.dark : ThemeMode.light),
        ),
      ],
      child: ScreenUtilInit(
        designSize: Size(size.width, size.height),
        child: Consumer<ThemeNotifier>(builder: (context, themeNotifier, _) {
          return MaterialApp.router(
            title: 'Neetprep',
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
      ),
    );
  }
}
