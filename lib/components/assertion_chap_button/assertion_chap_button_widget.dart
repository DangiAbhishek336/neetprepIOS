import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:neetprep_essential/flutter_flow/flutter_flow_animations.dart';
import '../../backend/api_requests/api_calls.dart';
import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../pages/practice/assertion_limit_popup/assertion_limit_popup_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'assertion_chap_button_model.dart';
export 'assertion_chap_button_model.dart';
import '/flutter_flow/custom_functions.dart' as functions;
class AssertionChapButtonWidget extends StatefulWidget {
  const AssertionChapButtonWidget({
    Key? key,
    required this.courseId,
    required this.hasAccess,
    this.parameter1,
    this.parameter2,
    this.parameter3,
    required this.parameter4,
  }) : super(key: key);
  final int courseId;
  final bool hasAccess;
  final dynamic parameter1;
  final dynamic parameter2;
  final dynamic parameter3;
  final List<int>? parameter4;

  @override
  _AssertionChapButtonWidgetState  createState() =>
      _AssertionChapButtonWidgetState ();
}

class _AssertionChapButtonWidgetState extends State<AssertionChapButtonWidget> {
  late AssertionChapButtonModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AssertionChapButtonModel());

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
        color: Colors.transparent,
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
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 4.0, 0.0, 10.0),
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
                            widget.hasAccess?
                            InkWell(
                              onTap: (){
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(height:10),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Reset Attempt',
                                                  style: FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                    fontFamily:
                                                    FlutterFlowTheme.of(
                                                        context)
                                                        .bodyMediumFamily,
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.w700,
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
                                                  color: FlutterFlowTheme.of(context)
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
                                            style:FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                              fontFamily:
                                              FlutterFlowTheme.of(
                                                  context)
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
                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                    fontWeight: FontWeight.w400,
                                                    color:Color(0XFF858585),
                                                    fontSize: 14.0,
                                                    useGoogleFonts:
                                                    GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: 'PERMANENTLY DELETED',
                                                  style:  FlutterFlowTheme.of(
                                                      context)
                                                      .bodyMedium
                                                      .override(
                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                    fontWeight: FontWeight.w700,
                                                    color:Color(0XFF858585),
                                                    fontSize: 14.0,
                                                    useGoogleFonts:
                                                    GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '. This action cannot be reverted.',
                                                  style:  FlutterFlowTheme.of(
                                                      context)
                                                      .bodyMedium
                                                      .override(
                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                    fontWeight: FontWeight.w400,
                                                    color:Color(0XFF858585),
                                                    fontSize: 14.0,
                                                    useGoogleFonts:
                                                    GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                  ),
                                                ),
                                              ],
                                              style: FlutterFlowTheme.of(context).bodyMedium,
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
                                                onPressed: () async{
                                                  await PracticeGroup
                                                      .resetAttemptsOfAPracticeTestShownOnClickingOnTheThreeDotsBesidesTestNameCall
                                                      .call(
                                                    selectedId: functions
                                                        .getIntFromBase64(
                                                      widget.parameter3!.toString()),
                                                    authToken: FFAppState().subjectToken,
                                                  ).then((_){
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Color(0xffEF4444),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8.0),
                                                  ),
                                                  padding: EdgeInsets.fromLTRB(20.0, 14.0, 20.0,14.0),
                                                ),
                                                child: Text('Delete',style:  FlutterFlowTheme.of(
                                                    context)
                                                    .bodyMedium
                                                    .override(
                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                  fontWeight: FontWeight.w500,
                                                  color:Colors.white,
                                                  fontSize: 16.0,
                                                  useGoogleFonts:
                                                  GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                )),
                                              ),
                                              SizedBox(height: 10.0),
                                              OutlinedButton(
                                                onPressed: () {

                                                  Navigator.pop(context);
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  side: BorderSide(color: FlutterFlowTheme.of(context).primary),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8.0),
                                                  ),
                                                  padding: EdgeInsets.fromLTRB(20.0, 14.0, 20.0,14.0),
                                                ),
                                                child: Text('Cancel', style:  FlutterFlowTheme.of(
                                                    context)
                                                    .bodyMedium
                                                    .override(
                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                  fontWeight: FontWeight.w500,
                                                  color:FlutterFlowTheme.of(context).primary,
                                                  fontSize: 16.0,
                                                  useGoogleFonts:
                                                  GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                )),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height:10),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Padding(
                                padding:
                                EdgeInsetsDirectional
                                    .fromSTEB(
                                    0.0,
                                    8.0,
                                    0.0,
                                    20.0),
                                child: Row(
                                  mainAxisSize:
                                  MainAxisSize.min,
                                  children: [
                                    Container(
                                      decoration:
                                      BoxDecoration(
                                        color: Color(
                                            0xFFF5F5F5),
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
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/images/reset_attempt.svg',
                                              fit: BoxFit.none,
                                            ),
                                            SizedBox(width:10),
                                            AutoSizeText(
                                              "Reset Attempts",
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
                                                color: Color(0xff121212),
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
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ):SizedBox(height:20),
                          ],
                        ),
                      ),
                    ),
                   widget.hasAccess?
                   FFButtonWidget(
                      onPressed: () async {
                        // final InAppReview inAppReview = InAppReview.instance;




                          context.pushNamed(
                            'PracticeQuetionsPage',
                            queryParameters: {
                              'testId':
                              serializeParam(
                                widget.parameter3?.toString(),
                                ParamType.String,
                              ),
                              'offset':
                              serializeParam(
                                0,
                                ParamType.int,
                              ),
                              'numberOfQuestions':
                              serializeParam(
                                widget.parameter2?.toString(),
                                ParamType.int,
                              ),
                              'sectionPointer':
                              serializeParam(
                                0,
                                ParamType.int,
                              ),
                              'chapterName':
                              serializeParam(
                                widget.parameter1?.toString(),
                                ParamType.String,
                              ),
                              'courseIdInt': serializeParam(
                                widget.courseId,
                                ParamType.int,
                              ),
                            }.withoutNulls,
                            extra: <String,
                                dynamic>{
                              kTransitionInfoKey:
                              TransitionInfo(
                                hasTransition:
                                true,
                                transitionType:
                                PageTransitionType
                                    .rightToLeft,
                              ),
                            },
                          );



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
                    ):  InkWell(
                     onTap: (){
                       showModalBottomSheet(
                         isScrollControlled: true,
                         backgroundColor: Colors.transparent,
                         context: context,
                         builder: (context) {
                           return GestureDetector(
                             child: Padding(
                               padding: MediaQuery.of(context).viewInsets,
                               child: AssertionLimitPopupWidget(),
                             ),
                           );
                         },
                       );
                     },
                      child: Padding(
                       padding: EdgeInsetsDirectional
                           .fromSTEB(
                           16.0,
                           0.0,
                           20.0,
                           0.0),
                       child: Image
                           .asset(
                         'assets/images/lock.png',
                         width:
                         24.0,
                         height:
                         24.0,
                         fit: BoxFit
                             .cover,
                         color:FlutterFlowTheme.of(context).primaryText
                       )
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
