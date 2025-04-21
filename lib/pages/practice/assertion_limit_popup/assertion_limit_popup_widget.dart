import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neetprep_essential/pages/create_test/test_limit_popup/test_limit_popup_model.dart';
import 'package:neetprep_essential/pages/practice/assertion_limit_popup/assertion_limit_popup_model.dart';
import '../../../clevertap/clevertap_service.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class AssertionLimitPopupWidget extends StatefulWidget {
  const AssertionLimitPopupWidget({Key? key})  :super(key: key);

  @override
  _AssertionLimitPopupWidgetState createState() => _AssertionLimitPopupWidgetState();
}

class _AssertionLimitPopupWidgetState extends State<AssertionLimitPopupWidget> {
  late AssertionLimitPopupModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AssertionLimitPopupModel());
    CleverTapService.recordPageView("Assertion Limit Popup Opened");
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

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Color.fromARGB(100, 0, 0, 0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Align(
            alignment: AlignmentDirectional(0.0, 1.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Material(
                    color: Colors.transparent,
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(0.0),
                        bottomRight: Radius.circular(0.0),
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(0.0),
                          bottomRight: Radius.circular(0.0),
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 18.0, 14.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
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
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 0.0, 10.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                'assets/images/Group_1000004054.png',
                                width: 75.0,
                                height: 64.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Divider(
                            height: 4.0,
                            thickness: 1.0,
                            color: Color(0xFFE0E3E7),
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 10.0, 16.0, 10.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    "Ab se No More Fear of Assertion/Reason Q's for NEET!",
                                    style:
                                    FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                        ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 10.0, 10.0, 10.0),
                                    child:  RichText(
                                      text: TextSpan(
                                        text: "Recent trend has changed to include more newer question types. Of these, Assertion Reason & Statements type Q's are the most challenging to NEET Aspirants.\n\nWith exclusive ",
                                        style: FlutterFlowTheme
                                            .of(context)
                                            .bodyMedium
                                            .override(
                                          fontSize: 12,
                                          fontFamily: FlutterFlowTheme
                                              .of(context)
                                              .bodyMediumFamily,
                                          color: FlutterFlowTheme.of(context).accent1,
                                          fontWeight: FontWeight.w400,
                                          useGoogleFonts: GoogleFonts
                                              .asMap()
                                              .containsKey(
                                              FlutterFlowTheme
                                                  .of(context)
                                                  .bodyMediumFamily),
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'ASSERTION/ REASON + STATEMENT Type Q ',
                                            style: FlutterFlowTheme
                                                .of(context)
                                                .bodyMedium
                                                .override(
                                              fontSize: 12,
                                              fontFamily: FlutterFlowTheme
                                                  .of(context)
                                                  .bodyMediumFamily,
                                              color: FlutterFlowTheme.of(context).accent1,
                                              fontWeight: FontWeight.w700,
                                              useGoogleFonts: GoogleFonts
                                                  .asMap()
                                                  .containsKey(
                                                  FlutterFlowTheme
                                                      .of(context)
                                                      .bodyMediumFamily),
                                            ),
                                          ),
                                          TextSpan(
                                            text: "PowerUp Course, conquer your fear and excel in NEET by practicing",
                                            style: FlutterFlowTheme
                                                .of(context)
                                                .bodyMedium
                                                .override(
                                              fontSize: 12,
                                              fontFamily: FlutterFlowTheme
                                                  .of(context)
                                                  .bodyMediumFamily,
                                              color: FlutterFlowTheme.of(context).accent1,
                                              fontWeight: FontWeight.w400,
                                              useGoogleFonts: GoogleFonts
                                                  .asMap()
                                                  .containsKey(
                                                  FlutterFlowTheme
                                                      .of(context)
                                                      .bodyMediumFamily),
                                            ),
                                          ),
                                          TextSpan(
                                            text: " 2500+ Q's",
                                            style:  FlutterFlowTheme
                                                .of(context)
                                                .bodyMedium
                                                .override(
                                              fontSize: 12,
                                              fontFamily: FlutterFlowTheme
                                                  .of(context)
                                                  .bodyMediumFamily,
                                              color: FlutterFlowTheme.of(context).accent1,
                                              fontWeight: FontWeight.w700,
                                              useGoogleFonts: GoogleFonts
                                                  .asMap()
                                                  .containsKey(
                                                  FlutterFlowTheme
                                                      .of(context)
                                                      .bodyMediumFamily),
                                            ),
                                          ),
                                          TextSpan(
                                            text: "!\n",
                                            style:  FlutterFlowTheme
                                                .of(context)
                                                .bodyMedium
                                                .override(
                                              fontSize: 12,
                                              fontFamily: FlutterFlowTheme
                                                  .of(context)
                                                  .bodyMediumFamily,
                                              color: FlutterFlowTheme.of(context).accent1,
                                              fontWeight: FontWeight.w400,
                                              useGoogleFonts: GoogleFonts
                                                  .asMap()
                                                  .containsKey(
                                                  FlutterFlowTheme
                                                      .of(context)
                                                      .bodyMediumFamily),
                                            ),
                                          ),
                                          TextSpan(
                                            text: "\nAs bonus, there will be ",
                                            style:  FlutterFlowTheme
                                                .of(context)
                                                .bodyMedium
                                                .override(
                                              fontSize: 12,
                                              fontFamily: FlutterFlowTheme
                                                  .of(context)
                                                  .bodyMediumFamily,
                                              color: FlutterFlowTheme.of(context).accent1,
                                              fontWeight: FontWeight.w400,
                                              useGoogleFonts: GoogleFonts
                                                  .asMap()
                                                  .containsKey(
                                                  FlutterFlowTheme
                                                      .of(context)
                                                      .bodyMediumFamily),
                                            ),
                                          ),
                                          TextSpan(
                                            text: "Matching Type Q's & Graphs Based Q's ",
                                            style:  FlutterFlowTheme
                                                .of(context)
                                                .bodyMedium
                                                .override(
                                              fontSize: 12,
                                              fontFamily: FlutterFlowTheme
                                                  .of(context)
                                                  .bodyMediumFamily,
                                              color: FlutterFlowTheme.of(context).accent1,
                                              fontWeight: FontWeight.bold,
                                              useGoogleFonts: GoogleFonts
                                                  .asMap()
                                                  .containsKey(
                                                  FlutterFlowTheme
                                                      .of(context)
                                                      .bodyMediumFamily),
                                            ),
                                          ),
                                          TextSpan(
                                            text: "as well!",
                                            style:  FlutterFlowTheme
                                                .of(context)
                                                .bodyMedium
                                                .override(
                                              fontSize: 12,
                                              fontFamily: FlutterFlowTheme
                                                  .of(context)
                                                  .bodyMediumFamily,
                                              color: FlutterFlowTheme.of(context).accent1,
                                              fontWeight: FontWeight.w400,
                                              useGoogleFonts: GoogleFonts
                                                  .asMap()
                                                  .containsKey(
                                                  FlutterFlowTheme
                                                      .of(context)
                                                      .bodyMediumFamily),
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
                          Container(
                            width: double.infinity,
                            height: 60.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 12.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  Navigator.pop(context);
                                  await FirebaseAnalytics.instance.logEvent(
                                    name: 'enroll_now_button_click',
                                    parameters: {
                                      "courseId":
                                        FFAppState().courseIdInt.toString(),
                                    },
                                  );
                                  context.pushNamed('OrderPage',  queryParameters: {
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
                                        'Enroll Now',
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
