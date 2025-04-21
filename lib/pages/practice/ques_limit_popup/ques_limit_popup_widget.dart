import 'package:firebase_analytics/firebase_analytics.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'ques_limit_popup_model.dart';
export 'ques_limit_popup_model.dart';

class QuesLimitPopupWidget extends StatefulWidget {
  const QuesLimitPopupWidget({
    Key? key,
    required this.mrp,
    required this.currPrice,
    String? disPercent,
  })  : this.disPercent = disPercent ?? 'Early Bird',
        super(key: key);

  final String? mrp;
  final String? currPrice;
  final String disPercent;

  @override
  _QuesLimitPopupWidgetState createState() => _QuesLimitPopupWidgetState();
}

class _QuesLimitPopupWidgetState extends State<QuesLimitPopupWidget> {
  late QuesLimitPopupModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => QuesLimitPopupModel());
    FirebaseAnalytics.instance
        .setCurrentScreen(screenName: "QuestionLimitPopUp");
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
          if (false)
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
              child: Material(
                color: Colors.transparent,
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  width: double.infinity,
                  height: 48.0,
                  decoration: BoxDecoration(
                    color: Color(0xFFFAECD3),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3.0,
                        color: Color(0xA0E6A123),
                        offset: Offset(0.0, 1.0),
                        spreadRadius: 0.0,
                      )
                    ],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            'assets/images/discount-shape.png',
                            width: 22.0,
                            height: 22.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                        child: Text(
                          '${widget.disPercent}',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.05),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              2.0, 0.0, 8.0, 0.0),
                          child: Text(
                            'Discount Applied',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  fontWeight: FontWeight.normal,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .bodyMediumFamily),
                                ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 18.0,
                        child: VerticalDivider(
                          thickness: 1.0,
                          color: Color(0xFF858585),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                        child: Text(
                          '${(String var1) {
                            return var1.split('.').first;
                          }(widget.currPrice!)}',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: Color(0xFF252525),
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.05),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              2.0, 0.0, 10.0, 0.0),
                          child: Text(
                            '${(String var1) {
                              return var1.split('.').first;
                            }(widget.mrp!)}',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.normal,
                                  decoration: TextDecoration.lineThrough,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .bodyMediumFamily),
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
                                    'NCERT Abhyas Batch : Padhai Karo Kahin Se Lekin, Q Practice Karo Yahi Se',
                                    style: FlutterFlowTheme.of(context)
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
                                          0.0, 10.0, 0.0, 10.0),
                                      child: RichText(
                                        text: TextSpan(
                                          text: "NCERT Padhne k Alawa ",
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontSize: 12,
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color: Color(0xff858585),
                                                fontWeight: FontWeight.w500,
                                                useGoogleFonts: GoogleFonts
                                                        .asMap()
                                                    .containsKey(
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily),
                                              ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: "NCERT Based Q Practice bhi Krni hai Zaroori ",
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontSize: 12,
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: Color(0xff858585),
                                                    fontWeight: FontWeight.w700,
                                                    useGoogleFonts: GoogleFonts
                                                            .asMap()
                                                        .containsKey(
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily),
                                                  ),
                                            ),
                                            TextSpan(
                                              text: "!\n\n",
                                              style: FlutterFlowTheme.of(
                                                  context)
                                                  .bodyMedium
                                                  .override(
                                                fontSize: 12,
                                                fontFamily:
                                                FlutterFlowTheme.of(
                                                    context)
                                                    .bodyMediumFamily,
                                                color: Color(0xff858585),
                                                fontWeight: FontWeight.w400,
                                                useGoogleFonts: GoogleFonts
                                                    .asMap()
                                                    .containsKey(
                                                    FlutterFlowTheme.of(
                                                        context)
                                                        .bodyMediumFamily),
                                              ),
                                            ),
                                            TextSpan(
                                              text: "FIRST TIME EVER ",
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontSize: 12,
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: Color(0xff858585),
                                                    fontWeight: FontWeight.w700,
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
                                                  ", Solve Q's exactly from pages of NCERT you are reading daily !\n\n",
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontSize: 12,
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: Color(0xff858585),
                                                    fontWeight: FontWeight.w400,
                                                    useGoogleFonts: GoogleFonts
                                                            .asMap()
                                                        .containsKey(
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily),
                                                  ),
                                            ),
                                            TextSpan(
                                              text: "NCERT Abhyas Batch is a One Stop Solution for Complete NCERT Based Q Practice Practice for NEET Preparation. You can ",
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontSize: 12,
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: Color(0xff858585),
                                                    fontWeight: FontWeight.w400,
                                                    useGoogleFonts: GoogleFonts
                                                            .asMap()
                                                        .containsKey(
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily),
                                                  ),
                                            ),
                                            TextSpan(
                                              text: "do Questions Pagewise ",
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontSize: 12,
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: Color(0xff858585),
                                                    fontWeight: FontWeight.w700,
                                                    useGoogleFonts: GoogleFonts
                                                            .asMap()
                                                        .containsKey(
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily),
                                                  ),
                                            ),
                                            TextSpan(
                                              text: "from both old and newer NCERT's. It ",
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontSize: 12,
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: Color(0xff858585),
                                                    fontWeight: FontWeight.w400,
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
                                              "includes ",
                                              style: FlutterFlowTheme.of(
                                                  context)
                                                  .bodyMedium
                                                  .override(
                                                fontSize: 12,
                                                fontFamily:
                                                FlutterFlowTheme.of(
                                                    context)
                                                    .bodyMediumFamily,
                                                color: Color(0xff858585),
                                                fontWeight: FontWeight.w400,
                                                useGoogleFonts: GoogleFonts
                                                    .asMap()
                                                    .containsKey(
                                                    FlutterFlowTheme.of(
                                                        context)
                                                        .bodyMediumFamily),
                                              ),
                                            ),
                                            TextSpan(
                                              text: "detailed audio and video solutions, ",
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontSize: 12,
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: Color(0xff858585),
                                                    fontWeight: FontWeight.w700,
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
                                              "apart from text explanations to almost all the Q's, has ",
                                              style: FlutterFlowTheme.of(
                                                  context)
                                                  .bodyMedium
                                                  .override(
                                                fontSize: 12,
                                                fontFamily:
                                                FlutterFlowTheme.of(
                                                    context)
                                                    .bodyMediumFamily,
                                                color: Color(0xff858585),
                                                fontWeight: FontWeight.w400,
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
                                              "NCERT Forming Line ",
                                              style: FlutterFlowTheme.of(
                                                  context)
                                                  .bodyMedium
                                                  .override(
                                                fontSize: 12,
                                                fontFamily:
                                                FlutterFlowTheme.of(
                                                    context)
                                                    .bodyMediumFamily,
                                                color: Color(0xff858585),
                                                fontWeight: FontWeight.w700,
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
                                              "from Which Q is asked, ",
                                              style: FlutterFlowTheme.of(
                                                  context)
                                                  .bodyMedium
                                                  .override(
                                                fontSize: 12,
                                                fontFamily:
                                                FlutterFlowTheme.of(
                                                    context)
                                                    .bodyMediumFamily,
                                                color: Color(0xff858585),
                                                fontWeight: FontWeight.w400,
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
                                              "hints ",
                                              style: FlutterFlowTheme.of(
                                                  context)
                                                  .bodyMedium
                                                  .override(
                                                fontSize: 12,
                                                fontFamily:
                                                FlutterFlowTheme.of(
                                                    context)
                                                    .bodyMediumFamily,
                                                color: Color(0xff858585),
                                                fontWeight: FontWeight.w700,
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
                                              "& steps of solving Calculation based Q & ",
                                              style: FlutterFlowTheme.of(
                                                  context)
                                                  .bodyMedium
                                                  .override(
                                                fontSize: 12,
                                                fontFamily:
                                                FlutterFlowTheme.of(
                                                    context)
                                                    .bodyMediumFamily,
                                                color: Color(0xff858585),
                                                fontWeight: FontWeight.w400,
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
                                              "PYQ ",
                                              style: FlutterFlowTheme.of(
                                                  context)
                                                  .bodyMedium
                                                  .override(
                                                fontSize: 12,
                                                fontFamily:
                                                FlutterFlowTheme.of(
                                                    context)
                                                    .bodyMediumFamily,
                                                color: Color(0xff858585),
                                                fontWeight: FontWeight.w700,
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
                                              "Marking too to Q's! The ",
                                              style: FlutterFlowTheme.of(
                                                  context)
                                                  .bodyMedium
                                                  .override(
                                                fontSize: 12,
                                                fontFamily:
                                                FlutterFlowTheme.of(
                                                    context)
                                                    .bodyMediumFamily,
                                                color: Color(0xff858585),
                                                fontWeight: FontWeight.w400,
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
                                              "Bookmark ",
                                              style: FlutterFlowTheme.of(
                                                  context)
                                                  .bodyMedium
                                                  .override(
                                                fontSize: 12,
                                                fontFamily:
                                                FlutterFlowTheme.of(
                                                    context)
                                                    .bodyMediumFamily,
                                                color: Color(0xff858585),
                                                fontWeight: FontWeight.w700,
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
                                              "feature allows you to revisit the difficult Q's later!\n\n",
                                              style: FlutterFlowTheme.of(
                                                  context)
                                                  .bodyMedium
                                                  .override(
                                                fontSize: 12,
                                                fontFamily:
                                                FlutterFlowTheme.of(
                                                    context)
                                                    .bodyMediumFamily,
                                                color: Color(0xff858585),
                                                fontWeight: FontWeight.w400,
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
                                              "3 day ",
                                              style: FlutterFlowTheme.of(
                                                  context)
                                                  .bodyMedium
                                                  .override(
                                                fontSize: 12,
                                                fontFamily:
                                                FlutterFlowTheme.of(
                                                    context)
                                                    .bodyMediumFamily,
                                                color: Color(0xff858585),
                                                fontWeight: FontWeight.w700,
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
                                              "No Q Asked ",
                                              style: FlutterFlowTheme.of(
                                                  context)
                                                  .bodyMedium
                                                  .override(
                                                fontSize: 12,
                                                fontFamily:
                                                FlutterFlowTheme.of(
                                                    context)
                                                    .bodyMediumFamily,
                                                color: Color(0xff858585),
                                                fontWeight: FontWeight.w400,
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
                                              "100% refund policy ",
                                              style: FlutterFlowTheme.of(
                                                  context)
                                                  .bodyMedium
                                                  .override(
                                                fontSize: 12,
                                                fontFamily:
                                                FlutterFlowTheme.of(
                                                    context)
                                                    .bodyMediumFamily,
                                                color: Color(0xff858585),
                                                fontWeight: FontWeight.w700,
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
                                              "on top of all this makes this a must buy for all NEET Aspirants!",
                                              style: FlutterFlowTheme.of(
                                                  context)
                                                  .bodyMedium
                                                  .override(
                                                fontSize: 12,
                                                fontFamily:
                                                FlutterFlowTheme.of(
                                                    context)
                                                    .bodyMediumFamily,
                                                color: Color(0xff858585),
                                                fontWeight: FontWeight.w400,
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
                                      )),
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
                                  context.pushNamed(
                                    'OrderPage',
                                    queryParameters: {
                                      'courseId': serializeParam(
                                        FFAppState().courseId,
                                        ParamType.String,
                                      ),
                                      'courseIdInt': serializeParam(
                                        FFAppState().courseIdInt.toString(),
                                        ParamType.String,
                                      ),
                                    }.withoutNulls,
                                  );
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
