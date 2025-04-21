import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:neetprep_essential/clevertap/clevertap_service.dart';
import 'package:neetprep_essential/providers/commonProvider.dart';
import 'package:neetprep_essential/utlis/text.dart';

import '../../../components/drawer/darwer_widget.dart';
import '../../../components/flashcard_chap_button/flashcard_chap_button_widget.dart';
import '../../../components/theme_notifier/theme_notifier.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'flashcard_chapter_wise_page_model.dart';


class FlashcardChapterWisePageWidget extends StatefulWidget {
  const FlashcardChapterWisePageWidget({Key? key}) : super(key: key);
  @override
  _FlashcardChapterWisePageWidgetState createState() =>
      _FlashcardChapterWisePageWidgetState();
}

//Using Isolates to set states in background

class IsolateModel {
  final String authToken;
  final int courseIdInt;
  final String altCourseIds;

  IsolateModel(this.authToken, this.courseIdInt, this.altCourseIds);
}

Future<ApiCallResponse> apiCallMembership(IsolateModel model) async {
  return await SignupGroup.loggedInUserInformationAndCourseAccessCheckingApiCall
      .call(
    authToken: model.authToken,
    courseIdInt: model.courseIdInt,
    altCourseIds: model.altCourseIds,
  );
}
//Isolate function implementation for :-

// getting chapter wise array data
class IsolateModelChapterWise {
  final String courseId;

  IsolateModelChapterWise(this.courseId);
}

Future<ApiCallResponse> apiCallToGetDecksToShowChapterWise(
    IsolateModelChapterWise model) async {
  return await FlashcardGroup.getDecksToShowChapterWiseCall.call(
    courseId: model.courseId,
  );
}

//gets name of subtopic along with its unique id
class IsolateModelSearchList {
  final Future<ApiCallResponse> searchList;

  IsolateModelSearchList(this.searchList);
}

Future<List<dynamic>> apiCallSearchList(IsolateModelSearchList model) async {
  return await FlashcardGroup.getDecksToShowChapterWiseCall
      .allChapterWithId(
    (model.searchList).toString(),
  )!
      .toList()
      .cast<dynamic>();
}

//gets topics to popuialte listview
class IsolateModelTopics {
  final dynamic topics;
  // final dynamic topics;

  IsolateModelTopics(this.topics);
}

dynamic apiCallTopics(IsolateModelTopics model) async {
  return await (FlashcardGroup.getDecksToShowChapterWiseCall.topicNodes(
    model.topics,
  )).toList();
}

class _FlashcardChapterWisePageWidgetState
    extends State<FlashcardChapterWisePageWidget> with TickerProviderStateMixin {
  late FlashcardChapterWisePageModel _model;
  final  scaffoldKey = GlobalKey<ScaffoldState>();
  final InAppReview inAppReview = InAppReview.instance;
  final animationsMap = {
    'iconOnActionTriggerAnimation': AnimationInfo(
      trigger: AnimationTrigger.onActionTrigger,
      applyInitialState: true,
      effects: [
        FadeEffect(
          curve: Curves.easeOut,
          delay: 0.ms,
          duration: 350.ms,
          begin: 0.415,
          end: 1.0,
        ),
      ],
    ),
    'rowOnActionTriggerAnimation': AnimationInfo(
      trigger: AnimationTrigger.onActionTrigger,
      applyInitialState: true,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.4,
          end: 1.0,
        ),
      ],
    ),
  };

  // calling isolate functions

  Future<ApiCallResponse> chapWiseTemp =
  compute<IsolateModelChapterWise, ApiCallResponse>(
      apiCallToGetDecksToShowChapterWise,
      IsolateModelChapterWise(FFAppState().flashcardCourseId));
  Future<ApiCallResponse> membershipTemp =
  compute<IsolateModel, ApiCallResponse>(
      apiCallMembership,
      IsolateModel(FFAppState().subjectToken, FFAppState().flashcardCourseIdInt,
          FFAppState().flashcardCourseIdInts));

  List<dynamic> topicTemp = [];
  void func(Future<ApiCallResponse> x) async {
    final y = await x;
    topicTemp = await compute<IsolateModelTopics, dynamic>(
        apiCallTopics, IsolateModelTopics(y.jsonBody));
    setState(() {});
  }


  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "FlashcardChapterWisePage",);
    CleverTapService.recordPageView("Flashcard Chapter Page Opened");
    _model = createModel(context, () => FlashcardChapterWisePageModel());
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.memberShip = await membershipTemp;
      if ((_model.memberShip?.succeeded ?? true) &&
          (SignupGroup.loggedInUserInformationAndCourseAccessCheckingApiCall.me(
            (_model.memberShip?.jsonBody ?? ''),
          ) !=
              null)) {
        setState(() {
          FFAppState().showLoading = false;
        });
      } else {
        context.pushNamed('LoginPage');

        return;
      }

      _model.apiResultdwy = await chapWiseTemp;
      if ((_model.apiResultdwy?.succeeded ?? true)) {
        func(chapWiseTemp);
        // Future.delayed(Duration(milliseconds: 300));
        FFAppState().allSearchItemsForFlashcards =
            FlashcardGroup.getDecksToShowChapterWiseCall
                .allChapterWithId(
              (_model.apiResultdwy?.jsonBody ?? ''),
            )!
                .toList()
                .cast<dynamic>();
      } else {
        func(chapWiseTemp);
      }
      // topicstemp = await compute<IsolateModelTopics, dynamic>(
      //     apiCallTopics, IsolateModelTopics(chapWiseTemp));

    });

    setupAnimations(
      animationsMap.values.where((anim) =>
      anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    setupAnimations(
      animationsMap.values.where((anim) =>
      anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {

      setState(() {});
    });
    setState(() {

    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }
  final ThemeNotifier themeNotifier = ThemeNotifier(ThemeMode.light);


  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    //setsate to be checked before removing it, sometimes page doesnot show chapters
    setState(() {});
    //WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
      builder: (context,ThemeMode themeMode ,_) {
        return FutureBuilder<ApiCallResponse>(
          future: chapWiseTemp,
          builder: (context, snapshot) {
            // Customize what your widget looks like when it's loading.
            if (!snapshot.hasData || FFAppState().showLoading) {
              return Scaffold(
                backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                body: Center(
                  child: SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  ),
                ),
              );
            }
            return Title(
                title: 'FlashcardChapterWisePage',
                color: FlutterFlowTheme.of(context).primaryBackground,
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
                  child: WillPopScope(
                    onWillPop: () async{
                      await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                      return false;
                    },
                    child: Consumer<CommonProvider>(
                      builder: (context,commonProvider,child) {
                        return Scaffold(
                          key: scaffoldKey,
                          floatingActionButton: !FFAppState().isScreenshotCaptureDisabled && !commonProvider.isFeedbackSubmitted ?
                          FloatingActionButton(
                            backgroundColor: Colors.black,
                            onPressed: () {
                              commonProvider.showFeedBackFormBottomSheet(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/images/messages-3.svg',
                                  width: 24.0,
                                  height: 24.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ):null,
                          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                          drawer: DrawerWidget(DrawerStrings.pagewiseFlashcards),
                          body: NestedScrollView(
                            floatHeaderSlivers: true,
                            headerSliverBuilder: (context, _) => [
                              SliverAppBar(
                                pinned: false,
                                floating: true,
                                snap: false,
                                backgroundColor:
                                FlutterFlowTheme.of(context).secondaryBackground,
                                automaticallyImplyLeading: false,
                                title: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 25.0, 0.0),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          scaffoldKey.currentState!.openDrawer();
                                          if (animationsMap[
                                          'iconOnActionTriggerAnimation'] !=
                                              null) {
                                            await animationsMap[
                                            'iconOnActionTriggerAnimation']!
                                                .controller
                                                .forward(from: 0.0);
                                          }
                                        },
                                        child: Icon(
                                          Icons.menu_rounded,
                                          color:FlutterFlowTheme.of(context).primaryText,
                                          size: 24.0,
                                        ).animateOnActionTrigger(
                                          animationsMap[
                                          'iconOnActionTriggerAnimation']!,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text('Pagewise Flashcards',style:FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily),
                                      ),),
                                    ),
                                  ],
                                ),
                                actions: [],
                                centerTitle: false,
                                elevation: 0.0,
                              )
                            ],
                            body: Builder(
                              builder: (context) {
                                return SafeArea(
                                  top: false,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            12.0, 16.0, 12.0, 8.0),
                                        child: InkWell(
                                          customBorder: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          splashColor:
                                          Color.fromARGB(135, 168, 168, 168),
                                          focusColor:
                                          Color.fromARGB(138, 128, 128, 128),
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            setState(() {
                                              FFAppState().showLoading = true;
                                            });

                                            if (animationsMap[
                                            'rowOnActionTriggerAnimation'] !=
                                                null) {
                                              animationsMap[
                                              'rowOnActionTriggerAnimation']!
                                                  .controller
                                                  .forward(from: 0.0);
                                            }

                                            await context.pushNamed(
                                              'FlashcardSearchPage',
                                              extra: <String, dynamic>{
                                                kTransitionInfoKey: TransitionInfo(
                                                  hasTransition: true,
                                                  transitionType:
                                                  PageTransitionType.bottomToTop,
                                                  duration: Duration(milliseconds: 300),
                                                ),
                                              },
                                            );
                                            setState(() {
                                              FFAppState().showLoading = false;
                                            });
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            height: 50.0,
                                            decoration: BoxDecoration(
                                              color:FlutterFlowTheme.of(context).secondaryBackground,
                                              borderRadius: BorderRadius.circular(12.0),
                                              border: Border.all(
                                                color:FlutterFlowTheme.of(context).secondaryBorderColor ,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 0.0, 20.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Search Chapters...',
                                                    style: FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                      fontFamily:
                                                      FlutterFlowTheme.of(
                                                          context)
                                                          .bodyMediumFamily,
                                                      color: FlutterFlowTheme.of(
                                                          context)
                                                          .secondaryText,
                                                      fontSize: 12.0,
                                                      fontWeight: FontWeight.normal,
                                                      useGoogleFonts: GoogleFonts
                                                          .asMap()
                                                          .containsKey(
                                                          FlutterFlowTheme.of(
                                                              context)
                                                              .bodyMediumFamily),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                        4.0, 0.0, 4.0, 0.0),
                                                    child: Icon(
                                                      Icons.search_rounded,
                                                      color: Color(0xFF6E6E6E),
                                                      size: 24.0,
                                                    ),
                                                  ),
                                                ],
                                              ).animateOnActionTrigger(
                                                animationsMap[
                                                'rowOnActionTriggerAnimation']!,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          children: [
                                            FutureBuilder<ApiCallResponse>(
                                              future: membershipTemp,
                                              builder: (context, snapshot) {
                                                // Customize what your widget looks like when it's loading.
                                                if (!snapshot.hasData) {
                                                  return Center(
                                                    child: SizedBox(
                                                      width: 50.0,
                                                      height: 50.0,
                                                      child: CircularProgressIndicator(
                                                        valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
                                                          FlutterFlowTheme.of(context)
                                                              .primary,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                                final columnLoggedInUserInformationAndCourseAccessCheckingApiResponse =
                                                snapshot.data!;
                                                return Column(
                                                  children: [
                                                    Builder(
                                                      builder: (context) {
                                                        // final topicNodes = topicstemp;
                                                        final List<dynamic> topicNodes =
                                                            topicTemp ?? [];
                                                        return Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: List.generate(
                                                              topicNodes.length,
                                                                  (topicNodesIndex) {
                                                                final topicNodesItem =
                                                                topicNodes[topicNodesIndex];
                                                                return Column(
                                                                  mainAxisSize:
                                                                  MainAxisSize.min,
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .stretch,
                                                                  children: [
                                                                    (getJsonField(
                                                                  topicNodesItem,
                                                                  r'''$.decks.edges[:].node''',
                                                                  true,
                                                                )??[].toList()).isEmpty?
                                                                  Container():
                                                                    Padding(
                                                                      padding:
                                                                      EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          16.0,
                                                                          16.0,
                                                                          16.0,
                                                                          16.0),
                                                                      child: Row(
                                                                        mainAxisSize:
                                                                        MainAxisSize.min,
                                                                        children: [
                                                                          Container(
                                                                            decoration:
                                                                            BoxDecoration(
                                                                              color:  FlutterFlowTheme.of(context).accent7,
                                                                              borderRadius:
                                                                              BorderRadius
                                                                                  .circular(
                                                                                  8.0),
                                                                            ),
                                                                            child: Padding(
                                                                              padding:
                                                                              EdgeInsetsDirectional
                                                                                  .fromSTEB(
                                                                                  12.0,
                                                                                  4.0,
                                                                                  12.0,
                                                                                  4.0),
                                                                              child:
                                                                              AutoSizeText(
                                                                                getJsonField(
                                                                                  topicNodesItem,
                                                                                  r'''$.name''',
                                                                                )
                                                                                    .toString()
                                                                                    .toUpperCase()
                                                                                    .maybeHandleOverflow(
                                                                                  maxChars:
                                                                                  31,
                                                                                  replacement:
                                                                                  '…',
                                                                                ),
                                                                                textAlign:
                                                                                TextAlign
                                                                                    .start,
                                                                                style: FlutterFlowTheme.of(
                                                                                    context)
                                                                                    .bodyMedium
                                                                                    .override(
                                                                                  fontFamily:
                                                                                  FlutterFlowTheme.of(context)
                                                                                      .bodyMediumFamily,
                                                                                  color:  FlutterFlowTheme.of(context).primaryText,
                                                                                  fontSize:
                                                                                  12.0,
                                                                                  fontWeight:
                                                                                  FontWeight
                                                                                      .normal,
                                                                                  useGoogleFonts: GoogleFonts
                                                                                      .asMap()
                                                                                      .containsKey(
                                                                                      FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width: double.infinity,
                                                                      decoration: BoxDecoration(
                                                                        color:FlutterFlowTheme.of(context).primaryBackground,
                                                                      ),
                                                                      child: Padding(
                                                                        padding:
                                                                        EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            16.0,
                                                                            0.0,
                                                                            16.0,
                                                                            0.0),
                                                                        child: Builder(
                                                                          builder: (context) {
                                                                            final practiceTest =
                                                                            getJsonField(
                                                                              topicNodesItem,
                                                                              r'''$.decks.edges[:].node''',
                                                                              true,
                                                                            )??[].toList();
                                                                            return ListView
                                                                                .builder(
                                                                              padding:
                                                                              EdgeInsets
                                                                                  .zero,
                                                                              primary: false,
                                                                              shrinkWrap: true,
                                                                              scrollDirection:
                                                                              Axis.vertical,
                                                                              itemCount:
                                                                              practiceTest
                                                                                  .length,
                                                                              itemBuilder: (context,
                                                                                  practiceTestIndex) {
                                                                                final practiceTestItem =
                                                                                practiceTest[
                                                                                practiceTestIndex];
                                                                                return FlashcardChapButtonWidget(
                                                                                  key: Key(
                                                                                      'Key59l_${practiceTestIndex}_of_${practiceTest.length}'),
                                                                                  parameter1:
                                                                                  getJsonField(
                                                                                    practiceTestItem,
                                                                                    r'''$.name''',
                                                                                  ),
                                                                                  parameter2:
                                                                                  getJsonField(
                                                                                    practiceTestItem,
                                                                                    r'''$.numCards''',
                                                                                  ),
                                                                                  parameter3:
                                                                                  getJsonField(
                                                                                    practiceTestItem,
                                                                                    r'''$.id''',
                                                                                  ),
                                                                                  parameter4:
                                                                                  FFAppState()
                                                                                      .numberOfTabs,
                                                                                );
                                                                              },
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              }),
                                                        );
                                                      },
                                                    )
                                                  ],
                                                );
                                              },
                                            ),

                                          ],
                                        ),
                                      ),
                                      // wrapWithModel(
                                      //   model: _model.navBarModel,
                                      //   updateCallback: () => setState(() {}),
                                      //   child: NavBarWidget(),
                                      // ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }
                    ),
                  ),
                ));
          },
        );
      }
    );
  }
}
