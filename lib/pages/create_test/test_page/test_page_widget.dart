import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neetprep_essential/components/bubble_track_for_test/bubble_track_for_test_widget.dart';
import 'package:neetprep_essential/custom_code/widgets/android_web_view.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';

import '../../../clevertap/clevertap_service.dart';
import '/backend/api_requests/api_calls.dart';
import '/components/html_question/html_question_widget.dart';
import '/components/test_count_down_timer/test_count_down_timer_widget.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import '/pages/create_test/confirm_pop/confirm_pop_widget.dart';
import 'test_page_model.dart';
import 'dart:io' show Platform;

export 'test_page_model.dart';

class TestPageWidget extends StatefulWidget {
  const TestPageWidget(
      {Key? key, String? testId, this.testAttemptId, this.courseIdInt})
      : this.testId = testId ?? 'dfgdfg',
        super(key: key);

  final String testId;
  final String? testAttemptId;
  final String? courseIdInt;

  @override
  _TestPageWidgetState createState() => _TestPageWidgetState();
}

class _TestPageWidgetState extends State<TestPageWidget> {
  late TestPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String questionStr = "";
  int idx = 0;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TestPageModel());

    FirebaseAnalytics.instance.setCurrentScreen(screenName: "TestPageWidget",);
    CleverTapService.recordEvent("Test Page Opened",{"testId":widget.testId});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _model.isLoading = true;
      });
      _model.questionsList = await TestGroup
          .getCompletedTestAttemptDataWithTestResultForATestAttemptCall
          .call(
        testAttemptId: widget.testAttemptId,
        authToken: FFAppState().subjectToken,
      );
      setState(() {
        FFAppState().questionList = TestGroup
            .getCompletedTestAttemptDataWithTestResultForATestAttemptCall
            .questionsList(
              (_model.questionsList?.jsonBody ?? ''),
            )
            .toList()
            .cast<dynamic>();
        FFAppState().testQueAnsList = functions
            .getTestQuestionsAnswerList(
                TestGroup
                    .getCompletedTestAttemptDataWithTestResultForATestAttemptCall
                    .numQuestions(
                  (_model.questionsList?.jsonBody ?? ''),
                ),
                TestGroup
                    .getCompletedTestAttemptDataWithTestResultForATestAttemptCall
                    .userAnswers(
                  (_model.questionsList?.jsonBody ?? ''),
                ),
                (TestGroup
                        .getCompletedTestAttemptDataWithTestResultForATestAttemptCall
                        .questionIdsList(
                  (_model.questionsList?.jsonBody ?? ''),
                ) as List)
                    .map<String>((s) => s.toString())
                    .toList()
                    .toList())
            .toList()
            .cast<int>();
        FFAppState().secondsList = functions
            .getSecondsInEachPage(
                TestGroup
                    .getCompletedTestAttemptDataWithTestResultForATestAttemptCall
                    .numQuestions(
                  (_model.questionsList?.jsonBody ?? ''),
                ),
                TestGroup
                    .getCompletedTestAttemptDataWithTestResultForATestAttemptCall
                    .userQuestionWiseDurationInSec(
                  (_model.questionsList?.jsonBody ?? ''),
                ),
                (TestGroup
                        .getCompletedTestAttemptDataWithTestResultForATestAttemptCall
                        .questionIdsList(
                  (_model.questionsList?.jsonBody ?? ''),
                ) as List)
                    .map<String>((s) => s.toString())
                    .toList()
                    .toList())
            .toList()
            .cast<int>();
      });
      setState(() {
        _model.isLoading = false;
        _model.startTimeInSec = ((valueOrDefault<int>(
          TestGroup.getCompletedTestAttemptDataWithTestResultForATestAttemptCall
              .durationInMin(
            (_model.questionsList?.jsonBody ?? ''),
          ),
          180,
        )));
        int testDurationInSec = (valueOrDefault<int>(
              TestGroup
                  .getCompletedTestAttemptDataWithTestResultForATestAttemptCall
                  .durationInMin(
                (_model.questionsList?.jsonBody ?? ''),
              ),
              180,
            )) *
            60;

        int elapsedDurationInSec = TestGroup
                .getCompletedTestAttemptDataWithTestResultForATestAttemptCall
                .elapsedDurationInSec(
              (_model.questionsList?.jsonBody ?? ''),
            ) ??
            0;
        if (elapsedDurationInSec < 0 ||
            elapsedDurationInSec > testDurationInSec) {
          elapsedDurationInSec = 0;
        }
        int remainingTimeInSec = testDurationInSec - elapsedDurationInSec;
        int remainingTimeInMin =
            functions.convertSecondsToMinutes(remainingTimeInSec);
        int remainingSec =
            functions.convertSecondsToSecondsPart(remainingTimeInSec);
        if (remainingSec >= 60) {
          remainingSec = 59;
        }
        if (remainingTimeInMin >
            (valueOrDefault<int>(
                  TestGroup
                      .getCompletedTestAttemptDataWithTestResultForATestAttemptCall
                      .durationInMin(
                    (_model.questionsList?.jsonBody ?? ''),
                  ),
                  180,
                ) -
                1)) {
          remainingTimeInMin = (valueOrDefault<int>(
                TestGroup
                    .getCompletedTestAttemptDataWithTestResultForATestAttemptCall
                    .durationInMin(
                  (_model.questionsList?.jsonBody ?? ''),
                ),
                180,
              ) -
              1);
        }
        _model.minutes = remainingTimeInMin;
        _model.seconds = remainingSec;
      });
      _model.instantTimer1 = InstantTimer.periodic(
        duration: Duration(milliseconds: 1000),
        callback: (timer) async {
          _model.secondsPerQuestion = (int var1, int var2) {
            return var1 >= var2 ? (var1 - var2) : 0;
          }(_model.instantTimer1.tick, _model.questionLoadedTime);
          if (_model.seconds == 0) {
            _model.minutes = _model.minutes! + -1;
            _model.seconds = 59;
            return;
          } else {
            _model.seconds = _model.seconds! + -1;
            return;
          }
        },
        startImmediately: true,
      );
    });

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
    return Title(
        title: 'TestPage',
        color: FlutterFlowTheme.of(context).primaryBackground,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
          child: WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              appBar: AppBar(
                backgroundColor:
                    FlutterFlowTheme.of(context).secondaryBackground,
                automaticallyImplyLeading: false,
                title: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
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
                              var _shouldSetState = false;
                              await showDialog(
                                context: context,
                                builder: (alertDialogContext) {
                                  return AlertDialog(
                                    title: Text('Are you submitting the test?'),
                                    content:
                                        Text('Do you want to submit the test?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          setState(() {
                                            FFAppState().questionsListInInt =
                                                functions
                                                    .getQuestionIdListInInteger(
                                                        FFAppState()
                                                            .questionList
                                                            .toList(),
                                                        FFAppState()
                                                            .testQueAnsList
                                                            .toList())
                                                    .toList()
                                                    .cast<int>();
                                            FFAppState().answerListInInt =
                                                functions
                                                    .getAnswerListInInteger(
                                                        FFAppState()
                                                            .testQueAnsList
                                                            .toList())
                                                    .toList()
                                                    .cast<int>();
                                            FFAppState().secondsListInInt =
                                                functions
                                                    .getSecondsListInInt(
                                                        FFAppState()
                                                            .secondsList
                                                            .toList())
                                                    .toList()
                                                    .cast<int>();
                                          });
                                          _model.submitRes1 = await TestGroup
                                              .updateTestAttemptForATestByAUserBasedOnQuestionsAttemptedAndTimeSpendEtcCall
                                              .call(
                                            testId: widget.testId,
                                            userId: functions.getBase64OfUserId(
                                                FFAppState().userIdInt),
                                            authToken:
                                                FFAppState().subjectToken,
                                            testAttemptId: widget.testAttemptId,
                                            userAnswersJsonStr: functions
                                                .convertQuestionAndAnsIntoMapJson(
                                                    FFAppState()
                                                        .questionsListInInt
                                                        .toList(),
                                                    FFAppState()
                                                        .answerListInInt
                                                        .toList()),
                                            userQuestionWiseDurationInSecJsonStr:
                                                functions
                                                    .convertQuestionAndAnsIntoMapJson(
                                                        FFAppState()
                                                            .questionsListInInt
                                                            .toList(),
                                                        FFAppState()
                                                            .secondsListInInt
                                                            .toList()),
                                            visitedQuestionsJsonStr: '{}',
                                            markedQuestionsJsonStr: '{}',
                                            elapsedDurationInSec:
                                                functions.getElapsedTime(
                                                    _model.startTimeInSec!,
                                                    _model.minutes!,
                                                    _model.seconds!),
                                            currentQuestionOffset: 0,
                                            completed: false,
                                          )
                                              .then((_) {
                                            Navigator.pop(context);
                                            context.pop();
                                            return null;
                                          });
                                          print(widget.testAttemptId);
                                          _shouldSetState = true;
                                          if (_shouldSetState) setState(() {});
                                          return;
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          setState(() {
                                            FFAppState().questionsListInInt =
                                                functions
                                                    .getQuestionIdListInInteger(
                                                        FFAppState()
                                                            .questionList
                                                            .toList(),
                                                        FFAppState()
                                                            .testQueAnsList
                                                            .toList())
                                                    .toList()
                                                    .cast<int>();
                                            FFAppState().answerListInInt =
                                                functions
                                                    .getAnswerListInInteger(
                                                        FFAppState()
                                                            .testQueAnsList
                                                            .toList())
                                                    .toList()
                                                    .cast<int>();
                                            FFAppState().secondsListInInt =
                                                functions
                                                    .getSecondsListInInt(
                                                        FFAppState()
                                                            .secondsList
                                                            .toList())
                                                    .toList()
                                                    .cast<int>();
                                          });
                                          _model.submitRes1 = await TestGroup
                                              .updateTestAttemptForATestByAUserBasedOnQuestionsAttemptedAndTimeSpendEtcCall
                                              .call(
                                            testId: widget.testId,
                                            userId: functions.getBase64OfUserId(
                                                FFAppState().userIdInt),
                                            authToken:
                                                FFAppState().subjectToken,
                                            testAttemptId: widget.testAttemptId,
                                            userAnswersJsonStr: functions
                                                .convertQuestionAndAnsIntoMapJson(
                                                    FFAppState()
                                                        .questionsListInInt
                                                        .toList(),
                                                    FFAppState()
                                                        .answerListInInt
                                                        .toList()),
                                            userQuestionWiseDurationInSecJsonStr:
                                                functions
                                                    .convertQuestionAndAnsIntoMapJson(
                                                        FFAppState()
                                                            .questionsListInInt
                                                            .toList(),
                                                        FFAppState()
                                                            .secondsListInInt
                                                            .toList()),
                                            visitedQuestionsJsonStr: '{}',
                                            markedQuestionsJsonStr: '{}',
                                            elapsedDurationInSec:
                                                functions.getElapsedTime(
                                                    _model.startTimeInSec!,
                                                    _model.minutes!,
                                                    _model.seconds!),
                                            currentQuestionOffset: 0,
                                            completed: true,
                                          );
                                          _shouldSetState = true;
                                          setState(() {
                                            FFAppState().testAttemptId =
                                                widget.testAttemptId!;
                                          });
                                          Navigator.pop(context);
                                          context.pushNamed(
                                            'CreateTestResultPage',
                                            queryParameters: {
                                              'testAttemptId': serializeParam(
                                                getJsonField(
                                                  (_model.questionsList
                                                          ?.jsonBody ??
                                                      ''),
                                                  r'''$.data.testAttempt.id''',
                                                ).toString(),
                                                ParamType.String,
                                              ),
                                              'courseIdInt': serializeParam(
                                                widget.courseIdInt.toString(),
                                                ParamType.String,
                                              ),
                                            }.withoutNulls,
                                          );

                                          if (_shouldSetState) setState(() {});
                                          return;
                                        },
                                        child: Text('Confirm'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 29.0,
                            ),
                          ),
                        ),
                        Text(
                          'Test',
                          style: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .headlineMediumFamily,
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .headlineMediumFamily),
                              ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if ((_model.minutes != null) &&
                            (_model.seconds != null))
                          wrapWithModel(
                            model: _model.testCountDownTimerModel,
                            updateCallback: () => setState(() {}),
                            child: TestCountDownTimerWidget(
                              minutes: _model.minutes != null
                                  ? _model.minutes
                                  : valueOrDefault<int>(
                                        TestGroup
                                            .getCompletedTestAttemptDataWithTestResultForATestAttemptCall
                                            .durationInMin(
                                          (_model.questionsList?.jsonBody ??
                                              ''),
                                        ),
                                        180,
                                      ) -
                                      1,
                              seconds:
                                  _model.seconds != null ? _model.seconds : (0),
                              testAttemptId: widget.testAttemptId,
                              testId: widget.testId,
                            ),
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
                              barrierColor: Color(0x00000000),
                              enableDrag: false,
                              context: context,
                              builder: (context) {
                                return GestureDetector(
                                  onTap: () => FocusScope.of(context)
                                      .requestFocus(_model.unfocusNode),
                                  child: Padding(
                                    padding: MediaQuery.viewInsetsOf(context),
                                    child: Container(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              1.0,
                                      child: BubbleTrackForTestWidget(
                                        testId: widget.testId,
                                        testAttemptId: widget.testAttemptId,
                                        numberOfQuestions: TestGroup
                                            .getCompletedTestAttemptDataWithTestResultForATestAttemptCall
                                            .numQuestions(
                                          _model.questionsList?.jsonBody,
                                        ),
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

                            setState(() {});
                          },
                          child: Icon(
                            Icons.grid_view,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 29.0,
                          ),
                        ),
                        SizedBox(width: 10),
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            var _shouldSetState = false;
                            await showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) {
                                return GestureDetector(
                                  onTap: () => FocusScope.of(context)
                                      .requestFocus(_model.unfocusNode),
                                  child: Padding(
                                    padding: MediaQuery.viewInsetsOf(context),
                                    child: ConfirmPopWidget(
                                      response: false,
                                    ),
                                  ),
                                );
                              },
                            ).then((value) =>
                                setState(() => _model.selRes = value));
                            _shouldSetState = true;
                            if (_model.selRes == true) {
                              setState(() {
                                FFAppState().questionsListInInt = functions
                                    .getQuestionIdListInInteger(
                                        FFAppState().questionList.toList(),
                                        FFAppState().testQueAnsList.toList())
                                    .toList()
                                    .cast<int>();
                                FFAppState().answerListInInt = functions
                                    .getAnswerListInInteger(
                                        FFAppState().testQueAnsList.toList())
                                    .toList()
                                    .cast<int>();
                                FFAppState().secondsListInInt = functions
                                    .getSecondsListInInt(
                                        FFAppState().secondsList.toList())
                                    .toList()
                                    .cast<int>();
                              });
                              setState(() {
                                _model.isLoading = true;
                              });
                              _model.submitRes = await TestGroup
                                  .updateTestAttemptForATestByAUserBasedOnQuestionsAttemptedAndTimeSpendEtcCall
                                  .call(
                                testId: widget.testId,
                                userId: functions
                                    .getBase64OfUserId(FFAppState().userIdInt),
                                authToken: FFAppState().subjectToken,
                                testAttemptId: widget.testAttemptId,
                                userAnswersJsonStr:
                                    functions.convertQuestionAndAnsIntoMapJson(
                                        FFAppState()
                                            .questionsListInInt
                                            .toList(),
                                        FFAppState().answerListInInt.toList()),
                                userQuestionWiseDurationInSecJsonStr:
                                    functions.convertQuestionAndAnsIntoMapJson(
                                        FFAppState()
                                            .questionsListInInt
                                            .toList(),
                                        FFAppState().secondsListInInt.toList()),
                                visitedQuestionsJsonStr: '{}',
                                markedQuestionsJsonStr: '{}',
                                elapsedDurationInSec: functions.getElapsedTime(
                                    _model.startTimeInSec!,
                                    _model.minutes!,
                                    _model.seconds!),
                                currentQuestionOffset: 0,
                                completed: true,
                              );
                              _shouldSetState = true;
                              setState(() {
                                _model.isLoading = false;
                              });

                              context.goNamed(
                                'CreateTestResultPage',
                                queryParameters: {
                                  'testAttemptId': serializeParam(
                                    widget.testAttemptId,
                                    ParamType.String,
                                  ),
                                  'courseIdInt': serializeParam(
                                    widget.courseIdInt.toString(),
                                    ParamType.String,
                                  ),
                                }.withoutNulls,
                              );

                              if (_shouldSetState) setState(() {});
                              return;
                            } else {
                              if (_shouldSetState) setState(() {});
                              return;
                            }

                            if (_shouldSetState) setState(() {});
                          },
                          child: Text(
                            'Submit',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .bodyMediumFamily),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [],
                centerTitle: false,
                elevation: 0.0,
              ),
              body: SafeArea(
                top: true,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (!_model.isLoading)
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                  ),
                                  child: Builder(
                                    builder: (context) {
                                      final quetionList =
                                          FFAppState().questionList.toList();
                                      // print("ppp"+FFAppState().questionList[0].toString());
                                      print(FFAppState().questionList.length);
                                      return Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: PageView.builder(
                                          controller: _model
                                                  .pageViewController ??=
                                              PageController(
                                                  initialPage: min(
                                                      valueOrDefault<int>(
                                                        FFAppState().pageNumber,
                                                        0,
                                                      ),
                                                      quetionList.length - 1)),
                                          onPageChanged: (_) async {
                                            questionStr = "";
                                            _model.questionLoadedTime =
                                                _model.instantTimer1.tick;
                                          },
                                          scrollDirection: Axis.horizontal,
                                          itemCount: quetionList.length,
                                          itemBuilder:
                                              (context, quetionListIndex) {
                                            final quetionListItem =
                                                quetionList[quetionListIndex];
                                            idx = quetionListIndex;
                                            return Stack(
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: 100.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                        ),
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Container(
                                                                        width:
                                                                            54.0,
                                                                        height:
                                                                            53.0,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                        alignment: AlignmentDirectional(
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            Text(
                                                                          (quetionListIndex + 1)
                                                                              .toString(),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                color: FlutterFlowTheme.of(context).primary,
                                                                                fontSize: 16.0,
                                                                                fontWeight: FontWeight.bold,
                                                                                useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                              ),
                                                                        ),
                                                                      ),
                                                                      Material(
                                                                        color: Colors
                                                                            .transparent,
                                                                        elevation:
                                                                            2.0,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              54.0,
                                                                          height:
                                                                              2.0,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primary,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            8.0,
                                                                            0.0,
                                                                            8.0,
                                                                            0.0),
                                                                child:
                                                                    Container(
                                                                        width: double
                                                                            .infinity,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryBackground,
                                                                        ),
                                                                        child:
                                                                            Stack(
                                                                          children: [
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 50.0, 0.0, 0.0),
                                                                              child: kIsWeb || Platform.isIOS
                                                                                  ? HtmlQuestionWidget(
                                                                                      key: Key('Keyba6_${quetionListIndex}_of_${quetionList.length}'),
                                                                                      questionHtmlStr: getJsonField(
                                                                                            quetionListItem,
                                                                                            r'''$.question''',
                                                                                          ).toString() +
                                                                                          questionStr,
                                                                                    )
                                                                                  : Container(
                                                                                      height: 300,
                                                                                      child: AndroidWebView(
                                                                                          html: getJsonField(
                                                                                        quetionListItem,
                                                                                        r'''$.question''',
                                                                                      ).toString()),
                                                                                    ),
                                                                            ),
                                                                            Positioned(
                                                                              right: 5,
                                                                              top: 5,
                                                                              child: Row(
                                                                                children: [
                                                                                  InkWell(
                                                                                    onTap: () async {
                                                                                      setState(() {
                                                                                        FFAppState().questionList = functions.getupdatedBookmark(FFAppState().questionList.toList(), FFAppState().bookMarkEmptyJson, quetionListIndex).toList().cast<dynamic>();
                                                                                      });
                                                                                      await PracticeGroup.createOrDeleteBookmarkForAPracticeQuestionByAUserCall.call(
                                                                                        questionId: FFAppState().questionList[quetionListIndex]['id'],
                                                                                        userId: functions.getBase64OfUserId(FFAppState().userIdInt),
                                                                                        authToken: FFAppState().subjectToken,
                                                                                      );

                                                                                      setState(() {});
                                                                                    },
                                                                                    child: Visibility(
                                                                                      visible: getJsonField(
                                                                                            FFAppState().questionList[quetionListIndex],
                                                                                            r'''$.bookmarkQuestion''',
                                                                                          ) ==
                                                                                          null,
                                                                                      child: Container(
                                                                                        margin: EdgeInsetsDirectional.only(end: 5),
                                                                                        decoration: BoxDecoration(
                                                                                          color: Colors.transparent,
                                                                                          borderRadius: BorderRadius.circular(8.0),
                                                                                          border: Border.all(
                                                                                            color: Color(0xFFF0F1F3),
                                                                                            width: 1.0,
                                                                                          ),
                                                                                        ),
                                                                                        child: Padding(
                                                                                          padding: EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 5.0, 5.0),
                                                                                          child: Icon(
                                                                                            Icons.bookmark_outline,
                                                                                            color: FlutterFlowTheme.of(context).primaryText,
                                                                                            size: 24.0,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  InkWell(
                                                                                    onTap: () async {
                                                                                      setState(() {
                                                                                        FFAppState().questionList = functions.getupdatedBookmarkRemove(FFAppState().questionList.toList(), FFAppState().bookMarkEmptyJson, quetionListIndex).toList().cast<dynamic>();
                                                                                      });
                                                                                      await PracticeGroup.createOrDeleteBookmarkForAPracticeQuestionByAUserCall.call(
                                                                                        questionId: FFAppState().questionList[quetionListIndex].id,
                                                                                        userId: functions.getBase64OfUserId(FFAppState().userIdInt),
                                                                                        authToken: FFAppState().subjectToken,
                                                                                      );

                                                                                      setState(() {});
                                                                                    },
                                                                                    child: Visibility(
                                                                                      visible: getJsonField(
                                                                                            FFAppState().questionList[quetionListIndex],
                                                                                            r'''$.bookmarkQuestion''',
                                                                                          ) !=
                                                                                          null,
                                                                                      child: Container(
                                                                                        margin: EdgeInsets.only(right: 5),
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
                                                                                          child: Icon(
                                                                                            Icons.bookmark_sharp,
                                                                                            color: FlutterFlowTheme.of(context).primaryText,
                                                                                            size: 24.0,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    decoration: BoxDecoration(
                                                                                      color: Colors.transparent,
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
                                                                                          if (kIsWeb || Platform.isIOS) {
                                                                                            questionStr = "<span class=\"display_webview\"></span>";
                                                                                            setState(() {});
                                                                                          } else {
                                                                                            showDialog(
                                                                                                context: context,
                                                                                                builder: (_) {
                                                                                                  return Padding(
                                                                                                      padding: const EdgeInsets.all(5),
                                                                                                      child: AndroidWebView(
                                                                                                          html: getJsonField(
                                                                                                        quetionListItem,
                                                                                                        r'''$.question''',
                                                                                                      ).toString()));
                                                                                                });
                                                                                          }
                                                                                        },
                                                                                        child: Icon(
                                                                                          Icons.refresh,
                                                                                          color: FlutterFlowTheme.of(context).primaryText,
                                                                                          size: 24.0,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        10.0,
                                                                        24.0,
                                                                        10.0,
                                                                        100.0),
                                                                child: Builder(
                                                                  builder:
                                                                      (context) {
                                                                    final queNumbers =
                                                                        FFAppState()
                                                                            .questionNumbers
                                                                            .toList();
                                                                    return Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: List.generate(
                                                                          queNumbers
                                                                              .length,
                                                                          (queNumbersIndex) {
                                                                        final queNumbersItem =
                                                                            queNumbers[queNumbersIndex];
                                                                        return Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              5.0,
                                                                              5.0,
                                                                              5.0,
                                                                              5.0),
                                                                          child:
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
                                                                              if (FFAppState().testQueAnsList[quetionListIndex] == queNumbersIndex) {
                                                                                setState(() {
                                                                                  FFAppState().testQueAnsList = functions.removeValueInListInSpecificPosition(FFAppState().testQueAnsList.toList(), quetionListIndex, queNumbersIndex).toList().cast<int>();
                                                                                  FFAppState().secondsList = functions.removeSecondsInList(FFAppState().secondsList.toList(), quetionListIndex, _model.secondsPerQuestion).toList().cast<int>();
                                                                                  _model.secondsPerQuestion = 0;
                                                                                });
                                                                              } else {
                                                                                setState(() {
                                                                                  FFAppState().testQueAnsList = functions.insertValueInListInSpecificPosition(FFAppState().testQueAnsList.toList(), quetionListIndex, queNumbersIndex).toList().cast<int>();
                                                                                  FFAppState().secondsList = functions.insertSeconsInList(FFAppState().secondsList.toList(), quetionListIndex, _model.secondsPerQuestion).toList().cast<int>();
                                                                                  _model.secondsPerQuestion = 0;
                                                                                });
                                                                              }
                                                                              setState(() {
                                                                                FFAppState().questionsListInInt = functions.getQuestionIdListInInteger(FFAppState().questionList.toList(), FFAppState().testQueAnsList.toList()).toList().cast<int>();
                                                                                FFAppState().answerListInInt = functions.getAnswerListInInteger(FFAppState().testQueAnsList.toList()).toList().cast<int>();
                                                                                FFAppState().secondsListInInt = functions.getSecondsListInInt(FFAppState().secondsList.toList()).toList().cast<int>();
                                                                              });
                                                                              _model.updateTestAttempt = await TestGroup.updateTestAttemptForATestByAUserBasedOnQuestionsAttemptedAndTimeSpendEtcCall.call(
                                                                                testId: widget.testId,
                                                                                userId: functions.getBase64OfUserId(FFAppState().userIdInt),
                                                                                authToken: FFAppState().subjectToken,
                                                                                testAttemptId: widget.testAttemptId,
                                                                                userAnswersJsonStr: functions.convertQuestionAndAnsIntoMapJson(FFAppState().questionsListInInt.toList(), FFAppState().answerListInInt.toList()),
                                                                                userQuestionWiseDurationInSecJsonStr: functions.convertQuestionAndAnsIntoMapJson(FFAppState().questionsListInInt.toList(), FFAppState().secondsListInInt.toList()),
                                                                                visitedQuestionsJsonStr: '{}',
                                                                                markedQuestionsJsonStr: '{}',
                                                                                // elapsedDurationInSec: 200,
                                                                                elapsedDurationInSec: functions.getElapsedTime(_model.startTimeInSec!, _model.minutes!, _model.seconds!),
                                                                                currentQuestionOffset: 0,
                                                                              );
                                                                              setState(() {});
                                                                            },
                                                                            child:
                                                                                Material(
                                                                              color: Colors.transparent,
                                                                              elevation: 4.0,
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(12.0),
                                                                              ),
                                                                              child: Container(
                                                                                width: 74.0,
                                                                                height: 52.0,
                                                                                decoration: BoxDecoration(
                                                                                  color: FFAppState().testQueAnsList[quetionListIndex] < 4 ? (FFAppState().testQueAnsList[quetionListIndex] == queNumbersIndex ? FlutterFlowTheme.of(context).primary : Colors.white) : Colors.white,
                                                                                  //FlutterFlowTheme.of(context).titleBackground,
                                                                                  boxShadow: [
                                                                                    BoxShadow(
                                                                                      blurRadius: 15.0,
                                                                                      color: Color(0x33000000),
                                                                                      offset: Offset(0.0, 10.0),
                                                                                    )
                                                                                  ],
                                                                                  borderRadius: BorderRadius.circular(12.0),
                                                                                  border: Border.all(
                                                                                    color: FFAppState().testQueAnsList[quetionListIndex] < 4 ? (FFAppState().testQueAnsList[quetionListIndex] == queNumbersIndex ? FlutterFlowTheme.of(context).primary : Colors.white) : Colors.white,
                                                                                  ),
                                                                                ),
                                                                                alignment: AlignmentDirectional(0.0, 0.0),
                                                                                child: Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Text(
                                                                                      queNumbersItem.toString(),
                                                                                      textAlign: TextAlign.center,
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                            color: FFAppState().testQueAnsList[quetionListIndex] < 4 ? (FFAppState().testQueAnsList[quetionListIndex] == queNumbersIndex ? Colors.white : Color(0xFF252525)) : Color(0xFF252525),
                                                                                            fontWeight: FontWeight.normal,
                                                                                            useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                          ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }),
                                                                    );
                                                                  },
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
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.0, 1.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 80.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                  ),
                                  child: PointerInterceptor(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 0.0, 0.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              questionStr = "";
                                              await _model.pageViewController
                                                  ?.previousPage(
                                                duration:
                                                    Duration(milliseconds: 300),
                                                curve: Curves.ease,
                                              );
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                if (idx == 0)
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0.0),
                                                    child: Image.asset(
                                                      'assets/images/arrow-square-left.png',
                                                      width: 44.0,
                                                      height: 44.0,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                if (idx != 0)
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 10.0,
                                                                0.0, 10.0),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0.0),
                                                      child: Image.asset(
                                                        'assets/images/left-filled.png',
                                                        width: 42.0,
                                                        height: 42.0,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 16.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              questionStr = "";
                                              await _model.pageViewController
                                                  ?.nextPage(
                                                duration:
                                                    Duration(milliseconds: 300),
                                                curve: Curves.ease,
                                              );
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                if (_model.questionsList
                                                        ?.jsonBody !=
                                                    null)
                                                  Builder(
                                                    builder: (context) {
                                                      final questionsListJson =
                                                          _model.questionsList
                                                                  ?.jsonBody ??
                                                              '';
                                                      final numQuestions = TestGroup
                                                          .getCompletedTestAttemptDataWithTestResultForATestAttemptCall
                                                          .numQuestions(
                                                              questionsListJson);

                                                      if (numQuestions !=
                                                              null &&
                                                          idx ==
                                                              (numQuestions -
                                                                  1)) {
                                                        return ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      0.0),
                                                          child: Image.asset(
                                                            'assets/images/arrow-square-right.png',
                                                            width: 44.0,
                                                            height: 44.0,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ); // Replace with your actual widget
                                                      }
                                                      return SizedBox
                                                          .shrink(); // Return an empty widget if condition is not met
                                                    },
                                                  ),
                                                

                                                if (idx !=
                                                    (TestGroup
                                                            .getCompletedTestAttemptDataWithTestResultForATestAttemptCall
                                                            .numQuestions(
                                                          (_model.questionsList
                                                                  ?.jsonBody ??
                                                              ''),
                                                        ) -
                                                        1))
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 10.0,
                                                                0.0, 10.0),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0.0),
                                                      child: Image.asset(
                                                        'assets/images/right-filled.png',
                                                        width: 42.0,
                                                        height: 42.0,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
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
              ),
            ),
          ),
        ));
  }
}
