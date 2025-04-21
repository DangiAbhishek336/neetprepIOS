import 'dart:async';
import 'dart:developer';

import 'package:expandable/expandable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neetprep_essential/providers/commonProvider.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import '../../../clevertap/clevertap_service.dart';
import '../../../custom_code/widgets/android_web_view.dart';
import '/backend/api_requests/api_calls.dart';
import '/components/bubble_questions/bubble_questions_widget.dart';
import '/components/custom_html_view/custom_html_view_widget.dart';
import '/components/html_question/html_question_widget.dart';
import '/components/report_aproblem/report_aproblem_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import '/flutter_flow/random_data_util.dart' as random_data;
import 'practice_quetions_page_model.dart';
import 'dart:io' show Platform;

export 'practice_quetions_page_model.dart';

class PracticeQuetionsPageWidget extends StatefulWidget {
  const PracticeQuetionsPageWidget(
      {Key? key,
      String? testId,
      int? offset,
      int? numberOfQuestions,
      int? sectionPointer,
      String? chapterName,
      String? courseIdInts,
      int? courseIdInt})
      : this.testId = testId ?? 'dfgdfg',
        this.offset = offset ?? 0,
        this.numberOfQuestions = numberOfQuestions ?? 0,
        this.sectionPointer = sectionPointer ?? 0,
        this.chapterName = chapterName ?? "Chapter",
        this.courseIdInt = courseIdInt ?? 3125,
        this.courseIdInts = courseIdInts ?? "",
        super(key: key);

  final String testId;
  final int offset;
  final int numberOfQuestions;
  final int sectionPointer;
  final String chapterName;
  final int courseIdInt;
  final String courseIdInts;

  @override
  _PracticeQuetionsPageWidgetState createState() =>
      _PracticeQuetionsPageWidgetState();
}

class _PracticeQuetionsPageWidgetState extends State<PracticeQuetionsPageWidget>
    with TickerProviderStateMixin {
  late PracticeQuetionsPageModel _model;

  int quesNoIndex = 0;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = {
    'containerOnActionTriggerAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onActionTrigger,
      applyInitialState: true,
      effects: [
        VisibilityEffect(duration: 1.ms),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 2000.ms,
          duration: 600.ms,
          begin: Offset(0.0, 0.0),
          end: Offset(0.0, 74.0),
        ),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 2000.ms,
          duration: 400.ms,
          begin: 1.0,
          end: 0.0,
        ),
      ],
    ),
  };
  bool firstQuestion = true;
  bool justopened = true;
  String questionStr = "";
  String explanationStr = "";
  ScrollController scrollController = ScrollController();
  final anchor = GlobalKey();
  Timer? _timer;
  int _secondsElapsed = 0;
  bool _isTimerRunning = false;


  void _startTimer({int? initialSeconds}) {
    setState(() {
      _isTimerRunning = true;
      _secondsElapsed = initialSeconds ?? 0;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
      setState(() {
        _isTimerRunning = false;
      });
    }
  }
  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${remainingSeconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:'
          '${remainingSeconds.toString().padLeft(2, '0')}';
    }
  }
  void _onAnswerSubmit() {
     _isTimerRunning = false;
     setState(() {

     });
    _stopTimer();
    // Here, add logic for handling the answer submission.
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PracticeQuetionsPageModel());
    // On page load action.
    FirebaseAnalytics.instance
        .setCurrentScreen(screenName: "PracticeQuestionsPage");
    CleverTapService.recordEvent("Practice Questions Page Opened",{
      "testId":widget.testId,
       "chapterName":widget.chapterName,
       "courseIdInts":widget.courseIdInts,
       "courseIdInt":widget.courseIdInt} );
    SchedulerBinding.instance.addPostFrameCallback((_) async {

      _model.userAccessJson = await SignupGroup
          .loggedInUserInformationAndCourseAccessCheckingApiCall
          .call(
        authToken: FFAppState().subjectToken,
        courseIdInt: widget.courseIdInt,
        altCourseIds: widget.courseIdInt == FFAppState().courseIdInt
            ? FFAppState().courseIdInts
            : widget.courseIdInt == FFAppState().assertionCourseIdInt
                ? FFAppState().assertionCourseIdInts
                : widget.courseIdInt == FFAppState().essentialCourseIdInt
                    ? FFAppState().essentialCourseIdInts
                    : "",
      );
      print("widget.courseIdInts" + widget.courseIdInts.toString());
      print(_model.userAccessJson?.jsonBody.toString());
      if (SignupGroup.loggedInUserInformationAndCourseAccessCheckingApiCall
              .courses(
                (_model.userAccessJson?.jsonBody ?? ''),
              )
              .length >
          0) {
        setState(() {
          _model.isLoading = true;
          _model.quesTitleNumber = widget.offset;
          _model.sectionNumber = widget.sectionPointer;
        });
        _model.statusList = await PracticeGroup
            .getStatusOfAllPracticeQuestionsForATestForAGivenUserCall
            .call(
          testIdInt: functions.getIntFromBase64(widget.testId),
          authToken: FFAppState().subjectToken,
        );
        _model.newStatusList = actions.chkJson(
          PracticeGroup.getStatusOfAllPracticeQuestionsForATestForAGivenUserCall
              .allQuestions(
                (_model.statusList?.jsonBody ?? ''),
              )!
              .toList(),
        );
        setState(() {
          FFAppState().allQuestionsStatus =
              _model.newStatusList!.toList().cast<dynamic>();
        });
        print(  FFAppState().allQuestionsStatus.toString() );
        setState(() {
          _model.isLoading = false;
          _model.currentExplanation = "";
        });


          _secondsElapsed   = getJsonField(
            FFAppState().allQuestionsStatus[_model.quesTitleNumber],
            r'''$.userAnswer.durationInSec''',
          )??0;

          if(getJsonField(FFAppState().allQuestionsStatus[_model.quesTitleNumber], r'''$.userAnswer''',) == null){
            _startTimer(initialSeconds: _secondsElapsed);
            _isTimerRunning = true;}




        return;
      } else {
        context.goNamed(
          'PracticeTestPage',
          queryParameters: {
            'testId': serializeParam(
              widget.testId,
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
        );



        return;
      }


    });

    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
    _model.isRefresh = false;



    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    // int quesNoIndex = 0;
    return FutureBuilder<ApiCallResponse>(
      future: SignupGroup.loggedInUserInformationAndCourseAccessCheckingApiCall
          .call(
        authToken: FFAppState().subjectToken,
        courseIdInt: widget.courseIdInt,
        altCourseIds: widget.courseIdInt == 3125
            ? FFAppState().courseIdInts
            : FFAppState().assertionCourseIdInts,
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).accent9,
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
        final practiceQuetionsPageLoggedInUserInformationAndCourseAccessCheckingApiResponse =
            snapshot.data!;

        return Title(
          title: 'PracticeQuetionsPage',
          color: FlutterFlowTheme.of(context).accent9,
          child: GestureDetector(
            onTap: () =>
                FocusScope.of(context).requestFocus(_model.unfocusNode),
            child: WillPopScope(
              onWillPop: () async => false,
              child: Consumer<CommonProvider>(
                  builder: (context, commonProvider, child) {
                return Scaffold(
                    floatingActionButton:
                        !FFAppState().isScreenshotCaptureDisabled &&
                                !commonProvider.isFeedbackSubmitted
                            ? FloatingActionButton(
                                backgroundColor: Colors.black,
                                onPressed: () {
                                  commonProvider
                                      .showFeedBackFormBottomSheet(context);
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
                        FlutterFlowTheme.of(context).accent9,
                    appBar: AppBar(
                      backgroundColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      automaticallyImplyLeading: false,
                      title: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 20.0, 0.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 29.0,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                widget.chapterName.maybeHandleOverflow(
                                  maxChars: 25,
                                  replacement: '…',
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .headlineMediumFamily,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.normal,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .headlineMediumFamily),
                                    ),
                              ),
                            ],
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              await showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                barrierColor: Color.fromARGB(113, 0, 0, 0),
                                context: context,
                                builder: (context) {
                                  return GestureDetector(
                                    onTap: () => FocusScope.of(context)
                                        .requestFocus(_model.unfocusNode),
                                    child: Padding(
                                      padding:
                                          MediaQuery.of(context).viewInsets,
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                1.0,
                                        child: BubbleQuestionsWidget(
                                          testId: widget.testId,
                                          numberOfQuestions:
                                              widget.numberOfQuestions ,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ).then((value) => setState(
                                  () => _model.selectedPageNumber = value));
                              if (_model.selectedPageNumber != null)
                                await _model.pageViewController?.animateToPage(
                                  _model.selectedPageNumber!,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.ease,
                                );

                              // setState(() {});
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset('assets/images/category.png',
                                  width: 25.0,
                                  height: 25.0,
                                  fit: BoxFit.contain,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText),
                            ),
                          ),
                        ],
                      ),
                      actions: [],
                      centerTitle: false,
                      elevation: 0,
                    ),
                    body: SafeArea(
                      top: true,
                      child: Stack(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (!_model.isLoading)
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .accent9,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            width: double.infinity,
                                            height: 100.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .accent9,
                                            ),
                                            child: Builder(
                                              builder: (context) {
                                                final quetionList = functions
                                                        .testQueTempList(widget
                                                            .numberOfQuestions)
                                                        ?.toList() ??
                                                    [];
                                                if (justopened) {
                                                  _model.quesTitleNumber =
                                                      widget.offset;
                                                  justopened = false;
                                                }
                                                return Container(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .accent9,
                                                  child: PageView.builder(
                                                    controller: _model
                                                            .pageViewController ??=
                                                        PageController(
                                                            initialPage: min(
                                                                valueOrDefault<
                                                                    int>(
                                                                  widget.offset,
                                                                  0,
                                                                ),
                                                                quetionList
                                                                        .length -
                                                                    1)),
                                                    onPageChanged: (_) async {
                                                      _stopTimer();
                                                      questionStr = "";
                                                      explanationStr = "";
                                                      setState(() {
                                                        setState(() {
                                                          FFAppState().allQuestionsStatus = functions.getUpdatedTimer(FFAppState().allQuestionsStatus.toList(), _secondsElapsed,    _model.quesTitleNumber).toList().cast<dynamic>();
                                                        });

                                                        log("_secondsElapsed"+_secondsElapsed.toString());
                                                        _model.showConfetti =
                                                            false;
                                                        _model.confettiParticleCount =
                                                            random_data
                                                                .randomInteger(
                                                                    20, 40);
                                                        _model.confettiGravity =
                                                            random_data
                                                                .randomDouble(
                                                                    0.75, 0.95);

                                                        _model.showExplanation =
                                                            true;
                                                        _model.ncertDropdown =
                                                            false;
                                                        if (justopened) {
                                                          _model.quesTitleNumber =
                                                              widget.offset;
                                                          justopened = false;
                                                        } else {
                                                          _model.quesTitleNumber =
                                                              _model.pageViewController!
                                                                      .page!
                                                                      .round() ??
                                                                  0;
                                                        }
                                                        log( "FFAppState().allQuestionsStatus[_model.quesTitleNumber].toString() "+FFAppState().allQuestionsStatus[_model.quesTitleNumber].toString());
                                                        log("FFAppState().allQuestionsStatus[_model.quesTitleNumber] "+getJsonField(
                                                          FFAppState().allQuestionsStatus[_model.quesTitleNumber],
                                                          r'''$.userAnswer.durationInSec''',
                                                        ).toString());
                                                          _secondsElapsed   = getJsonField(
                                                            FFAppState().allQuestionsStatus[_model.quesTitleNumber],
                                                            r'''$.userAnswer.durationInSec''',
                                                          )??0;
                                                        if(getJsonField(FFAppState().allQuestionsStatus[_model.quesTitleNumber], r'''$.userAnswer''',) == null){
                                                          _secondsElapsed   = getJsonField(
                                                            FFAppState().allQuestionsStatus[_model.quesTitleNumber],
                                                            r'''$.tempDurationInSec''',
                                                          )??0;
                                                          _startTimer( initialSeconds: _secondsElapsed);
                                                          _isTimerRunning = true;
                                                        }


                                                        firstQuestion = false;
                                                      });
                                                    },
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        quetionList.length ,
                                                    itemBuilder: (context,
                                                        quetionListIndex) {
                                                      final quetionListItem =
                                                          quetionList[
                                                              quetionListIndex];
                                                      return Container(
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                        child: Stack(
                                                          children: [
                                                            FutureBuilder<
                                                                ApiCallResponse>(
                                                              future: FFAppState()
                                                                  .testQuestionsCache(
                                                                uniqueQueryKey:
                                                                    '${widget.testId}${functions.getOffsetInt(quetionListIndex).toString()}10${'${DateTime.now().day}-${DateTime.now().month}'}',
                                                                overrideCache:
                                                                    FFAppState()
                                                                            .userIdInt ==
                                                                        null,
                                                                requestFn: () =>
                                                                    PracticeGroup
                                                                        .getPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall
                                                                        .call(
                                                                  testId: widget
                                                                      .testId,
                                                                  offset: functions
                                                                      .getOffsetInt(
                                                                          quetionListIndex),
                                                                  first: 10,
                                                                ),
                                                              ),
                                                              builder: (context,
                                                                  snapshot) {
                                                                // Customize what your widget looks like when it's loading.
                                                                if (!snapshot
                                                                    .hasData) {
                                                                  return Container(
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .accent9,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            50.0,
                                                                        height:
                                                                            50.0,
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primary,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                }
                                                                final columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse =
                                                                    snapshot
                                                                        .data!;
                                                                // print("////" +
                                                                //     columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse
                                                                //         .jsonBody
                                                                //         .toString());
                                                                return Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    // if(quetionListIndex == )
                                                                    FutureBuilder<
                                                                        ApiCallResponse>(
                                                                      future: PracticeGroup
                                                                          .getPracticeTestDetailsForAnExampleSubjectAnatomyCall
                                                                          .call(
                                                                        testId:
                                                                            widget.testId,
                                                                      ),
                                                                      builder:
                                                                          (context,
                                                                              snapshot) {
                                                                        // Customize what your widget looks like when it's loading.
                                                                        if (!snapshot
                                                                            .hasData) {
                                                                          return Center(
                                                                              child: Container(
                                                                            height:
                                                                                0,
                                                                            width:
                                                                                0,
                                                                          ));
                                                                        }
                                                                        final containerGetPracticeTestDetailsForAnExampleSubjectAnatomyResponse =
                                                                            snapshot.data!;
                                                                        //gets index of first question of each section
                                                                        if (widget.courseIdInt ==
                                                                            FFAppState().courseIdInt) {
                                                                          List<
                                                                              dynamic> sortedList = (((PracticeGroup.getPracticeTestDetailsForAnExampleSubjectAnatomyCall.sectionFirstQues(
                                                                                    containerGetPracticeTestDetailsForAnExampleSubjectAnatomyResponse.jsonBody,
                                                                                  ) ??
                                                                                  []) as List)
                                                                              .map<dynamic>((s) => (s))
                                                                              .toList());
                                                                          //we run search on the list to get the index of the question which is less than or equal to the current question number or target
                                                                          int target =
                                                                              _model.quesTitleNumber;
                                                                          int upperBound(
                                                                              List<dynamic> sortedList,
                                                                              int target) {
                                                                            int start =
                                                                                0;
                                                                            int end =
                                                                                sortedList.length - 1;
                                                                            int result =
                                                                                0;

                                                                            while (start <=
                                                                                end) {
                                                                              int mid = start + ((end - start) ~/ 2);

                                                                              if (sortedList[mid] <= target) {
                                                                                result = mid;
                                                                                start = mid + 1;
                                                                              } else {
                                                                                end = mid - 1;
                                                                              }
                                                                            }

                                                                            return result;
                                                                          }

                                                                          _model.sectionNumber = upperBound(
                                                                              sortedList,
                                                                              target + 1);
                                                                          String
                                                                              temp =
                                                                              _model.subTopicName;
                                                                          //get the name of current section
                                                                          _model
                                                                              .subTopicName = (PracticeGroup.getPracticeTestDetailsForAnExampleSubjectAnatomyCall.sections(
                                                                            containerGetPracticeTestDetailsForAnExampleSubjectAnatomyResponse.jsonBody,
                                                                          ) as List)
                                                                              .map<dynamic>((s) => s)
                                                                              .toList()[_model.sectionNumber]
                                                                              .first
                                                                              .toString();
                                                                          if (temp !=
                                                                              _model.subTopicName) {}
                                                                          firstQuestion = (_model.quesTitleNumber + 1 == sortedList[_model.sectionNumber])
                                                                              ? true
                                                                              : false;
                                                                        }

                                                                        return Container(
                                                                          height:
                                                                              0,
                                                                          width:
                                                                              0,
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children: [
                                                                              if (false)
                                                                                ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(8.0),
                                                                                  child: Image.asset(
                                                                                    'assets/images/Screenshot_2023-07-04_125804.png',
                                                                                    width: 50.0,
                                                                                    height: 70.0,
                                                                                    fit: BoxFit.contain,
                                                                                  ),
                                                                                ),
                                                                              if (false)
                                                                                Flexible(
                                                                                  child: Text(
                                                                                    // Congratulations! You have completed the questions of
                                                                                    'Congratulations! You have completed all the questions of ${(PracticeGroup.getPracticeTestDetailsForAnExampleSubjectAnatomyCall.sections(
                                                                                      containerGetPracticeTestDetailsForAnExampleSubjectAnatomyResponse.jsonBody,
                                                                                    ) as List).map<dynamic>((s) => s).toList()[_model.sectionNumber].first.toString()}. Let\'s do some more.',
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium,
                                                                                  ),
                                                                                ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        width: double
                                                                            .infinity,
                                                                        height:
                                                                            double.infinity,
                                                                        constraints:
                                                                            BoxConstraints(
                                                                          minWidth:
                                                                              double.infinity,
                                                                          minHeight:
                                                                              double.infinity,
                                                                          maxWidth:
                                                                              double.infinity,
                                                                          maxHeight:
                                                                              double.infinity,
                                                                        ),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).accent9,
                                                                        ),
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          controller:
                                                                              scrollController,
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children: [
                                                                              if (firstQuestion && _model.subTopicName != '' && widget.courseIdInt == FFAppState().courseIdInt)
                                                                                Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(16, 5, 16, 5),
                                                                                  child: Container(
                                                                                    width: MediaQuery.of(context).size.width,
                                                                                    decoration: BoxDecoration(
                                                                                      color: FlutterFlowTheme.of(context).sectionBackgroundColor,
                                                                                      borderRadius: BorderRadius.circular(8),
                                                                                    ),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(16, 14, 16, 14),
                                                                                      child: Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        children: [
                                                                                          Icon(
                                                                                            Icons.info_outline_rounded,
                                                                                            color: FlutterFlowTheme.of(context).primaryText,
                                                                                            size: 22,
                                                                                          ),
                                                                                          Padding(
                                                                                            padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                                                                            child: Text(
                                                                                              'You are on section: ${_model.subTopicName}',
                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(color: FlutterFlowTheme.of(context).primaryText, fontSize: 15, fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                              //line no 683
                                                                              Container(
                                                                                decoration: BoxDecoration(
                                                                                  color: Color.fromARGB(0, 242, 242, 242),
                                                                                ),
                                                                                child: Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    children: [
                                                                                      Expanded(
                                                                                        child: Container(
                                                                                          width: 100.0,
                                                                                          height: 50.0,
                                                                                          decoration: BoxDecoration(
                                                                                            color: Color.fromARGB(0, 242, 242, 242),
                                                                                          ),
                                                                                          child: Row(
                                                                                            mainAxisSize: MainAxisSize.max,
                                                                                            children: [
                                                                                              if ((PracticeGroup.getPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall.testTags(
                                                                                                            columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                                          ) ??
                                                                                                          [])
                                                                                                      .toList()
                                                                                                      .asMap()[functions.getOffsetListQueIndex(quetionListIndex)]
                                                                                                      ?.isNotEmpty ??
                                                                                                  false)
                                                                                                Flexible(
                                                                                                  child: Container(
                                                                                                    child: Column(
                                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      children: [
                                                                                                        SingleChildScrollView(
                                                                                                          scrollDirection: Axis.horizontal,
                                                                                                          child: Row(
                                                                                                            children: List.generate(1, (index) {
                                                                                                              final items = List.generate(
                                                                                                                (PracticeGroup.getPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall.testTags(
                                                                                                                  columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                                                ) ??
                                                                                                                    [])
                                                                                                                    .toList()
                                                                                                                    .asMap()[functions.getOffsetListQueIndex(quetionListIndex)]
                                                                                                                    .length,
                                                                                                                    (index) => '$index',
                                                                                                              );

                                                                                                              return Column(
                                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                children: [
                                                                                                                  Wrap(
                                                                                                                    spacing: 4.0, // Space between items horizontally
                                                                                                                    runSpacing: 5.0, // Space between rows vertically
                                                                                                                    children: items.map((item) {
                                                                                                                      return Container(
                                                                                                                        decoration: BoxDecoration(
                                                                                                                          borderRadius: BorderRadius.circular(8.0),
                                                                                                                        ),
                                                                                                                        child: Padding(
                                                                                                                          padding: EdgeInsetsDirectional.fromSTEB(2.0, 0.0, 2.0, 0.0),
                                                                                                                          child: Container(
                                                                                                                            decoration: BoxDecoration(
                                                                                                                              color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                                                              border: Border.all(
                                                                                                                                color: FlutterFlowTheme.of(context).primary,
                                                                                                                                width: 1.0,
                                                                                                                              ),
                                                                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                                                                            ),
                                                                                                                            child: Padding(
                                                                                                                              padding: EdgeInsetsDirectional.fromSTEB(12.0, 3.0, 12.0, 3.0),
                                                                                                                              child: Text(
                                                                                                                                (PracticeGroup.getPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall.testTags(
                                                                                                                                  columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                                                                ) as List)
                                                                                                                                    .asMap()[functions.getOffsetListQueIndex(quetionListIndex)][int.parse(item)]['node']['tag']
                                                                                                                                    .toString()
                                                                                                                                    .toUpperCase(),
                                                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                                  color: FlutterFlowTheme.of(context).primary,
                                                                                                                                  fontSize: 12.0,
                                                                                                                                  useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      );
                                                                                                                    }).toList(),
                                                                                                                  ),
                                                                                                                ],
                                                                                                              );
                                                                                                            }),
                                                                                                          )
                                                                                                          ,
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                )
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                child: Stack(
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
                                                                                      child: Column(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        children: [
                                                                                          Material(
                                                                                            color: Colors.transparent,
                                                                                            elevation: 0,
                                                                                            shape: RoundedRectangleBorder(
                                                                                              borderRadius: BorderRadius.circular(12.0),
                                                                                            ),
                                                                                            child: GestureDetector(
                                                                                              onVerticalDragStart: (DragStartDetails details) {},
                                                                                              child: Container(
                                                                                                height: MediaQuery.of(context).size.height * 0.4,
                                                                                                decoration: BoxDecoration(
                                                                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                                  borderRadius: BorderRadius.circular(8.0),
                                                                                                  // border: Border.all(
                                                                                                  //   color: FlutterFlowTheme.of(context).secondaryBorderColor,
                                                                                                  //   width: 1.0,
                                                                                                  // ),
                                                                                                  boxShadow: [
                                                                                                    BoxShadow(
                                                                                                      blurRadius: 15.0,
                                                                                                      color: Color.fromARGB(16, 0, 0, 0),
                                                                                                      offset: Offset(0.0, 10.0),
                                                                                                    )
                                                                                                  ],
                                                                                                ),
                                                                                                child: kIsWeb || Platform.isIOS
                                                                                                    ? Padding(
                                                                                                        padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                                                                                                        child: HtmlQuestionWidget(
                                                                                                          key: Key('Key92a_${quetionListIndex}_of_${quetionList.length}'),
                                                                                                          questionHtmlStr: (PracticeGroup.getPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall.testHtmlQuestionsArr(
                                                                                                                columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                                              ) as List)
                                                                                                                  .map<String>((s) => s.toString())
                                                                                                                  .toList()[functions.getOffsetListQueIndex(quetionListIndex)] +
                                                                                                              questionStr,
                                                                                                        ),
                                                                                                      )
                                                                                                    : Padding(
                                                                                                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                                                                                                        child: AndroidWebView(
                                                                                                            html: (PracticeGroup.getPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall.testHtmlQuestionsArr(
                                                                                                          columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                                        ) as List)
                                                                                                                .map<String>((s) => s.toString())
                                                                                                                .toList()[functions.getOffsetListQueIndex(quetionListIndex)])),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Positioned(
                                                                                      right: 5,
                                                                                      top: 10,
                                                                                      child: Container(
                                                                                        height:28,
                                                                                        width:28,
                                                                                        decoration: BoxDecoration(
                                                                                          color: Color.fromRGBO(255, 255, 255, 0.5), // 50% transparent white
                                                                                          borderRadius: BorderRadius.circular(8.0),
                                                                                          border: Border.all(
                                                                                            color: FlutterFlowTheme.of(context).secondaryBorderColor,
                                                                                            width: 1.0,
                                                                                          ),
                                                                                        ),
                                                                                        child: Padding(
                                                                                          padding: EdgeInsetsDirectional.fromSTEB(4.0, 4.0, 4.0, 4.0),
                                                                                          child: InkWell(
                                                                                              splashColor: Colors.transparent,
                                                                                              focusColor: Colors.transparent,
                                                                                              hoverColor: Colors.transparent,
                                                                                              highlightColor: Colors.transparent,
                                                                                              onTap: () async {
                                                                                                if (kIsWeb || Platform.isIOS) {
                                                                                                  questionStr = "<span class=\"display_webview\"></span>";
                                                                                                  setState(() {});
                                                                                                } else {
                                                                                                  setState(() {});
                                                                                                  showDialog(
                                                                                                      context: context,
                                                                                                      builder: (_) {
                                                                                                        return Padding(
                                                                                                            padding: const EdgeInsets.all(5),
                                                                                                            child: AndroidWebView(
                                                                                                                html: (PracticeGroup.getPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall.testHtmlQuestionsArr(
                                                                                                              columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                                            ) as List)
                                                                                                                    .map<String>((s) => s.toString())
                                                                                                                    .toList()[functions.getOffsetListQueIndex(quetionListIndex)]));
                                                                                                      });
                                                                                                }
                                                                                              },
                                                                                              child: kIsWeb || Platform.isIOS ? Icon(Icons.refresh) : SvgPicture.asset("assets/images/enlarge.svg", color: FlutterFlowTheme.of(context).primaryText),),
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                                                                                child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                                    children:[
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                                                                                        child: Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            Container(
                                                                                              decoration: BoxDecoration(
                                                                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                              ),
                                                                                              child: Visibility(
                                                                                                visible: getJsonField(
                                                                                                  FFAppState().allQuestionsStatus[quetionListIndex],
                                                                                                  r'''$.starmarkQuestion''',
                                                                                                ) !=
                                                                                                    null,
                                                                                                child: Padding(
                                                                                                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
                                                                                                  child: InkWell(
                                                                                                    splashColor: Colors.transparent,
                                                                                                    focusColor: Colors.transparent,
                                                                                                    hoverColor: Colors.transparent,
                                                                                                    highlightColor: Colors.transparent,
                                                                                                    onTap: () async {
                                                                                                      setState(() {
                                                                                                        FFAppState().allQuestionsStatus = functions.getupdatedStarmarkRemove(FFAppState().allQuestionsStatus.toList(), FFAppState().starMarkEmptyJson, quetionListIndex).toList().cast<dynamic>();
                                                                                                      });

                                                                                                      final userIdBase64 = functions.getBase64OfUserId(FFAppState().userIdInt);
                                                                                                      final questionIdBase64 =(PracticeGroup.getPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall.testQuestionIdArr(
                                                                                                        columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                                      ) as List)
                                                                                                          .map<String>((s) => s.toString())
                                                                                                          .toList()[functions.getOffsetListQueIndex(quetionListIndex)];

                                                                                                      // Perform the mutation call
                                                                                                      final response = await CreateOrDeleteStarmarkQuestionCall().call(
                                                                                                        questionId: questionIdBase64,
                                                                                                        userId: userIdBase64!,
                                                                                                        authToken: FFAppState().subjectToken,
                                                                                                      );

                                                                                                      if (response.succeeded) {
                                                                                                        print("Mutation successful: ${response.jsonBody}");

                                                                                                      } else {
                                                                                                        print("Error: ${response.response?.body} ${response.response?.request}");
                                                                                                      }

                                                                                                      setState(() {});
                                                                                                    },
                                                                                                    child: SvgPicture.asset('assets/images/star.svg', width: 22.0, height: 22.0, fit: BoxFit.cover, color: FlutterFlowTheme.of(context).primaryText),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            Container(
                                                                                              decoration: BoxDecoration(
                                                                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                              ),
                                                                                              child: Visibility(
                                                                                                visible: getJsonField(
                                                                                                  FFAppState().allQuestionsStatus[quetionListIndex],
                                                                                                  r'''$.starmarkQuestion''',
                                                                                                ) ==
                                                                                                    null,
                                                                                                child: Padding(
                                                                                                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
                                                                                                  child: InkWell(
                                                                                                    splashColor: Colors.transparent,
                                                                                                    focusColor: Colors.transparent,
                                                                                                    hoverColor: Colors.transparent,
                                                                                                    highlightColor: Colors.transparent,
                                                                                                    // onTap: () async {
                                                                                                    //   setState(() {
                                                                                                    //     FFAppState().allQuestionsStatus = functions.getupdatedBookmark(FFAppState().allQuestionsStatus.toList(), FFAppState().bookMarkEmptyJson, quetionListIndex).toList().cast<dynamic>();
                                                                                                    //   });
                                                                                                    //   _model.apiResultdn1 = await PracticeGroup.createOrDeleteBookmarkForAPracticeQuestionByAUserCall.call(
                                                                                                    //     questionId: (PracticeGroup.getPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall.testQuestionIdArr(
                                                                                                    //       columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                                    //     ) as List)
                                                                                                    //         .map<String>((s) => s.toString())
                                                                                                    //         .toList()[functions.getOffsetListQueIndex(quetionListIndex)],
                                                                                                    //     userId: functions.getBase64OfUserId(FFAppState().userIdInt),
                                                                                                    //     authToken: FFAppState().subjectToken,
                                                                                                    //   );

                                                                                                    //   setState(() {});
                                                                                                    // },
                                                                                                    onTap: () async {
                                                                                                      setState(() {
                                                                                                        // Optionally, update your UI state
                                                                                                        FFAppState().allQuestionsStatus = functions.getupdatedStarmark(
                                                                                                            FFAppState().allQuestionsStatus.toList(),
                                                                                                            FFAppState().starMarkEmptyJson,
                                                                                                            quetionListIndex
                                                                                                        ).toList().cast<dynamic>();
                                                                                                      });
                                                                                                      final userIdBase64 = functions.getBase64OfUserId(FFAppState().userIdInt);
                                                                                                      final questionIdBase64 =(PracticeGroup.getPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall.testQuestionIdArr(
                                                                                                        columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                                      ) as List)
                                                                                                          .map<String>((s) => s.toString())
                                                                                                          .toList()[functions.getOffsetListQueIndex(quetionListIndex)];

                                                                                                      // Perform the mutation call
                                                                                                      final response = await CreateOrDeleteStarmarkQuestionCall().call(
                                                                                                        questionId: questionIdBase64,
                                                                                                        userId: userIdBase64!,
                                                                                                        authToken: FFAppState().subjectToken,
                                                                                                      );

                                                                                                      if (response.succeeded) {
                                                                                                        print("Mutation successful: ${response.jsonBody}");

                                                                                                      } else {
                                                                                                        print("Error: ${response.response?.body} ${response.response?.request}");
                                                                                                      }
                                                                                                      setState(() {

                                                                                                      });
                                                                                                    },

                                                                                                    child: SvgPicture.asset('assets/images/star_outline.svg', width: 22.0, height: 22.0, fit: BoxFit.cover, color: FlutterFlowTheme.of(context).primaryText),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                                                                                        child: Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            Container(
                                                                                              decoration: BoxDecoration(
                                                                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                              ),
                                                                                              child: Visibility(
                                                                                                visible: getJsonField(
                                                                                                  FFAppState().allQuestionsStatus[quetionListIndex],
                                                                                                  r'''$.bookmarkQuestion''',
                                                                                                ) !=
                                                                                                    null,
                                                                                                child: Padding(
                                                                                                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
                                                                                                  child: InkWell(
                                                                                                    splashColor: Colors.transparent,
                                                                                                    focusColor: Colors.transparent,
                                                                                                    hoverColor: Colors.transparent,
                                                                                                    highlightColor: Colors.transparent,
                                                                                                    onTap: () async {
                                                                                                      setState(() {
                                                                                                        FFAppState().allQuestionsStatus = functions.getupdatedBookmarkRemove(FFAppState().allQuestionsStatus.toList(), FFAppState().bookMarkEmptyJson, quetionListIndex).toList().cast<dynamic>();
                                                                                                      });
                                                                                                      _model.apiResultdn0 = await PracticeGroup.createOrDeleteBookmarkForAPracticeQuestionByAUserCall.call(
                                                                                                        questionId: (PracticeGroup.getPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall.testQuestionIdArr(
                                                                                                          columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                                        ) as List)
                                                                                                            .map<String>((s) => s.toString())
                                                                                                            .toList()[functions.getOffsetListQueIndex(quetionListIndex)],
                                                                                                        userId: functions.getBase64OfUserId(FFAppState().userIdInt),
                                                                                                        authToken: FFAppState().subjectToken,
                                                                                                      );

                                                                                                      setState(() {});
                                                                                                    },
                                                                                                    child: Icon(
                                                                                                      Icons.bookmark_sharp,
                                                                                                      color: FlutterFlowTheme.of(context).primaryText,
                                                                                                      size: 22.0,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            Container(
                                                                                              decoration: BoxDecoration(
                                                                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                              ),
                                                                                              child: Visibility(
                                                                                                visible: getJsonField(
                                                                                                  FFAppState().allQuestionsStatus[quetionListIndex],
                                                                                                  r'''$.bookmarkQuestion''',
                                                                                                ) ==
                                                                                                    null,
                                                                                                child: Padding(
                                                                                                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
                                                                                                  child: InkWell(
                                                                                                    splashColor: Colors.transparent,
                                                                                                    focusColor: Colors.transparent,
                                                                                                    hoverColor: Colors.transparent,
                                                                                                    highlightColor: Colors.transparent,
                                                                                                    onTap: () async {
                                                                                                      setState(() {
                                                                                                        FFAppState().allQuestionsStatus = functions.getupdatedBookmark(FFAppState().allQuestionsStatus.toList(), FFAppState().bookMarkEmptyJson, quetionListIndex).toList().cast<dynamic>();
                                                                                                      });
                                                                                                      _model.apiResultdn1 = await PracticeGroup.createOrDeleteBookmarkForAPracticeQuestionByAUserCall.call(
                                                                                                        questionId: (PracticeGroup.getPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall.testQuestionIdArr(
                                                                                                          columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                                        ) as List)
                                                                                                            .map<String>((s) => s.toString())
                                                                                                            .toList()[functions.getOffsetListQueIndex(quetionListIndex)],
                                                                                                        userId: functions.getBase64OfUserId(FFAppState().userIdInt),
                                                                                                        authToken: FFAppState().subjectToken,
                                                                                                      );

                                                                                                      setState(() {});
                                                                                                    },
                                                                                                    child: Icon(
                                                                                                      Icons.bookmark_border,
                                                                                                      color: FlutterFlowTheme.of(context).primaryText,
                                                                                                      size: 22.0,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                       if(_isTimerRunning)
                                                                                         Padding(
                                                                                           padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                                                                                           child: Container(
                                                                                             decoration: BoxDecoration(
                                                                                               color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                               borderRadius: BorderRadius.circular(8.0),
                                                                                             ),
                                                                                             child: Padding(
                                                                                               padding: EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
                                                                                               child:Text(_formatTime(_secondsElapsed), style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                 fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                 fontSize: 12.0,
                                                                                                 useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                               )),
                                                                                             ),
                                                                                           ),
                                                                                         ),
                                                                                         if(!_isTimerRunning)
                                                                                           if(getJsonField(FFAppState().allQuestionsStatus[quetionListIndex], r'''$.userAnswer''',) == null)
                                                                                             Padding(
                                                                                               padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                                                                                               child: Container(
                                                                                                 decoration: BoxDecoration(
                                                                                                   color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                                   borderRadius: BorderRadius.circular(8.0),
                                                                                                 ),
                                                                                                 child: Padding(
                                                                                                   padding: EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
                                                                                                   child: InkWell(
                                                                                                     splashColor: Colors.transparent,
                                                                                                     focusColor: Colors.transparent,
                                                                                                     hoverColor: Colors.transparent,
                                                                                                     highlightColor: Colors.transparent,
                                                                                                     onTap: () async {
                                                                                                       _startTimer(initialSeconds: _secondsElapsed);
                                                                                                     },
                                                                                                     child: SvgPicture.asset('assets/images/timer.svg', width: 22.0, height: 22.0, fit: BoxFit.cover, color: FlutterFlowTheme.of(context).primaryText),
                                                                                                   ),
                                                                                                 ),
                                                                                               ),
                                                                                             )
                                                                                             else
                                                                                             Padding(
                                                                                               padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                                                                                               child: Container(
                                                                                                 decoration: BoxDecoration(
                                                                                                   color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                                   borderRadius: BorderRadius.circular(8.0),
                                                                                                 ),
                                                                                                 child: Padding(
                                                                                                   padding: EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
                                                                                                   child:Text(_formatTime(_secondsElapsed), style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                     fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                     fontSize: 12.0,
                                                                                                     useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                                   )),
                                                                                                 ),
                                                                                               ),
                                                                                             ),
                                                                                      Container(
                                                                                        decoration: BoxDecoration(
                                                                                          color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                          borderRadius: BorderRadius.circular(8.0),
                                                                                        ),
                                                                                        child: Padding(
                                                                                          padding: EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
                                                                                          child: InkWell(
                                                                                            splashColor: Colors.transparent,
                                                                                            focusColor: Colors.transparent,
                                                                                            hoverColor: Colors.transparent,
                                                                                            highlightColor: Colors.transparent,
                                                                                            onTap: () async {
                                                                                              await showModalBottomSheet(
                                                                                                isScrollControlled: true,
                                                                                                backgroundColor: Color.fromARGB(113, 43, 43, 43),
                                                                                                barrierColor: Color.fromARGB(134, 85, 85, 85),
                                                                                                enableDrag: true,
                                                                                                context: context,
                                                                                                builder: (context) {
                                                                                                  return GestureDetector(
                                                                                                    onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
                                                                                                    child: Padding(
                                                                                                      padding: MediaQuery.of(context).viewInsets,
                                                                                                      child: Container(
                                                                                                        height: MediaQuery.of(context).size.height * 1.0,
                                                                                                        child: ReportAproblemWidget(
                                                                                                          testId: widget.testId,
                                                                                                          questionId: (PracticeGroup.getPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall.testQuestionIdArr(
                                                                                                            columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                                          ) as List)
                                                                                                              .map<String>((s) => s.toString())
                                                                                                              .toList()[functions.getOffsetListQueIndex(quetionListIndex)],
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  );
                                                                                                },
                                                                                              ).then((value) => setState(() {}));
                                                                                            },
                                                                                            child: Icon(
                                                                                              Icons.more_vert,
                                                                                              color: FlutterFlowTheme.of(context).primaryText,
                                                                                              size: 22.0,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ]
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),

                                                                    Container(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0,
                                                                          .0),
                                                                      child:
                                                                          Builder(
                                                                        builder:
                                                                            (context) {
                                                                          final queNumbers = FFAppState()
                                                                              .questionNumbers
                                                                              .toList();
                                                                          return Column(
                                                                            children: [
                                                                              if ((getJsonField(
                                                                                        FFAppState().allQuestionsStatus[quetionListIndex],
                                                                                        r'''$.userAnswer''',
                                                                                      ) !=
                                                                                      null) &&
                                                                                  (((PracticeGroup.getPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall.testHtmlExplanationsArr(
                                                                                            columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                          ) as List)
                                                                                              .map<String>((s) => s.toString())
                                                                                              .toList()[functions.getOffsetListQueIndex(quetionListIndex)] !=
                                                                                          '') &&
                                                                                      ((PracticeGroup.getPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall.testHtmlExplanationsArr(
                                                                                            columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                          ) as List)
                                                                                              .map<String>((s) => s.toString())
                                                                                              .toList()[functions.getOffsetListQueIndex(quetionListIndex)] !=
                                                                                          'null')) && PracticeGroup.getPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall.haveNcertSentenceAtIndex(columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody, functions.getOffsetListQueIndex(quetionListIndex)).toString()!='' )
                                                                                Container(
                                                                                  color: FlutterFlowTheme.of(context).accent9,
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 10.0),
                                                                                        child: InkWell(
                                                                                          splashColor: Colors.transparent,
                                                                                          focusColor: Colors.transparent,
                                                                                          hoverColor: Colors.transparent,
                                                                                          highlightColor: Colors.transparent,
                                                                                          onTap: () async {
                                                                                            final explanationIndex = functions.getOffsetListQueIndex(quetionListIndex);
                                                                                            var response =  columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody;
                                                                                            dynamic getSentenceAtIndex(dynamic response, int questionIndex) => getJsonField(
                                                                                              response,
                                                                                              r'''$.data.test.questions.edges[''' + questionIndex.toString() + r'''].node.ncertSentences.edges[:].node''',
                                                                                              true
                                                                                            );
                                                                                            final sentences = getSentenceAtIndex(response, explanationIndex);
                                                                                            _model.showNcertSentencesBottomSheet(context, sentences);

                                                                                          },
                                                                                          child: Container(
                                                                                            decoration: BoxDecoration(
                                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                                              border: Border.all(
                                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                                              ),
                                                                                            ),
                                                                                            child: Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
                                                                                              child: Text(
                                                                                                'NCERT Ref.',
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                  fontSize: 12.0,
                                                                                                  useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 10.0),
                                                                                        child: InkWell(
                                                                                          splashColor: Colors.transparent,
                                                                                          focusColor: Colors.transparent,
                                                                                          hoverColor: Colors.transparent,
                                                                                          highlightColor: Colors.transparent,
                                                                                          onTap: () async {
                                                                                            final explanationIndex = functions.getOffsetListQueIndex(quetionListIndex);
                                                                                            final explanation = (PracticeGroup.getPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall.testHtmlExplanationsArr(
                                                                                              columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                            ) as List)
                                                                                                .map<String>((s) => s.toString())
                                                                                                .toList()[explanationIndex];

                                                                                            setState(() {
                                                                                              _model.currentExplanation = explanation;
                                                                                            });
                                                                                            showModalBottomSheet(
                                                                                                context: context,
                                                                                                backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                                shape: const RoundedRectangleBorder(
                                                                                                  borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                                                                                                ),
                                                                                                builder: (_) {
                                                                                                  return SingleChildScrollView(
                                                                                                    child: Column(
                                                                                                      children: [
                                                                                                        Container(
                                                                                                          padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                                                                                                          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                                                                                            GestureDetector(
                                                                                                              onTap: () {
                                                                                                                Navigator.pop(context);
                                                                                                              },
                                                                                                              child: Container(
                                                                                                                decoration: BoxDecoration(
                                                                                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                                                                  border: Border.all(
                                                                                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                                                                                  ),
                                                                                                                ),
                                                                                                                child: Padding(
                                                                                                                  padding: EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
                                                                                                                  child: Text(
                                                                                                                    'Hide NCERT Line',
                                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                          fontSize: 12.0,
                                                                                                                          useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                                                        ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ]),
                                                                                                        ),
                                                                                                        Padding(
                                                                                                          padding: EdgeInsetsDirectional.fromSTEB(16, 40, 16, 16),
                                                                                                          child: Material(
                                                                                                            color: Colors.transparent,
                                                                                                            elevation: 0,
                                                                                                            shape: RoundedRectangleBorder(
                                                                                                              borderRadius: BorderRadius.circular(16),
                                                                                                            ),
                                                                                                            child: InkWell(
                                                                                                              splashColor: Colors.transparent,
                                                                                                              focusColor: Colors.transparent,
                                                                                                              hoverColor: Colors.transparent,
                                                                                                              highlightColor: Colors.transparent,
                                                                                                              onTap: () async {
                                                                                                                setState(() {
                                                                                                                  _model.ncertDropdown = !_model.ncertDropdown;
                                                                                                                });
                                                                                                              },
                                                                                                              child: Container(
                                                                                                                width: double.infinity,
                                                                                                                decoration: BoxDecoration(
                                                                                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                                                  boxShadow: [
                                                                                                                    BoxShadow(
                                                                                                                      blurRadius: 15,
                                                                                                                      color: Color.fromRGBO(0, 0, 0, 0.1),
                                                                                                                      offset: Offset(0, 10),
                                                                                                                      spreadRadius: 0,
                                                                                                                    )
                                                                                                                  ],
                                                                                                                  borderRadius: BorderRadius.circular(16),
                                                                                                                  border: Border.all(
                                                                                                                    color: FlutterFlowTheme.of(context).secondaryBorderColor,
                                                                                                                    width: 1,
                                                                                                                  ),
                                                                                                                ),
                                                                                                                child: Padding(
                                                                                                                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 8.0),
                                                                                                                  child: Container(
                                                                                                                    width: double.infinity,
                                                                                                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                                                    child: ExpandableNotifier(
                                                                                                                      initialExpanded: true,
                                                                                                                      child: ExpandablePanel(
                                                                                                                        header: Text(
                                                                                                                          'Question from this NCERT line',
                                                                                                                          style: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                                                                fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                                                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                                                                                fontSize: 14.0,
                                                                                                                                fontWeight: FontWeight.w600,
                                                                                                                                useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).titleSmallFamily),
                                                                                                                              ),
                                                                                                                        ),
                                                                                                                        collapsed: Container(
                                                                                                                          height: 0.0,
                                                                                                                          decoration: BoxDecoration(
                                                                                                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        expanded: Padding(
                                                                                                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                                                                                                                          child: Builder(builder: (context) {
                                                                                                                            final subTopicList = PracticeGroup.getPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall
                                                                                                                                    .showMeNcert(
                                                                                                                                      columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                                                                    )
                                                                                                                                    ?.toList()[functions.getOffsetListQueIndex(quetionListIndex)] ??
                                                                                                                                [];
                                                                                                                            //  data =  (PracticeGroup.getPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall.testHtmlFullExplanationsArr(columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,) as List).map<String>((s) => s.toString()).toList()[functions.getOffsetListQueIndex(quetionListIndex)];

                                                                                                                            return Column(
                                                                                                                                mainAxisSize: MainAxisSize.max,
                                                                                                                                children: List.generate(subTopicList.length, (subTopicListIndex) {
                                                                                                                                  final subTopicListItem = subTopicList[subTopicListIndex];
                                                                                                                                  if (RegExp(r'<(audio|iframe|table)\b[^>]*>').hasMatch(functions.converHtmlIntoString(
                                                                                                                                        getJsonField(
                                                                                                                                          subTopicListItem,
                                                                                                                                          r'''$.node.sentenceHtml''',
                                                                                                                                        ).toString(),
                                                                                                                                      )) ||
                                                                                                                                      RegExp(r'(<math.*>.*</math>|math-tex)').hasMatch(functions.converHtmlIntoString(
                                                                                                                                        getJsonField(
                                                                                                                                          subTopicListItem,
                                                                                                                                          r'''$.node.sentenceHtml''',
                                                                                                                                        ).toString(),
                                                                                                                                      ))) {
                                                                                                                                    return wrapWithModel(
                                                                                                                                      model: _model.customHtmlViewModels1.getModel(
                                                                                                                                        'QuestionListId:ncert:${getJsonField(
                                                                                                                                          quetionListItem,
                                                                                                                                          r'''$.id''',
                                                                                                                                        ).toString()}',
                                                                                                                                        quetionListIndex,
                                                                                                                                      ),
                                                                                                                                      updateCallback: () => setState(() {}),
                                                                                                                                      child: custom_widgets.CustomWebView(
                                                                                                                                        height: 50,
                                                                                                                                        width: MediaQuery.of(context).size.width * 0.9,
                                                                                                                                        src: functions.converHtmlIntoString(
                                                                                                                                          getJsonField(
                                                                                                                                            subTopicListItem,
                                                                                                                                            r'''$.node.sentenceHtml''',
                                                                                                                                          ).toString(),
                                                                                                                                        ),
                                                                                                                                      ),
                                                                                                                                    );
                                                                                                                                  } else {
                                                                                                                                    return wrapWithModel(
                                                                                                                                      model: _model.customHtmlViewModels1.getModel(
                                                                                                                                        'QuestionListId:ncert:${getJsonField(
                                                                                                                                          quetionListItem,
                                                                                                                                          r'''$.id''',
                                                                                                                                        ).toString()}',
                                                                                                                                        quetionListIndex,
                                                                                                                                      ),
                                                                                                                                      updateCallback: () => setState(() {}),
                                                                                                                                      child: CustomHtmlViewWidget(
                                                                                                                                        key: Key(
                                                                                                                                          'Keytb7_${'QuestionListId:ncert:${getJsonField(
                                                                                                                                            quetionListItem,
                                                                                                                                            r'''$.id''',
                                                                                                                                          ).toString()}'}',
                                                                                                                                        ),
                                                                                                                                        questionStr: functions.converHtmlIntoString(
                                                                                                                                          getJsonField(
                                                                                                                                            subTopicListItem,
                                                                                                                                            r'''$.node.sentenceHtml''',
                                                                                                                                          ).toString(),
                                                                                                                                        ),
                                                                                                                                      ),
                                                                                                                                    );
                                                                                                                                  }
                                                                                                                                }));
                                                                                                                          }),
                                                                                                                        ),
                                                                                                                        theme: ExpandableThemeData(tapHeaderToExpand: true, tapBodyToExpand: false, tapBodyToCollapse: false, headerAlignment: ExpandablePanelHeaderAlignment.center, hasIcon: false, iconColor: FlutterFlowTheme.of(context).primaryText),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  );
                                                                                                });
                                                                                          },
                                                                                          child: Container(
                                                                                            decoration: BoxDecoration(
                                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                                              border: Border.all(
                                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                                              ),
                                                                                            ),
                                                                                            child: Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
                                                                                              child: Text(
                                                                                                'Show NCERT Line',
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                      fontSize: 12.0,
                                                                                                      useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                                    ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 10.0),
                                                                                        child: InkWell(
                                                                                          splashColor: Colors.transparent,
                                                                                          focusColor: Colors.transparent,
                                                                                          hoverColor: Colors.transparent,
                                                                                          highlightColor: Colors.transparent,
                                                                                          onTap: () async {
                                                                                            final explanationIndex = functions.getOffsetListQueIndex(quetionListIndex);
                                                                                            final explanation = (PracticeGroup.getPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall.testHtmlExplanationsArr(
                                                                                              columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                            ) as List)
                                                                                                .map<String>((s) => s.toString())
                                                                                                .toList()[explanationIndex];

                                                                                            setState(() {
                                                                                              _model.currentExplanation = explanation;
                                                                                            });
                                                                                            kIsWeb || Platform.isIOS
                                                                                                ? showModalBottomSheet(
                                                                                                    useSafeArea: true,
                                                                                                    context: context,
                                                                                                    isScrollControlled: true,
                                                                                                    backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                                    shape: const RoundedRectangleBorder(
                                                                                                      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                                                                                                    ),
                                                                                                    builder: (_) {
                                                                                                      return Container(
                                                                                                        height: MediaQuery.of(context).size.height,
                                                                                                        child: Column(
                                                                                                          children: [
                                                                                                            Container(
                                                                                                              padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                                                                                                              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                                                                                                GestureDetector(
                                                                                                                  onTap: () {
                                                                                                                    Navigator.pop(context);
                                                                                                                  },
                                                                                                                  child: Container(
                                                                                                                    decoration: BoxDecoration(
                                                                                                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                                                      borderRadius: BorderRadius.circular(10.0),
                                                                                                                      border: Border.all(
                                                                                                                        color: FlutterFlowTheme.of(context).primaryText,
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    child: Padding(
                                                                                                                      padding: EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
                                                                                                                      child: Text(
                                                                                                                        'Hide Explanation',
                                                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                              fontSize: 12.0,
                                                                                                                              useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                                                            ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ]),
                                                                                                            ),
                                                                                                            Stack(
                                                                                                              key: anchor,
                                                                                                              children: [
                                                                                                                Padding(
                                                                                                                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                                                                                                                  child: Column(
                                                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                                                    children: [
                                                                                                                      if ((String var1) {
                                                                                                                        return !RegExp(r'<(iframe)\b[^>]*>').hasMatch(var1);
                                                                                                                      }((PracticeGroup.getPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall.testHtmlFullExplanationsArr(
                                                                                                                        columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                                                      ) as List)
                                                                                                                          .map<String>((s) => s.toString())
                                                                                                                          .toList()[functions.getOffsetListQueIndex(quetionListIndex)]))
                                                                                                                        wrapWithModel(
                                                                                                                          model: _model.customHtmlViewModels2.getModel(
                                                                                                                            'QuestionListId:${getJsonField(
                                                                                                                              quetionListItem,
                                                                                                                              r'''$.id''',
                                                                                                                            ).toString()}',
                                                                                                                            quetionListIndex,
                                                                                                                          ),
                                                                                                                          updateCallback: () => setState(() {}),
                                                                                                                          child: Material(
                                                                                                                            color: Colors.transparent,
                                                                                                                            elevation: 0.0,
                                                                                                                            shape: RoundedRectangleBorder(
                                                                                                                              borderRadius: BorderRadius.circular(12.0),
                                                                                                                            ),
                                                                                                                            child: Container(
                                                                                                                              decoration: BoxDecoration(
                                                                                                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                                                                border: Border.all(
                                                                                                                                  color: FlutterFlowTheme.of(context).secondaryBorderColor,
                                                                                                                                  width: 1.0,
                                                                                                                                ),
                                                                                                                                boxShadow: [
                                                                                                                                  BoxShadow(
                                                                                                                                    blurRadius: 15.0,
                                                                                                                                    color: Color.fromARGB(16, 0, 0, 0),
                                                                                                                                    offset: Offset(0.0, 10.0),
                                                                                                                                  )
                                                                                                                                ],
                                                                                                                              ),
                                                                                                                              child: Padding(
                                                                                                                                padding: const EdgeInsets.all(8.0),
                                                                                                                                child: kIsWeb || Platform.isIOS
                                                                                                                                    ? CustomHtmlViewWidget(
                                                                                                                                        key: Key(
                                                                                                                                          'Keyb4a_${'QuestionListId:${getJsonField(
                                                                                                                                            quetionListItem,
                                                                                                                                            r'''$.id''',
                                                                                                                                          ).toString()}'}',
                                                                                                                                        ),
                                                                                                                                        // questionStr: "<span>Pick the correct statements:</span>\r\n\r\n<table border=\"1\" cellpadding=\"1\" cellspacing=\"1\">\r\n\t<tbody>\r\n\t\t<tr>\r\n\t\t\t<td>a.</td>\r\n\t\t\t<td>Average speed of a particle in a given time is never less than the magnitude of the average velocity.</td>\r\n\t\t</tr>\r\n\t\t<tr>\r\n\t\t\t<td>b.</td>\r\n\t\t\t<td><span id=\"cke_bm_901S\" style=\"display: none;\">&nbsp;</span>It is possible to have a situation in which <span class=\"math-tex\">\\(|\\frac{d \\vec{v}}{d t}| \\neq 0\\)</span> but <span class=\"math-tex\">\\(\\frac{d}{d t}|\\vec{v}|=0.\\)</span></td>\r\n\t\t</tr>\r\n\t\t<tr>\r\n\t\t\t<td>c.</td>\r\n\t\t\t<td>The average velocity of a particle is zero in a time interval. It is possible that the instantaneous velocity is never zero in the interval.</td>\r\n\t\t</tr>\r\n\t\t<tr>\r\n\t\t\t<td>d.</td>\r\n\t\t\t<td>The average velocity of a particle moving in a straight line is zero in a time interval. It is possible that the instantaneous velocity is never zero in the interval. (Infinite accelerations are not allowed)</td>\r\n\t\t</tr>\r\n\t</tbody>\r\n</table>\r\n\r\n<p><br />\r\nChoose the correct option:</p>\r\n\r\n<table border=\"1\" cellpadding=\"1\" cellspacing=\"1\">\r\n\t<tbody>\r\n\t\t<tr>\r\n\t\t\t<td>1.</td>\r\n\t\t\t<td>(a), (b) and (c)</td>\r\n\t\t</tr>\r\n\t\t<tr>\r\n\t\t\t<td>2.</td>\r\n\t\t\t<td>(b), (c) and (d)</td>\r\n\t\t</tr>\r\n\t\t<tr>\r\n\t\t\t<td>3.</td>\r\n\t\t\t<td>(a) and (b)</td>\r\n\t\t</tr>\r\n\t\t<tr>\r\n\t\t\t<td>4.</td>\r\n\t\t\t<td>(b) and (c)</td>\r\n\t\t</tr>\r\n\t</tbody>\r\n</table>\r\n"
                                                                                                                                        questionStr: _model.currentExplanation + explanationStr,
                                                                                                                                      )
                                                                                                                                    : Container(height: MediaQuery.of(context).size.height * 0.8, child: AndroidWebView(html: _model.currentExplanation)),
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      if ((String var1) {
                                                                                                                        return RegExp(r'<(iframe)\b[^>]*>').hasMatch(var1) || RegExp(r'(<math.*>.*</math>|math-tex)').hasMatch(var1);
                                                                                                                      }((PracticeGroup.getPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall.testHtmlFullExplanationsArr(
                                                                                                                        columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                                                      ) as List)
                                                                                                                          .map<String>((s) => s.toString())
                                                                                                                          .toList()[functions.getOffsetListQueIndex(quetionListIndex)]))
                                                                                                                        Material(
                                                                                                                          color: Colors.transparent,
                                                                                                                          elevation: 0.0,
                                                                                                                          shape: RoundedRectangleBorder(
                                                                                                                            borderRadius: BorderRadius.circular(12.0),
                                                                                                                          ),
                                                                                                                          child: Container(
                                                                                                                            decoration: BoxDecoration(
                                                                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                                                                              border: Border.all(
                                                                                                                                color: FlutterFlowTheme.of(context).secondaryBorderColor,
                                                                                                                                width: 1.0,
                                                                                                                              ),
                                                                                                                              boxShadow: [
                                                                                                                                BoxShadow(
                                                                                                                                  blurRadius: 15.0,
                                                                                                                                  color: Color.fromARGB(16, 0, 0, 0),
                                                                                                                                  offset: Offset(0.0, 10.0),
                                                                                                                                )
                                                                                                                              ],
                                                                                                                            ),
                                                                                                                            child: Padding(
                                                                                                                              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                                                                                                              child: kIsWeb || Platform.isIOS
                                                                                                                                  ? custom_widgets.CustomWebView(
                                                                                                                                      width: MediaQuery.of(context).size.width * 0.8,
                                                                                                                                      height: 400,
                                                                                                                                      src: _model.currentExplanation + explanationStr,
                                                                                                                                    )
                                                                                                                                  : Container(
                                                                                                                                      height: MediaQuery.of(context).size.height * 0.8,
                                                                                                                                      child: AndroidWebView(html: _model.currentExplanation),
                                                                                                                                    ),
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                    ],
                                                                                                                  ),
                                                                                                                ),
                                                                                                                Positioned(
                                                                                                                  right: 5,
                                                                                                                  top: 5,
                                                                                                                  child: Row(
                                                                                                                    children: [
                                                                                                                      if (false)
                                                                                                                        Container(
                                                                                                                          decoration: BoxDecoration(
                                                                                                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                                                            borderRadius: BorderRadius.circular(8.0),
                                                                                                                            border: Border.all(
                                                                                                                              color: Color(0xFFF0F1F3),
                                                                                                                              width: 1.0,
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                          child: Padding(
                                                                                                                            padding: EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 5.0, 5.0),
                                                                                                                            child: InkWell(
                                                                                                                                splashColor: Colors.transparent,
                                                                                                                                focusColor: Colors.transparent,
                                                                                                                                hoverColor: Colors.transparent,
                                                                                                                                highlightColor: Colors.transparent,
                                                                                                                                onTap: () async {
                                                                                                                                  setState(() {
                                                                                                                                    //  data =  (PracticeGroup.getPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall.testHtmlFullExplanationsArr(columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,) as List).map<String>((s) => s.toString()).toList()[functions.getOffsetListQueIndex(quetionListIndex)];
                                                                                                                                  });
                                                                                                                                },
                                                                                                                                child: Icon(Icons.refresh)),
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      SizedBox(width: 2),
                                                                                                                      Container(
                                                                                                                        height:28,
                                                                                                                        width:28,
                                                                                                                        decoration: BoxDecoration(
                                                                                                                          color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                                                          borderRadius: BorderRadius.circular(8.0),
                                                                                                                          border: Border.all(
                                                                                                                            color: FlutterFlowTheme.of(context).secondaryBorderColor,
                                                                                                                            width: 1.0,
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        child: Padding(
                                                                                                                          padding: EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 5.0, 5.0),
                                                                                                                          child: InkWell(
                                                                                                                              splashColor: Colors.transparent,
                                                                                                                              focusColor: Colors.transparent,
                                                                                                                              hoverColor: Colors.transparent,
                                                                                                                              highlightColor: Colors.transparent,
                                                                                                                              onTap: () async {
                                                                                                                                if (kIsWeb || Platform.isIOS) {
                                                                                                                                  explanationStr = "<span class=\"display_webview\"></span>";
                                                                                                                                  setState(() {});
                                                                                                                                } else {
                                                                                                                                  showDialog(
                                                                                                                                      context: context,
                                                                                                                                      builder: (_) {
                                                                                                                                        return Padding(
                                                                                                                                            padding: const EdgeInsets.all(5),
                                                                                                                                            child: AndroidWebView(
                                                                                                                                                html: ((PracticeGroup.getPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall.testHtmlFullExplanationsArr(
                                                                                                                                              columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                                                                            ) as List)
                                                                                                                                                    .map<String>((s) => s.toString())
                                                                                                                                                    .toList()[functions.getOffsetListQueIndex(quetionListIndex)])));
                                                                                                                                      });
                                                                                                                                }
                                                                                                                              },
                                                                                                                              child: kIsWeb || Platform.isIOS
                                                                                                                                  ? Icon(Icons.refresh)
                                                                                                                                  : SvgPicture.asset(
                                                                                                                                      "assets/images/enlarge.svg",
                                                                                                                                      color: FlutterFlowTheme.of(context).primaryText,
                                                                                                                                    )),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ],
                                                                                                                  ),
                                                                                                                )
                                                                                                              ],
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      );
                                                                                                    })
                                                                                                : showDialog(
                                                                                                    context: context,
                                                                                                    builder: (_) {
                                                                                                      return Material (
                                                                                                        color: Colors.transparent,
                                                                                                        elevation: 0.0,
                                                                                                        shape: RoundedRectangleBorder(
                                                                                                          borderRadius:
                                                                                                          BorderRadius.circular(12.0),
                                                                                                        ),
                                                                                                        child: Container(
                                                                                                          decoration: BoxDecoration(
                                                                                                            color: FlutterFlowTheme.of(context)
                                                                                                                .secondaryBackground,
                                                                                                            borderRadius:
                                                                                                            BorderRadius.circular(8.0),
                                                                                                            border: Border.all(
                                                                                                              color: FlutterFlowTheme.of(context)
                                                                                                                  .secondaryBorderColor,
                                                                                                              width: 1.0,
                                                                                                            ),
                                                                                                            boxShadow: [
                                                                                                              BoxShadow(
                                                                                                                blurRadius: 15.0,
                                                                                                                color:
                                                                                                                Color.fromARGB(16, 0, 0, 0),
                                                                                                                offset: Offset(0.0, 10.0),
                                                                                                              )
                                                                                                            ],
                                                                                                          ),
                                                                                                          height:MediaQuery.of(context).size.height*0.8,
                                                                                                          child: Column(
                                                                                                            children: [
                                                                                                              InkWell(onTap:(){
                                                                                                                Navigator.pop(context);
                                                                                                              },child: Align(
                                                                                                                alignment: AlignmentDirectional.topEnd,
                                                                                                                child: Padding(
                                                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                                                  child: Icon(Icons.close),
                                                                                                                ),
                                                                                                              )),
                                                                                                              Padding(
                                                                                                                  padding: const EdgeInsets.all(5),
                                                                                                                  child: Dialog(
                                                                                                                    insetPadding: const EdgeInsets.all(0),
                                                                                                                    child: Container(
                                                                                                                      height: MediaQuery.of(context).size.height*0.8,
                                                                                                                      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                                                                                                                      child: AndroidWebView(
                                                                                                                          html: ((PracticeGroup.getPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall.testHtmlFullExplanationsArr(
                                                                                                                        columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                                                      ) as List)
                                                                                                                              .map<String>((s) => s.toString())
                                                                                                                              .toList()[functions.getOffsetListQueIndex(quetionListIndex)])),
                                                                                                                    ),
                                                                                                                  )),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                      );
                                                                                                    });
                                                                                          },
                                                                                          child: Container(
                                                                                            decoration: BoxDecoration(
                                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                                              border: Border.all(
                                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                                              ),
                                                                                            ),
                                                                                            child: Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
                                                                                              child: Text(
                                                                                                'Show Explanation',
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                      fontSize: 12.0,
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
                                                                              Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                children: List.generate(queNumbers.length, (queNumbersIndex) {
                                                                                  final queNumbersItem = queNumbers[queNumbersIndex];
                                                                                  return Expanded(
                                                                                    child: Container(
                                                                                      // padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 5.0, 0.0),
                                                                                      child: InkWell(
                                                                                        splashColor: Colors.transparent,
                                                                                        focusColor: Colors.transparent,
                                                                                        hoverColor: Colors.transparent,
                                                                                        highlightColor: Colors.transparent,
                                                                                        onTap: () async {
                                                                                          var _shouldSetState = false;
                                                                                          _onAnswerSubmit();
                                                                                          if (getJsonField(
                                                                                                FFAppState().allQuestionsStatus[quetionListIndex],
                                                                                                r'''$.userAnswer''',
                                                                                              ) ==
                                                                                              null) {
                                                                                            setState(() {
                                                                                              FFAppState().allQuestionsStatus = functions.getUpdatedQuestionsStatusList(FFAppState().allQuestionsStatus.toList(), quetionListIndex, queNumbersIndex, _secondsElapsed==0?null:_secondsElapsed).toList().cast<dynamic>();
                                                                                            });
                                                                                            setState(() {
                                                                                              _model.showConfetti = (PracticeGroup.getPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall.testQuestionCorrectOptionIndices(
                                                                                                    columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                                  ) as List)
                                                                                                      .map<String>((s) => s.toString())
                                                                                                      .toList()[functions.getOffsetListQueIndex(quetionListIndex)]
                                                                                                      .toString() ==
                                                                                                  queNumbersIndex.toString();
                                                                                            });
                                                                                            _model.apiResultixv = await PracticeGroup.createAnswerForAPracticeQuestionByAUserWithSpecificMarkedOptionCall.call(
                                                                                              questionId: (PracticeGroup.getPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall.testQuestionIdArr(
                                                                                                columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                              ) as List)
                                                                                                  .map<String>((s) => s.toString())
                                                                                                  .toList()[functions.getOffsetListQueIndex(quetionListIndex)],
                                                                                              userId: functions.getBase64OfUserId(FFAppState().userIdInt),
                                                                                              userAnswer: queNumbersIndex,
                                                                                              authToken: FFAppState().subjectToken,
                                                                                              durationInSec:_secondsElapsed
                                                                                            );
                                                                                            log(_model.apiResultixv!.jsonBody.toString());

                                                                                            _shouldSetState = true;
                                                                                            _model.instantTimer = InstantTimer.periodic(
                                                                                              duration: Duration(milliseconds: 1000),
                                                                                              callback: (timer) async {
                                                                                                _model.showConfetti = false;
                                                                                                _model.instantTimer?.cancel();
                                                                                                return;
                                                                                              },

                                                                                              startImmediately: false,
                                                                                            );
                                                                                          } else {
                                                                                            if (_shouldSetState) setState(() {});
                                                                                            return;
                                                                                          }

                                                                                          if (_shouldSetState) setState(() {});
                                                                                        },
                                                                                        child: Material(
                                                                                          color: FlutterFlowTheme.of(context).tertiaryBackground,
                                                                                          child: Container(
                                                                                            margin: EdgeInsets.fromLTRB(1, 0, 1, 0),
                                                                                            height: 46.0,
                                                                                            decoration: BoxDecoration(
                                                                                              color: FlutterFlowTheme.of(context).tertiaryBackground,
                                                                                              boxShadow: [
                                                                                                BoxShadow(
                                                                                                  blurRadius: 15.0,
                                                                                                  color: Color.fromARGB(14, 0, 0, 0),
                                                                                                  offset: Offset(0.0, 10.0),
                                                                                                )
                                                                                              ],
                                                                                              //  borderRadius: BorderRadius.circular(12.0),
                                                                                              border: Border.all(
                                                                                                style: BorderStyle.solid,
                                                                                                color: getJsonField(
                                                                                                          FFAppState().allQuestionsStatus[quetionListIndex],
                                                                                                          r'''$.userAnswer''',
                                                                                                        ) !=
                                                                                                        null
                                                                                                    ? ((PracticeGroup.getPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall.testQuestionCorrectOptionIndices(
                                                                                                              columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                                            ) as List)
                                                                                                                .map<String>((s) => s.toString())
                                                                                                                .toList()[functions.getOffsetListQueIndex(quetionListIndex)]
                                                                                                                .toString() ==
                                                                                                            queNumbersIndex.toString()
                                                                                                        ? Color(0xFF5EB85E)
                                                                                                        : ((PracticeGroup.getPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall.testQuestionCorrectOptionIndices(
                                                                                                                      columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                                                    )[functions.getOffsetListQueIndex(quetionListIndex)] !=
                                                                                                                    queNumbersIndex) &&
                                                                                                                (getJsonField(
                                                                                                                      FFAppState().allQuestionsStatus[quetionListIndex],
                                                                                                                      r'''$.userAnswer.userAnswer''',
                                                                                                                    ) !=
                                                                                                                    queNumbersIndex)
                                                                                                            ? FlutterFlowTheme.of(context).accent4
                                                                                                            : (getJsonField(
                                                                                                                      FFAppState().allQuestionsStatus[quetionListIndex],
                                                                                                                      r'''$.userAnswer.userAnswer''',
                                                                                                                    ) ==
                                                                                                                    queNumbersIndex
                                                                                                                ? Color(0xFFFF2424)
                                                                                                                : Color(0xFF5EB85E))))
                                                                                                    : FlutterFlowTheme.of(context).accent4,
                                                                                                width: 1.5,
                                                                                              ),
                                                                                            ),
                                                                                            alignment: AlignmentDirectional(0.0, 0.0),
                                                                                            child: Row(
                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                              children: [
                                                                                                getJsonField(
                                                                                                  FFAppState().allQuestionsStatus[quetionListIndex],
                                                                                                  r'''$.userAnswer''',
                                                                                                ) !=
                                                                                                    null
                                                                                                    && ((PracticeGroup.getPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall.testQuestionCorrectOptionIndices(
                                                                                                  columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                                ) as List)
                                                                                                    .map<String>((s) => s.toString())
                                                                                                    .toList()[functions.getOffsetListQueIndex(quetionListIndex)]
                                                                                                    .toString() ==
                                                                                                    queNumbersIndex.toString())?
                                                                                                SvgPicture.asset("assets/images/right_icon.svg", width: 20.0, height: 20.0,):
                                                                                          (getJsonField(
                                                                                            FFAppState().allQuestionsStatus[quetionListIndex],
                                                                                            r'''$.userAnswer.userAnswer''',
                                                                                          ) ==
                                                                                              queNumbersIndex)?
                                                                                                SvgPicture.asset("assets/images/wrong_icon.svg", width: 20.0, height: 20.0,):SizedBox(),
                                                                                                SizedBox(width:2.0),
                                                                                                Text(
                                                                                                  queNumbersItem.toString(),
                                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                        color: FlutterFlowTheme.of(context).primaryText,
                                                                                                        fontWeight: FontWeight.w500,
                                                                                                        useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                                      ),
                                                                                                ),
                                                                                                if ((getJsonField(
                                                                                                          FFAppState().allQuestionsStatus[quetionListIndex],
                                                                                                          r'''$.userAnswer''',
                                                                                                        ) !=
                                                                                                        null) &&
                                                                                                    ((PracticeGroup.getPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall.testQuestionCorrectPercentages(
                                                                                                          columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                                        ) as List)
                                                                                                            .map<String>((s) => s.toString())
                                                                                                            .toList()[functions.getOffsetListQueIndex(quetionListIndex)] !=
                                                                                                        'null') &&
                                                                                                    (getJsonField(
                                                                                                          practiceQuetionsPageLoggedInUserInformationAndCourseAccessCheckingApiResponse.jsonBody,
                                                                                                          r'''$.data.me.userCourses.edges''',
                                                                                                        ) !=
                                                                                                        null))
                                                                                                  Text(
                                                                                                    ' ( ${functions.getOptionCorrectPercentage(PracticeGroup.getPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall.testQuestions(
                                                                                                          columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                                        )[functions.getOffsetListQueIndex(quetionListIndex)], queNumbersIndex)}% ) ',
                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                          color: Color(0xFFB9B9B9),
                                                                                                          fontSize: 12.0,
                                                                                                          fontWeight: FontWeight.w500,
                                                                                                          useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                                        ),
                                                                                                  ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                }),
                                                                              ),
                                                                            ],
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 1.0),
                                          child: Container(
                                            width: double.infinity,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            child: PointerInterceptor(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      await showModalBottomSheet(
                                                        isScrollControlled:
                                                            true,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        barrierColor:
                                                            Color.fromARGB(
                                                                113, 0, 0, 0),
                                                        context: context,
                                                        builder: (context) {
                                                          return GestureDetector(
                                                            onTap: () => FocusScope
                                                                    .of(context)
                                                                .requestFocus(_model
                                                                    .unfocusNode),
                                                            child: Padding(
                                                              padding: MediaQuery
                                                                      .of(context)
                                                                  .viewInsets,
                                                              child: Container(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    1.0,
                                                                child:
                                                                    BubbleQuestionsWidget(
                                                                  testId: widget
                                                                      .testId,
                                                                  numberOfQuestions:
                                                                      widget
                                                                          .numberOfQuestions,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ).then((value) =>
                                                          setState(() => _model
                                                                  .selectedPageNumber =
                                                              value));
                                                      await _model
                                                          .pageViewController
                                                          ?.animateToPage(
                                                        _model
                                                            .selectedPageNumber!,
                                                        duration: Duration(
                                                            milliseconds: 500),
                                                        curve: Curves.ease,
                                                      );

                                                      setState(() {});
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              8, 10, 58, 10),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .tertiaryBackground,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          border: Border.all(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBorderColor,
                                                            width: 1.0,
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  18.0,
                                                                  10.0,
                                                                  18.0,
                                                                  10.0),
                                                          child: Text(
                                                            //text with combination from both variable and string
                                                            'Q' +
                                                                ((_model.quesTitleNumber +
                                                                            1)
                                                                        .toString())
                                                                    .maybeHandleOverflow(
                                                                  maxChars: 20,
                                                                  replacement:
                                                                      '…',
                                                                ),

                                                            textAlign: TextAlign
                                                                .center,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily),
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    16.0,
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
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            questionStr = "";
                                                            await _model
                                                                .pageViewController
                                                                ?.previousPage(
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      300),
                                                              curve:
                                                                  Curves.ease,
                                                            );
                                                          },
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              if (_model
                                                                      .quesTitleNumber ==
                                                                  0)
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              0.0),
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/images/arrow-square-left.png',
                                                                    width: 38.0,
                                                                    height: 38.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              if (_model
                                                                      .quesTitleNumber >
                                                                  0)
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          10.0,
                                                                          0.0,
                                                                          10.0),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            0.0),
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/images/left-filled.png',
                                                                      width:
                                                                          38.0,
                                                                      height:
                                                                          38.0,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
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
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            questionStr = "";
                                                            await _model
                                                                .pageViewController
                                                                ?.nextPage(
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      300),
                                                              curve:
                                                                  Curves.ease,
                                                            );
                                                          },
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              if (quesNoIndex ==
                                                                  (widget.numberOfQuestions -
                                                                      1))
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              0.0),
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/images/arrow-square-right.png',
                                                                    width: 38.0,
                                                                    height:
                                                                        38.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              if (quesNoIndex !=
                                                                  (widget.numberOfQuestions -
                                                                      1))
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          10.0,
                                                                          0.0,
                                                                          10.0),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            0.0),
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/images/right-filled.png',
                                                                      width:
                                                                          38.0,
                                                                      height:
                                                                          38.0,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              if (_model.isLoading)
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    height: 200.0,
                                    child: custom_widgets.CustomLoader(
                                      width: double.infinity,
                                      height: 200.0,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ));
              }),
            ),
          ),
        );
      },
    );
  }
}
