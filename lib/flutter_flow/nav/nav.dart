import 'dart:async';

import 'package:flutter/material.dart';
import 'package:neetprep_essential/flutter_flow/flutter_flow_theme.dart';
import 'package:neetprep_essential/pages/abhyasbatch2/abhyasBatch2InfoPage.dart';
import 'package:neetprep_essential/pages/create_test/classroom_test_series_page/classroom_test_series_page_widget.dart';
import 'package:neetprep_essential/pages/create_test/classroom_test_series_page/promotion_page_widget.dart';
import 'package:neetprep_essential/pages/create_test/classroom_test_series_page/thankyou_page_with_center_widget.dart';
import 'package:neetprep_essential/pages/flashcard/flashcard_chapter_wise_page/flashcard_chapter_wise_page_widget.dart';
import 'package:neetprep_essential/pages/flashcard/flashcard_deck_page/flashcard_deck_page_widget.dart';
import 'package:neetprep_essential/pages/flashcard/flashcard_page/flashcard_page_widget.dart';
import 'package:neetprep_essential/pages/flutter_webview/flutter_webview.dart';
import 'package:neetprep_essential/pages/ncert_annotation/ncert_annotation.dart';
import 'package:neetprep_essential/pages/payment/order_page/book_purchase_form.dart';
import 'package:neetprep_essential/pages/practice/assertion_chapter_wise_page/assertion_chapter_wise_page_widget.dart';
import 'package:neetprep_essential/pages/starmarkedQs/StarmarkQuestionPage/starmarkedQuestionPagewidget.dart';
import 'package:neetprep_essential/pages/starmarkedQs/starmarkedChapterWisePage/starmarkedChapterWisePageWidget.dart';
import 'package:neetprep_essential/pages/starmarkedQs/starmarkedSearchPage/starmarkedSearchPagewidget.dart';
import 'package:neetprep_essential/pages/user_info_form/user_form/user_info_form_widget.dart';

import '../../auth/base_auth_user_provider.dart';

import '../../pages/abhyasbatch2/abhyasBatch2.dart';
import '../../pages/bookmarkedQs/bookmarked_chapter_wise_page/bookmarked_chapter_wise_page_widget.dart';
import '../../pages/bookmarkedQs/bookmarked_questions_page/bookmark_questions_page_widget.dart';
import '../../pages/bookmarkedQs/bookmarked_search_page/bookmarked_search_page_widget.dart';
import '../../pages/create_test/classroom_test_series_page/personal_details_page_widget.dart';
import '../../pages/create_test/classroom_test_series_page/thankyou_page_widget.dart';
import '../../pages/flashcard/flashcard_question_page/flashcard_question_page_widget.dart';
import '../../pages/flashcard/flashcard_search_page/flashcard_search_page_widget.dart';
import '../../pages/practice/assertion_search_page/assertion_search_page_widget.dart';
import '../../pages/practice/essential_chapter_wise_page/essential_chapter_wise_page_widget.dart';
import '../../pages/practice/essential_search_page/essential_search_page_widget.dart';
import '../../pages/practice/hardestqs_chapter_wise_page/hardestqs_chapter_page_widget.dart';
import '../../pages/practice/practice_chapter_wise_page/practice_chapter_page_widget.dart';
import '../../pages/practice_log/practice_log.dart';
import '../../pages/user_info_form/form_completion_handler/form_completion_handler_widget.dart';
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

  bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

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
    initialUser ??= newUser;
    user = newUser;
    // Refresh the app on auth change unless explicitly marked otherwise.
    // No need to update unless the user has changed.
    if (notifyOnAuthChange && shouldUpdate) {
      notifyListeners();
    }
    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,


      errorBuilder: (context, state) => appStateNotifier.loggedIn
          ? PracticeChapterPageWidget()
          : LoginPageWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => appStateNotifier.loggedIn
              ? PracticeChapterPageWidget()
              : LoginPageWidget(),
        ),
        FFRoute(
          name: 'BookmarkedChapterWisePage',
          path: '/bookmarkedChapterWisePage',
          builder: (context, params) => BookmarkedChapterWisePageWidget(),
        ),
        FFRoute(
          name: 'HardestQsChapterPageWidget',
          path: '/hardestQsChapterPageWidget',
          builder: (context, params) => HardestQsChapterPageWidget(),
        ),
        FFRoute(
          name: 'StarmarkedChapterWisePage',
          path: '/starmarkedChapterWisePage',
          builder: (context, params) => StarmarkedChapterWisePageWidget(),
        ),
        FFRoute(
          name: 'EssentialChapterWisePage',
          path: '/essentialChapterWisePage',
          builder: (context, params) => EssentialChapterWisePageWidget(),
        ),
        FFRoute(
          name: 'StarmarkQuestionsPage',
          path: '/StarmarkQuestionsPage',
          builder: (context, params) => StarmarkedQuestionsPageWidget(
            chapterId: params.getParam('chapterId', ParamType.String),
            topicName: params.getParam('topicName', ParamType.String),
            count: params.getParam('count', ParamType.int)
          ),
        ),
        FFRoute(
          name: 'BookmarkQuestionsPage',
          path: '/BookmarkQuestionsPage',
          builder: (context, params) => BookmarkedQuestionsPageWidget(
            chapterId: params.getParam('chapterId', ParamType.String),
            topicName: params.getParam('topicName', ParamType.String),
            courseId: params.getParam('courseId', ParamType.String),
            count: params.getParam('count', ParamType.int)
          ),
        ),

        FFRoute(
          name: 'StarmarkedSearchPage',
          path: '/starmarkedSearchPage',
          builder: (context, params) => StarmarkedSearchPageWidget(),
        ),
        FFRoute(
          name: 'BookmarkedSearchPage',
          path: '/bookmarkedSearchPage',
          builder: (context, params) => BookmarkedSearchPageWidget(),
        ),
        FFRoute(
          name: 'FormCompletionHandler',
          path: '/formCompletionHandler',
          requireAuth: true,
          builder: (context, params) => FormCompletionHandler(),
        ),
        FFRoute(
          name: 'PracticeQuetionsPage',
          path: '/practiceQuetionsPage',
          requireAuth: true,
          builder: (context, params) => PracticeQuetionsPageWidget(
            testId: params.getParam('testId', ParamType.String),
            offset: params.getParam('offset', ParamType.int),
            numberOfQuestions: params.getParam('numberOfQuestions', ParamType.int),
            sectionPointer: params.getParam('sectionPointer', ParamType.int),
            chapterName: params.getParam('chapterName', ParamType.String),
            courseIdInt: params.getParam('courseIdInt', ParamType.int),
          ),
        ),
        FFRoute(
          name: 'FlashcardPage',
          path: '/flashcardPage',
          requireAuth: true,
          builder: (context, params) => FlashcardPageWidget(
            deckName:params.getParam('deckName', ParamType.String),
            deckId: params.getParam('deckId', ParamType.String),
            offset: params.getParam('offset', ParamType.int),
            numberOfQuestions:
            params.getParam('numberOfQuestions', ParamType.int),
            sectionPointer: params.getParam('sectionPointer', ParamType.int),
          ),
        ),
        FFRoute(
          name: 'PracticeLog',
          path: '/practiceLog',
          requireAuth: true,
          builder: (context, params) => PracticeLog(),
        ),
        FFRoute(
          name: 'NotesPage',
          path: '/notesPage',
          requireAuth: true,
          builder: (context, params) => NotesPageWidget(),
        ),
        FFRoute(
          name: 'UserInfoForm',
          path: '/userInfoForm',
          requireAuth: true,
          builder: (context, params) => UserInfoForm(),
        ),
        FFRoute(
          name: 'ClassroomTestSeriesPage',
          path: '/classroomTestSeriesPage',
          requireAuth: true,
          builder: (context, params) => ClassroomTestSeriesPageWidget(),
        ),
        FFRoute(
          name: 'ThankYouPage',
          path: '/thankYouPage',
          requireAuth: true,
          builder: (context, params) => ThankYouPageWidget(),
        ),
        FFRoute(
          name: 'PromotionPage',
          path: '/promotionPage',
          requireAuth: true,
          builder: (context, params) => PromotionPage(),
        ),
        FFRoute(
          name: 'ThankYouPageWithCenterAvailable',
          path: '/thankYouPageWithCenterAvailable',
          requireAuth: true,
          builder: (context, params) => ThankYouPageWithCenterAvailable(),
        ),
        FFRoute(
          name: 'CreateTestPage',
          path: '/createTestPage',
          requireAuth: true,
          builder: (context, params) => CreateTestPageWidget(),
        ),
        FFRoute(
          name: 'PersonalDetailsPageWidget',
          path: '/personalDetailsPageWidget',
          requireAuth: true,
          builder: (context, params) => PersonalDetailsPageWidget(
              isFromBuyNow:params.getParam('isFromBuyNow', ParamType.bool)
          ),
        ),
        FFRoute(
          name: 'TestList',
          path: '/testList',
          requireAuth: true,
          builder: (context, params) => TestListWidget(
            pdfLink: params.getParam('pdfLink', ParamType.String),
          ),
        ),
        FFRoute(
          name: 'StartTestPage',
          path: '/startTestPage',
          requireAuth: true,
          builder: (context, params) => StartTestPageWidget(
            testId: params.getParam('testId', ParamType.String),
            courseIdInt: params.getParam('courseIdInt', ParamType.String),
          ),
        ),
        FFRoute(
          name: 'OrderPage',
          path: '/orderPage',
          requireAuth: true,
          builder: (context, params) => OrderPageWidget(
            courseId: params.getParam('courseId', ParamType.String),
            courseIdInt: params.getParam('courseIdInt', ParamType.String),
            state: params.getParam('state', ParamType.String),
            city:params.getParam('city', ParamType.String),
              centerAddress:params.getParam('centerAddress', ParamType.String)
          ),
        ),
        FFRoute(
          name: 'CreateAndPreviewTestPage',
          path: '/createAndPreviewTestPage',
          requireAuth: true,
          builder: (context, params) => CreateAndPreviewTestPageWidget(),
        ),
        FFRoute(
          name: 'testingNew',
          path: '/testingNew',
          builder: (context, params) => TestingNewWidget(),
        ),
        FFRoute(
          name: 'ncertAnnotation',
          path: '/ncertAnnotation',
          builder: (context, params) => NcertAnnotation(
              webUrl: params.getParam('webUrl', ParamType.String),
              title: params.getParam('title', ParamType.String)
          ),
        ),
        FFRoute(
          name: 'flutterWebView',
          path: '/flutterWebView',
          builder: (context, params) => FlutterWebView(
              webUrl: params.getParam('webUrl', ParamType.String),
              title: params.getParam('title', ParamType.String)
          ),
        ),
        FFRoute(
          name: 'abhyasBatch2',
          path: '/abhyasBatch2',
          builder: (context, params) => AbhyasBatch2(
          ),
        ),
        FFRoute(
          name: 'abhyasBatch2InfoPage',
          path: '/abhyasBatch2InfoPage',
          builder: (context, params) => AbhyasBatch2InfoPage(
          ),
        ),
        FFRoute(
          name: 'LearnMore',
          path: '/learnMore',
          requireAuth: true,
          builder: (context, params) => LearnMoreWidget(
            value: params.getParam('value', ParamType.String),
            is6MonthChecked: params.getParam('is6MonthChecked', ParamType.bool),
            is1YearChecked: params.getParam('is1YearChecked', ParamType.bool),
          ),
        ),
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
          name: 'TestPage',
          path: '/testPage',
          requireAuth: true,
          builder: (context, params) => TestPageWidget(
            testId: params.getParam('testId', ParamType.String),
            testAttemptId: params.getParam('testAttemptId', ParamType.String),
            courseIdInt: params.getParam('courseIdInt', ParamType.String),
          ),
        ),
        FFRoute(
          name: 'ViewAnswerPage',
          path: '/viewAnswerPage',
          requireAuth: true,
          builder: (context, params) => ViewAnswerPageWidget(
            testAttemptId: params.getParam('testAttemptId', ParamType.String),
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
          name: 'CreateTestResultPage',
          path: '/createTestResultPage',
          requireAuth: true,
          builder: (context, params) => CreateTestResultPageWidget(
            testAttemptId: params.getParam('testAttemptId', ParamType.String),
            courseIdInt: params.getParam('courseIdInt', ParamType.String),
          ),
        ),
        FFRoute(
          name: 'PracticeChapterWisePage',
          path: '/practiceChapterWisePage',
          requireAuth: true,
          builder: (context, params) => PracticeChapterPageWidget(),
        ),
        FFRoute(
          name: 'AssertionChapterWisePage',
          path: '/assertionChapterWisePage',
          requireAuth: true,
          builder: (context, params) => AssertionChapterWisePageWidget(),
        ),
        FFRoute(
          name: 'AssertionSearchPage',
          path: '/assertionSearchPage',
          builder: (context, params) => AssertionSearchPageWidget(
            hasAccess: params.getParam('hasAccess', ParamType.bool),

          ),
        ),
        FFRoute(
          name: 'FlashcardChapterWisePage',
          path: '/flashcardChapterWisePage',
          requireAuth: true,
          builder: (context, params) => FlashcardChapterWisePageWidget(),
        ),
        FFRoute(
          name: 'FlashcardDeckPage',
          path: '/flashcardDeckPage',
          requireAuth: true,
          builder: (context, params) => FlashcardDeckPageWidget(
            deckId: params.getParam('deckId', ParamType.String),
          ),
        ),
        FFRoute(
          name: 'FlashcardQuestionPage',
          path: '/flashcardQuestionPage',
          requireAuth: true,
          builder: (context, params) => FlashcardQuestionPage(
            questionId: params.getParam('questionId', ParamType.String),
          ),
        ),
        FFRoute(
          name: 'LoginPage',
          path: '/loginPage',
          builder: (context, params) => LoginPageWidget(),
        ),
        FFRoute(
          name: 'PostTransaction',
          path: '/postTransaction',
          requireAuth: true,
          builder: (context, params) => PostTransactionWidget(
              success: params.getParam('success', ParamType.bool),
              id: params.getParam('id', ParamType.String),
              amount: params.getParam('amount', ParamType.String),
              course: params.getParam('course', ParamType.String)),
        ),
        FFRoute(
          name: 'CourseDetailPage24',
          path: '/courseDetailPage24',
          builder: (context, params) => CourseDetailPage24Widget(),
        ),
        FFRoute(
          name: 'BookPurchaseForm',
          path: '/bookPurchaseForm',
          builder: (context, params) => BookPurchaseForm(),
        ),
        FFRoute(
          name: 'PracticeFreeQuestionsPage',
          path: '/practiceFreeQuestionsPage',
          requireAuth: true,
          builder: (context, params) => PracticeFreeQuestionsPageWidget(
            testId: params.getParam('testId', ParamType.String),
            offset: params.getParam('offset', ParamType.int),
            numberOfQuestions:
                params.getParam('numberOfQuestions', ParamType.int),
          ),
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
          name: 'BookmarkSoonPage',
          path: '/bookmarkSoonPage',
          builder: (context, params) => BookmarkSoonPageWidget(),
        ),
        FFRoute(
          name: 'CourseDetailPage25',
          path: '/courseDetailPage25',
          builder: (context, params) => CourseDetailPage25Widget(),
        ),
        FFRoute(
          name: 'BookmarkedQuesDisplayPage',
          path: '/bookmarkedQuesDisplayPage',
          builder: (context, params) => BookmarkedQuesDisplayPageWidget(),
        ),
        FFRoute(
          name: 'PracticeTestPage',
          path: '/practiceTestPage',
          requireAuth: true,
          builder: (context, params) => PracticeTestPageWidget(
            testId: params.getParam('testId', ParamType.String),
            courseIdInt: params.getParam('courseIdInt', ParamType.int),
            courseIdInts: params.getParam('courseIdInts', ParamType.String),
            topicId: params.getParam('topicId', ParamType.String),
          ),
        ),
        FFRoute(
          name: 'PracticeSearchPage',
          path: '/practiceSearchPage',
          builder: (context, params) => PracticeSearchPageWidget(
              courseIdInt: params.getParam('courseIdInt', ParamType.int),
              courseIdInts: params.getParam('courseIdInts', ParamType.String)
          ),
        ),
        FFRoute(
          name: 'EssentialSearchPage',
          path: '/essentialSearchPage',
          builder: (context, params) => EssentialSearchPageWidget(
              hasAccess: params.getParam('hasAccess', ParamType.bool),
              courseIdInt: params.getParam('courseIdInt', ParamType.int),
              courseIdInts: params.getParam('courseIdInts', ParamType.String),
          ),
        ),
        FFRoute(
          name: 'FlashcardSearchPage',
          path: '/flashcardSearchPage',
          builder: (context, params) => FlashcardSearchPageWidget(),
        ),
        FFRoute(
          name: 'NotesViewerPage',
          path: '/notesViewerPage',
          requireAuth: true,
          builder: (context, params) => NotesViewerPageWidget(
            pdfURL: params.getParam('pdfURL', ParamType.String),
            pdfName: params.getParam('pdfName', ParamType.String),
          ),
        )
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

  void safePopForTests( String? courseIdInt) {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      if(courseIdInt==FFAppState().testCourseIdInt.toString())
      go('/createAndPreviewTestPage');
      else if(courseIdInt==FFAppState().classroomTestCourseIdInt.toString()){
        go('/classroomTestSeriesPage');
      }
      else if(courseIdInt==FFAppState().flashcardCourseIdInt.toString()){
        go('/flashcardChapterWisePage');
      }
      else if(courseIdInt==FFAppState().assertionCourseIdInt.toString()) {
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
  void setRedirectLocationIfUnset(String location) =>
      appState.updateNotifyOnAuthChange(false);
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
          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            appStateNotifier.clearRedirectLocation();
            return redirectLocation;
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.uri.toString());
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
          final child = appStateNotifier.loading
              ? Container(
                  color: Colors.black,
                  child: Image.asset(
                    FFAppState().isDarkMode
                        ?
                    'assets/images/Splash_Screen_Essential_Dark.png':'assets/images/Splash_Screen_-_Essential.png',
                    fit: BoxFit.contain,
                  ),
                )
              : page;

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
