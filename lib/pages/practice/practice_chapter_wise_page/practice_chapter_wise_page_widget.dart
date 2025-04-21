import 'dart:async';
import 'dart:developer';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:neetprep_essential/firebase/firebase_push_notification.dart';
import 'package:neetprep_essential/pages/starmarkedQs/starmarkedChapterWisePage/starmarkedChapterWisePageModel.dart';
import 'package:neetprep_essential/providers/commonProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../components/drawer/darwer_widget.dart';
import '../../../components/nav_bar/nav_bar_model.dart';
import '../../../flutter_flow/flutter_flow_icon_button.dart';
import '../../../utlis/text.dart';
import '../../bookmarkedQs/bookmarked_chapter_wise_page/bookmarked_chapter_wise_page_model.dart';
import '../../bookmarkedQs/bookmarked_questions_page/bookmarked_questions_page_model.dart';
import '../../practice_log/practice_log.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/components/practice_chap_button/practice_chap_button_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'practice_chapter_wise_page_model.dart';
export 'practice_chapter_wise_page_model.dart';

class PracticeChapterWisePageWidget extends StatefulWidget {
  const PracticeChapterWisePageWidget({Key? key}) : super(key: key);
  @override
  _PracticeChapterWisePageWidgetState createState() =>
      _PracticeChapterWisePageWidgetState();
}

//Using Isolates to set states in background

class IsolateModel {
  final String authToken;
  final int courseIdInt;
  final String altCourseIds;

  IsolateModel(this.authToken, this.courseIdInt, this.altCourseIds);
}

Future<ApiCallResponse> apiCallMembership(IsolateModel model) async {
  return await SignupGroup.loggedInUserInformationAndCourseAccessCheckingApiCall
      .call(
    authToken: model.authToken,
    courseIdInt: model.courseIdInt,
    altCourseIds: model.altCourseIds,
  );
}
//Isolate function implementation for :-

// getting chapter wise array data
class IsolateModelChapterWise {
  final String courseId;

  IsolateModelChapterWise(this.courseId);
}

Future<ApiCallResponse> apiCallPracticeTestsToShowChapterWise(
    IsolateModelChapterWise model) async {
  return await PracticeGroup.getPracticeTestsToShowChapterWiseCall.call(
    courseId: model.courseId,
  );
}

//gets name of subtopic along with its unique id
class IsolateModelSearchList {
  final Future<ApiCallResponse> searchList;

  IsolateModelSearchList(this.searchList);
}

Future<List<dynamic>> apiCallSearchList(IsolateModelSearchList model) async {
  return await PracticeGroup.getPracticeTestsToShowChapterWiseCall
      .allChapterWithId(
    (model.searchList).toString(),
  )!
      .toList()
      .cast<dynamic>();
}

//gets topics to popuialte listview
class IsolateModelTopics {
  final dynamic topics;
  // final dynamic topics;

  IsolateModelTopics(this.topics);
}

dynamic apiCallTopics(IsolateModelTopics model) async {
  return await (PracticeGroup.getPracticeTestsToShowChapterWiseCall.topicNodes(
    model.topics,
  )).toList();
}

class _PracticeChapterWisePageWidgetState
    extends State<PracticeChapterWisePageWidget> with TickerProviderStateMixin {
  late PracticeChapterWisePageModel _model;
  final  scaffoldKey = GlobalKey<ScaffoldState>();
  final InAppReview inAppReview = InAppReview.instance;
  final animationsMap = {
    'iconOnActionTriggerAnimation': AnimationInfo(
      trigger: AnimationTrigger.onActionTrigger,
      applyInitialState: true,
      effects: [
        FadeEffect(
          curve: Curves.easeOut,
          delay: 0.ms,
          duration: 350.ms,
          begin: 0.415,
          end: 1.0,
        ),
      ],
    ),
    'rowOnActionTriggerAnimation': AnimationInfo(
      trigger: AnimationTrigger.onActionTrigger,
      applyInitialState: true,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.4,
          end: 1.0,
        ),
      ],
    ),
  };

  // calling isolate functions

  Future<ApiCallResponse> chapWiseTemp =
  compute<IsolateModelChapterWise, ApiCallResponse>(
      apiCallPracticeTestsToShowChapterWise,
      IsolateModelChapterWise(FFAppState().courseId));
  Future<ApiCallResponse> membershipTemp =
  compute<IsolateModel, ApiCallResponse>(
      apiCallMembership,
      IsolateModel(FFAppState().subjectToken, FFAppState().courseIdInt,
          FFAppState().courseIdInts));

  List<dynamic> topicTemp = [];
  void func(Future<ApiCallResponse> x) async {
    final y = await x;
    topicTemp = await compute<IsolateModelTopics, dynamic>(
        apiCallTopics, IsolateModelTopics(y.jsonBody));
    setState(() {});
  }
  final JustTheController  tooltipController  = JustTheController();

  // dynamic topicTemp = compute<IsolateModelTopics, dynamic>(
  //     apiCallTopics, IsolateModelTopics(chapWiseTemp));


  Future<void> initilizeUpdateFCM()async {
    await FirebaseApi.updateFcmToken(authorizationToken: FFAppState().subjectToken,userId: FFAppState().userIdInt,fcmToken: FirebaseApi.fcmToken,deviceId: "",androidDetails: "",platform:"android" ,app:"abhyas", deviceAdsId: "");
    log("worked on practice page");
  }

  @override
  void initState() {
    super.initState();
    initilizeUpdateFCM();
    print("subject token: "+ FFAppState().subjectToken.toString());
    print("userId: "+ FFAppState().userIdInt.toString());
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "PracticeChapterWisePage",);
    _model = Provider.of<PracticeChapterWisePageModel>(context, listen: false);
    var commonProvider = Provider.of<CommonProvider>(context, listen: false);
    _model.navBarModel = createModel(context, () => NavBarModel());
    _model.totalPracticedQuestions = 0;
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      setState(() {});
      SharedPreferences prefs  = await SharedPreferences.getInstance();
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.setUserIdentifier(currentUserUid);
        FirebaseCrashlytics.instance.setCustomKey('userID', currentUserUid);
      }
      // FirebaseCrashlytics.instance.log("Higgs-Boson detected! Bailing out");
      _model.memberShip = await membershipTemp;
      if ((_model.memberShip?.succeeded ?? true) &&
          (SignupGroup.loggedInUserInformationAndCourseAccessCheckingApiCall.me(
            (_model.memberShip?.jsonBody ?? ''),
          ) !=
              null)) {


        setState(()  {
          FFAppState().memberShipRes = getJsonField(
            (_model.memberShip?.jsonBody ?? ''),
            r'''$.data''',
          );
          FFAppState().memberShipResIdList = getJsonField(
            (_model.memberShip?.jsonBody ?? ''),
            r'''$.data.me.userCourses.edges''',
          )!
              .toList()
              .cast<dynamic>();
          // FFAppState().homeVisibility = true;
          // FFAppState().notesVisibility = false;

          FFAppState().showLoading = false;
        });
        print(FFAppState().newToken.toString());
        // if(prefs.containsKey('count')){
        //   FFAppState().count = prefs.getInt('count')!;
        //   print("111");
        // }
        // print( FFAppState().count.toString()+"count");
        // print(FFAppState().isFormCompleted.toString());
        // if(FFAppState().isFormCompleted==false && FFAppState().count%3==0  || (kIsWeb && FFAppState().isFormCompleted==false)){
        //   if( !await isFormCompleted())
        //    {
        //      context.goNamed('UserInfoForm');
        //      FFAppState().isFormCompleted= true;
        //      setState(() {
        //
        //      });
        //      return;
        //
        //   }
        //
        //
        //
        // }


        if(FFAppState().newToken=="" || FFAppState().newToken==null){
          var bookmarkedProvider = Provider.of<StarmarkedChapterWisePageModel>(context, listen: false);
          await bookmarkedProvider.fetchNewToken(FFAppState().subjectToken);
        }

      } else {
        print("login page on  practice chapter button ");
        context.pushNamed('LoginPage');
        FFAppState().newToken = "";
        return;
      }
      print("AUTH TOKEN "+ FFAppState().subjectToken.toString());
      if(FFAppState().showBanners ) {
        await SignupGroup
            .loggedInUserInformationAndCourseAccessCheckingApiCall
            .call(
          authToken: FFAppState().subjectToken,
          courseIdInt: FFAppState().assertionCourseIdInt,
          altCourseIds: FFAppState().assertionCourseIdInts,
        )
            .then((response) async {
          if (SignupGroup
              .loggedInUserInformationAndCourseAccessCheckingApiCall
              .courses(
            response
                .jsonBody,
          )
              .length ==
              0 && FFAppState().memberShipResIdList.toList().length == 0 ) {
            showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    insetPadding: EdgeInsets.zero,
                    backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                    content: StatefulBuilder(
                        builder: (context, setState) {
                          return Container(
                              width: MediaQuery.of(context).size.width *0.8,
                              child:SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 10.0, 0.0, 10.0),
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
                                    // Align(
                                    //   alignment: Alignment.topLeft,
                                    //   child: Padding(
                                    //     padding: const EdgeInsets.fromLTRB(
                                    //         10, 0, 10, 10),
                                    //     child: SvgPicture.asset("assets/images/announcement.svg"),
                                    //   ),
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 10),
                                      child: Text(
                                          'NEVER LIKE BEFORE DISCOUNT on Abhyas Batch ', style: FlutterFlowTheme
                                          .of(context)
                                          .bodyMedium
                                          .override(
                                        fontSize: 15,
                                        fontFamily: FlutterFlowTheme
                                            .of(context)
                                            .bodyMediumFamily,
                                        color: FlutterFlowTheme.of(context).primaryText,
                                        fontWeight: FontWeight.w700,
                                        useGoogleFonts: GoogleFonts
                                            .asMap()
                                            .containsKey(
                                            FlutterFlowTheme
                                                .of(context)
                                                .bodyMediumFamily),
                                      )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 10),
                                      child:
                                      RichText(
                                        text: TextSpan(
                                          text: "NCERT Abhyas Batch for NEET 2025 is available at a ",
                                          style: FlutterFlowTheme
                                              .of(context)
                                              .bodyMedium
                                              .override(
                                            fontSize: 12,
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
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: "SPECIAL DISCOUNTED ",
                                              style: FlutterFlowTheme
                                                  .of(context)
                                                  .bodyMedium
                                                  .override(
                                                fontSize: 12,
                                                fontFamily: FlutterFlowTheme
                                                    .of(context)
                                                    .bodyMediumFamily,
                                                color: Color(0xff858585),
                                                fontWeight: FontWeight.w700,
                                                useGoogleFonts: GoogleFonts
                                                    .asMap()
                                                    .containsKey(
                                                    FlutterFlowTheme
                                                        .of(context)
                                                        .bodyMediumFamily),
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: 'PRICE for you! Enroll before 15th October to also get ',
                                                  style: FlutterFlowTheme
                                                      .of(context)
                                                      .bodyMedium
                                                      .override(
                                                    fontSize: 12,
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
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: "A/R PowerUp Course COMPLEMENTARY ",
                                                  style: FlutterFlowTheme
                                                      .of(context)
                                                      .bodyMedium
                                                      .override(
                                                    fontSize: 12,
                                                    fontFamily: FlutterFlowTheme
                                                        .of(context)
                                                        .bodyMediumFamily,
                                                    color: Color(0xff858585),
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
                                                  text: "on your purchase! \n\n",
                                                  style:  FlutterFlowTheme
                                                      .of(context)
                                                      .bodyMedium
                                                      .override(
                                                    fontSize: 12,
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
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: "Abhyas Batch empowers you to do ",
                                                  style:  FlutterFlowTheme
                                                      .of(context)
                                                      .bodyMedium
                                                      .override(
                                                    fontSize: 12,
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
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: "PageWise NCERT Q Practice, ",
                                                  style:  FlutterFlowTheme
                                                      .of(context)
                                                      .bodyMedium
                                                      .override(
                                                    fontSize: 12,
                                                    fontFamily: FlutterFlowTheme
                                                        .of(context)
                                                        .bodyMediumFamily,
                                                    color: Color(0xff858585),
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
                                                  text: "which are available with detailed Audio/Video Explanations! You also get ",
                                                  style:  FlutterFlowTheme
                                                      .of(context)
                                                      .bodyMedium
                                                      .override(
                                                    fontSize: 12,
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
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: "PYQ Marked NCERT, ",
                                                  style:  FlutterFlowTheme
                                                      .of(context)
                                                      .bodyMedium
                                                      .override(
                                                    fontSize: 12,
                                                    fontFamily: FlutterFlowTheme
                                                        .of(context)
                                                        .bodyMediumFamily,
                                                    color: Color(0xff858585),
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
                                                  text: "which enables you to attempt 25 yrs ",
                                                  style:  FlutterFlowTheme
                                                      .of(context)
                                                      .bodyMedium
                                                      .override(
                                                    fontSize: 12,
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
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: "PYQ's ",
                                                  style:  FlutterFlowTheme
                                                      .of(context)
                                                      .bodyMedium
                                                      .override(
                                                    fontSize: 12,
                                                    fontFamily: FlutterFlowTheme
                                                        .of(context)
                                                        .bodyMediumFamily,
                                                    color: Color(0xff858585),
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
                                                  text: "for all three subjects ",
                                                  style:  FlutterFlowTheme
                                                      .of(context)
                                                      .bodyMedium
                                                      .override(
                                                    fontSize: 12,
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
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: "PAGEWISE ",
                                                  style:  FlutterFlowTheme
                                                      .of(context)
                                                      .bodyMedium
                                                      .override(
                                                    fontSize: 12,
                                                    fontFamily: FlutterFlowTheme
                                                        .of(context)
                                                        .bodyMediumFamily,
                                                    color: Color(0xff858585),
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
                                                  text: "itself as you read through NCERT. ",
                                                  style:  FlutterFlowTheme
                                                      .of(context)
                                                      .bodyMedium
                                                      .override(
                                                    fontSize: 12,
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
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    //   Padding(
                                    //     padding: const EdgeInsets.only(bottom:8.0),
                                    //     child: Divider(
                                    //       color:Color(0xffefefef),
                                    //     height: 2.0,
                                    //       thickness: 1.0,
                                    //
                                    //     ),
                                    //   ),
                                    // Padding(
                                    //   padding: const EdgeInsets.fromLTRB(
                                    //       10, 0, 10, 10),
                                    //   child:
                                    //   RichText(
                                    //     text: TextSpan(
                                    //       text: "Note: ",
                                    //       style: FlutterFlowTheme
                                    //           .of(context)
                                    //           .bodyMedium
                                    //           .override(
                                    //         fontSize: 12,
                                    //         fontFamily: FlutterFlowTheme
                                    //             .of(context)
                                    //             .bodyMediumFamily,
                                    //         color: Color(0xff858585),
                                    //         fontWeight: FontWeight.w700,
                                    //         useGoogleFonts: GoogleFonts
                                    //             .asMap()
                                    //             .containsKey(
                                    //             FlutterFlowTheme
                                    //                 .of(context)
                                    //                 .bodyMediumFamily),
                                    //       ),
                                    //       children: <TextSpan>[
                                    //         TextSpan(
                                    //           text: "Unlock this course ",
                                    //           style: FlutterFlowTheme
                                    //               .of(context)
                                    //               .bodyMedium
                                    //               .override(
                                    //             fontSize: 12,
                                    //             fontFamily: FlutterFlowTheme
                                    //                 .of(context)
                                    //                 .bodyMediumFamily,
                                    //             color: Color(0xff858585),
                                    //             fontWeight: FontWeight.w400,
                                    //             useGoogleFonts: GoogleFonts
                                    //                 .asMap()
                                    //                 .containsKey(
                                    //                 FlutterFlowTheme
                                    //                     .of(context)
                                    //                     .bodyMediumFamily),
                                    //           ),),
                                    //         TextSpan(
                                    //           text: "COMPLETELY FREE ",
                                    //           style: FlutterFlowTheme
                                    //               .of(context)
                                    //               .bodyMedium
                                    //               .override(
                                    //             fontSize: 12,
                                    //             fontFamily: FlutterFlowTheme
                                    //                 .of(context)
                                    //                 .bodyMediumFamily,
                                    //             color: Color(0xff858585),
                                    //             fontWeight: FontWeight.w700,
                                    //             useGoogleFonts: GoogleFonts
                                    //                 .asMap()
                                    //                 .containsKey(
                                    //                 FlutterFlowTheme
                                    //                     .of(context)
                                    //                     .bodyMediumFamily),
                                    //           ),
                                    //         ),
                                    //         TextSpan(
                                    //           text: "of cost by attempting atleast ",
                                    //           style: FlutterFlowTheme
                                    //               .of(context)
                                    //               .bodyMedium
                                    //               .override(
                                    //             fontSize: 12,
                                    //             fontFamily: FlutterFlowTheme
                                    //                 .of(context)
                                    //                 .bodyMediumFamily,
                                    //             color: Color(0xff858585),
                                    //             fontWeight: FontWeight.w400,
                                    //             useGoogleFonts: GoogleFonts
                                    //                 .asMap()
                                    //                 .containsKey(
                                    //                 FlutterFlowTheme
                                    //                     .of(context)
                                    //                     .bodyMediumFamily),
                                    //           ),
                                    //         ),
                                    //         TextSpan(
                                    //           text: "2500 questions ",
                                    //           style: FlutterFlowTheme
                                    //               .of(context)
                                    //               .bodyMedium
                                    //               .override(
                                    //             fontSize: 12,
                                    //             fontFamily: FlutterFlowTheme
                                    //                 .of(context)
                                    //                 .bodyMediumFamily,
                                    //             color: Color(0xff858585),
                                    //             fontWeight: FontWeight.w700,
                                    //             useGoogleFonts: GoogleFonts
                                    //                 .asMap()
                                    //                 .containsKey(
                                    //                 FlutterFlowTheme
                                    //                     .of(context)
                                    //                     .bodyMediumFamily),
                                    //           ),
                                    //         ),
                                    //         TextSpan(
                                    //           text: "from ",
                                    //           style: FlutterFlowTheme
                                    //               .of(context)
                                    //               .bodyMedium
                                    //               .override(
                                    //             fontSize: 12,
                                    //             fontFamily: FlutterFlowTheme
                                    //                 .of(context)
                                    //                 .bodyMediumFamily,
                                    //             color: Color(0xff858585),
                                    //             fontWeight: FontWeight.w400,
                                    //             useGoogleFonts: GoogleFonts
                                    //                 .asMap()
                                    //                 .containsKey(
                                    //                 FlutterFlowTheme
                                    //                     .of(context)
                                    //                     .bodyMediumFamily),
                                    //           ),
                                    //         ),
                                    //         TextSpan(
                                    //           text: "NCERT Abhyas Batch ",
                                    //           style: FlutterFlowTheme
                                    //               .of(context)
                                    //               .bodyMedium
                                    //               .override(
                                    //             fontSize: 12,
                                    //             fontFamily: FlutterFlowTheme
                                    //                 .of(context)
                                    //                 .bodyMediumFamily,
                                    //             color: Color(0xff858585),
                                    //             fontWeight: FontWeight.w700,
                                    //             useGoogleFonts: GoogleFonts
                                    //                 .asMap()
                                    //                 .containsKey(
                                    //                 FlutterFlowTheme
                                    //                     .of(context)
                                    //                     .bodyMediumFamily),
                                    //           ),
                                    //         ),
                                    //         TextSpan(
                                    //           text: "(This Offer is Valid only till 31st March for Abhyas Batch students only)",
                                    //           style:  FlutterFlowTheme
                                    //               .of(context)
                                    //               .bodyMedium
                                    //               .override(
                                    //             fontSize: 12,
                                    //             fontFamily: FlutterFlowTheme
                                    //                 .of(context)
                                    //                 .bodyMediumFamily,
                                    //             color: Color(0xff858585),
                                    //             fontWeight: FontWeight.w400,
                                    //             useGoogleFonts: GoogleFonts
                                    //                 .asMap()
                                    //                 .containsKey(
                                    //                 FlutterFlowTheme
                                    //                     .of(context)
                                    //                     .bodyMediumFamily),
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
                                    // Text(
                                    //   "Recent trend has changed to include more newer question types. Of these, Assertion Reason & Statements type Q's are the most challenging to NEET Aspirants.\n\nWith exclusive ASSERTION/ REASON + STATEMENT Type Q PowerUp Course, conquer your fear and excel in NEET by practicing 2500+ Q's!",
                                    //   style: FlutterFlowTheme
                                    //       .of(context)
                                    //       .bodyMedium
                                    //       .override(
                                    //     fontSize: 12,
                                    //     fontFamily: FlutterFlowTheme
                                    //         .of(context)
                                    //         .bodyMediumFamily,
                                    //     color: Color(0xff858585),
                                    //     fontWeight: FontWeight.w400,
                                    //     useGoogleFonts: GoogleFonts
                                    //         .asMap()
                                    //         .containsKey(
                                    //         FlutterFlowTheme
                                    //             .of(context)
                                    //             .bodyMediumFamily),
                                    //   ),
                                    // ),
                                    //  ),
                                    // Padding(
                                    //   padding: const EdgeInsets.fromLTRB(
                                    //       10, 10, 10, 5),
                                    //   child: ListTile(
                                    //     leading: Text('📕'),
                                    //     minLeadingWidth: 5.0,
                                    //     title: Text(
                                    //       'Unlock AR & Statement Mastery',
                                    //       style: FlutterFlowTheme
                                    //           .of(context)
                                    //           .bodyMedium
                                    //           .override(
                                    //         fontSize: 12,
                                    //         fontFamily: FlutterFlowTheme
                                    //             .of(context)
                                    //             .bodyMediumFamily,
                                    //         color: Colors.black,
                                    //         fontWeight: FontWeight.w600,
                                    //         useGoogleFonts: GoogleFonts.asMap()
                                    //             .containsKey(
                                    //             FlutterFlowTheme
                                    //                 .of(context)
                                    //                 .bodyMediumFamily),
                                    //       ),
                                    //     ),
                                    //     subtitle: Text(
                                    //         'Dive into 2500+ questions tailored to conquer Assertion/Reason and Statement types',
                                    //         style: FlutterFlowTheme
                                    //             .of(context)
                                    //             .bodyMedium
                                    //             .override(
                                    //           fontSize: 12,
                                    //           fontFamily: FlutterFlowTheme
                                    //               .of(context)
                                    //               .bodyMediumFamily,
                                    //           color: Color(0xff858585),
                                    //           fontWeight: FontWeight.w400,
                                    //           useGoogleFonts: GoogleFonts
                                    //               .asMap()
                                    //               .containsKey(
                                    //               FlutterFlowTheme
                                    //                   .of(context)
                                    //                   .bodyMediumFamily),
                                    //         )),
                                    //   ),
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.fromLTRB(
                                    //       10, 10, 10, 5),
                                    //   child: ListTile(
                                    //     leading: Text('📖'),
                                    //     minLeadingWidth: 5.0,
                                    //     title: Text(
                                    //       'Simplify Complex Concepts',
                                    //       style: FlutterFlowTheme
                                    //           .of(context)
                                    //           .bodyMedium
                                    //           .override(
                                    //         fontSize: 12,
                                    //         fontFamily: FlutterFlowTheme
                                    //             .of(context)
                                    //             .bodyMediumFamily,
                                    //         color: Colors.black,
                                    //         fontWeight: FontWeight.w600,
                                    //         useGoogleFonts: GoogleFonts.asMap()
                                    //             .containsKey(
                                    //             FlutterFlowTheme
                                    //                 .of(context)
                                    //                 .bodyMediumFamily),
                                    //       ),
                                    //     ),
                                    //     subtitle: Text(
                                    //         'Our PowerUp Course breaks down the toughest NEET challenges, making them easier for you',
                                    //         style: FlutterFlowTheme
                                    //             .of(context)
                                    //             .bodyMedium
                                    //             .override(
                                    //           fontSize: 12,
                                    //           fontFamily: FlutterFlowTheme
                                    //               .of(context)
                                    //               .bodyMediumFamily,
                                    //           color: Color(0xff858585),
                                    //           fontWeight: FontWeight.w400,
                                    //           useGoogleFonts: GoogleFonts
                                    //               .asMap()
                                    //               .containsKey(
                                    //               FlutterFlowTheme
                                    //                   .of(context)
                                    //                   .bodyMediumFamily),
                                    //         )),
                                    //   ),
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.fromLTRB(
                                    //       10, 10, 10, 5),
                                    //   child: ListTile(
                                    //     leading: Text('🏆'),
                                    //     minLeadingWidth: 5.0,
                                    //     title: Text(
                                    //       'Ace NEET with Confidence',
                                    //       style: FlutterFlowTheme
                                    //           .of(context)
                                    //           .bodyMedium
                                    //           .override(
                                    //         fontSize: 12,
                                    //         fontFamily: FlutterFlowTheme
                                    //             .of(context)
                                    //             .bodyMediumFamily,
                                    //         color: Colors.black,
                                    //         fontWeight: FontWeight.w600,
                                    //         useGoogleFonts: GoogleFonts.asMap()
                                    //             .containsKey(
                                    //             FlutterFlowTheme
                                    //                 .of(context)
                                    //                 .bodyMediumFamily),
                                    //       ),
                                    //     ),
                                    //     subtitle: Text(
                                    //         "Gain the competitive edge with targeted practice and strategic insights.",
                                    //         style: FlutterFlowTheme
                                    //             .of(context)
                                    //             .bodyMedium
                                    //             .override(
                                    //           fontSize: 12,
                                    //           fontFamily: FlutterFlowTheme
                                    //               .of(context)
                                    //               .bodyMediumFamily,
                                    //           color: Color(0xff858585),
                                    //           fontWeight: FontWeight.w400,
                                    //           useGoogleFonts: GoogleFonts
                                    //               .asMap()
                                    //               .containsKey(
                                    //               FlutterFlowTheme
                                    //                   .of(context)
                                    //                   .bodyMediumFamily),
                                    //         )),
                                    //   ),
                                    // ),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(
                                          10, 10, 10, 5),
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            context.pushNamed(
                                              'OrderPage', queryParameters: {
                                              'courseId': serializeParam(
                                                FFAppState().courseId,
                                                ParamType.String,
                                              ),
                                              'courseIdInt': serializeParam(
                                                FFAppState().courseIdInt
                                                    .toString(),
                                                ParamType.String,
                                              ),
                                            }.withoutNulls,);
                                            return;
                                          },
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            elevation: 5,
                                            backgroundColor:
                                            FlutterFlowTheme
                                                .of(context)
                                                .primary,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 50, vertical: 15),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .circular(
                                                  10.0), // Border radius
                                            ),
                                          ),
                                          child: Text('Enroll Now! for SPECIAL DISCOUNT',
                                              textAlign: TextAlign.center,
                                              style: FlutterFlowTheme
                                                  .of(context)
                                                  .bodyMedium
                                                  .override(
                                                fontFamily:
                                                FlutterFlowTheme
                                                    .of(context)
                                                    .bodyMediumFamily,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                                fontSize: 14.0,
                                                useGoogleFonts: GoogleFonts
                                                    .asMap()
                                                    .containsKey(
                                                    FlutterFlowTheme
                                                        .of(context)
                                                        .bodyMediumFamily),
                                              ))),
                                    ),
                                    // Container(
                                    //   width:MediaQuery.of(context).size.width,
                                    //   padding: EdgeInsets.fromLTRB(
                                    //       10, 5, 10, 10),
                                    //   child: OutlinedButton(
                                    //       onPressed: () {
                                    //         Navigator.pop(context);
                                    //         context.pushNamed(
                                    //             'FlashcardChapterWisePage'
                                    //         );
                                    //         return;
                                    //       },
                                    //       style: OutlinedButton.styleFrom(
                                    //           shape: RoundedRectangleBorder(
                                    //               borderRadius:
                                    //               new BorderRadius.circular(
                                    //                   10.0)),
                                    //           side: BorderSide(
                                    //               width: 1.0,
                                    //               color: FlutterFlowTheme
                                    //                   .of(context)
                                    //                   .primary),
                                    //           padding:
                                    //           EdgeInsets.symmetric(
                                    //               vertical: 15,horizontal:50)),
                                    //       child: Text("Learn More",
                                    //           style: FlutterFlowTheme
                                    //               .of(context)
                                    //               .bodyMedium
                                    //               .override(
                                    //             fontFamily:
                                    //             FlutterFlowTheme
                                    //                 .of(context)
                                    //                 .bodyMediumFamily,
                                    //             fontSize: 12.0,
                                    //             color: FlutterFlowTheme
                                    //                 .of(context)
                                    //                 .primary,
                                    //             fontWeight: FontWeight.w400,
                                    //             useGoogleFonts: GoogleFonts
                                    //                 .asMap()
                                    //                 .containsKey(
                                    //                 FlutterFlowTheme
                                    //                     .of(context)
                                    //                     .bodyMediumFamily),
                                    //           ))),
                                    // ),
                                    // Align(
                                    //   alignment: Alignment.center,
                                    //   child: ListTileTheme(
                                    //     horizontalTitleGap: 0,
                                    //     child: CheckboxListTile(
                                    //       title: Text("Don't show this message again",
                                    //           style:FlutterFlowTheme.of(context).bodyMedium.override(
                                    //         fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                    //         color: Color(0xFF252525),
                                    //         fontSize: 12.0,
                                    //         fontWeight: FontWeight.normal,
                                    //         useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                    //       )),
                                    //       value: _model.prefsShowAssertionBannerUpdated,
                                    //       checkColor: FlutterFlowTheme.of(context).primary,
                                    //       fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                                    //         return Colors.white;
                                    //       }),
                                    //       onChanged: (newValue) async{
                                    //         setState(() {
                                    //           _model.prefsShowAssertionBannerUpdated = newValue!;
                                    //           print(_model.prefsShowAssertionBannerUpdated);
                                    //         });
                                    //         SharedPreferences prefs = await SharedPreferences.getInstance();
                                    //         prefs.setBool('prefsShowAssertionBannerUpdated',!_model.prefsShowAssertionBannerUpdated);
                                    //       },
                                    //       controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                              )
                          );
                        }
                    ),
                  );
                });

          }
          if (SignupGroup
              .loggedInUserInformationAndCourseAccessCheckingApiCall
              .courses(
            response
                .jsonBody,
          )
              .length ==
              0 && FFAppState().memberShipResIdList.toList().length != 0  && false) {
            getTotalPracticedQuestions().then((_){
              _model.totalPracticedQuestions<2500
                  ? _model.showPopup(context):_model.showCongratulationsPopUp(context);
            });

          }
        });
        FFAppState().showBanners = false;
      }

      await actions.getJson(
        FFAppState().memberShipRes,
      );
      print(FFAppState().memberShipResIdList.toList().length == 0);
      actions.chkJson(
        FFAppState().memberShipResIdList.toList(),
      );
      _model.apiResultdwy = await chapWiseTemp;


      if ((_model.apiResultdwy?.succeeded ?? true)) {
        func(chapWiseTemp);
        // Future.delayed(Duration(milliseconds: 300));
        FFAppState().allSearchItems =
            PracticeGroup.getPracticeTestsToShowChapterWiseCall
                .allChapterWithId(
              (_model.apiResultdwy?.jsonBody ?? ''),
            )!
                .toList()
                .cast<dynamic>();
      } else {
        func(chapWiseTemp);
      }
      // topicstemp = await compute<IsolateModelTopics, dynamic>(
      //     apiCallTopics, IsolateModelTopics(chapWiseTemp));

    });

    setupAnimations(
      animationsMap.values.where((anim) =>
      anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    setupAnimations(
      animationsMap.values.where((anim) =>
      anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_)async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? count = prefs.containsKey("showCount")? prefs.getInt("showCount"):0;
      count = count!+1;
      prefs.setInt("showCount", count);
      print(FFAppState().showFeedbackDrawerTooltip.toString()+"FFAppState().showFeedbackDrawerTooltip");
      if(FFAppState().showFeedbackDrawerTooltip && count<=4){
        FFAppState().showFeedbackDrawerTooltip = false;
        FFAppState().showFeedbackSubmitTooltip = false;
      }
      else{
        if(FFAppState().showFeedbackSubmitTooltip){
          ShowCaseWidget.of(context).startShowCase([commonProvider.feedbackSubmitToolTipKey]);
          FFAppState().showFeedbackSubmitTooltip = false;
        }

      }

      setState(() {});
    });

  }

  Future<bool> isFormCompleted() async {
    _model.response= await SignupGroup
        .getUserInformationApiCall
        .call(
      authToken: FFAppState().subjectToken,
    );
    bool isPhonePresent  = false, isCityPresent  = false,isStatePresent  = false, isBoardExamYearPresent  = false, isNeetExamYearPresent=false, isFirstNamePresent = false, isLastNamePresent = false, isDOBPresent = false, isRegistrationNoPresent = false;
    if(SignupGroup.getUserInformationApiCall.me( _model.response?.jsonBody)!=null) {
      isPhonePresent = SignupGroup.getUserInformationApiCall.phone(
          _model.response?.jsonBody) != null
          && SignupGroup.getUserInformationApiCall
              .phone( _model.response?.jsonBody)
              .isNotEmpty;

      isCityPresent = SignupGroup.getUserInformationApiCall.city(
          _model.response?.jsonBody) != null
          && SignupGroup.getUserInformationApiCall
              .city( _model.response?.jsonBody)
              .isNotEmpty;

      isStatePresent = SignupGroup.getUserInformationApiCall.state(
          _model.response?.jsonBody) != null
          && SignupGroup.getUserInformationApiCall
              .state( _model.response?.jsonBody)
              .isNotEmpty;

      isBoardExamYearPresent = SignupGroup.getUserInformationApiCall
          .boardExamYear( _model.response?.jsonBody) != null
          && SignupGroup.getUserInformationApiCall
              .boardExamYear( _model.response?.jsonBody).toString()
              .isNotEmpty;

      isNeetExamYearPresent = SignupGroup.getUserInformationApiCall
          .neetExamYear( _model.response?.jsonBody) != null
          && SignupGroup.getUserInformationApiCall
              .neetExamYear( _model.response?.jsonBody).toString()
              .isNotEmpty;

      isFirstNamePresent = SignupGroup.getUserInformationApiCall.firstName(
          _model.response?.jsonBody) != null
          && SignupGroup.getUserInformationApiCall
              .firstName( _model.response?.jsonBody)
              .isNotEmpty;

      isLastNamePresent = SignupGroup.getUserInformationApiCall.lastName(
          _model.response?.jsonBody) != null
          && SignupGroup.getUserInformationApiCall
              .lastName( _model.response?.jsonBody)
              .isNotEmpty;
      isDOBPresent= SignupGroup.getUserInformationApiCall.dob(
          _model.response?.jsonBody) != null
          && SignupGroup.getUserInformationApiCall
              .dob( _model.response?.jsonBody)
              .isNotEmpty;
      isRegistrationNoPresent= SignupGroup.getUserInformationApiCall.registrationNo(
          _model.response?.jsonBody) != null
          && SignupGroup.getUserInformationApiCall
              .registrationNo( _model.response?.jsonBody)
              .isNotEmpty;
    }


    bool isFormCompleted  = isPhonePresent && isCityPresent && isNeetExamYearPresent && isStatePresent && isBoardExamYearPresent  && isFirstNamePresent && isLastNamePresent && isDOBPresent;
    if(isNeetExamYearPresent && isFormCompleted){
      String neetExamYear =  SignupGroup.getUserInformationApiCall
          .neetExamYear( _model.response?.jsonBody).toString();
      if(neetExamYear=="2024" && !isRegistrationNoPresent){
        isFormCompleted = false;
      }

    }
    FFAppState().isFormCompleted = isFormCompleted;
    if(FFAppState().isFormCompleted) {
      FFAppState().firstName =
          SignupGroup.getUserInformationApiCall.firstName(_model.response?.jsonBody).toString();
      FFAppState().lastName =
          SignupGroup.getUserInformationApiCall.lastName(_model.response?.jsonBody)
              .toString();
      FFAppState().phoneNum = SignupGroup.getUserInformationApiCall
          .phone(_model.response?.jsonBody)
          .toString();
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(isFormCompleted){
      prefs.setBool('isPersonalDetailsCompleted', true);
    }
    else{
      prefs.setBool('isPersonalDetailsCompleted', false);
    }
    return Future.value(isFormCompleted) ;

  }

  Future<void> getTotalPracticedQuestions() async {
    final String apiUrl = 'https://api.neetprep.com/v2api/user_practice_summary';

    final Map<String, String> headers = {
      'Authorization':
      'Bearer '+ FFAppState().newToken,
    };

    try {
      http.Response response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {

        final List<dynamic> responseData = parseTotalPracticedQuestions(response.body);
        setState(() {
          _model.totalPracticedQuestions = responseData.isNotEmpty
              ? responseData[0]['total_questions_practiced']
              : 0;
        });
        print(responseData);
      } else {
        print('API Error - Status Code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (error) {
      print('Error during API call: $error');
    }
  }

  List<dynamic> parseTotalPracticedQuestions(String responseBody) {
    return jsonDecode(responseBody);
  }

  @override
  void dispose() {
    _model.dispose();
    tooltipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    //setsate to be checked before removing it, sometimes page doesnot show chapters
    setState(() {});
    //WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    return Consumer2<PracticeChapterWisePageModel,CommonProvider>(
        builder: (context,practiceChapModel,commonProvider,child) {
          return FutureBuilder<ApiCallResponse>(
            future: chapWiseTemp,
            builder: (context, snapshot) {
              // Customize what your widget looks like when it's loading.
              if (!snapshot.hasData || FFAppState().showLoading) {
                return Scaffold(
                  backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                  body: Center(
                    child: SizedBox(
                      width: 50.0,
                      height: 50.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                    ),
                  ),
                );
              }
              final practiceChapterWisePageGetPracticeTestsToShowChapterWiseResponse =
              snapshot.data!;

              return Title(
                  title: 'PracticeChapterWisePage',
                  color:
                  FlutterFlowTheme.of(context).primaryBackground,
                  child: GestureDetector(
                    // onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
                    child: WillPopScope(
                      onWillPop: () async{
                        await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                        return false;

                      },
                      child: Scaffold(
                        key: scaffoldKey,
                        floatingActionButton: !FFAppState().isScreenshotCaptureDisabled && !commonProvider.isFeedbackSubmitted ?
                        Showcase(
                            key: commonProvider.feedbackSubmitToolTipKey,
                            title: "Submit your feedback here 👇",
                            titleTextStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                              fontSize: 14.0,
                              color:Colors.black,
                              fontWeight: FontWeight.w700,
                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                  FlutterFlowTheme.of(context).bodyMediumFamily),
                            ),
                            description: 'You can close this anytime by restarting the app.',
                            descTextStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                              fontSize: 11.0,
                              color:Colors.black,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w400,
                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                  FlutterFlowTheme.of(context).bodyMediumFamily),
                            ),
                            disableDefaultTargetGestures: false,
                            child: FloatingActionButton(
                              backgroundColor: Colors.black,
                              onPressed: () {
                                commonProvider.showFeedBackFormBottomSheet(context);

                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/images/messages-3.svg',
                                    width: 24.0,
                                    height: 24.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ))
                            :null,
                        backgroundColor:  FlutterFlowTheme.of(context).primaryBackground,

                        drawer: DrawerWidget(DrawerStrings.abhyasBatch),
                        body:  NestedScrollView(
                          floatHeaderSlivers: true,
                          headerSliverBuilder: (context, _) => [
                            SliverAppBar(
                              pinned: false,
                              floating: true,
                              snap: false,
                              backgroundColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                              automaticallyImplyLeading: false,
                              title:Container(
                                width:MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 25.0, 0.0),
                                        child:
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            scaffoldKey.currentState!.openDrawer();
                                          },
                                          child: Icon(
                                            Icons.menu_rounded,
                                            color: FlutterFlowTheme.of(context).accent1,
                                            size: 24.0,
                                          ).animateOnActionTrigger(
                                            animationsMap[
                                            'iconOnActionTriggerAnimation']!,
                                          ),
                                        )
                                    ),
                                    Flexible(
                                      child: Text('NCERT Abhyas',style:FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily),
                                      ),),
                                    ),
                                    SizedBox(width:20),

                                  ],
                                ),
                              ),
                              centerTitle: false,
                              elevation: 0.0,
                              iconTheme: IconThemeData(color:FlutterFlowTheme.of(context).primary),
                            )
                          ],
                          body: Builder(
                            builder: (context) {
                              return SafeArea(
                                top: false,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          12.0, 16.0, 12.0, 8.0),
                                      child: InkWell(
                                        customBorder: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        splashColor:
                                        Color.fromARGB(135, 168, 168, 168),
                                        focusColor:
                                        Color.fromARGB(138, 128, 128, 128),
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          setState(() {
                                            FFAppState().showLoading = true;
                                          });

                                          if (animationsMap[
                                          'rowOnActionTriggerAnimation'] !=
                                              null) {
                                            animationsMap[
                                            'rowOnActionTriggerAnimation']!
                                                .controller
                                                .forward(from: 0.0);
                                          }

                                          await context.pushNamed(
                                            'PracticeSearchPage',
                                            queryParameters: {
                                              'courseIdInt': serializeParam(
                                                FFAppState().courseIdInt,
                                                ParamType.int,
                                              ),
                                              'courseIdInts': serializeParam(
                                                FFAppState().courseIdInts,
                                                ParamType.String,
                                              ),
                                            }.withoutNulls,
                                            extra: <String, dynamic>{
                                              kTransitionInfoKey: TransitionInfo(
                                                hasTransition: true,
                                                transitionType:
                                                PageTransitionType.bottomToTop,
                                                duration: Duration(milliseconds: 300),
                                              ),
                                            },
                                          );
                                          setState(() {
                                            FFAppState().showLoading = false;
                                          });
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 50.0,
                                          decoration: BoxDecoration(
                                            color:FlutterFlowTheme.of(context).secondaryBackground,
                                            borderRadius: BorderRadius.circular(12.0),
                                            border: Border.all(
                                              color: FlutterFlowTheme.of(context).secondaryBorderColor,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                16.0, 0.0, 20.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Search Chapters...',
                                                  style: FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                    fontFamily:
                                                    FlutterFlowTheme.of(
                                                        context)
                                                        .bodyMediumFamily,
                                                    color: FlutterFlowTheme.of(
                                                        context)
                                                        .primaryText,
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.normal,
                                                    useGoogleFonts: GoogleFonts
                                                        .asMap()
                                                        .containsKey(
                                                        FlutterFlowTheme.of(
                                                            context)
                                                            .bodyMediumFamily),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                      4.0, 0.0, 4.0, 0.0),
                                                  child: Icon(
                                                    Icons.search_rounded,
                                                    color:  FlutterFlowTheme.of(
                                                        context)
                                                        .primaryText,
                                                    size: 24.0,
                                                  ),
                                                ),
                                              ],
                                            ).animateOnActionTrigger(
                                              animationsMap[
                                              'rowOnActionTriggerAnimation']!,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        children: [
                                          if (false)
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        16.0, 0.0, 0.0, 0.0),
                                                    child: Image.asset(
                                                      'assets/images/Frame_1000006420.png',
                                                      width: 47.0,
                                                      height: 41.0,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0.0, 2.0, 0.0, 0.0),
                                                      child: Text(
                                                        'Unlock your potential with regular practice today.',
                                                        style: FlutterFlowTheme.of(
                                                            context)
                                                            .bodyMedium
                                                            .override(
                                                          fontFamily:
                                                          FlutterFlowTheme.of(
                                                              context)
                                                              .bodyMediumFamily,
                                                          color:
                                                          Color(0xFFB9B9B9),
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                          FontWeight.normal,
                                                          useGoogleFonts: GoogleFonts
                                                              .asMap()
                                                              .containsKey(
                                                              FlutterFlowTheme.of(
                                                                  context)
                                                                  .bodyMediumFamily),
                                                          lineHeight: 1.4,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          FutureBuilder<ApiCallResponse>(
                                            future: membershipTemp,
                                            builder: (context, snapshot) {
                                              // Customize what your widget looks like when it's loading.
                                              if (!snapshot.hasData) {
                                                return Container(
                                                  height:MediaQuery.of(context).size.height,
                                                  color:FlutterFlowTheme.of(context).primaryBackground,
                                                  child: Center(
                                                    child: SizedBox(
                                                      width: 50.0,
                                                      height: 50.0,
                                                      child: CircularProgressIndicator(
                                                        valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
                                                          FlutterFlowTheme.of(context)
                                                              .primary,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                              final columnLoggedInUserInformationAndCourseAccessCheckingApiResponse =
                                              snapshot.data!;
                                              return Builder(
                                                builder: (context) {
                                                  // final topicNodes = topicstemp;
                                                  final List<dynamic> topicNodes =
                                                      topicTemp ?? [];
                                                  return Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: List.generate(
                                                        topicNodes.length,
                                                            (topicNodesIndex) {
                                                          final topicNodesItem =
                                                          topicNodes[topicNodesIndex];
                                                          return Column(
                                                            mainAxisSize:
                                                            MainAxisSize.min,
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    16.0,
                                                                    16.0,
                                                                    16.0,
                                                                    16.0),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                  MainAxisSize.min,
                                                                  children: [
                                                                    Container(
                                                                      decoration:
                                                                      BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context).accent7,
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
                                                                        AutoSizeText(
                                                                          getJsonField(
                                                                            topicNodesItem,
                                                                            r'''$.name''',
                                                                          )
                                                                              .toString()
                                                                              .toUpperCase()
                                                                              .maybeHandleOverflow(
                                                                            maxChars:
                                                                            31,
                                                                            replacement:
                                                                            '…',
                                                                          ),
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
                                                                            color: FlutterFlowTheme.of(context).primaryText,
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
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                width: double.infinity,
                                                                decoration: BoxDecoration(
                                                                  color: FlutterFlowTheme.of(context).primaryBackground,
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      16.0,
                                                                      0.0,
                                                                      16.0,
                                                                      0.0),
                                                                  child: Builder(
                                                                    builder: (context) {
                                                                      final practiceTest =
                                                                      getJsonField(
                                                                        topicNodesItem,
                                                                        r'''$.questionSets.edges[:].node''',
                                                                        true,
                                                                      ).toList();
                                                                      return ListView
                                                                          .builder(
                                                                        padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                        primary: false,
                                                                        shrinkWrap: true,
                                                                        scrollDirection:
                                                                        Axis.vertical,
                                                                        itemCount:
                                                                        practiceTest
                                                                            .length,
                                                                        itemBuilder: (context,
                                                                            practiceTestIndex) {
                                                                          final practiceTestItem =
                                                                          practiceTest[
                                                                          practiceTestIndex];
                                                                          return PracticeChapButtonWidget(
                                                                            key: Key(
                                                                                'Key59l_${practiceTestIndex}_of_${practiceTest.length}'),
                                                                            parameter1:
                                                                            getJsonField(
                                                                              practiceTestItem,
                                                                              r'''$.name''',
                                                                            ),
                                                                            parameter2:
                                                                            getJsonField(
                                                                              practiceTestItem,
                                                                              r'''$.numQuestions''',
                                                                            ),
                                                                            parameter3:
                                                                            getJsonField(
                                                                              practiceTestItem,
                                                                              r'''$.id''',
                                                                            ),
                                                                            parameter4:
                                                                            FFAppState()
                                                                                .numberOfTabs,
                                                                            courseIdInt:
                                                                            FFAppState()
                                                                                .courseIdInt,
                                                                            courseIdInts:
                                                                            FFAppState()
                                                                                .courseIdInts,
                                                                            trial:false,
                                                                            hasChapterAccess: true,
                                                                            isPaidUser:true,
                                                                              topicId: getJsonField(
                                                                                topicNodesItem,
                                                                                r'''$.id''',
                                                                              )

                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        }),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    // wrapWithModel(
                                    //   model: _model.navBarModel,
                                    //   updateCallback: () => setState(() {}),
                                    //   child: NavBarWidget(),
                                    // ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ));
            },
          );
        }
    );
  }
}