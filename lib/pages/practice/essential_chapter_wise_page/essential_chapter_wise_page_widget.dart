import 'dart:async';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:neetprep_essential/firebase/firebase_push_notification.dart';
import 'package:neetprep_essential/providers/commonProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../clevertap/clevertap_service.dart';
import '../../../components/drawer/darwer_widget.dart';
import '../../../components/nav_bar/nav_bar_model.dart';
import '../../../flutter_flow/flutter_flow_icon_button.dart';
import '../../../utlis/text.dart';
import '../../bookmarkedQs/bookmarked_chapter_wise_page/bookmarked_chapter_wise_page_model.dart';
import '../../bookmarkedQs/bookmarked_questions_page/bookmarked_questions_page_model.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/components/practice_chap_button/practice_chap_button_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'essential_chapter_wise_page_model.dart';
export 'essential_chapter_wise_page_model.dart';

class EssentialChapterWisePageWidget extends StatefulWidget {
  const EssentialChapterWisePageWidget({Key? key}) : super(key: key);
  @override
  _EssentialChapterWisePageWidgetState createState() =>
      _EssentialChapterWisePageWidgetState();
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

class _EssentialChapterWisePageWidgetState
    extends State<EssentialChapterWisePageWidget> with TickerProviderStateMixin {
  late EssentialChapterWisePageModel _model;
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
          apiCallPracticeTestsToShowChapterWise,
          IsolateModelChapterWise(FFAppState().essentialCourseId));
  Future<ApiCallResponse> membershipTemp =
      compute<IsolateModel, ApiCallResponse>(
          apiCallMembership,
          IsolateModel(FFAppState().subjectToken, FFAppState().essentialCourseIdInt,
              FFAppState().essentialCourseIdInts));

  List<dynamic> topicTemp = [];
  void func(Future<ApiCallResponse> x) async {
    final y = await x;
    topicTemp = await compute<IsolateModelTopics, dynamic>(
        apiCallTopics, IsolateModelTopics(y.jsonBody));
   setState(() {});
  }
  final JustTheController  tooltipController  = JustTheController();


  @override
  void initState() {
    super.initState();

    FirebaseAnalytics.instance.setCurrentScreen(screenName: "EssentialChapterWisePage",);
    _model = Provider.of<EssentialChapterWisePageModel>(context, listen: false);
    var commonProvider = Provider.of<CommonProvider>(context, listen: false);
    _model.navBarModel = createModel(context, () => NavBarModel());
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      setState(() {});
      SharedPreferences prefs  = await SharedPreferences.getInstance();
      CleverTapService.recordPageView("Essential Chapter Page Opened");
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


        setState(()  {
          FFAppState().memberShipResForEssential = getJsonField(
            (_model.memberShip?.jsonBody ?? ''),
            r'''$.data''',
          );
          FFAppState().memberShipResForEssentialIdList = getJsonField(
            (_model.memberShip?.jsonBody ?? ''),
            r'''$.data.me.userCourses.edges''',
          )!
              .toList()
              .cast<dynamic>();

          FFAppState().showLoading = false;
        });




      await actions.getJson(
        FFAppState().memberShipResForEssential,
      );
      print(FFAppState().memberShipResForEssentialIdList.toList().length == 0);
      actions.chkJson(
        FFAppState().memberShipResForEssentialIdList.toList(),
      );
      _model.apiResultdwy = await chapWiseTemp;


      if ((_model.apiResultdwy?.succeeded ?? true)) {
        func(chapWiseTemp);
        // Future.delayed(Duration(milliseconds: 300));
        FFAppState().allSearchItemsForEssential =
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

    }});

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


  }


  @override
  void dispose() {
    _model.dispose();
    tooltipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    //setsate to be checked before removing it, sometimes page doesnot show chapters
    setState(() {});
    //WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    return Consumer2<EssentialChapterWisePageModel,CommonProvider>(
      builder: (context,practiceChapModel,commonProvider,child) {
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
                title: 'EssentialChapterWisePage',
                color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
                child: GestureDetector(
                 // onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
                  child: WillPopScope(
                     onWillPop: () async{
                       await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                       return false;

                     },
                    child: Scaffold(
                      key: scaffoldKey,
                      floatingActionButton: !FFAppState().isScreenshotCaptureDisabled && !commonProvider.isFeedbackSubmitted ?
                      Showcase(
                          key: commonProvider.feedbackSubmitToolTipKey,
                          title: "Submit your feedback here 👇",
                          titleTextStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                            FlutterFlowTheme.of(context).bodyMediumFamily,
                            fontSize: 14.0,
                            color:Colors.black,
                            fontWeight: FontWeight.w700,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).bodyMediumFamily),
                          ),
                          description: 'You can close this anytime by restarting the app.',
                          descTextStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                            FlutterFlowTheme.of(context).bodyMediumFamily,
                            fontSize: 11.0,
                            color:Colors.black,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w400,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).bodyMediumFamily),
                          ),

                          disableDefaultTargetGestures: false,
                          child: FloatingActionButton(
                            backgroundColor:FlutterFlowTheme.of(context).primaryBackground,
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
                          ))
                            :null,
                            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                            drawer: DrawerWidget(DrawerStrings.abhyasEssentials),
                            body:  NestedScrollView(
                              floatHeaderSlivers: true,
                              headerSliverBuilder: (context, _) => [
                                SliverAppBar(
                                  pinned: false,
                                  floating: true,
                                  snap: false,
                                  backgroundColor:
                                  FlutterFlowTheme.of(context).secondaryBackground,
                                  automaticallyImplyLeading: false,
                                  title:Container(
                                    width:MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 25.0, 0.0),
                                          child:
                                         // FFAppState().showFeedbackDrawerTooltip?
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              scaffoldKey.currentState!.openDrawer();
                                              // if (animationsMap[
                                              // 'iconOnActionTriggerAnimation'] !=
                                              //     null) {
                                              //   await animationsMap[
                                              //   'iconOnActionTriggerAnimation']!
                                              //       .controller
                                              //       .forward(from: 0.0);
                                              // }
                                            },
                                            child: Icon(
                                              Icons.menu_rounded,
                                              color: FlutterFlowTheme.of(context).accent1,
                                              size: 24.0,

                                            ).animateOnActionTrigger(
                                              animationsMap[
                                              'iconOnActionTriggerAnimation']!,
                                            ),
                                          )
                                        // :InkWell(
                                        //     splashColor: Colors.transparent,
                                        //     focusColor: Colors.transparent,
                                        //     hoverColor: Colors.transparent,
                                        //     highlightColor: Colors.transparent,
                                        //     onTap: () async {
                                        //       scaffoldKey.currentState!.openDrawer();
                                        //       // if (animationsMap[
                                        //       // 'iconOnActionTriggerAnimation'] !=
                                        //       //     null) {
                                        //       //   await animationsMap[
                                        //       //   'iconOnActionTriggerAnimation']!
                                        //       //       .controller
                                        //       //       .forward(from: 0.0);
                                        //       // }
                                        //     },
                                        //     child: Icon(
                                        //       Icons.menu_rounded,
                                        //       color: Colors.black,
                                        //       size: 24.0,
                                        //     ).animateOnActionTrigger(
                                        //       animationsMap[
                                        //       'iconOnActionTriggerAnimation']!,
                                        //     ),
                                        //   ),
                                        ),
                                        Flexible(
                                          child: Text('Abhyas Essential',style:FlutterFlowTheme.of(context)
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
                                          'EssentialSearchPage',
                                          queryParameters: {
                                            'courseIdInt': serializeParam(
                                              FFAppState().essentialCourseIdInt,
                                              ParamType.int,
                                            ),
                                            'courseIdInts': serializeParam(
                                              FFAppState().essentialCourseIdInts,
                                              ParamType.String,
                                            ),
                                            'hasAccess': serializeParam(
                                              FFAppState().memberShipResForEssentialIdList.toList().length==0 ? false:true,
                                              ParamType.bool,
                                            ),
                                          }.withoutNulls,
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
                                            color: FlutterFlowTheme.of(context).secondaryBorderColor,
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
                                        if (false)
                                          Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context)
                                                  .secondaryBackground,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          16.0, 0.0, 0.0, 0.0),
                                                  child: Image.asset(
                                                    'assets/images/Frame_1000006420.png',
                                                    width: 47.0,
                                                    height: 41.0,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsetsDirectional
                                                        .fromSTEB(
                                                            0.0, 2.0, 0.0, 0.0),
                                                    child: Text(
                                                      'Unlock your potential with regular practice today.',
                                                      style: FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            color:
                                                                Color(0xFFB9B9B9),
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                                FontWeight.normal,
                                                            useGoogleFonts: GoogleFonts
                                                                    .asMap()
                                                                .containsKey(
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumFamily),
                                                            lineHeight: 1.4,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
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
                                                                  color: FlutterFlowTheme.of(context).accent7,
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
                                                                          color: FlutterFlowTheme.of(context).primaryText,
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
                                                            color:  FlutterFlowTheme.of(context).primaryBackground,
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
                                                                    return PracticeChapButtonWidget(
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
                                                                      trial:false,
                                                                      hasChapterAccess: true,
                                                                      isPaidUser:  FFAppState().memberShipResForEssentialIdList.length>0,
                                                                      courseIdInt:
                                                                      FFAppState()
                                                                          .essentialCourseIdInt,
                                                                      courseIdInts:
                                                                      FFAppState()
                                                                          .essentialCourseIdInts,
                                                                      topicId: getJsonField(
                                                                        topicNodesItem,
                                                                        r'''$.id''',
                                                                      ) ,
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
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ));
          },
        );
      }
    );
  }
}
