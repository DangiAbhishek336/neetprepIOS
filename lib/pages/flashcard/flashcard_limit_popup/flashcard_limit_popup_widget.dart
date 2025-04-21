import 'package:firebase_analytics/firebase_analytics.dart';
import '../../../clevertap/clevertap_service.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'flashcard_limit_popup_model.dart';


class FlashcardLimitPopupWidget extends StatefulWidget {
  const FlashcardLimitPopupWidget({Key? key})  :super(key: key);

  @override
  _FlashcardLimitPopupWidgetState createState() => _FlashcardLimitPopupWidgetState();
}

class _FlashcardLimitPopupWidgetState extends State<FlashcardLimitPopupWidget> {
  late FlashcardLimitPopupModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FlashcardLimitPopupModel());
    FirebaseAnalytics.instance
        .setCurrentScreen(screenName: "FlashcardLimitPopupPage");
    CleverTapService.recordPageView("Flashcard Limit Popup Page");
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
                                    'Ace NEET with Premium Pagewise Flashcards'
                                        ,
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
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 10, 18, 5),
                                    child: ListTile(
                                      leading: Text('📕'),
                                      minLeadingWidth: 5.0,
                                      title: Text(
                                        '10,000+ PageWise Flashcards',
                                        style: FlutterFlowTheme
                                            .of(context)
                                            .bodyMedium
                                            .override(
                                          fontSize: 14,
                                          fontFamily: FlutterFlowTheme
                                              .of(context)
                                              .bodyMediumFamily,
                                          fontWeight: FontWeight.w600,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                              FlutterFlowTheme
                                                  .of(context)
                                                  .bodyMediumFamily),
                                        ),
                                      ),
                                      subtitle: Text(
                                          'For P+C+B with Both NEW & OLD NCERT Page Filter',
                                          style: FlutterFlowTheme
                                              .of(context)
                                              .bodyMedium
                                              .override(
                                            fontSize: 14,
                                            fontFamily: FlutterFlowTheme
                                                .of(context)
                                                .bodyMediumFamily,
                                            color: Color(0xff858585),
                                            fontWeight: FontWeight.w400,
                                            useGoogleFonts: GoogleFonts
                                                .asMap()
                                                .containsKey(
                                                FlutterFlowTheme
                                                    .of(context)
                                                    .bodyMediumFamily),
                                          )),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 10, 18, 5),
                                    child: ListTile(
                                      leading: Text('🔄'),
                                      minLeadingWidth: 5.0,
                                      title: Text(
                                        'Actively Recall NCERT PageWise',
                                        style: FlutterFlowTheme
                                            .of(context)
                                            .bodyMedium
                                            .override(
                                          fontSize: 14,
                                          fontFamily: FlutterFlowTheme
                                              .of(context)
                                              .bodyMediumFamily,

                                          fontWeight: FontWeight.w600,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                              FlutterFlowTheme
                                                  .of(context)
                                                  .bodyMediumFamily),
                                        ),
                                      ),
                                      subtitle: Text(
                                          'Rapidly Revise the Most Forgettable Words & Concepts on an NCERT Page',
                                          style: FlutterFlowTheme
                                              .of(context)
                                              .bodyMedium
                                              .override(
                                            fontSize: 14,
                                            fontFamily: FlutterFlowTheme
                                                .of(context)
                                                .bodyMediumFamily,
                                            color: Color(0xff858585),
                                            fontWeight: FontWeight.w400,
                                            useGoogleFonts: GoogleFonts
                                                .asMap()
                                                .containsKey(
                                                FlutterFlowTheme
                                                    .of(context)
                                                    .bodyMediumFamily),
                                          )),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 10, 18, 5),
                                    child: ListTile(
                                      leading: Text('⏳'),
                                      minLeadingWidth: 5.0,
                                      title: Text(
                                        'Limited Time Discount',
                                        style: FlutterFlowTheme
                                            .of(context)
                                            .bodyMedium
                                            .override(
                                          fontSize: 14,
                                          fontFamily: FlutterFlowTheme
                                              .of(context)
                                              .bodyMediumFamily,

                                          fontWeight: FontWeight.w600,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                              FlutterFlowTheme
                                                  .of(context)
                                                  .bodyMediumFamily),
                                        ),
                                      ),
                                      subtitle: Text(
                                          "Grab this exclusive New Year deal before it's gone!",
                                          style: FlutterFlowTheme
                                              .of(context)
                                              .bodyMedium
                                              .override(
                                            fontSize: 14,
                                            fontFamily: FlutterFlowTheme
                                                .of(context)
                                                .bodyMediumFamily,
                                            color: Color(0xff858585),
                                            fontWeight: FontWeight.w400,
                                            useGoogleFonts: GoogleFonts
                                                .asMap()
                                                .containsKey(
                                                FlutterFlowTheme
                                                    .of(context)
                                                    .bodyMediumFamily),
                                          )),
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
                              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 12.0),
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
                                        FFAppState().flashcardCourseId.toString(),
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
                                        'Go Premium Now',
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
