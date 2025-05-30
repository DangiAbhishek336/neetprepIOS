import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:neetprep_essential/pages/auth/login_page/login_page_widget.dart';

import 'package:neetprep_essential/pages/WebView/webview.dart';
import 'package:neetprep_essential/pages/webViewWithoutToken/webviewWithoutToken.dart';

import '../../auth/base_auth_user_provider.dart';

import '/index.dart';
import '/flutter_flow/flutter_flow_util.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;
  bool isFormCompeted = false;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  bool get loading => user == null;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect {
    final result = loggedIn && _redirectLocation != null;
    log('shouldRedirect: $result (loggedIn: $loggedIn, redirectLocation: $_redirectLocation)');
    return result;
  }

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(BaseAuthUser newUser) {
    final shouldUpdate =
        user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;

    log('Previous user UID: ${user?.uid}');
    log('New user UID: ${newUser.uid}');
    log('Should update: $shouldUpdate');
    log('Notify on auth change: $notifyOnAuthChange');

    initialUser ??= newUser;
    user = newUser;
    log('Updated user: ${user?.authUserInfo.displayName}');
    log('Updated loggedIn state: $loggedIn');

    if (notifyOnAuthChange && shouldUpdate) {
      log("Notifying listeners about auth change");
      notifyListeners();
    } else {
      log("Skipping notification - notifyOnAuthChange: $notifyOnAuthChange, shouldUpdate: $shouldUpdate");
    }

    updateNotifyOnAuthChange(true);
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      errorBuilder: (context, state) {
        log('Error: ${state.error}');
        log('Error logged in : ${appStateNotifier.loggedIn}');

        return appStateNotifier.loggedIn
            ? FlutterWebView(
                webUrl: 'https://www.neetprep.com/newui/study',
                title: 'Dashboard',
              )
            : LoginPageWidget();
      },
      routes: [
        FFRoute(
            name: '_initialize',
            path: '/',
            builder: (context, _) {
              if (appStateNotifier.loggedIn) {
                // Force navigation to web view
                Future.microtask(() => context.goNamed('flutterWebView',
                        pathParameters: {
                          'webUrl': 'https://www.neetprep.com/newui/study',
                          'title': 'Dashboard'
                        }));
                return Container(); // Temporary empty widget
              }
              return LoginPageWidget();
            }),
        FFRoute(
          name: 'ReportQuestionPage',
          path: '/reportQuestionPage',
          requireAuth: true,
          builder: (context, params) => ReportQuestionPageWidget(
            testId: params.getParam('testId', ParamType.String),
            questionId: params.getParam('questionId', ParamType.String),
          ),
        ),
        FFRoute(
          name: 'ReportQuestionSubmitPage',
          path: '/reportQuestionSubmitPage',
          requireAuth: true,
          builder: (context, params) => ReportQuestionSubmitPageWidget(
            testId: params.getParam('testId', ParamType.String),
            questionId: params.getParam('questionId', ParamType.String),
            typeId: params.getParam('typeId', ParamType.String),
            issueType: params.getParam('issueType', ParamType.String),
          ),
        ),
        FFRoute(
          name: 'LockPage',
          path: '/lockPage',
          requireAuth: true,
          builder: (context, params) => LockPageWidget(),
        ),
        FFRoute(
          name: 'about',
          path: '/about',
          builder: (context, params) => AboutWidget(),
        ),
        FFRoute(
          name: 'flutterWebView',
          path: '/flutterWebView',
          requireAuth: true,
          builder: (context, params) => FlutterWebView(
            webUrl: params.getParam('webUrl', ParamType.String) ??
                'https://www.neetprep.com/newui/study', // Default URL
            title: params.getParam('title', ParamType.String) ??
                'Dashboard', // Default title
          ),
        ),
        FFRoute(
          name: 'flutterWebViewWithoutAuthToken',
          path: '/flutterWebViewWithoutAuthToken',
          builder: (context, params) => FlutterWebViewWithoutToken(
              webUrl: params.getParam('webUrl', ParamType.String),
              title: params.getParam('title', ParamType.String)),
        ),
        FFRoute(
          name: 'LoginPage',
          path: '/loginPage',
          builder: (context, params) => LoginPageWidget(),
        ),
        FFRoute(
          name: 'CourseDetailPage24',
          path: '/courseDetailPage24',
          builder: (context, params) => CourseDetailPage24Widget(),
        ),
        FFRoute(
          name: 'LandingPage',
          path: '/landingPage',
          builder: (context, params) => LandingPageWidget(),
        ),
        FFRoute(
          name: 'AllCoursesPage',
          path: '/allCoursesPage',
          builder: (context, params) => AllCoursesPageWidget(),
        ),
        FFRoute(
          name: 'CourseDetailPage25',
          path: '/courseDetailPage25',
          builder: (context, params) => CourseDetailPage25Widget(),
        ),
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }

  void safePopForTests(String? courseIdInt) {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      if (courseIdInt == FFAppState().testCourseIdInt.toString())
        go('/createAndPreviewTestPage');
      else if (courseIdInt ==
          FFAppState().classroomTestCourseIdInt.toString()) {
        go('/classroomTestSeriesPage');
      } else if (courseIdInt == FFAppState().flashcardCourseIdInt.toString()) {
        go('/flashcardChapterWisePage');
      } else if (courseIdInt == FFAppState().assertionCourseIdInt.toString()) {
        go('/assertionChapterWisePage');
      }
    }
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => AppStateNotifier.instance;
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect
          ? null
          : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState.hasRedirect();
  void clearRedirectLocation() => appState.clearRedirectLocation();
  void setRedirectLocationIfUnset(String loc) {
    appState._redirectLocation ??= loc; // This line is missing
    appState.updateNotifyOnAuthChange(false);
  }
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.extraMap.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, [
    bool isList = false,
  ]) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (context, state) {
          log('Route $name - checking redirect');
          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            log('Redirecting to: $redirectLocation');
            appStateNotifier.clearRedirectLocation();
            return redirectLocation;
          }

          log("Route $name - requireAuth: $requireAuth, loggedIn: ${appStateNotifier.loggedIn}");

          if (requireAuth && !appStateNotifier.loggedIn) {
            final redirectUri = state.uri.toString();
            log('Setting redirect location to: $redirectUri');
            appStateNotifier.setRedirectLocationIfUnset(redirectUri);
            return '/loginPage';
          }
          return null;
        },
        pageBuilder: (context, state) {
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);

          log("page is $page");
          final child = page;
          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder: PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).transitionsBuilder,
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(
        hasTransition: true,
        transitionType: PageTransitionType.fade,
        duration: Duration(milliseconds: 300),
      );
}
