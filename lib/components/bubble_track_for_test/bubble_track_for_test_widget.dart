import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/random_data_util.dart' as random_data;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'bubble_track_for_test_model.dart';
export 'bubble_track_for_test_model.dart';

class BubbleTrackForTestWidget extends StatefulWidget {
  const BubbleTrackForTestWidget({
    Key? key,
    this.testId,
    this.numberOfQuestions,
    this.testAttemptId,
  }) : super(key: key);

  final String? testId;
  final int? numberOfQuestions;
  final String? testAttemptId;

  @override
  _BubbleTrackForTestWidgetState createState() =>
      _BubbleTrackForTestWidgetState();
}

class _BubbleTrackForTestWidgetState extends State<BubbleTrackForTestWidget> {
  late BubbleTrackForTestModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BubbleTrackForTestModel());

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

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            height: 100.0,
            decoration: BoxDecoration(
              color: Color(0x00FFFFFF),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (false)
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 12.0),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.sizeOf(context).height * 0.5,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 5.0, 0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 110.0,
                                  height: 3.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF838383),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                20.0, 15.0, 20.0, 20.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(
                                    Icons.cancel_outlined,
                                    color: Color(0xFF00629F),
                                    size: 20.0,
                                  ),
                                ),
                                Text(
                                  'Question Tracker',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w500,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                ),
                                Icon(
                                  Icons.cancel_outlined,
                                  color: Color(0x0000629F),
                                  size: 24.0,
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 1.0,
                            color: Color(0xFFA6A6A6),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  10.0, 10.0, 10.0, 10.0),
                              child: Container(
                                height: 200.0,
                                decoration: BoxDecoration(),
                                child: Builder(
                                  builder: (context) {
                                    final answerList =
                                        FFAppState().testQueAnsList.toList();
                                    return GridView.builder(
                                      padding: EdgeInsets.zero,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 5,
                                        crossAxisSpacing: 10.0,
                                        mainAxisSpacing: 10.0,
                                        childAspectRatio: 1.0,
                                      ),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: answerList.length,
                                      itemBuilder: (context, answerListIndex) {
                                        final answerListItem =
                                            answerList[answerListIndex];
                                        return Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  5.0, 5.0, 5.0, 5.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              Navigator.pop(
                                                  context, answerListIndex);
                                            },
                                            child: Container(
                                              width: 100.0,
                                              height: 100.0,
                                              decoration: BoxDecoration(
                                                color: answerListItem < 4
                                                    ? Color(0xFF5EB85E)
                                                    : Color(0xFF00629F),
                                                shape: BoxShape.circle,
                                              ),
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: Text(
                                                (answerListIndex + 1)
                                                    .toString(),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color: Colors.white,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily),
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
                        ],
                      ),
                    ),
                  ),
                Container(

                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height * 0.6,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 4.0, 0.0, 16.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Question Tracker',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily),
                                    ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 4.0, 0.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    Navigator.pop(context);
                                  },
                                  child: FaIcon(
                                    FontAwesomeIcons.timesCircle,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 24.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child:
                            // Column(
                            //   mainAxisSize: MainAxisSize.max,
                            //   children: [
                            //     if (false)
                            //       Material(
                            //         color: Colors.transparent,
                            //         elevation: 2.0,
                            //         shape: RoundedRectangleBorder(
                            //           borderRadius: BorderRadius.circular(16.0),
                            //         ),
                            //         child: Container(
                            //           decoration: BoxDecoration(
                            //             color: FlutterFlowTheme.of(context)
                            //                 .secondaryBackground,
                            //             borderRadius:
                            //                 BorderRadius.circular(16.0),
                            //             border: Border.all(
                            //               color: Color(0xFFE9E9E9),
                            //               width: 1.0,
                            //             ),
                            //           ),
                            //           child: Column(
                            //             mainAxisSize: MainAxisSize.max,
                            //             crossAxisAlignment:
                            //                 CrossAxisAlignment.start,
                            //             children: [
                            //               Padding(
                            //                 padding:
                            //                     EdgeInsetsDirectional.fromSTEB(
                            //                         20.0, 16.0, 20.0, 20.0),
                            //                 child: Row(
                            //                   mainAxisSize: MainAxisSize.max,
                            //                   mainAxisAlignment:
                            //                       MainAxisAlignment
                            //                           .spaceBetween,
                            //                   children: [
                            //                     Column(
                            //                       mainAxisSize:
                            //                           MainAxisSize.max,
                            //                       crossAxisAlignment:
                            //                           CrossAxisAlignment.start,
                            //                       children: [
                            //                         Padding(
                            //                           padding:
                            //                               EdgeInsetsDirectional
                            //                                   .fromSTEB(
                            //                                       0.0,
                            //                                       0.0,
                            //                                       0.0,
                            //                                       5.0),
                            //                           child: Row(
                            //                             mainAxisSize:
                            //                                 MainAxisSize.max,
                            //                             children: [
                            //                               Container(
                            //                                 width: 20.0,
                            //                                 height: 20.0,
                            //                                 decoration:
                            //                                     BoxDecoration(
                            //                                   color: Color(
                            //                                       0xFF10B981),
                            //                                   shape: BoxShape
                            //                                       .circle,
                            //                                 ),
                            //                               ),
                            //                               Padding(
                            //                                 padding:
                            //                                     EdgeInsetsDirectional
                            //                                         .fromSTEB(
                            //                                             8.0,
                            //                                             0.0,
                            //                                             0.0,
                            //                                             0.0),
                            //                                 child: Text(
                            //                                   'Correct',
                            //                                   style: FlutterFlowTheme
                            //                                           .of(context)
                            //                                       .bodyMedium
                            //                                       .override(
                            //                                         fontFamily:
                            //                                             FlutterFlowTheme.of(context)
                            //                                                 .bodyMediumFamily,
                            //                                         color: Color(
                            //                                             0xFF6E6E6E),
                            //                                         fontSize:
                            //                                             12.0,
                            //                                         fontWeight:
                            //                                             FontWeight
                            //                                                 .normal,
                            //                                         useGoogleFonts: GoogleFonts
                            //                                                 .asMap()
                            //                                             .containsKey(
                            //                                                 FlutterFlowTheme.of(context).bodyMediumFamily),
                            //                                       ),
                            //                                 ),
                            //                               ),
                            //                               Padding(
                            //                                 padding:
                            //                                     EdgeInsetsDirectional
                            //                                         .fromSTEB(
                            //                                             5.0,
                            //                                             0.0,
                            //                                             0.0,
                            //                                             0.0),
                            //                                 child: Text(
                            //                                   '( ${functions.getTotalOfAllStatus(FFAppState().allQuestionsStatus.toList(), 'correct').toString()}/${widget.numberOfQuestions?.toString()} )',
                            //                                   style: FlutterFlowTheme
                            //                                           .of(context)
                            //                                       .bodyMedium
                            //                                       .override(
                            //                                         fontFamily:
                            //                                             FlutterFlowTheme.of(context)
                            //                                                 .bodyMediumFamily,
                            //                                         color: Color(
                            //                                             0xFF6E6E6E),
                            //                                         fontSize:
                            //                                             12.0,
                            //                                         fontWeight:
                            //                                             FontWeight
                            //                                                 .normal,
                            //                                         useGoogleFonts: GoogleFonts
                            //                                                 .asMap()
                            //                                             .containsKey(
                            //                                                 FlutterFlowTheme.of(context).bodyMediumFamily),
                            //                                       ),
                            //                                 ),
                            //                               ),
                            //                             ],
                            //                           ),
                            //                         ),
                            //                         Padding(
                            //                           padding:
                            //                               EdgeInsetsDirectional
                            //                                   .fromSTEB(
                            //                                       0.0,
                            //                                       0.0,
                            //                                       0.0,
                            //                                       5.0),
                            //                           child: Row(
                            //                             mainAxisSize:
                            //                                 MainAxisSize.max,
                            //                             children: [
                            //                               Container(
                            //                                 width: 20.0,
                            //                                 height: 20.0,
                            //                                 decoration:
                            //                                     BoxDecoration(
                            //                                   color: Color(
                            //                                       0xFFEF4444),
                            //                                   shape: BoxShape
                            //                                       .circle,
                            //                                 ),
                            //                               ),
                            //                               Padding(
                            //                                 padding:
                            //                                     EdgeInsetsDirectional
                            //                                         .fromSTEB(
                            //                                             8.0,
                            //                                             0.0,
                            //                                             0.0,
                            //                                             0.0),
                            //                                 child: Text(
                            //                                   'Incorrect',
                            //                                   style: FlutterFlowTheme
                            //                                           .of(context)
                            //                                       .bodyMedium
                            //                                       .override(
                            //                                         fontFamily:
                            //                                             FlutterFlowTheme.of(context)
                            //                                                 .bodyMediumFamily,
                            //                                         color: Color(
                            //                                             0xFF6E6E6E),
                            //                                         fontSize:
                            //                                             12.0,
                            //                                         fontWeight:
                            //                                             FontWeight
                            //                                                 .normal,
                            //                                         useGoogleFonts: GoogleFonts
                            //                                                 .asMap()
                            //                                             .containsKey(
                            //                                                 FlutterFlowTheme.of(context).bodyMediumFamily),
                            //                                       ),
                            //                                 ),
                            //                               ),
                            //                               Padding(
                            //                                 padding:
                            //                                     EdgeInsetsDirectional
                            //                                         .fromSTEB(
                            //                                             5.0,
                            //                                             0.0,
                            //                                             0.0,
                            //                                             0.0),
                            //                                 child: Text(
                            //                                   '( ${functions.getTotalOfAllStatus(FFAppState().allQuestionsStatus.toList(), 'incorrect').toString()}/${widget.numberOfQuestions?.toString()} )',
                            //                                   style: FlutterFlowTheme
                            //                                           .of(context)
                            //                                       .bodyMedium
                            //                                       .override(
                            //                                         fontFamily:
                            //                                             FlutterFlowTheme.of(context)
                            //                                                 .bodyMediumFamily,
                            //                                         color: Color(
                            //                                             0xFF6E6E6E),
                            //                                         fontSize:
                            //                                             12.0,
                            //                                         fontWeight:
                            //                                             FontWeight
                            //                                                 .normal,
                            //                                         useGoogleFonts: GoogleFonts
                            //                                                 .asMap()
                            //                                             .containsKey(
                            //                                                 FlutterFlowTheme.of(context).bodyMediumFamily),
                            //                                       ),
                            //                                 ),
                            //                               ),
                            //                             ],
                            //                           ),
                            //                         ),
                            //                         Padding(
                            //                           padding:
                            //                               EdgeInsetsDirectional
                            //                                   .fromSTEB(
                            //                                       0.0,
                            //                                       0.0,
                            //                                       0.0,
                            //                                       5.0),
                            //                           child: Row(
                            //                             mainAxisSize:
                            //                                 MainAxisSize.max,
                            //                             children: [
                            //                               Container(
                            //                                 width: 20.0,
                            //                                 height: 20.0,
                            //                                 decoration:
                            //                                     BoxDecoration(
                            //                                   color: Color(
                            //                                       0xFF4A4A4A),
                            //                                   shape: BoxShape
                            //                                       .circle,
                            //                                 ),
                            //                               ),
                            //                               Padding(
                            //                                 padding:
                            //                                     EdgeInsetsDirectional
                            //                                         .fromSTEB(
                            //                                             8.0,
                            //                                             0.0,
                            //                                             0.0,
                            //                                             0.0),
                            //                                 child: Text(
                            //                                   'Bookmark',
                            //                                   style: FlutterFlowTheme
                            //                                           .of(context)
                            //                                       .bodyMedium
                            //                                       .override(
                            //                                         fontFamily:
                            //                                             FlutterFlowTheme.of(context)
                            //                                                 .bodyMediumFamily,
                            //                                         color: Color(
                            //                                             0xFF6E6E6E),
                            //                                         fontSize:
                            //                                             12.0,
                            //                                         fontWeight:
                            //                                             FontWeight
                            //                                                 .normal,
                            //                                         useGoogleFonts: GoogleFonts
                            //                                                 .asMap()
                            //                                             .containsKey(
                            //                                                 FlutterFlowTheme.of(context).bodyMediumFamily),
                            //                                       ),
                            //                                 ),
                            //                               ),
                            //                               Padding(
                            //                                 padding:
                            //                                     EdgeInsetsDirectional
                            //                                         .fromSTEB(
                            //                                             5.0,
                            //                                             0.0,
                            //                                             0.0,
                            //                                             0.0),
                            //                                 child: Text(
                            //                                   '( ${functions.getTotalOfAllStatus(FFAppState().allQuestionsStatus.toList(), 'bookmark').toString()}/${widget.numberOfQuestions?.toString()} )',
                            //                                   style: FlutterFlowTheme
                            //                                           .of(context)
                            //                                       .bodyMedium
                            //                                       .override(
                            //                                         fontFamily:
                            //                                             FlutterFlowTheme.of(context)
                            //                                                 .bodyMediumFamily,
                            //                                         color: Color(
                            //                                             0xFF6E6E6E),
                            //                                         fontSize:
                            //                                             12.0,
                            //                                         fontWeight:
                            //                                             FontWeight
                            //                                                 .normal,
                            //                                         useGoogleFonts: GoogleFonts
                            //                                                 .asMap()
                            //                                             .containsKey(
                            //                                                 FlutterFlowTheme.of(context).bodyMediumFamily),
                            //                                       ),
                            //                                 ),
                            //                               ),
                            //                             ],
                            //                           ),
                            //                         ),
                            //                         Padding(
                            //                           padding:
                            //                               EdgeInsetsDirectional
                            //                                   .fromSTEB(
                            //                                       0.0,
                            //                                       0.0,
                            //                                       0.0,
                            //                                       5.0),
                            //                           child: Row(
                            //                             mainAxisSize:
                            //                                 MainAxisSize.max,
                            //                             children: [
                            //                               Container(
                            //                                 width: 20.0,
                            //                                 height: 20.0,
                            //                                 decoration:
                            //                                     BoxDecoration(
                            //                                   color: Color(
                            //                                       0xFFD9D9D9),
                            //                                   shape: BoxShape
                            //                                       .circle,
                            //                                 ),
                            //                               ),
                            //                               Padding(
                            //                                 padding:
                            //                                     EdgeInsetsDirectional
                            //                                         .fromSTEB(
                            //                                             8.0,
                            //                                             0.0,
                            //                                             0.0,
                            //                                             0.0),
                            //                                 child: Text(
                            //                                   'Un Attempted',
                            //                                   style: FlutterFlowTheme
                            //                                           .of(context)
                            //                                       .bodyMedium
                            //                                       .override(
                            //                                         fontFamily:
                            //                                             FlutterFlowTheme.of(context)
                            //                                                 .bodyMediumFamily,
                            //                                         color: Color(
                            //                                             0xFF6E6E6E),
                            //                                         fontSize:
                            //                                             12.0,
                            //                                         fontWeight:
                            //                                             FontWeight
                            //                                                 .normal,
                            //                                         useGoogleFonts: GoogleFonts
                            //                                                 .asMap()
                            //                                             .containsKey(
                            //                                                 FlutterFlowTheme.of(context).bodyMediumFamily),
                            //                                       ),
                            //                                 ),
                            //                               ),
                            //                               Padding(
                            //                                 padding:
                            //                                     EdgeInsetsDirectional
                            //                                         .fromSTEB(
                            //                                             5.0,
                            //                                             0.0,
                            //                                             0.0,
                            //                                             0.0),
                            //                                 child: Text(
                            //                                   '( ${functions.getTotalOfAllStatus(FFAppState().allQuestionsStatus.toList(), 'unattempt').toString()}/${widget.numberOfQuestions?.toString()} )',
                            //                                   style: FlutterFlowTheme
                            //                                           .of(context)
                            //                                       .bodyMedium
                            //                                       .override(
                            //                                         fontFamily:
                            //                                             FlutterFlowTheme.of(context)
                            //                                                 .bodyMediumFamily,
                            //                                         color: Color(
                            //                                             0xFF6E6E6E),
                            //                                         fontSize:
                            //                                             12.0,
                            //                                         fontWeight:
                            //                                             FontWeight
                            //                                                 .normal,
                            //                                         useGoogleFonts: GoogleFonts
                            //                                                 .asMap()
                            //                                             .containsKey(
                            //                                                 FlutterFlowTheme.of(context).bodyMediumFamily),
                            //                                       ),
                            //                                 ),
                            //                               ),
                            //                             ],
                            //                           ),
                            //                         ),
                            //                       ],
                            //                     ),
                            //                   ],
                            //                 ),
                            //               ),
                            //               Padding(
                            //                 padding:
                            //                     EdgeInsetsDirectional.fromSTEB(
                            //                         20.0, 0.0, 20.0, 15.0),
                            //                 child: Text(
                            //                   'No negative marks for skipped questions',
                            //                   style:
                            //                       FlutterFlowTheme.of(context)
                            //                           .bodyMedium
                            //                           .override(
                            //                             fontFamily:
                            //                                 FlutterFlowTheme.of(
                            //                                         context)
                            //                                     .bodyMediumFamily,
                            //                             color:
                            //                                 Color(0xFF6E6E6E),
                            //                             fontSize: 12.0,
                            //                             fontWeight:
                            //                                 FontWeight.normal,
                            //                             useGoogleFonts: GoogleFonts
                            //                                     .asMap()
                            //                                 .containsKey(
                            //                                     FlutterFlowTheme.of(
                            //                                             context)
                            //                                         .bodyMediumFamily),
                            //                           ),
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //       ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 30.0, 0.0, 0.0),
                                  child: Container(
                                    decoration: BoxDecoration(),
                                    child: Builder(
                                      builder: (context) {
                                        final quetionList = FFAppState()
                                            .testQueAnsList
                                            .toList();
                                        return GridView.builder(
                                          padding: EdgeInsets.zero,
                                          physics: ScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 5,
                                            crossAxisSpacing: 16.0,
                                            mainAxisSpacing: 20.0,
                                            childAspectRatio:
                                                valueOrDefault<double>(
                                              random_data.randomDouble(
                                                  1.5, 1.5001),
                                              1.5,
                                            ),
                                          ),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount: quetionList.length,
                                          itemBuilder:
                                              (context, quetionListIndex) {
                                            final quetionListItem =
                                                quetionList[quetionListIndex];
                                            return InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                Navigator.pop(
                                                    context, quetionListIndex);
                                              },
                                              child: Material(
                                                color: Colors.transparent,
                                                elevation: 4.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(context).tertiaryBackground,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    shape: BoxShape.rectangle,
                                                    border: Border.all(
                                                      color:
                                                          valueOrDefault<Color>(
                                                        quetionListItem < 4
                                                            ? FlutterFlowTheme
                                                                    .of(context)
                                                                .primary
                                                            : FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryText,
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .primaryText,
                                                      ),
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(10.0, 2.0,
                                                                10.0, 2.0),
                                                    child: AutoSizeText(
                                                      'Q${(quetionListIndex + 1).toString()}',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                             fontSize: 13,
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                color: FlutterFlowTheme.of(context).primaryText,
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
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              // ],
                            // ),
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
      ],
    );
  }
}
