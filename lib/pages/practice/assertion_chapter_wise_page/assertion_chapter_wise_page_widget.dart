import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:neetprep_essential/flutter_flow/flutter_flow_animations.dart';
import 'package:neetprep_essential/providers/commonProvider.dart';
import 'package:neetprep_essential/utlis/text.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../clevertap/clevertap_service.dart';
import '../../../components/assertion_chap_button/assertion_chap_button_widget.dart';
import '../../../flutter_flow/flutter_flow_icon_button.dart';
import '/custom_code/actions/index.dart' as actions;
import '../../../app_state.dart';
import '../../../auth/firebase_auth/auth_util.dart';
import '../../../backend/api_requests/api_calls.dart';
import '../../../backend/api_requests/api_manager.dart';
import '../../../components/drawer/darwer_widget.dart';
import '../../../components/practice_chap_button/practice_chap_button_widget.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/nav/nav.dart';
import 'assertion_chapter_wise_page_model.dart';

class AssertionChapterWisePageWidget extends StatefulWidget {
  const AssertionChapterWisePageWidget({super.key});

  @override
  State<AssertionChapterWisePageWidget> createState() => _AssertionChapterWisePageWidgetState();
}
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

Future<ApiCallResponse> apiCallPracticeTestsToShowChapterWise(
    IsolateModelChapterWise model) async {
  return await PracticeGroup.getPracticeTestsToShowChapterWiseCall.call(
    courseId: model.courseId,
  );
}

//gets name of subtopic along with its unique id
class IsolateModelSearchList {
  final Future<ApiCallResponse> searchList;

  IsolateModelSearchList(this.searchList);
}

Future<List<dynamic>> apiCallSearchList(IsolateModelSearchList model) async {
  return await PracticeGroup.getPracticeTestsToShowChapterWiseCall
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
  return await (PracticeGroup.getPracticeTestsToShowChapterWiseCall.topicNodes(
    model.topics,
  )).toList();
}

class _AssertionChapterWisePageWidgetState extends State<AssertionChapterWisePageWidget>  with TickerProviderStateMixin{
  late AssertionChapterWisePageModel _model;
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

  Future<ApiCallResponse> chapWiseTemp =
  compute<IsolateModelChapterWise, ApiCallResponse>(
      apiCallPracticeTestsToShowChapterWise,
      IsolateModelChapterWise(FFAppState().assertionCourseId));
  Future<ApiCallResponse> membershipTemp =
  compute<IsolateModel, ApiCallResponse>(
      apiCallMembership,
      IsolateModel(FFAppState().subjectToken, FFAppState().assertionCourseIdInt,
          FFAppState().assertionCourseIdInts));

  List<dynamic> topicTemp = [];
  void func(Future<ApiCallResponse> x) async {
    final y = await x;
    topicTemp = await compute<IsolateModelTopics, dynamic>(
        apiCallTopics, IsolateModelTopics(y.jsonBody));
    setState(() {});
  }
  int totalPracticedQuestions = 0;



  @override
  void initState() {
    // TODO: implement initState
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "AssertionChapterWisePage",);
    CleverTapService.recordPageView("Assertion Chapter Page Opened");
    _model = createModel(context, () => AssertionChapterWisePageModel());
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.setUserIdentifier(currentUserUid);
        FirebaseCrashlytics.instance.setCustomKey('userID', currentUserUid);
      }
      // FirebaseCrashlytics.instance.log("Higgs-Boson detected! Bailing out");
      _model.memberShip = await membershipTemp;
      if ((_model.memberShip?.succeeded ?? true) &&
          (SignupGroup.loggedInUserInformationAndCourseAccessCheckingApiCall.me(
            (_model.memberShip?.jsonBody ?? ''),
          ) !=
              null)) {
        setState(() {
           FFAppState().memberShipResForAssertion = getJsonField(
            (_model.memberShip?.jsonBody ?? ''),
            r'''$.data''',
          );
          FFAppState().memberShipResForAssertionIdList = getJsonField(
            (_model.memberShip?.jsonBody ?? ''),
            r'''$.data.me.userCourses.edges''',
          )!
              .toList()
              .cast<dynamic>();
          // FFAppState().homeVisibility = true;
          // FFAppState().notesVisibility = false;
          FFAppState().showLoading = false;
        });
      } else {
        context.pushNamed('LoginPage');
        FFAppState().newToken = "";
        return;
      }

      await actions.getJson(
        FFAppState().memberShipResForAssertion,
      );
      actions.chkJson(
        FFAppState().memberShipResForAssertionIdList.toList(),
      );
      _model.apiResultdwy = await chapWiseTemp;









      if ((_model.apiResultdwy?.succeeded ?? true)) {
        func(chapWiseTemp);
        // Future.delayed(Duration(milliseconds: 300));
        FFAppState().allSearchItemsForAssertionReason =
            PracticeGroup.getPracticeTestsToShowChapterWiseCall
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

    super.initState();
  }

  Future<void> getTotalPracticedQuestions() async {
    final String apiUrl = 'https://api.neetprep.com/v2api/user_practice_summary';

    final Map<String, String> headers = {
      'Authorization':
      'Bearer '+ FFAppState().newToken,
    };

    try {
      http.Response response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = parseTotalPracticedQuestions(response.body);
        setState(() {
          totalPracticedQuestions = responseData.isNotEmpty
              ? responseData[0]['total_questions_practiced']
              : 0;
        });
      } else {
        print('API Error - Status Code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (error) {
      print('Error during API call: $error');
    }
  }

  List<dynamic> parseTotalPracticedQuestions(String responseBody) {
    return jsonDecode(responseBody);
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    //setsate to be checked before removing it, sometimes page doesnot show chapters
    setState(() {});
    //WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
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
        final practiceChapterWisePageGetPracticeTestsToShowChapterWiseResponse =
        snapshot.data!;

        return Title(
            title: 'AssertionChapterWisePage',
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
                      floatingActionButton: !FFAppState().isScreenshotCaptureDisabled && !commonProvider.isFeedbackSubmitted  ?
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
                      drawer: DrawerWidget(DrawerStrings.arQsPowerUp),
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
                            title:Row(
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
                                      color: FlutterFlowTheme.of(context).accent1,
                                      size: 24.0,
                                    ).animateOnActionTrigger(
                                      animationsMap[
                                      'iconOnActionTriggerAnimation']!,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Text('Assertion - Reason PowerUp',style:FlutterFlowTheme.of(context)
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

                                         context.pushNamed(
                                          'AssertionSearchPage',
                                          queryParameters: {
                                            'hasAccess': serializeParam(
                                            FFAppState().memberShipResForAssertionIdList.toList().length==0 ? false:true,
                                        ParamType.bool,
                                        ),
                                          },
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
                                          color: FlutterFlowTheme.of(context).secondaryBackground,
                                          borderRadius: BorderRadius.circular(12.0),
                                          border: Border.all(
                                            color:FlutterFlowTheme.of(context).secondaryBorderColor,
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
                                                      .primaryText,
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
                                                  color: FlutterFlowTheme.of(
                                                      context)
                                                      .primaryText,
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
                                            return Builder(
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
                                                                color: FlutterFlowTheme.of(context).primaryBackground,
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
                                                                      r'''$.questionSets.edges[:].node''',
                                                                      true,
                                                                    ).toList();
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
                                                                        return AssertionChapButtonWidget(
                                                                          key: Key(
                                                                              'Key59l_${practiceTestIndex}_of_${practiceTest.length}'),
                                                                          courseId: FFAppState().assertionCourseIdInt,
                                                                          hasAccess:FFAppState().memberShipResForAssertionIdList.toList().length==0 ? false:true,
                                                                          parameter1:
                                                                          getJsonField(
                                                                            practiceTestItem,
                                                                            r'''$.name''',
                                                                          ),
                                                                          parameter2:
                                                                          getJsonField(
                                                                            practiceTestItem,
                                                                            r'''$.numQuestions''',
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
                                 topicTemp.isNotEmpty && topicTemp!=[]?
                                  Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme
                                          .of(context)
                                          .secondaryBackground,
                                    ),
                                    child: Visibility(
                                      visible: (FFAppState()
                                          .memberShipResForAssertionIdList
                                          .toList()
                                          .length ==
                                          0),
                                      child: FutureBuilder<
                                          ApiCallResponse>(
                                        future: PaymentGroup
                                            .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                                            .call(
                                          courseId:
                                          FFAppState()
                                              .assertionCourseId,
                                        ),
                                        builder: (context,
                                            snapshot) {
                                          // Customize what your widget looks like when it's loading.
                                          if (!snapshot
                                              .hasData) {
                                            return Center(
                                              child:
                                              LinearProgressIndicator(
                                                color: FlutterFlowTheme.of(
                                                    context)
                                                    .primary,
                                              ),
                                            );
                                          }
                                          final containerGetCoursePriceAndCourseOffersToSelectFromToStartPaymentResponse =
                                          snapshot.data!;
                                          return Container(
                                            width: double
                                                .infinity,
                                            decoration:
                                            BoxDecoration(
                                              color: Color(
                                                  0xFFB27A14),
                                              image:
                                              DecorationImage(
                                                fit: BoxFit
                                                    .cover,
                                                image: Image
                                                    .asset(
                                                  'assets/images/Header-Curves.png',
                                                ).image,
                                              ),
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  12.0),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                  16.0,
                                                  23.0,
                                                  16.0,
                                                  25.0),
                                              child: Row(
                                                mainAxisSize:
                                                MainAxisSize
                                                    .max,
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child:
                                                    Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                          0.0,
                                                          0.0,
                                                          10.0,
                                                          0.0),
                                                      child:
                                                      Wrap(
                                                        spacing:
                                                        0.0,
                                                        runSpacing:
                                                        0.0,
                                                        alignment:
                                                        WrapAlignment.start,
                                                        crossAxisAlignment:
                                                        WrapCrossAlignment.start,
                                                        direction:
                                                        Axis.horizontal,
                                                        runAlignment:
                                                        WrapAlignment.start,
                                                        verticalDirection:
                                                        VerticalDirection.down,
                                                        clipBehavior:
                                                        Clip.none,
                                                        children: [
                                                          Text(
                                                            'Get access to the Chapters',
                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.normal,
                                                              useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                            ),
                                                          ),
                                                          // Text(
                                                          //   '₹ ${(String var1) {
                                                          //     return var1.split('.').first;
                                                          //   }((PaymentGroup.getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall.offerDiscountedFees(
                                                          //     containerGetCoursePriceAndCourseOffersToSelectFromToStartPaymentResponse.jsonBody,
                                                          //   ) as List).map<String>((s) => s.toString()).toList().first)}',
                                                          //   style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          //     fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                          //     color: Colors.white,
                                                          //     fontWeight: FontWeight.bold,
                                                          //     useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                          //   ),
                                                          // ),
                                                          // Text(
                                                          //   ' & ',
                                                          //   style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          //     fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                          //     color: Colors.white,
                                                          //     fontWeight: FontWeight.normal,
                                                          //     useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                          //   ),
                                                          // ),
                                                          // Text(
                                                          //   'get ',
                                                          //   style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          //     fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                          //     color: Colors.white,
                                                          //     fontWeight: FontWeight.normal,
                                                          //     useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                          //   ),
                                                          // ),
                                                          // Text(
                                                          //   'access ',
                                                          //   style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          //     fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                          //     color: Colors.white,
                                                          //     fontWeight: FontWeight.normal,
                                                          //     useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                          //   ),
                                                          // ),
                                                          // Text(
                                                          //   'to ',
                                                          //   style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          //     fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                          //     color: Colors.white,
                                                          //     fontWeight: FontWeight.normal,
                                                          //     useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                          //   ),
                                                          // ),
                                                          // Text(
                                                          //   'the ',
                                                          //   style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          //     fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                          //     color: Colors.white,
                                                          //     fontWeight: FontWeight.normal,
                                                          //     useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                          //   ),
                                                          // ),
                                                          // Text(
                                                          //   'chapters.',
                                                          //   style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          //     fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                          //     color: Colors.white,
                                                          //     fontWeight: FontWeight.normal,
                                                          //     useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                          //   ),
                                                          // ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    splashColor:
                                                    Colors
                                                        .transparent,
                                                    focusColor:
                                                    Colors
                                                        .transparent,
                                                    hoverColor:
                                                    Colors
                                                        .transparent,
                                                    highlightColor:
                                                    Colors
                                                        .transparent,
                                                    onTap:
                                                        () async {
                                                      FirebaseAnalytics.instance.logEvent(
                                                        name: 'buy_now_button_click',
                                                        parameters: {
                                                          "courseId": FFAppState().courseIdInt.toString(),
                                                        },
                                                      );
                                                      CleverTapService.recordEvent(
                                                        'Buy Now Clicked',
                                                        {"courseId":
                                                          FFAppState().courseIdInt.toString(),

                                                        },
                                                      );
                                                      context.pushNamed(
                                                        'OrderPage',queryParameters: {
                                                        'courseId': serializeParam(
                                                          FFAppState().courseId,
                                                          ParamType.String,
                                                        ),
                                                        'courseIdInt': serializeParam(
                                                          FFAppState().courseIdInt.toString(),
                                                          ParamType.String,
                                                        ),
                                                      }.withoutNulls,);
                                                    },
                                                    child:
                                                    Material(
                                                      color: Colors
                                                          .transparent,
                                                      elevation:
                                                      2.0,
                                                      shape:
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(10.0),
                                                      ),
                                                      child:
                                                      Container(
                                                        decoration:
                                                        BoxDecoration(
                                                          color:
                                                          FlutterFlowTheme.of(context).secondaryBackground,
                                                          borderRadius:
                                                          BorderRadius.circular(10.0),
                                                        ),
                                                        child:
                                                        Padding(
                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                              29.0,
                                                              13.0,
                                                              29.0,
                                                              13.0),
                                                          child:
                                                          Text(
                                                            'Buy Now',
                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                              color: Color(0xFFB27A14),
                                                              fontSize: 16.0,
                                                              useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ):SizedBox(),
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
}
