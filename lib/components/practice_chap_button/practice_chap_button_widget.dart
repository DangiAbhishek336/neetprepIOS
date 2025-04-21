import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:neetprep_essential/clevertap/clevertap_service.dart';
import 'package:neetprep_essential/flutter_flow/flutter_flow_animations.dart';
import 'package:neetprep_essential/pages/practice/practice_chapter_wise_page/practice_chapter_page_model.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'practice_chap_button_model.dart';
export 'practice_chap_button_model.dart';

class PracticeChapButtonWidget extends StatefulWidget {
  const PracticeChapButtonWidget(
      {Key? key,
        this.parameter1,
        this.parameter2,
        this.parameter3,
        required this.parameter4,
        required this.trial,
        required this.hasChapterAccess,
        required this.topicId,
        required this.isPaidUser,
      required this.courseIdInt,
      required this.courseIdInts})
      : super(key: key);

  final dynamic parameter1;
  final dynamic parameter2;
  final dynamic parameter3;
  final List<int>? parameter4;
  final bool trial;
  final bool hasChapterAccess;
  final bool isPaidUser;
  final int courseIdInt;
  final String courseIdInts;
  final String topicId;

  @override
  _PracticeChapButtonWidgetState createState() =>
      _PracticeChapButtonWidgetState();
}

class _PracticeChapButtonWidgetState extends State<PracticeChapButtonWidget> {
  late PracticeChapButtonModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PracticeChapButtonModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  final InAppReview inAppReview = InAppReview.instance;

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
      child: Material(
        color: FlutterFlowTheme.of(context).primaryBackground,
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 320),
          curve: Curves.bounceOut,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: [
              BoxShadow(
                blurRadius: 60.0,
                color: Color(0x04060F0D),
                offset: Offset(0.0, 4.0),
                spreadRadius: 0.0,
              )
            ],
            borderRadius: BorderRadius.circular(16.0),
          ),
          alignment: AlignmentDirectional(0.0, 0.0),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 20.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 15.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 20.0, 0.0, 0.0),
                              child: AutoSizeText(
                                '${widget.parameter1?.toString()}',
                                maxLines: 2,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily),
                                    ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 4.0, 0.0, 20.0),
                                  child: Text(
                                    'No of Questions: ${widget.parameter2?.toString()}',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: FlutterFlowTheme.of(context)
                                              .bodyMediumFamily,
                                          color: Color(0xFF858585),
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.normal,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                        ),
                                  ),
                                ),
                                (widget.trial && widget.hasChapterAccess)?Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8.0, 4.0, 0.0, 20.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFf5f5f5),
                                      borderRadius:
                                      BorderRadius.circular(
                                          5.0),
                                      border: Border.all(
                                        color:
                                        Color(0xFFf5f5f5),
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          6.0, 2.0, 6.0, 2.0),
                                      child: Text(
                                        '${(widget.trial && widget.hasChapterAccess)?" Free ":""}',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                          fontFamily: FlutterFlowTheme.of(context)
                                              .bodyMediumFamily,
                                          color:Color(0xFF252525),
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w400,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily),
                                        ),
                                      ),
                                    ),
                                  ),
                                ):SizedBox(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    FFButtonWidget(
                      onPressed: () async {
                        // final InAppReview inAppReview = InAppReview.instance;

                        FirebaseAnalytics.instance.logEvent(
                          name: 'practice_button_click',
                          parameters: {
                            "courseId":widget.courseIdInt,
                            "testId": serializeParam(
                              widget.parameter3?.toString(),
                              ParamType.String,
                            ),
                          },
                        );
                        CleverTapService.recordEvent(
                          'Practice Button Click',
                          {"courseId":widget.courseIdInt,
                            "testId": serializeParam(
                              widget.parameter3?.toString(),
                              ParamType.String,
                            ),
                          },
                        );

                        if (FFAppState().showRatingPrompt > 3) {
                          await inAppReview.isAvailable();
                          inAppReview.requestReview();
                          FFAppState().showRatingPrompt = -1;
                        }
                        _model.numTabs = await actions.getTabs(
                          widget.parameter2!,
                        );
                        FFAppState().numberOfTabs =
                            _model.numTabs!.toList().cast<int>();
                        FFAppState().topicNameForEachPage =
                            widget.parameter1!.toString();
                        if (widget.parameter2.toString() == "0") {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text("Questions for this chapter are not uploaded yet. Kindly check again after a few days.",style:FlutterFlowTheme.of(context).bodyMedium),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      child: Text("OK"),
                                      style: ElevatedButton
                                          .styleFrom(
                                      backgroundColor: FlutterFlowTheme.of(
                                context)
                                    .primary,
                                shape:
                                RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius
                                    .circular(
                                8.0),
                                ),
                                padding: EdgeInsets
                                    .fromLTRB(
                                20.0,
                                14.0,
                                20.0,
                                14.0),
                                ),
                                      onPressed: () {
                                        // Close the pop-up
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        } else {
                          context.pushNamed(
                            'PracticeTestPage',
                            queryParameters: {
                              'testId': serializeParam(
                                widget.parameter3?.toString(),
                                ParamType.String,
                              ),
                              'courseIdInt': serializeParam(
                                widget.courseIdInt.toString(),
                                ParamType.int,
                              ),
                              'courseIdInts': serializeParam(
                                widget.courseIdInts.toString(),
                                ParamType.String,
                              ),
                              'topicId': serializeParam(
                                widget.topicId.toString(),
                                ParamType.String,
                              ),
                            }.withoutNulls,
                          );
                        }

                        setState(() {});
                      },
                      text: 'Practice',
                      options: FFButtonOptions(
                        // height: 40,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 8.0, 16.0, 8.0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 8.0, 16.0, 8.0),
                        iconSize: 13,
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle: FlutterFlowTheme.of(context)
                            .titleSmall
                            .override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).titleSmallFamily,
                              color: Colors.white,
                              fontSize: 12.0,
                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                  FlutterFlowTheme.of(context)
                                      .titleSmallFamily),
                            ),
                        elevation: 3.0,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                        hoverBorderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          width: 1.0,
                        ),
                        hoverElevation: 5.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
