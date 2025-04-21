import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:neetprep_essential/auth/firebase_auth/auth_util.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../flutter_flow/flutter_flow_icon_button.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '/backend/api_requests/api_calls.dart';
import '/components/nav_bar/nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PracticeChapterWisePageModel extends ChangeNotifier {
  ///  Local state fields for this page.

  ///  State fields for stateful widgets in this page.
  bool showSearchList = false;
  bool prefsShowAssertionBannerUpdated = false;
  int totalPracticedQuestions = 0;
  bool isScreenshotDisabled = true;
  bool hasCourseAccess = false;
  // final unfocusNode = FocusNode();
  // Stores action output result for [Backend Call - API (Logged in user information and course access checking api )] action in PracticeChapterWisePage widget.
  ApiCallResponse? memberShip;
  // Stores action output result for [Backend Call - API (Get Practice Tests to show chapter wise)] action in PracticeChapterWisePage widget.
  ApiCallResponse? apiResultdwy;
  // Stores action output result for [Bottom Sheet - selectBook] action in Row widget.
  int? selectedCourseIndex;
  // Stores action output result for [Backend Call - API (Get Courses for switching)] action in Row widget.
  ApiCallResponse? selectCourses;
  // Model for navBar component.
  late NavBarModel navBarModel;
  bool isLoading = false;
  ApiCallResponse? response;
  final courseStatuses = ["TRIAL", "TRIAL EXPIRED", "PAID", "EXPIRED"];
  String? courseStatus = null;

  final TextEditingController feedbackTextController =
      new TextEditingController();

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    navBarModel = createModel(context, () => NavBarModel());
  }

  void dispose() {
    // unfocusNode.dispose();
    // textController?.dispose();
    navBarModel.dispose();
  }

  void callNotify() {}

  void showPopup(context) {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            content: StatefulBuilder(builder: (context, setState) {
              return Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
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
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
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
                          padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Unlock A/R PowerUp Course Free!",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                        fontSize: 20.0,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                ),
                              ],
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: ListTile(
                            leading: Text('🚀'),
                            minLeadingWidth: 0.0,
                            title: RichText(
                              text: TextSpan(
                                text: "Progress Update: ",
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontSize: 12,
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color: Color(0xff858585),
                                      fontWeight: FontWeight.w700,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily),
                                    ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "You've attempted ",
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontSize: 12,
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: Color(0xff858585),
                                          fontWeight: FontWeight.w400,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                        ),
                                  ),
                                  TextSpan(
                                    text: "${totalPracticedQuestions} ",
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontSize: 12,
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: Color(0xff858585),
                                          fontWeight: FontWeight.w700,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                        ),
                                  ),
                                  TextSpan(
                                    text: "questions.",
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontSize: 12,
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: Color(0xff858585),
                                          fontWeight: FontWeight.w400,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                          child: ListTile(
                            leading: Text('🎯'),
                            minLeadingWidth: 0.0,
                            title: RichText(
                              text: TextSpan(
                                text: "Just ",
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontSize: 12,
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color: Color(0xff858585),
                                      fontWeight: FontWeight.w700,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily),
                                    ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: " ${2500 - totalPracticedQuestions} ",
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontSize: 12,
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: Color(0xff858585),
                                          fontWeight: FontWeight.w700,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                        ),
                                  ),
                                  TextSpan(
                                    text:
                                        "more to unlock the A/R PowerUp Course for FREE!",
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontSize: 12,
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: Color(0xff858585),
                                          fontWeight: FontWeight.w400,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                        ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: RichText(
                            text: TextSpan(
                              text: "Keep up the consistency ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontSize: 12,
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color: Color(0xff858585),
                                    fontWeight: FontWeight.w700,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily),
                                  ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'of Q practice & ',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontSize: 12,
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: Color(0xff858585),
                                        fontWeight: FontWeight.w400,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                ),
                                TextSpan(
                                  text: "Unlock ",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontSize: 12,
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: Color(0xff858585),
                                        fontWeight: FontWeight.w700,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                ),
                                TextSpan(
                                  text: "A/R PowerUp Course ",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontSize: 12,
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: Color(0xff858585),
                                        fontWeight: FontWeight.w400,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                ),
                                TextSpan(
                                  text: "completely free.",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontSize: 12,
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: Color(0xff858585),
                                        fontWeight: FontWeight.w700,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Divider(
                            color: Color(0xffefefef),
                            height: 2.0,
                            thickness: 1.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: RichText(
                            text: TextSpan(
                              text: "Note: ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontSize: 12,
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color: Color(0xff858585),
                                    fontWeight: FontWeight.w700,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily),
                                  ),
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      "Your attempted questions will update within",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontSize: 12,
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: Color(0xff858585),
                                        fontWeight: FontWeight.w400,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                ),
                                TextSpan(
                                  text: " 24 hours.",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontSize: 12,
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: Color(0xff858585),
                                        fontWeight: FontWeight.w700,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                return;
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                elevation: 0,
                                side: BorderSide(color: Colors.white),
                                backgroundColor:
                                    FlutterFlowTheme.of(context).primary,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Border radius
                                ),
                              ),
                              child: Text('Okay',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 14.0,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ))),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: ListTileTheme(
                            horizontalTitleGap: 0,
                            child: CheckboxListTile(
                              title: Text("Don't show this message again",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: Color(0xFF252525),
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.normal,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      )),
                              value: prefsShowAssertionBannerUpdated,
                              checkColor: FlutterFlowTheme.of(context).primary,
                              fillColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                return Colors.white;
                              }),
                              onChanged: (newValue) async {
                                setState(() {
                                  prefsShowAssertionBannerUpdated = newValue!;
                                  print(prefsShowAssertionBannerUpdated);
                                });
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setBool('prefsShowAssertionBannerUpdated',
                                    !prefsShowAssertionBannerUpdated);
                              },
                              controlAffinity: ListTileControlAffinity
                                  .leading, //  <-- leading Checkbox
                            ),
                          ),
                        )
                      ],
                    ),
                  ));
            }),
          );
        });
  }

  void showCongratulationsPopUp(context) {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            content: StatefulBuilder(builder: (context, setState) {
              return Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
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
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
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
                          padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "A Small Gift 🎁 & Request 🙏from Dr Aman Tilak",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                        fontSize: 20.0,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                ),
                              ],
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: ListTile(
                            leading: Text('🚀'),
                            minLeadingWidth: 0.0,
                            title: RichText(
                              text: TextSpan(
                                text: "Congratulations: on attempting ",
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontSize: 12,
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color: Color(0xff858585),
                                      fontWeight: FontWeight.w400,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily),
                                    ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "2500+ ",
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontSize: 12,
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: Color(0xff858585),
                                          fontWeight: FontWeight.w700,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                        ),
                                  ),
                                  TextSpan(
                                    text:
                                        "Q's from Abhyas batch. You are being given access of A/R PowerUp Course for Completely Free of cost on this achievement!\n ",
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontSize: 12,
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: Color(0xff858585),
                                          fontWeight: FontWeight.w400,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                        ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: RichText(
                            text: TextSpan(
                              text: "Note: ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontSize: 12,
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color: Color(0xff858585),
                                    fontWeight: FontWeight.w700,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily),
                                  ),
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      "You’ll get access to the PowerUp Course on 31st March 24. ",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontSize: 12,
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: Color(0xff858585),
                                        fontWeight: FontWeight.w400,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Divider(
                            color: Color(0xffefefef),
                            height: 2.0,
                            thickness: 1.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: RichText(
                            text: TextSpan(
                              text: "In case you have loved the Abhyas Batch, ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontSize: 12,
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color: Color(0xff858585),
                                    fontWeight: FontWeight.w400,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily),
                                  ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: "Dr Aman kindly requests ",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontSize: 12,
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: Color(0xff858585),
                                        fontWeight: FontWeight.w700,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                ),
                                TextSpan(
                                  text:
                                      "you to write a small paragraph on how Abhyas Batch helped you in your NEET Preparation journey on the Play Store.",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontSize: 12,
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: Color(0xff858585),
                                        fontWeight: FontWeight.w400,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                              onPressed: () async {
                                await launchURL(
                                    'https://play.google.com/store/apps/details?id=com.neetprep.ios');

                                Navigator.pop(context);
                                return;
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                elevation: 0,
                                side: BorderSide(color: Colors.white),
                                backgroundColor:
                                    FlutterFlowTheme.of(context).primary,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Border radius
                                ),
                              ),
                              child: Text('Write a Review',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 14.0,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ))),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: ListTileTheme(
                            horizontalTitleGap: 0,
                            child: CheckboxListTile(
                              title: Text("Don't show this message again",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: Color(0xFF252525),
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.normal,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      )),
                              value: prefsShowAssertionBannerUpdated,
                              checkColor: FlutterFlowTheme.of(context).primary,
                              fillColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                return Colors.white;
                              }),
                              onChanged: (newValue) async {
                                setState(() {
                                  prefsShowAssertionBannerUpdated = newValue!;
                                  print(prefsShowAssertionBannerUpdated);
                                });
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setBool('prefsShowAssertionBannerUpdated',
                                    !prefsShowAssertionBannerUpdated);
                              },
                              controlAffinity: ListTileControlAffinity
                                  .leading, //  <-- leading Checkbox
                            ),
                          ),
                        )
                      ],
                    ),
                  ));
            }),
          );
        });
  }

  Future<void> getTrialCourse() async {
    final url = Uri.parse('${FFAppState().baseUrl}/get-trial-course');

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      "email": currentUserEmail.toString(),
      "phone": "0000000000",
      "course": FFAppState().courseIdInt,
      "name": currentUserDisplayName,
    });
    print(body);
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print('Response data: ${response.body}');
        // Handle successful response
      } else {
        print(response.body);
        print(
            'Failed to get trial course. Status code: ${response.statusCode}');
        // Handle error response
      }
    } catch (e) {
      print('Error occurred: $e');
      // Handle exceptions
    }
  }

  Future<void> callLoginApi(BuildContext context) async {
    try {
      setLoading(true); // Start loading
      String authToken = FFAppState().subjectToken;
      int courseIdInt = FFAppState().courseIdInt;
      String altCourseIds = FFAppState().courseIdInts;

      final apiResponse =
          await LoggedInUserInformationAndCourseAccessCheckingApiCall().call(
        authToken: authToken,
        courseIdInt: courseIdInt,
        altCourseIds: altCourseIds,
      );

      if (apiResponse.statusCode == 200) {
        // Parse the user data from the response
        final userData = LoggedInUserInformationAndCourseAccessCheckingApiCall()
            .me(apiResponse.jsonBody);
        final userCourses =
            LoggedInUserInformationAndCourseAccessCheckingApiCall()
                .courses(apiResponse.jsonBody);
        hasCourseAccess = userCourses.isNotEmpty;

        notifyListeners();
      } else {
        debugPrint('Failed to fetch user details.');
      }
    } catch (e) {
      // Handle exception
      debugPrint('Error in callLoginApi: $e');
    } finally {
      setLoading(false); // Stop loading after the API call
    }
  }

  // Helper method to set the loading state and notify listeners
  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
