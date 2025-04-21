import '/flutter_flow/custom_functions.dart' as functions;
import '../../backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'test_count_down_timer_model.dart';
export 'test_count_down_timer_model.dart';

class TestCountDownTimerWidget extends StatefulWidget {
   TestCountDownTimerWidget({
    Key? key,
    this.minutes,
    int? seconds,
    this.testAttemptId, required this.testId,
  })  : this.seconds = seconds ?? 0,
        super(key: key);

  final int? minutes;
  final int seconds;
  final String? testAttemptId;
  final String testId;

  @override
  _TestCountDownTimerWidgetState createState() =>
      _TestCountDownTimerWidgetState();
}

class _TestCountDownTimerWidgetState extends State<TestCountDownTimerWidget> {
  late TestCountDownTimerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TestCountDownTimerModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _model.minutes = widget.minutes;
        _model.seconds = widget.seconds;
      });

      _model.instantTimer2 = InstantTimer.periodic(
        duration: Duration(milliseconds: 1000),
        callback: (timer) async {
          if(_model.minutes==0 &&_model.seconds==0){
            print("time is up!!");
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return WillPopScope(
                  onWillPop: () {return Future.value(false);},
                  child: AlertDialog(
                    title: Center(child: Text("Time's Up!", style: FlutterFlowTheme.of(context)
                        .bodyMedium
                        .override(
                      fontFamily:
                      FlutterFlowTheme.of(context)
                          .bodyMediumFamily,
                      color: FlutterFlowTheme.of(context).primary,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      useGoogleFonts: GoogleFonts
                          .asMap()
                          .containsKey(
                          FlutterFlowTheme.of(
                              context)
                              .bodyMediumFamily),
                    ),)),
                    content: Container(
                      height:MediaQuery.of(context).size.height*0.2,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/timer.jpg",height:40,width:40),
                          Text("Your time has run out.",style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                            fontFamily:
                            FlutterFlowTheme.of(context)
                                .bodyMediumFamily,
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                            useGoogleFonts: GoogleFonts
                                .asMap()
                                .containsKey(
                                FlutterFlowTheme.of(
                                    context)
                                    .bodyMediumFamily),
                          )),
                          Container(
                            width: double.infinity,
                            height: 60.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 8.0, 10.0, 8.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
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
                                   await TestGroup
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
                                    elapsedDurationInSec: 200,
                                    //  elapsedDurationInSec: functions.getElapsedTime(_model.startTimeInSec!,_model.minutes!),
                                    currentQuestionOffset: 0,
                                    completed: true,
                                  ).then((value) {
                                    Navigator.pop(context);
                                    context.goNamed(
                                      'CreateTestResultPage',
                                      queryParameters: {
                                        'testAttemptId': serializeParam(
                                          widget.testAttemptId,
                                          ParamType.String,
                                        ),
                                      }.withoutNulls,
                                    );

                                  });


                                },
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Check Result',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                          fontFamily:
                                          FlutterFlowTheme.of(context)
                                              .bodyMediumFamily,
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          useGoogleFonts: GoogleFonts
                                              .asMap()
                                              .containsKey(
                                              FlutterFlowTheme.of(
                                                  context)
                                                  .bodyMediumFamily),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ),
                );
              },
            );
            timer.cancel();
            return;
          }
         else if (_model.seconds == 0) {
            setState(() {
              _model.minutes = (int var1) {
                return var1 > 0 ? (var1 - 1) : 0;
              }(_model.minutes!);
              _model.seconds = (int var1) {
                return var1 > 0 ? 59 : 0;
              }(_model.minutes!);
            });
            return;
          } else {
            setState(() {
              _model.seconds = _model.seconds! + -1;
            });
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
    _model.maybeDispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 20.0, 0.0),
      child: Text(
        '${(String var1) {
          return var1.padLeft(2, '0');
        }(_model.minutes!.toString())} : ${(String var1) {
          return var1.padLeft(2, '0');
        }(_model.seconds!.toString())}',
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
              fontSize: 15.0,
              fontWeight: FontWeight.normal,
              useGoogleFonts: GoogleFonts.asMap()
                  .containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
            ),
      ),
    );
  }
}
