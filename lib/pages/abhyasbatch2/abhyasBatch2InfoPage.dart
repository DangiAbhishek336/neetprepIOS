import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neetprep_essential/flutter_flow/flutter_flow_util.dart';

import '../../clevertap/clevertap_service.dart';
import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';

class AbhyasBatch2InfoPage extends StatelessWidget {
  const AbhyasBatch2InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                //   child: Image.asset(
                //     "assets/images/info.png",
                //     height: 60,
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                //   child: RichText(
                //     text: TextSpan(
                //       children: [
                //         TextSpan(
                //           text: 'Home Test Series',
                //           style: FlutterFlowTheme.of(context)
                //               .bodyMedium
                //               .override(
                //                 fontFamily: FlutterFlowTheme.of(context)
                //                     .bodyMediumFamily,
                //                 fontWeight: FontWeight.w700,
                //                 color: FlutterFlowTheme.of(context).primaryText,
                //                 fontSize: 20.0,
                //                 useGoogleFonts: GoogleFonts.asMap().containsKey(
                //                     FlutterFlowTheme.of(context)
                //                         .bodyMediumFamily),
                //               ),
                //         ),
                //       ],
                //       style: FlutterFlowTheme.of(context).bodyMedium,
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: ImageSlideshow(
                      width: double.infinity,
                      height: 300,
                      initialPage: 0,
                      indicatorColor: FlutterFlowTheme.of(context).primary,
                      indicatorBackgroundColor: Colors.grey,
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                        //   child: AspectRatio(
                        //     aspectRatio: 16 / 9,
                        //     child: YoutubePlayer(
                        //       controller: _ytControllerHTS,
                        //       aspectRatio: 16 / 9,
                        //     ),
                        //   ),
                        // ),
                        Image.asset(
                          'assets/images/abs1.png',
                          fit: BoxFit.cover,
                        ),
                        Image.asset(
                          'assets/images/abs2.png',
                          fit: BoxFit.cover,
                        ),
                        Image.asset(
                          'assets/images/abs3.png',
                          fit: BoxFit.cover,
                        ),
                        Image.asset(
                          'assets/images/abs4.png',
                          fit: BoxFit.cover,
                        ),
                        Image.asset(
                          'assets/images/abs5.png',
                          fit: BoxFit.cover,
                        ),
                        Image.asset(
                          'assets/images/abs6.png',
                          fit: BoxFit.cover,
                        ),
                      ],
                      autoPlayInterval: null,
                      isLoop: false,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                  child: RichText(
                    text: TextSpan(
                      text: 'Introducing ',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontSize: 13,
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: FlutterFlowTheme.of(context).accent1,
                            fontWeight: FontWeight.w400,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).bodyMediumFamily),
                          ),
                      children: <TextSpan>[
                        TextSpan(
                          text: "Custom Abhyas – ",
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                        ),
                        TextSpan(
                          text:
                              "Your ",
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                        ),
                        TextSpan(
                          text: "Personalized ",
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                        ),
                        TextSpan(
                          text:
                              "NEET Practice Companion! 📝\n\n",
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                        ),
                        TextSpan(
                          text: "With Custom Abhyas, experience session-based question practice tailored just for NEET prep. Choose subjects, apply filters, and receive detailed performance analytics—all in one platform to target your weaknesses and track your progress. 📊✨\n\n",
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                        ),
                        TextSpan(
                          text: "Select Subject\n",
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                        ),
                        TextSpan(
                          text: "Begin by picking the subject—Physics, Chemistry, or Biology. A simple start to focus your practice. ⚛️🧬\n\n",
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                        ),
                        TextSpan(
                          text: "Choose Chapter & Sub-Topics\n",
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                        ),
                        TextSpan(
                          text: "Next, select the chapter and dive deeper by choosing specific sub-topics. This helps you cover exactly what you need, one focused step at a time. 🔍\n\n",
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                        ),
                        TextSpan(
                          text: "Apply Filters for a Tailored Experience\n",
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                        ),
                        TextSpan(
                          text: "Refine your session by filtering questions based on difficulty level, bookmarked questions, or past mistakes. Choose from sets like NCERT-based, PYQs, or Recommended Sets for an authentic NEET-like experience. 🏆\n\n",
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                        ),
                        TextSpan(
                          text:
                              "Set the Number of Questions\n",
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                        ),
                        TextSpan(
                          text: "Customize each session with the exact number of questions you want. Perfect for both quick revisions and extensive practice sessions. ⏳\n\n",
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                        ),
                        TextSpan(
                          text:
                              "Create Session & Start Practicing\n",
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                        ),
                        TextSpan(
                          text: "Click \"Create Session\" and begin your tailored practice! Get instant explanations and solutions as you go, enhancing learning in real-time. 💡\n\nEnd with Detailed Analytics Wrap up with Session Analytics that show your performance—correct vs. incorrect questions, improvement areas, and overall progress. Track your streak and keep improving with every session! 📈🔥",
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                        )
                      ],
                    ),
                  ),
                ),
              ]),
        ),
      ),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
        child: ElevatedButton(
            onPressed: () async {
              CleverTapService.recordEvent(
                'Buy Now Clicked',
                {"courseId":serializeParam(
                  FFAppState().abhyas2CourseId,
                  ParamType.String,
                )
                },
              );
              context.pushNamed(
                'OrderPage',
                queryParameters: {
                  'courseId': serializeParam(
                    FFAppState().abhyas2CourseId,
                    ParamType.String,
                  ),
                  'courseIdInt': serializeParam(
                    FFAppState().abhyas2CourseIdInt.toString(),
                    ParamType.String,
                  ),
                }.withoutNulls,
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              elevation: 5,
              backgroundColor: FlutterFlowTheme.of(context).primary,
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Text('Go Buy Now',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 14.0,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context).bodyMediumFamily),
                    ))),
      ),
    );
    ;
  }
}
