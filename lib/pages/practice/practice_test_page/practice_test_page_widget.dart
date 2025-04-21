import 'dart:convert';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neetprep_essential/app_state.dart';
import 'package:neetprep_essential/providers/commonProvider.dart';
import 'package:provider/provider.dart';

import '../../../clevertap/clevertap_service.dart';
import '../../../flutter_flow/flutter_flow_icon_button.dart';
import '/backend/api_requests/api_calls.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'practice_test_page_model.dart';

export 'practice_test_page_model.dart';

class PracticeTestPageWidget extends StatefulWidget {
  const PracticeTestPageWidget({
    Key? key,
    this.testId,
    required this.courseIdInt,
    required this.courseIdInts,
    required this.topicId,
  }) : super(key: key);

  final String? testId;
  final int courseIdInt;
  final String courseIdInts;
  final String topicId;

  @override
  _PracticeTestPageWidgetState createState() => _PracticeTestPageWidgetState();
}

class _PracticeTestPageWidgetState extends State<PracticeTestPageWidget>
    with TickerProviderStateMixin {
  late PracticeTestPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = {
    'imageOnActionTriggerAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onActionTrigger,
      applyInitialState: false,
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
    'imageOnActionTriggerAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onActionTrigger,
      applyInitialState: false,
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

  String encodeBase64(String input) {
    final bytes = utf8.encode(input);
    final base64Str = base64.encode(bytes);
    return base64Str;
  }

  String base64DecodeString(String base64EncodedString) {
    List<int> bytes = base64.decode(base64EncodedString);
    String decodedString = utf8.decode(bytes);
    print(decodedString);
    String issueNum = decodedString.split(":")[1];
    return issueNum;
  }

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "PracticeTestPage");
    CleverTapService.recordEvent(
      'Practice Test Page Opened',
      {
        "courseId": widget.courseIdInt,
        "testId": widget.testId,
        "topicId": widget.topicId
      },
    );
    _model = createModel(context, () => PracticeTestPageModel());

    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    print(widget.testId);
    return FutureBuilder<ApiCallResponse>(
      future: PracticeGroup.getPracticeTestDetailsForAnExampleSubjectAnatomyCall
          .call(
        testId: widget.testId,
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
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
        final practiceTestPageGetPracticeTestDetailsForAnExampleSubjectAnatomyResponse =
            snapshot.data!;
        return Title(
            title: 'PracticeTestPage',
            color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
            child: GestureDetector(
              onTap: () =>
                  FocusScope.of(context).requestFocus(_model.unfocusNode),
              child: Consumer<CommonProvider>(
                  builder: (context, commonProvider, child) {
                return Scaffold(
                  floatingActionButton: !FFAppState()
                              .isScreenshotCaptureDisabled &&
                          !commonProvider.isFeedbackSubmitted
                      ? FloatingActionButton(
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
                        )
                      : null,
                  key: scaffoldKey,
                  backgroundColor:
                      FlutterFlowTheme.of(context).primaryBackground,
                  appBar: AppBar(
                    backgroundColor:
                        FlutterFlowTheme.of(context).secondaryBackground,
                    automaticallyImplyLeading: false,
                    title: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  setState(() {
                                    FFAppState().pageNumber = 0;
                                  });

                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 29.0,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  getJsonField(
                                    practiceTestPageGetPracticeTestDetailsForAnExampleSubjectAnatomyResponse
                                        .jsonBody,
                                    r'''$.data.test.name''',
                                  ).toString().maybeHandleOverflow(
                                        maxChars: 25,
                                        replacement: '…',
                                      ),
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .headlineMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .headlineMediumFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.normal,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .headlineMediumFamily),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16.0)),
                              ),
                              builder: (BuildContext builder) {
                                return Container(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Reset Attempt',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily,
                                                        fontSize: 20.0,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        useGoogleFonts: GoogleFonts
                                                                .asMap()
                                                            .containsKey(
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily),
                                                      )),
                                          FlutterFlowIconButton(
                                            borderColor: Colors.white,
                                            borderRadius: 20.0,
                                            borderWidth: 0.0,
                                            buttonSize: 40.0,
                                            fillColor: Colors.white,
                                            icon: FaIcon(
                                              FontAwesomeIcons.timesCircle,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              size: 24.0,
                                            ),
                                            onPressed: () async {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20.0),
                                      Text(
                                        'Are you sure?',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w700,
                                              useGoogleFonts: GoogleFonts
                                                      .asMap()
                                                  .containsKey(
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily),
                                            ),
                                      ),
                                      SizedBox(height: 10.0),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  'Your attempts in this chapter will be ',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0XFF858585),
                                                    fontSize: 14.0,
                                                    useGoogleFonts: GoogleFonts
                                                            .asMap()
                                                        .containsKey(
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily),
                                                  ),
                                            ),
                                            TextSpan(
                                              text: 'PERMANENTLY DELETED',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0XFF858585),
                                                    fontSize: 14.0,
                                                    useGoogleFonts: GoogleFonts
                                                            .asMap()
                                                        .containsKey(
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily),
                                                  ),
                                            ),
                                            TextSpan(
                                              text:
                                                  '. This action cannot be reverted.',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0XFF858585),
                                                    fontSize: 14.0,
                                                    useGoogleFonts: GoogleFonts
                                                            .asMap()
                                                        .containsKey(
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily),
                                                  ),
                                            ),
                                          ],
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium,
                                        ),
                                      ),
                                      SizedBox(height: 20.0),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              await PracticeGroup
                                                  .resetAttemptsOfAPracticeTestShownOnClickingOnTheThreeDotsBesidesTestNameCall
                                                  .call(
                                                selectedId:
                                                    functions.getIntFromBase64(
                                                        widget.testId!),
                                                authToken:
                                                    FFAppState().subjectToken,
                                              )
                                                  .then((_) {
                                                Navigator.pop(context);
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xffEF4444),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              padding: EdgeInsets.fromLTRB(
                                                  20.0, 14.0, 20.0, 14.0),
                                            ),
                                            child: Text('Delete',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white,
                                                          fontSize: 16.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily),
                                                        )),
                                          ),
                                          SizedBox(height: 10.0),
                                          OutlinedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              padding: EdgeInsets.fromLTRB(
                                                  20.0, 14.0, 20.0, 14.0),
                                            ),
                                            child: Text('Cancel',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          fontSize: 16.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily),
                                                        )),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Icon(
                            Icons.more_vert,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 29.0,
                          ),
                        ),
                      ],
                    ),
                    actions: [],
                    centerTitle: false,
                    elevation: 0.0,
                  ),
                  body: SafeArea(
                    top: true,
                    child: Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: FutureBuilder<ApiCallResponse>(
                        future: PracticeGroup
                            .getAllQuestionStatusGivenTestIDCall
                            .call(
                          testIdInt: functions.getIntFromBase64(widget.testId!),
                          authToken: FFAppState().subjectToken,
                        ),
                        builder: (context, snapshot) {
                          // Customize what your widget looks like when it's loading.
                          if (!snapshot.hasData) {
                            return Container(
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              child: Center(
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
                          final tabBarGetAllQuestionStatusGivenTestIDResponse =
                              snapshot.data!;
                          return Container(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            child: DefaultTabController(
                              length: 1,
                              initialIndex: 0,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: TabBarView(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      children: [
                                        KeepAliveWidgetWrapper(
                                          builder: (context) => Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 5.0, 0.0, 0.0),
                                            child:
                                                FutureBuilder<ApiCallResponse>(
                                              future: SignupGroup
                                                  .loggedInUserInformationAndCourseAccessCheckingApiCall
                                                  .call(
                                                authToken:
                                                    FFAppState().subjectToken,
                                                courseIdInt: widget.courseIdInt,
                                                altCourseIds:
                                                    widget.courseIdInts,
                                              ),
                                              builder: (context, snapshot) {
                                                // Customize what your widget looks like when it's loading.
                                                if (!snapshot.hasData) {
                                                  return Container(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    child: Center(
                                                      child: SizedBox(
                                                        width: 50.0,
                                                        height: 50.0,
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                                if (snapshot.hasData) {
                                                  final containerLoggedInUserInformationAndCourseAccessCheckingApiResponse =
                                                      snapshot.data!;
                                                  if (SignupGroup
                                                          .loggedInUserInformationAndCourseAccessCheckingApiCall
                                                          .me(containerLoggedInUserInformationAndCourseAccessCheckingApiResponse
                                                              .jsonBody) !=
                                                      null) {
                                                    var courseStatusResponse =
                                                        getJsonField(
                                                      (containerLoggedInUserInformationAndCourseAccessCheckingApiResponse
                                                              .jsonBody ??
                                                          ''),
                                                      r'''$.data.me.profile.courseStatus''',
                                                    );
                                                    String? courseStatus =
                                                        courseStatusResponse[
                                                                widget
                                                                    .courseIdInt
                                                                    .toString()]
                                                            ?.toString()
                                                            .toUpperCase();

                                                    if (widget.courseIdInt
                                                            .toString() ==
                                                        FFAppState()
                                                            .courseIdInt
                                                            .toString()) {
                                                      String? altCourseStatus =
                                                          courseStatusResponse[
                                                                  '3653']
                                                              ?.toString()
                                                              .toUpperCase();
                                                      if (altCourseStatus ==
                                                          'PAID') {
                                                        courseStatus = "PAID";
                                                      }
                                                    }

                                                    bool trial =
                                                        courseStatus == "TRIAL";
                                                    bool isPaid =
                                                        courseStatus == "PAID";
                                                    List<dynamic> freeChapters =
                                                        [];
                                                    if (trial) {
                                                      freeChapters = SignupGroup
                                                              .loggedInUserInformationAndCourseAccessCheckingApiCall
                                                              .freeChapters(
                                                                  containerLoggedInUserInformationAndCourseAccessCheckingApiResponse
                                                                      .jsonBody) ??
                                                          [];
                                                    }
                                                    //
                                                    // log(trial.toString());
                                                    // log(freeChapters.toString());
                                                    // log(base64DecodeString(widget.topicId.toString()));
                                                    // log(freeChapters.contains(int.parse(base64DecodeString(widget.topicId.toString()))).toString());
                                                    return Container(
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .primaryBackground,
                                                      ),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          AnalyticsWidget(
                                                              !(isPaid ||
                                                                  (trial &&
                                                                      freeChapters.contains(int.parse(base64DecodeString(widget
                                                                          .topicId
                                                                          .toString()))))),
                                                              getJsonField(
                                                                practiceTestPageGetPracticeTestDetailsForAnExampleSubjectAnatomyResponse
                                                                    .jsonBody,
                                                                r'''$.data.test.name''',
                                                              )
                                                                  .toString()
                                                                  .maybeHandleOverflow(
                                                                    maxChars:
                                                                        27,
                                                                    replacement:
                                                                        '…',
                                                                  ),
                                                              widget.testId),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        15.0,
                                                                        0.0,
                                                                        16.0,
                                                                        0.0),
                                                            child: InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                var _shouldSetState =
                                                                    false;
                                                                FirebaseAnalytics
                                                                    .instance
                                                                    .logEvent(
                                                                  name:
                                                                      'practice_test_button_click',
                                                                  parameters: {
                                                                    "chapterName":
                                                                        getJsonField(
                                                                      practiceTestPageGetPracticeTestDetailsForAnExampleSubjectAnatomyResponse
                                                                          .jsonBody,
                                                                      r'''$.data.test.name''',
                                                                    ).toString()
                                                                  },
                                                                );
                                                                if ((getJsonField(
                                                                          containerLoggedInUserInformationAndCourseAccessCheckingApiResponse
                                                                              .jsonBody,
                                                                          r'''$.data.me.userCourses.edges''',
                                                                        ) !=
                                                                        null) &&
                                                                    (SignupGroup
                                                                            .loggedInUserInformationAndCourseAccessCheckingApiCall
                                                                            .courses(
                                                                              containerLoggedInUserInformationAndCourseAccessCheckingApiResponse.jsonBody,
                                                                            )
                                                                            .length !=
                                                                        0)) {
                                                                  _model.offSetN1 =
                                                                      await actions
                                                                          .getOffset(
                                                                    getJsonField(
                                                                      practiceTestPageGetPracticeTestDetailsForAnExampleSubjectAnatomyResponse
                                                                          .jsonBody,
                                                                      r'''$.data.test.sectionNumQues''',
                                                                    )!,
                                                                    0,
                                                                  );
                                                                  _shouldSetState =
                                                                      true;

                                                                  if (FFAppState()
                                                                          .showRatingPrompt !=
                                                                      -1) {
                                                                    FFAppState()
                                                                        .showRatingPrompt++;
                                                                  }

                                                                  if ((trial &&
                                                                          SignupGroup
                                                                                  .loggedInUserInformationAndCourseAccessCheckingApiCall
                                                                                  .courses(
                                                                                    containerLoggedInUserInformationAndCourseAccessCheckingApiResponse.jsonBody,
                                                                                  )
                                                                                  .length >
                                                                              0 &&
                                                                          freeChapters.length >
                                                                              0 &&
                                                                          freeChapters.contains(int.parse(base64DecodeString(widget
                                                                              .topicId
                                                                              .toString())))) ||
                                                                      courseStatus ==
                                                                          "PAID") {
                                                                    context
                                                                        .pushNamed(
                                                                      'PracticeQuetionsPage',
                                                                      queryParameters:
                                                                          {
                                                                        'testId':
                                                                            serializeParam(
                                                                          widget
                                                                              .testId,
                                                                          ParamType
                                                                              .String,
                                                                        ),
                                                                        'offset':
                                                                            serializeParam(
                                                                          0,
                                                                          ParamType
                                                                              .int,
                                                                        ),
                                                                        'numberOfQuestions':
                                                                            serializeParam(
                                                                          getJsonField(
                                                                            practiceTestPageGetPracticeTestDetailsForAnExampleSubjectAnatomyResponse.jsonBody,
                                                                            r'''$.data.test.numQuestions''',
                                                                          ),
                                                                          ParamType
                                                                              .int,
                                                                        ),
                                                                        'sectionPointer':
                                                                            serializeParam(
                                                                          0,
                                                                          ParamType
                                                                              .int,
                                                                        ),
                                                                        'chapterName':
                                                                            serializeParam(
                                                                          getJsonField(
                                                                            practiceTestPageGetPracticeTestDetailsForAnExampleSubjectAnatomyResponse.jsonBody,
                                                                            r'''$.data.test.name''',
                                                                          ).toString().maybeHandleOverflow(
                                                                                maxChars: 25,
                                                                                replacement: '…',
                                                                              ),
                                                                          ParamType
                                                                              .String,
                                                                        ),
                                                                        'courseIdInt':
                                                                            serializeParam(
                                                                          widget
                                                                              .courseIdInt,
                                                                          ParamType
                                                                              .int,
                                                                        ),
                                                                        'courseIdInts':
                                                                            serializeParam(
                                                                          widget
                                                                              .courseIdInts,
                                                                          ParamType
                                                                              .String,
                                                                        ),
                                                                      }.withoutNulls,
                                                                      extra: <String,
                                                                          dynamic>{
                                                                        kTransitionInfoKey:
                                                                            TransitionInfo(
                                                                          hasTransition:
                                                                              true,
                                                                          transitionType:
                                                                              PageTransitionType.rightToLeft,
                                                                        ),
                                                                      },
                                                                    );
                                                                  } else {
                                                                    context
                                                                        .pushNamed(
                                                                      'OrderPage',
                                                                      queryParameters:
                                                                          {
                                                                        'courseId':
                                                                            serializeParam(
                                                                          base64Encode(
                                                                              utf8.encode('Course:${FFAppState().courseIdInt.toString()}')),
                                                                          ParamType
                                                                              .String,
                                                                        ),
                                                                        'courseIdInt':
                                                                            serializeParam(
                                                                              FFAppState()
                                                                              .courseIdInt
                                                                              .toString(),
                                                                          ParamType
                                                                              .String,
                                                                        ),
                                                                      }.withoutNulls,
                                                                    );
                                                                  }

                                                                  if (_shouldSetState)
                                                                    setState(
                                                                        () {});
                                                                  return;
                                                                } else {
                                                                  context
                                                                      .pushNamed(
                                                                    'OrderPage',
                                                                    queryParameters:
                                                                        {
                                                                      'courseId':
                                                                          serializeParam(
                                                                        base64Encode(
                                                                            utf8.encode('Course:${FFAppState().courseIdInt.toString()}')),
                                                                        ParamType
                                                                            .String,
                                                                      ),
                                                                      'courseIdInt':
                                                                          serializeParam(
                                                                        FFAppState()
                                                                            .courseIdInt
                                                                            .toString(),
                                                                        ParamType
                                                                            .String,
                                                                      ),
                                                                    }.withoutNulls,
                                                                  );
                                                                }

                                                                if (_shouldSetState)
                                                                  setState(
                                                                      () {});
                                                              },
                                                              child: Material(
                                                                color: Colors
                                                                    .transparent,
                                                                elevation: 2.0,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              16.0),
                                                                ),
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryBackground,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        blurRadius:
                                                                            60.0,
                                                                        color: Color(
                                                                            0x04060F0D),
                                                                        offset: Offset(
                                                                            0.0,
                                                                            4.0),
                                                                      )
                                                                    ],
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16.0),
                                                                  ),
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          0.0,
                                                                          0.0),
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
                                                                              16.0,
                                                                              20.0,
                                                                              15.0,
                                                                              20.0),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                getJsonField(
                                                                                  practiceTestPageGetPracticeTestDetailsForAnExampleSubjectAnatomyResponse.jsonBody,
                                                                                  r'''$.data.test.name''',
                                                                                ).toString().maybeHandleOverflow(
                                                                                      maxChars: 27,
                                                                                      replacement: '…',
                                                                                    ),
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                      fontSize: 16.0,
                                                                                      useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                    ),
                                                                              ),
                                                                              Row(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                children: [
                                                                                  Container(
                                                                                    height: 36.0,
                                                                                    child: Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 14.0, 6.0),
                                                                                      child: Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        children: [
                                                                                          Text(
                                                                                            'Total Qs ',
                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                  color: Color(0xFF858585),
                                                                                                  fontWeight: FontWeight.normal,
                                                                                                  useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                                ),
                                                                                          ),
                                                                                          Text(
                                                                                            '${getJsonField(
                                                                                              practiceTestPageGetPracticeTestDetailsForAnExampleSubjectAnatomyResponse.jsonBody,
                                                                                              r'''$.data.test.numQuestions''',
                                                                                            ).toString()}',
                                                                                            textAlign: TextAlign.center,
                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                  color: Color(0xFF858585),
                                                                                                  useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                                ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    ' | ',
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                          color: Color(0xFF858585),
                                                                                          fontWeight: FontWeight.w500,
                                                                                          useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                        ),
                                                                                  ),
                                                                                  if (valueOrDefault<bool>(
                                                                                    getJsonField(
                                                                                          practiceTestPageGetPracticeTestDetailsForAnExampleSubjectAnatomyResponse.jsonBody,
                                                                                          r'''$.data.test.sections''',
                                                                                        ) !=
                                                                                        null,
                                                                                    false,
                                                                                  ))
                                                                                    InkWell(
                                                                                      splashColor: Colors.transparent,
                                                                                      focusColor: Colors.transparent,
                                                                                      hoverColor: Colors.transparent,
                                                                                      highlightColor: Colors.transparent,
                                                                                      onTap: () async {
                                                                                        // context.pushNamed(
                                                                                        //     'OrderPage');
                                                                                      },
                                                                                      child: Container(
                                                                                        height: 36.0,
                                                                                        child: Padding(
                                                                                          padding: EdgeInsetsDirectional.fromSTEB(14.0, 6.0, 14.0, 6.0),
                                                                                          child: Row(
                                                                                            mainAxisSize: MainAxisSize.max,
                                                                                            children: [
                                                                                              Text(
                                                                                                'Topics ',
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      color: Color(0xFF858585),
                                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                      fontWeight: FontWeight.normal,
                                                                                                      useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                                    ),
                                                                                              ),
                                                                                              Text(
                                                                                                ((List<String>? var1) {
                                                                                                  return var1 == null ? 1 : var1.length;
                                                                                                }((getJsonField(
                                                                                                  practiceTestPageGetPracticeTestDetailsForAnExampleSubjectAnatomyResponse.jsonBody,
                                                                                                  r'''$.data.test.sections''',
                                                                                                ) as List)
                                                                                                        .map<String>((s) => s.toString())
                                                                                                        .toList()))
                                                                                                    .toString(),
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                      color: Color(0xFF858585),
                                                                                                      useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                                    ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      if (SignupGroup.loggedInUserInformationAndCourseAccessCheckingApiCall
                                                                                  .courses(
                                                                                    containerLoggedInUserInformationAndCourseAccessCheckingApiResponse.jsonBody,
                                                                                  )
                                                                                  .length >
                                                                              0 &&
                                                                          !trial)
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              16.0,
                                                                              0.0,
                                                                              20.0,
                                                                              0.0),
                                                                          child:
                                                                              Image.asset('assets/images/arrow-right.png', width: 24.0, height: 24.0, fit: BoxFit.cover, color: FlutterFlowTheme.of(context).primaryText).animateOnActionTrigger(
                                                                            animationsMap['imageOnActionTriggerAnimation2']!,
                                                                          ),
                                                                        ),
                                                                      trial
                                                                          ? SignupGroup.loggedInUserInformationAndCourseAccessCheckingApiCall
                                                                                          .courses(
                                                                                            containerLoggedInUserInformationAndCourseAccessCheckingApiResponse.jsonBody,
                                                                                          )
                                                                                          .length >
                                                                                      0 &&
                                                                                  freeChapters.length > 0 &&
                                                                                  freeChapters.contains(int.parse(base64DecodeString(widget.topicId.toString())))
                                                                              ? Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 20.0, 0.0),
                                                                                  child: Image.asset('assets/images/arrow-right.png', width: 24.0, height: 24.0, fit: BoxFit.cover, color: FlutterFlowTheme.of(context).primaryText).animateOnActionTrigger(
                                                                                    animationsMap['imageOnActionTriggerAnimation2']!,
                                                                                  ),
                                                                                )
                                                                              : InkWell(
                                                                                  onTap: () {
                                                                                    if (widget.courseIdInt == FFAppState().essentialCourseIdInt) {
                                                                                      context.pushNamed(
                                                                                        'OrderPage',
                                                                                        queryParameters: {
                                                                                          'courseId': serializeParam(
                                                                                            base64Encode(utf8.encode('Course:${FFAppState().courseIdInt.toString()}')),
                                                                                            ParamType.String,
                                                                                          ),
                                                                                          'courseIdInt': serializeParam(
                                                                                            FFAppState().courseIdInt.toString(),
                                                                                            ParamType.String,
                                                                                          ),
                                                                                        }.withoutNulls,
                                                                                      );
                                                                                    } else {
                                                                                      context.pushNamed(
                                                                                        'OrderPage',
                                                                                        queryParameters: {
                                                                                          'courseId': serializeParam(
                                                                                            base64Encode(utf8.encode('Course:${FFAppState().courseIdInt.toString()}')),
                                                                                            ParamType.String,
                                                                                          ),
                                                                                          'courseIdInt': serializeParam(
                                                                                            FFAppState().courseIdInt.toString(),
                                                                                            ParamType.String,
                                                                                          ),
                                                                                        }.withoutNulls,
                                                                                      );
                                                                                    }
                                                                                  },
                                                                                  child: Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 20.0, 0.0),
                                                                                    child: Image.asset('assets/images/lock.png', width: 24.0, height: 24.0, fit: BoxFit.cover, color: FlutterFlowTheme.of(context).primaryText),
                                                                                  ),
                                                                                )
                                                                          : SizedBox(),
                                                                      if (SignupGroup
                                                                              .loggedInUserInformationAndCourseAccessCheckingApiCall
                                                                              .courses(
                                                                                containerLoggedInUserInformationAndCourseAccessCheckingApiResponse.jsonBody,
                                                                              )
                                                                              .length ==
                                                                          0)
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                                if (widget.courseIdInt == FFAppState().essentialCourseIdInt) {
                                                                                  context.pushNamed(
                                                                                    'OrderPage',
                                                                                    queryParameters: {
                                                                                      'courseId': serializeParam(
                                                                                        base64Encode(utf8.encode('Course:${FFAppState().courseIdInt.toString()}')),
                                                                                        ParamType.String,
                                                                                      ),
                                                                                      'courseIdInt': serializeParam(
                                                                                        FFAppState().courseIdInt.toString(),
                                                                                        ParamType.String,
                                                                                      ),
                                                                                    }.withoutNulls,
                                                                                  );
                                                                                } else {
                                                                                  context.pushNamed(
                                                                                    'OrderPage',
                                                                                    queryParameters: {
                                                                                      'courseId': serializeParam(
                                                                                        base64Encode(utf8.encode('Course:${FFAppState().courseIdInt.toString()}')),
                                                                                        ParamType.String,
                                                                                      ),
                                                                                      'courseIdInt': serializeParam(
                                                                                        FFAppState().courseIdInt.toString(),
                                                                                        ParamType.String,
                                                                                      ),
                                                                                    }.withoutNulls,
                                                                                  );
                                                                                }
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                16.0,
                                                                                0.0,
                                                                                20.0,
                                                                                0.0),
                                                                            child: Image.asset('assets/images/lock.png',
                                                                                width: 24.0,
                                                                                height: 24.0,
                                                                                fit: BoxFit.cover,
                                                                                color: FlutterFlowTheme.of(context).primaryText),
                                                                          ),
                                                                        )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          16.0,
                                                                          0.0,
                                                                          8.0),
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                height: 100.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBackground,
                                                                ),
                                                                child:
                                                                    Visibility(
                                                                  visible:
                                                                      valueOrDefault<
                                                                          bool>(
                                                                    getJsonField(
                                                                          practiceTestPageGetPracticeTestDetailsForAnExampleSubjectAnatomyResponse
                                                                              .jsonBody,
                                                                          r'''$.data.test.sections''',
                                                                        ) !=
                                                                        null,
                                                                    false,
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            16.0,
                                                                            8.0,
                                                                            16.0,
                                                                            0.0),
                                                                    child:
                                                                        Builder(
                                                                      builder:
                                                                          (context) {
                                                                        final practiceTestSections = PracticeGroup.getPracticeTestDetailsForAnExampleSubjectAnatomyCall
                                                                                .sections(
                                                                                  practiceTestPageGetPracticeTestDetailsForAnExampleSubjectAnatomyResponse.jsonBody,
                                                                                )
                                                                                ?.toList() ??
                                                                            [];
                                                                        return ListView
                                                                            .builder(
                                                                          padding:
                                                                              EdgeInsets.zero,
                                                                          scrollDirection:
                                                                              Axis.vertical,
                                                                          itemCount:
                                                                              practiceTestSections.length,
                                                                          itemBuilder:
                                                                              (context, practiceTestSectionsIndex) {
                                                                            final practiceTestSectionsItem =
                                                                                practiceTestSections[practiceTestSectionsIndex];
                                                                            return Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                                                                              child: InkWell(
                                                                                splashColor: Colors.transparent,
                                                                                focusColor: Colors.transparent,
                                                                                hoverColor: Colors.transparent,
                                                                                highlightColor: Colors.transparent,
                                                                                onTap: () async {
                                                                                  var _shouldSetState = false;
                                                                                  if ((getJsonField(
                                                                                            containerLoggedInUserInformationAndCourseAccessCheckingApiResponse.jsonBody,
                                                                                            r'''$.data.me.userCourses.edges''',
                                                                                          ) !=
                                                                                          null) &&
                                                                                      (SignupGroup.loggedInUserInformationAndCourseAccessCheckingApiCall
                                                                                              .courses(
                                                                                                containerLoggedInUserInformationAndCourseAccessCheckingApiResponse.jsonBody,
                                                                                              )
                                                                                              .length !=
                                                                                          0)) {
                                                                                    _model.offSetN1Copy = await actions.getOffset(
                                                                                      getJsonField(
                                                                                        practiceTestPageGetPracticeTestDetailsForAnExampleSubjectAnatomyResponse.jsonBody,
                                                                                        r'''$.data.test.sectionNumQues''',
                                                                                      )!,
                                                                                      practiceTestSectionsIndex,
                                                                                    );
                                                                                    _shouldSetState = true;

                                                                                    if (FFAppState().showRatingPrompt != -1) {
                                                                                      FFAppState().showRatingPrompt++;
                                                                                    }

                                                                                    print(trial.toString());
                                                                                    print(courseStatus == "PAID");

                                                                                    if ((trial &&
                                                                                            SignupGroup.loggedInUserInformationAndCourseAccessCheckingApiCall
                                                                                                    .courses(
                                                                                                      containerLoggedInUserInformationAndCourseAccessCheckingApiResponse.jsonBody,
                                                                                                    )
                                                                                                    .length >
                                                                                                0 &&
                                                                                            freeChapters.length > 0 &&
                                                                                            freeChapters.contains(int.parse(base64DecodeString(widget.topicId.toString())))) ||
                                                                                        courseStatus == "PAID") {
                                                                                      context.pushNamed(
                                                                                        'PracticeQuetionsPage',
                                                                                        queryParameters: {
                                                                                          'testId': serializeParam(
                                                                                            widget.testId,
                                                                                            ParamType.String,
                                                                                          ),
                                                                                          'offset': serializeParam(
                                                                                            _model.offSetN1Copy,
                                                                                            ParamType.int,
                                                                                          ),
                                                                                          'numberOfQuestions': serializeParam(
                                                                                            getJsonField(
                                                                                              practiceTestPageGetPracticeTestDetailsForAnExampleSubjectAnatomyResponse.jsonBody,
                                                                                              r'''$.data.test.numQuestions''',
                                                                                            ),
                                                                                            ParamType.int,
                                                                                          ),
                                                                                          'sectionPointer': serializeParam(
                                                                                            practiceTestSectionsIndex,
                                                                                            ParamType.int,
                                                                                          ),
                                                                                          'chapterName': serializeParam(
                                                                                            getJsonField(
                                                                                              practiceTestPageGetPracticeTestDetailsForAnExampleSubjectAnatomyResponse.jsonBody,
                                                                                              r'''$.data.test.name''',
                                                                                            ).toString().maybeHandleOverflow(
                                                                                                  maxChars: 25,
                                                                                                  replacement: '…',
                                                                                                ),
                                                                                            ParamType.String,
                                                                                          ),
                                                                                          'courseIdInt': serializeParam(
                                                                                            widget.courseIdInt,
                                                                                            ParamType.int,
                                                                                          ),
                                                                                          'courseIdInts': serializeParam(
                                                                                            widget.courseIdInts,
                                                                                            ParamType.String,
                                                                                          ),
                                                                                        }.withoutNulls,
                                                                                        extra: <String, dynamic>{
                                                                                          kTransitionInfoKey: TransitionInfo(
                                                                                            hasTransition: true,
                                                                                            transitionType: PageTransitionType.rightToLeft,
                                                                                          ),
                                                                                        },
                                                                                      );
                                                                                    } else {
                                                                                      print("helloo");

                                                                                      context.pushNamed(
                                                                                        'OrderPage',
                                                                                        queryParameters: {
                                                                                          'courseId': serializeParam(
                                                                                            base64Encode(utf8.encode('Course:${FFAppState().courseIdInt.toString()}')),
                                                                                            ParamType.String,
                                                                                          ),
                                                                                          'courseIdInt': serializeParam(
                                                                                            FFAppState().courseIdInt.toString(),
                                                                                            ParamType.String,
                                                                                          ),
                                                                                        }.withoutNulls,
                                                                                      );
                                                                                    }

                                                                                    if (_shouldSetState) setState(() {});
                                                                                    return;
                                                                                  } else {
                                                                                    context.pushNamed(
                                                                                      'OrderPage',
                                                                                      queryParameters: {
                                                                                        'courseId': serializeParam(
                                                                                          base64Encode(utf8.encode('Course:${FFAppState().courseIdInt.toString()}')),
                                                                                          ParamType.String,
                                                                                        ),
                                                                                        'courseIdInt': serializeParam(
                                                                                          FFAppState().courseIdInt.toString(),
                                                                                          ParamType.String,
                                                                                        ),
                                                                                      }.withoutNulls,
                                                                                    );
                                                                                  }

                                                                                  if (_shouldSetState) setState(() {});
                                                                                },
                                                                                child: Material(
                                                                                  color: Colors.transparent,
                                                                                  elevation: 2.0,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(16.0),
                                                                                  ),
                                                                                  child: Container(
                                                                                    width: 100.0,
                                                                                    decoration: BoxDecoration(
                                                                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                      boxShadow: [
                                                                                        BoxShadow(
                                                                                          blurRadius: 60.0,
                                                                                          color: Color(0x04060F0D),
                                                                                          offset: Offset(0.0, 4.0),
                                                                                        )
                                                                                      ],
                                                                                      borderRadius: BorderRadius.circular(16.0),
                                                                                    ),
                                                                                    alignment: AlignmentDirectional(0.0, 0.0),
                                                                                    child: Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Expanded(
                                                                                          child: Padding(
                                                                                            padding: EdgeInsetsDirectional.fromSTEB(16.0, 20.0, 15.0, 20.0),
                                                                                            child: Column(
                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Text(
                                                                                                  getJsonField(
                                                                                                    practiceTestSectionsItem,
                                                                                                    r'''$[0]''',
                                                                                                  ).toString().maybeHandleOverflow(
                                                                                                        maxChars: 27,
                                                                                                        replacement: '…',
                                                                                                      ),
                                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                        fontSize: 16.0,
                                                                                                        useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                                      ),
                                                                                                ),
                                                                                                Text(
                                                                                                  '${functions.numberOfQuestins(getJsonField(
                                                                                                        practiceTestPageGetPracticeTestDetailsForAnExampleSubjectAnatomyResponse.jsonBody,
                                                                                                        r'''$.data.test.sectionNumQues''',
                                                                                                      )!, practiceTestSectionsIndex).toString()} questions',
                                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                        color: Color(0xFF858585),
                                                                                                        fontSize: 14.0,
                                                                                                        fontWeight: FontWeight.normal,
                                                                                                        useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                                      ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        if (SignupGroup.loggedInUserInformationAndCourseAccessCheckingApiCall
                                                                                                    .courses(
                                                                                                      containerLoggedInUserInformationAndCourseAccessCheckingApiResponse.jsonBody,
                                                                                                    )
                                                                                                    .length >
                                                                                                0 &&
                                                                                            !trial)
                                                                                          Padding(
                                                                                            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 20.0, 0.0),
                                                                                            child: Image.asset('assets/images/arrow-right.png', width: 24.0, height: 24.0, fit: BoxFit.cover, color: FlutterFlowTheme.of(context).primaryText).animateOnActionTrigger(
                                                                                              animationsMap['imageOnActionTriggerAnimation2']!,
                                                                                            ),
                                                                                          ),
                                                                                        trial
                                                                                            ? SignupGroup.loggedInUserInformationAndCourseAccessCheckingApiCall
                                                                                                            .courses(
                                                                                                              containerLoggedInUserInformationAndCourseAccessCheckingApiResponse.jsonBody,
                                                                                                            )
                                                                                                            .length >
                                                                                                        0 &&
                                                                                                    freeChapters.length > 0 &&
                                                                                                    freeChapters.contains(int.parse(base64DecodeString(widget.topicId.toString())))
                                                                                                ? Padding(
                                                                                                    padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 20.0, 0.0),
                                                                                                    child: Image.asset('assets/images/arrow-right.png', width: 24.0, height: 24.0, fit: BoxFit.cover, color: FlutterFlowTheme.of(context).primaryText).animateOnActionTrigger(
                                                                                                      animationsMap['imageOnActionTriggerAnimation2']!,
                                                                                                    ),
                                                                                                  )
                                                                                                : InkWell(
                                                                                                    onTap: () {
                                                                                                      if (widget.courseIdInt == FFAppState().essentialCourseIdInt) {
                                                                                                        context.pushNamed(
                                                                                                          'OrderPage',
                                                                                                          queryParameters: {
                                                                                                            'courseId': serializeParam(
                                                                                                              base64Encode(utf8.encode('Course:${FFAppState().courseIdInt.toString()}')),
                                                                                                              ParamType.String,
                                                                                                            ),
                                                                                                            'courseIdInt': serializeParam(
                                                                                                              FFAppState().courseIdInt.toString(),
                                                                                                              ParamType.String,
                                                                                                            ),
                                                                                                          }.withoutNulls,
                                                                                                        );
                                                                                                      } else {
                                                                                                        context.pushNamed(
                                                                                                          'OrderPage',
                                                                                                          queryParameters: {
                                                                                                            'courseId': serializeParam(
                                                                                                              base64Encode(utf8.encode('Course:${FFAppState().courseIdInt.toString()}')),
                                                                                                              ParamType.String,
                                                                                                            ),
                                                                                                            'courseIdInt': serializeParam(
                                                                                                              FFAppState().courseIdInt.toString(),
                                                                                                              ParamType.String,
                                                                                                            ),
                                                                                                          }.withoutNulls,
                                                                                                        );
                                                                                                      }
                                                                                                    },
                                                                                                    child: Padding(
                                                                                                      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 20.0, 0.0),
                                                                                                      child: Image.asset('assets/images/lock.png', width: 24.0, height: 24.0, fit: BoxFit.cover, color: FlutterFlowTheme.of(context).primaryText),
                                                                                                    ),
                                                                                                  )
                                                                                            : SizedBox(),
                                                                                        if (SignupGroup.loggedInUserInformationAndCourseAccessCheckingApiCall
                                                                                                .courses(
                                                                                                  containerLoggedInUserInformationAndCourseAccessCheckingApiResponse.jsonBody,
                                                                                                )
                                                                                                .length ==
                                                                                            0)
                                                                                          InkWell(
                                                                                            onTap: () {
                                                                                              if (widget.courseIdInt == FFAppState().essentialCourseIdInt) {
                                                                                                context.pushNamed(
                                                                                                  'OrderPage',
                                                                                                  queryParameters: {
                                                                                                    'courseId': serializeParam(
                                                                                                      base64Encode(utf8.encode('Course:${FFAppState().courseIdInt.toString()}')),
                                                                                                      ParamType.String,
                                                                                                    ),
                                                                                                    'courseIdInt': serializeParam(
                                                                                                      FFAppState().courseIdInt.toString(),
                                                                                                      ParamType.String,
                                                                                                    ),
                                                                                                  }.withoutNulls,
                                                                                                );
                                                                                              } else {
                                                                                                context.pushNamed(
                                                                                                  'OrderPage',
                                                                                                  queryParameters: {
                                                                                                    'courseId': serializeParam(
                                                                                                      base64Encode(utf8.encode('Course:${FFAppState().courseIdInt.toString()}')),
                                                                                                      ParamType.String,
                                                                                                    ),
                                                                                                    'courseIdInt': serializeParam(
                                                                                                      FFAppState().courseIdInt.toString(),
                                                                                                      ParamType.String,
                                                                                                    ),
                                                                                                  }.withoutNulls,
                                                                                                );
                                                                                              }
                                                                                            },
                                                                                            child: Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 20.0, 0.0),
                                                                                              child: Image.asset('assets/images/lock.png', width: 24.0, height: 24.0, fit: BoxFit.cover, color: FlutterFlowTheme.of(context).primaryText),
                                                                                            ),
                                                                                          ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryBackground,
                                                            ),
                                                            child: Visibility(
                                                              visible: SignupGroup
                                                                      .loggedInUserInformationAndCourseAccessCheckingApiCall
                                                                      .courses(
                                                                        containerLoggedInUserInformationAndCourseAccessCheckingApiResponse
                                                                            .jsonBody,
                                                                      )
                                                                      .length <=
                                                                  0,
                                                              child: FutureBuilder<
                                                                  ApiCallResponse>(
                                                                future: PaymentGroup
                                                                    .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                                                                    .call(
                                                                  courseId: widget
                                                                              .courseIdInt
                                                                              .toString() ==
                                                                          FFAppState()
                                                                              .courseIdInt
                                                                              .toString()
                                                                      ? FFAppState()
                                                                          .courseId
                                                                          .toString()
                                                                      : FFAppState()
                                                                          .essentialCourseId
                                                                          .toString(),
                                                                ),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  // Customize what your widget looks like when it's loading.
                                                                  if (!snapshot
                                                                      .hasData) {
                                                                    return Center(
                                                                      child:
                                                                          LinearProgressIndicator(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                      ),
                                                                    );
                                                                  }
                                                                  final containerGetCoursePriceAndCourseOffersToSelectFromToStartPaymentResponse =
                                                                      snapshot
                                                                          .data!;
                                                                  print(containerGetCoursePriceAndCourseOffersToSelectFromToStartPaymentResponse
                                                                      .jsonBody
                                                                      .toString());
                                                                  List<dynamic>
                                                                      prices =
                                                                      PaymentGroup
                                                                          .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                                                                          .offerDiscountedFees(
                                                                              containerGetCoursePriceAndCourseOffersToSelectFromToStartPaymentResponse.jsonBody) as List;

// Assuming prices are strings, convert them to double and find the minimum value.
                                                                  double?
                                                                      minPrice =
                                                                      prices
                                                                          .map<double>((s) => double.parse(s
                                                                              .toString())) // Convert each item to double
                                                                          .reduce((a, b) => a < b
                                                                              ? a
                                                                              : b);
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
                                                                          BorderRadius.circular(
                                                                              12.0),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          16.0,
                                                                          23.0,
                                                                          16.0,
                                                                          25.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                                                                              child: Wrap(
                                                                                spacing: 0.0,
                                                                                runSpacing: 0.0,
                                                                                alignment: WrapAlignment.start,
                                                                                crossAxisAlignment: WrapCrossAlignment.start,
                                                                                direction: Axis.horizontal,
                                                                                runAlignment: WrapAlignment.start,
                                                                                verticalDirection: VerticalDirection.down,
                                                                                clipBehavior: Clip.none,
                                                                                children: [
                                                                                  // Text(
                                                                                  //   'Pay only ',
                                                                                  //   style: FlutterFlowTheme
                                                                                  //       .of(
                                                                                  //       context)
                                                                                  //       .bodyMedium
                                                                                  //       .override(
                                                                                  //     fontFamily: FlutterFlowTheme
                                                                                  //         .of(
                                                                                  //         context)
                                                                                  //         .bodyMediumFamily,
                                                                                  //     color: Colors
                                                                                  //         .white,
                                                                                  //     fontWeight: FontWeight
                                                                                  //         .normal,
                                                                                  //     useGoogleFonts: GoogleFonts
                                                                                  //         .asMap()
                                                                                  //         .containsKey(
                                                                                  //         FlutterFlowTheme
                                                                                  //             .of(
                                                                                  //             context)
                                                                                  //             .bodyMediumFamily),
                                                                                  //   ),
                                                                                  // ),
                                                                                  // Text(
                                                                                  //   '₹ ${(
                                                                                  //       String var1) {
                                                                                  //     return var1
                                                                                  //         .split(
                                                                                  //         '.')
                                                                                  //         .first;
                                                                                  //   }(minPrice.toString())}',
                                                                                  //   style: FlutterFlowTheme
                                                                                  //       .of(
                                                                                  //       context)
                                                                                  //       .bodyMedium
                                                                                  //       .override(
                                                                                  //     fontFamily: FlutterFlowTheme
                                                                                  //         .of(
                                                                                  //         context)
                                                                                  //         .bodyMediumFamily,
                                                                                  //     color: Colors
                                                                                  //         .white,
                                                                                  //     fontWeight: FontWeight
                                                                                  //         .bold,
                                                                                  //     useGoogleFonts: GoogleFonts
                                                                                  //         .asMap()
                                                                                  //         .containsKey(
                                                                                  //         FlutterFlowTheme
                                                                                  //             .of(
                                                                                  //             context)
                                                                                  //             .bodyMediumFamily),
                                                                                  //   ),
                                                                                  // ),
                                                                                  // Text(
                                                                                  //   ' & ',
                                                                                  //   style: FlutterFlowTheme
                                                                                  //       .of(
                                                                                  //       context)
                                                                                  //       .bodyMedium
                                                                                  //       .override(
                                                                                  //     fontFamily: FlutterFlowTheme
                                                                                  //         .of(
                                                                                  //         context)
                                                                                  //         .bodyMediumFamily,
                                                                                  //     color: Colors
                                                                                  //         .white,
                                                                                  //     fontWeight: FontWeight
                                                                                  //         .normal,
                                                                                  //     useGoogleFonts: GoogleFonts
                                                                                  //         .asMap()
                                                                                  //         .containsKey(
                                                                                  //         FlutterFlowTheme
                                                                                  //             .of(
                                                                                  //             context)
                                                                                  //             .bodyMediumFamily),
                                                                                  //   ),
                                                                                  // ),
                                                                                  Text(
                                                                                    'Get ',
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                          color: Colors.white,
                                                                                          fontWeight: FontWeight.normal,
                                                                                          useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                        ),
                                                                                  ),
                                                                                  Text(
                                                                                    'access ',
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                          color: Colors.white,
                                                                                          fontWeight: FontWeight.normal,
                                                                                          useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                        ),
                                                                                  ),
                                                                                  Text(
                                                                                    'to ',
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                          color: Colors.white,
                                                                                          fontWeight: FontWeight.normal,
                                                                                          useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                        ),
                                                                                  ),
                                                                                  Text(
                                                                                    'the ',
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                          color: Colors.white,
                                                                                          fontWeight: FontWeight.normal,
                                                                                          useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                        ),
                                                                                  ),
                                                                                  Text(
                                                                                    'chapters.',
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                          color: Colors.white,
                                                                                          fontWeight: FontWeight.normal,
                                                                                          useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                        ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          InkWell(
                                                                            splashColor:
                                                                                Colors.transparent,
                                                                            focusColor:
                                                                                Colors.transparent,
                                                                            hoverColor:
                                                                                Colors.transparent,
                                                                            highlightColor:
                                                                                Colors.transparent,
                                                                            onTap:
                                                                                () async {
                                                                              FirebaseAnalytics.instance.logEvent(
                                                                                name: 'buy_now_button_click',
                                                                                parameters: {
                                                                                  "courseId": widget.courseIdInt.toString(),
                                                                                },
                                                                              );
                                                                              CleverTapService.recordEvent(
                                                                                'Buy Now Clicked',
                                                                                {
                                                                                  "courseId": serializeParam(
                                                                                    widget.courseIdInt,
                                                                                    ParamType.String,
                                                                                  )
                                                                                },
                                                                              );
                                                                              if (widget.courseIdInt == FFAppState().essentialCourseIdInt) {
                                                                                context.pushNamed(
                                                                                  'OrderPage',
                                                                                  queryParameters: {
                                                                                    'courseId': serializeParam(
                                                                                      base64Encode(utf8.encode('Course:${FFAppState().courseIdInt.toString()}')),
                                                                                      ParamType.String,
                                                                                    ),
                                                                                    'courseIdInt': serializeParam(
                                                                                      FFAppState().courseIdInt.toString(),
                                                                                      ParamType.String,
                                                                                    ),
                                                                                  }.withoutNulls,
                                                                                );
                                                                              } else {
                                                                                context.pushNamed(
                                                                                  'OrderPage',
                                                                                  queryParameters: {
                                                                                    'courseId': serializeParam(
                                                                                      base64Encode(utf8.encode('Course:${FFAppState().courseIdInt.toString()}')),
                                                                                      ParamType.String,
                                                                                    ),
                                                                                    'courseIdInt': serializeParam(
                                                                                      FFAppState().courseIdInt.toString(),
                                                                                      ParamType.String,
                                                                                    ),
                                                                                  }.withoutNulls,
                                                                                );
                                                                              }
                                                                            },
                                                                            child:
                                                                                Material(
                                                                              color: Colors.transparent,
                                                                              elevation: 2.0,
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(10.0),
                                                                              ),
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                                ),
                                                                                child: Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(29.0, 13.0, 29.0, 13.0),
                                                                                  child: Text(
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
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  } else {
                                                    return Container(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .primaryBackground,
                                                      child: Center(
                                                        child: SizedBox(
                                                          width: 50.0,
                                                          height: 50.0,
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                }
                                                return Container();
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              }),
            ));
      },
    );
  }

  Widget AnalyticsWidget(bool showLock, title, testId) {
    return InkWell(
      onTap: !showLock
          ? () {
              context.pushNamed(
                'flutterWebView',
                queryParameters: {
                  'webUrl':
                      "${FFAppState().baseUrl}/newui/essential/chapterAnalytics/analytics?testId=${testId}",
                  'title': "Analytics of " + title
                },
              );
            }
          : null,
      child: Container(
          width: double.infinity,
          height: 60.0,
          child: Padding(
            padding:
                const EdgeInsetsDirectional.fromSTEB(15.0, 5.0, 16.0, 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xfffaecd3),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 16.0, 0.0),
                child: Row(mainAxisSize: MainAxisSize.max, children: [
                  Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 8.0, 0.0),
                      child: SvgPicture.asset(
                        "assets/images/analytics_graph.svg",
                        height: 20,
                      )),
                  Text(
                    'View Analytics',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          fontSize: 14.0,
                          color: Colors.black,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).bodyMediumFamily),
                        ),
                  ),
                  Spacer(),
                  showLock
                      ? InkWell(
                          onTap: () {
                            if (widget.courseIdInt == FFAppState().essentialCourseIdInt) {
                              context.pushNamed(
                                'OrderPage',
                                queryParameters: {
                                  'courseId': serializeParam(
                                    base64Encode(utf8.encode('Course:${FFAppState().courseIdInt.toString()}')),
                                    ParamType.String,
                                  ),
                                  'courseIdInt': serializeParam(
                                    FFAppState().courseIdInt.toString(),
                                    ParamType.String,
                                  ),
                                }.withoutNulls,
                              );
                            } else {
                              context.pushNamed(
                                'OrderPage',
                                queryParameters: {
                                  'courseId': serializeParam(
                                    base64Encode(utf8.encode('Course:${FFAppState().courseIdInt.toString()}')),
                                    ParamType.String,
                                  ),
                                  'courseIdInt': serializeParam(
                                    FFAppState().courseIdInt.toString(),
                                    ParamType.String,
                                  ),
                                }.withoutNulls,
                              );
                            }
                          },
                          child: Image.asset('assets/images/lock.png',
                              width: 24.0,
                              height: 24.0,
                              fit: BoxFit.cover,
                              color: Colors.black),
                        )
                      : Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.black,
                        )
                ]),
              ),
            ),
          )),
    );
  }
}
