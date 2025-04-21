import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neetprep_essential/clevertap/clevertap_service.dart';
import 'package:neetprep_essential/custom_code/widgets/custom_banner.dart';
import 'package:neetprep_essential/flutter_flow/flutter_flow_util.dart';
import 'package:neetprep_essential/pages/starmarkedQs/starmarkedChapterWisePage/starmarkedChapterWisePageModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app_state.dart';
import '../../../auth/firebase_auth/auth_util.dart';
import '../../../backend/api_requests/api_calls.dart';
import '../../../components/drawer/darwer_widget.dart';
import '../../../components/practice_chap_button/practice_chap_button_widget.dart';
import '../../../flutter_flow/flutter_flow_animations.dart';
import '../../../flutter_flow/flutter_flow_icon_button.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/nav/serialization_util.dart';
import '../../../providers/commonProvider.dart';
import '../../../utlis/text.dart';
import 'package:neetprep_essential/pages/practice/practice_chapter_wise_page/practice_chapter_page_model.dart';

import '../../bookmarkedQs/bookmarked_chapter_wise_page/bookmarked_chapter_wise_page_model.dart';

class PracticeChapterPageWidget extends StatefulWidget {
  const PracticeChapterPageWidget({super.key});

  @override
  State<PracticeChapterPageWidget> createState() =>
      _PracticeChapterPageWidgetState();
}

class _PracticeChapterPageWidgetState extends State<PracticeChapterPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoadingTopics = true; // State variable to track loading state
  late ConfettiController _controllerCenter;

  int _current = 0;
  final carousel.CarouselController _controller = carousel.CarouselController();

  @override
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 2));
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      print("subject token: " + FFAppState().subjectToken.toString());
      print("userId: " + FFAppState().userIdInt.toString());
      FirebaseAnalytics.instance.setCurrentScreen(
        screenName: "PracticeChapterWisePage",
      );
      CleverTapService.recordPageView("Abhyas Practice Chapter Page Opened");
      var _model =
          Provider.of<PracticeChapterPageModel>(context, listen: false);
      _model.isLoading = true;
      _model.isTopicsLoading = true;
      setState(() {});
      var commonProvider = Provider.of<CommonProvider>(context, listen: false);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.setUserIdentifier(currentUserUid);
        FirebaseCrashlytics.instance.setCustomKey('userID', currentUserUid);
      }

      print(FFAppState().newToken.toString());

      if (FFAppState().newToken.isEmpty) {
        var bookmarkedProvider =
            Provider.of<StarmarkedChapterWisePageModel>(context, listen: false);
        await bookmarkedProvider.fetchNewToken(FFAppState().subjectToken);
      }

      int? count =
          prefs.containsKey("showCount") ? prefs.getInt("showCount") : 0;
      count = count! + 1;
      prefs.setInt("showCount", count);
      print(FFAppState().showFeedbackDrawerTooltip.toString() +
          "FFAppState().showFeedbackDrawerTooltip");
      if (FFAppState().showFeedbackDrawerTooltip && count <= 4) {
        FFAppState().showFeedbackDrawerTooltip = false;
        FFAppState().showFeedbackSubmitTooltip = false;
      } else {
        if (FFAppState().showFeedbackSubmitTooltip) {
          ShowCaseWidget.of(context)
              .startShowCase([commonProvider.feedbackSubmitToolTipKey]);
          FFAppState().showFeedbackSubmitTooltip = false;
        }
      }

      // _model.initilizeUpdateFCM();
      await _model.callLoginApi(context).then((_) {
        !_model.phoneConfirmed && FFAppState().showPhoneConfirmedModalSheet
            ? (showModalBottomSheet(
                isDismissible: false,
                enableDrag: false,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25.0),
                  ),
                ),
                context: context,
                builder: (context) {
                  return Container(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 30.0, right: 16),
                                    child: SvgPicture.asset(
                                        'assets/images/close_circle.svg',
                                        fit: BoxFit.none,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText),
                                  ),
                                )
                              ]),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                            child: SvgPicture.asset(
                              "assets/images/mobile.svg",
                              height: 60,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Stay Updated',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          fontWeight: FontWeight.w700,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 22.0,
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
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                            child: Text(
                              'Please verify your mobile number for important updates.',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontSize: 13,
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color: FlutterFlowTheme.of(context).accent1,
                                    fontWeight: FontWeight.w400,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily),
                                  ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 15, 16, 15),
                                child: ElevatedButton(
                                    onPressed: () async {
                                      //
                                      // context.pushNamed('flutterWebView',queryParameters: {
                                      //   'webUrl':"assets/webpage.html" ,
                                      //   'title': "Abhyas  2.0"
                                      // },
                                      // );

                                      context.pushNamed('flutterWebView',
                                          queryParameters: {
                                            'webUrl':
                                                "${FFAppState().baseUrl}/newui/essential/phoneVerification?embed=1&disable=home_btn&id_token=${FFAppState().subjectToken}",
                                            'title': "OTP Verification "
                                          });
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      elevation: 5,
                                      backgroundColor:
                                          FlutterFlowTheme.of(context).primary,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 50, vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    child: Text('Continue',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                              fontSize: 14.0,
                                              useGoogleFonts: GoogleFonts
                                                      .asMap()
                                                  .containsKey(
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily),
                                            ))),
                              ),
                            ),
                          )
                        ]),
                  );
                },
              ))
            : null;
      });
      await _model.fetchTopics();
      await _model.getBannersVersion2().then((_) {
        _model.filterBanners();
      });
      setState(() {
        FFAppState().showPhoneConfirmedModalSheet = false;
      });

      var profile = {
        'Name': FFAppState().userName.toString(),
        'UserId': FFAppState().userIdInt.toString(),
        'Email': FFAppState().emailId.toString(),
        'Identity': FFAppState().userIdInt.toString(),
        'CourseStatus': _model.courseStatusResponse.toString(),
        'Phone': _model.phone.toString()
      };

      CleverTapService.profileSet(profile);
    });
  }

  Widget PromotionalBanner(CustomBanner? banner) {
    Color getRandomColor(List<Color> colors) {
      final random = Random();
      return colors[random.nextInt(colors.length)];
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 5, 16, 5),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            color: getRandomColor([
              Color(0xfff8e8b0),
              Color(0xffd7eff2),
              Color(0xfff3efec),
              Color(0xffE4F0D3),
            ]),
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 4, 10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            banner!.title,
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .headlineMediumFamily,
                                  color: Color(0xFF2525250),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w700,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .headlineMediumFamily),
                                ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Flexible(
                            child: RichText(
                          softWrap: true,
                          text: TextSpan(
                            text: banner.content,
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .headlineMediumFamily,
                                  color: Color(0xFF252525),
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.normal,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .headlineMediumFamily),
                                ),
                          ),
                        )),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding: EdgeInsets.zero,
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size.fromHeight(20),
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  // side: BorderSide(width: 3, color: Colors.black),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 10),
                                textStyle: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                            onPressed: () async {
                              if (banner.webPageUrl == null ||
                                  banner.webPageUrl!.isEmpty) {
                                FirebaseAnalytics.instance.logEvent(
                                  name: 'buy_now_button_click',
                                  parameters: {
                                    "courseId": serializeParam(
                                      banner.courseIdForOrderPage.toString(),
                                      ParamType.String,
                                    )
                                  },
                                );
                                CleverTapService.recordEvent(
                                  'Buy Now Clicked',
                                  {
                                    "courseId": serializeParam(
                                      banner.courseIdForOrderPage.toString(),
                                      ParamType.String,
                                    )
                                  },
                                );
                                context.pushNamed(
                                  'OrderPage',
                                  queryParameters: {
                                    'courseId': serializeParam(
                                      base64Encode(utf8.encode(
                                          'Course:${banner.courseIdForOrderPage.toString()}')),
                                      ParamType.String,
                                    ),
                                    'courseIdInt': serializeParam(
                                      banner.courseIdForOrderPage.toString(),
                                      ParamType.String,
                                    ),
                                  }.withoutNulls,
                                );
                              } else {
                                if (!kIsWeb)
                                  context.pushNamed('flutterWebView',
                                      queryParameters: {
                                        'webUrl':
                                            "${banner.webPageUrl}?embed=1&disable=home_btn&id_token=${FFAppState().subjectToken}",
                                        'title': banner.webPageTitle
                                      });
                                else {
                                  final Uri _url = Uri.parse(
                                      '${banner.webPageUrl}?embed=1&disable=home_btn&id_token=${FFAppState().subjectToken}');
                                  if (!await launchUrl(_url)) {
                                    throw Exception('Could not launch ${_url}');
                                  }
                                }
                              }
                            },
                            child: Text(
                              banner.ctaText ?? 'Buy Now',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    fontSize: 14.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily),
                                  ),
                            ),
                          ),
                        ),
                      ]),
                )),
            Flexible(
                flex: 1,
                child: Image.network(
                  banner.imageUrl,
                  width: 270.0,
                  height: 180.0,
                ))
          ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PracticeChapterPageModel>(
      builder: (context, practiceChapModel, child) {
        if (practiceChapModel.isLoading && practiceChapModel.isTopicsLoading) {
          // Display loading indicator if fetching topics
          return Scaffold(
              body: Center(
                  child: CircularProgressIndicator(
                      color: FlutterFlowTheme.of(context).primary)));
        } else
          return Stack(
            children: [
              Scaffold(
                backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                key: scaffoldKey,
                drawer: DrawerWidget(DrawerStrings.abhyasBatch),
                body: practiceChapModel.topicsData == null
                    ? Center(
                        child: CircularProgressIndicator(
                            color: FlutterFlowTheme.of(context).primary))
                    : buildBody(context), // Build your main content
                bottomNavigationBar: practiceChapModel.courseStatus ==
                            "TRIAL" &&
                        practiceChapModel.daysLeft != 0 &&
                        practiceChapModel.daysLeft != null
                    ? Container(
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color:
                                FlutterFlowTheme.of(context).tertiaryBackground,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FFAppState().isDarkMode
                                  ? Image.asset(
                                      'assets/images/sticky-footer-dark.png',
                                    ).image
                                  : Image.asset(
                                      'assets/images/sticky-footer-light.png',
                                    ).image,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 23.0, 16.0, 25.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 10.0, 0.0),
                                    child: Wrap(
                                      spacing: 0.0,
                                      runSpacing: 0.0,
                                      alignment: WrapAlignment.start,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.start,
                                      direction: Axis.horizontal,
                                      runAlignment: WrapAlignment.start,
                                      verticalDirection: VerticalDirection.down,
                                      clipBehavior: Clip.none,
                                      children: [
                                        Text(
                                          '${practiceChapModel.daysLeft} days left  ',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontSize: 14,
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontWeight: FontWeight.bold,
                                                useGoogleFonts: GoogleFonts
                                                        .asMap()
                                                    .containsKey(
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily),
                                              ),
                                        ),
                                        Text(
                                          'in your free trial.',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontSize: 14,
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontWeight: FontWeight.w500,
                                                useGoogleFonts: GoogleFonts
                                                        .asMap()
                                                    .containsKey(
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily),
                                              ),
                                        ),
                                        Text(
                                          'Unlock all chapters now. ',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontSize: 14,
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontWeight: FontWeight.w500,
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
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    FirebaseAnalytics.instance.logEvent(
                                      name: 'buy_now_button_click',
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
                                          //  widget.courseIdInt.toString() ==FFAppState().courseIdInt.toString()?FFAppState().courseId:FFAppState().essentialCourseId,
                                          ParamType.String,
                                        ),
                                        'courseIdInt': serializeParam(
                                          FFAppState().courseIdInt.toString(),
                                          //   widget.courseIdInt.toString(),
                                          ParamType.String,
                                        ),
                                      }.withoutNulls,
                                    );
                                  },
                                  child: Material(
                                    color: Colors.transparent,
                                    elevation: 2.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            29.0, 13.0, 29.0, 13.0),
                                        child: Text(
                                          'Upgrade',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : practiceChapModel.courseStatus != "PAID"
                        ? Container(
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .tertiaryBackground,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FFAppState().isDarkMode
                                      ? Image.asset(
                                          'assets/images/sticky-footer-dark.png',
                                        ).image
                                      : Image.asset(
                                          'assets/images/sticky-footer-light.png',
                                        ).image,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 23.0, 16.0, 25.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 10.0, 0.0),
                                        child: Wrap(
                                          spacing: 0.0,
                                          runSpacing: 0.0,
                                          alignment: WrapAlignment.start,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.start,
                                          direction: Axis.horizontal,
                                          runAlignment: WrapAlignment.start,
                                          verticalDirection:
                                              VerticalDirection.down,
                                          clipBehavior: Clip.none,
                                          children: [
                                            Text(
                                              'Unlock all chapters ',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontSize: 14,
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    fontWeight: FontWeight.bold,
                                                    useGoogleFonts: GoogleFonts
                                                            .asMap()
                                                        .containsKey(
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily),
                                                  ),
                                            ),
                                            Text(
                                              'and kickstart your learning.',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontSize: 14,
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    fontWeight: FontWeight.w500,
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
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        FirebaseAnalytics.instance.logEvent(
                                          name: 'buy_now_button_click',
                                          parameters: {
                                            "courseId": FFAppState()
                                                .courseIdInt
                                                .toString(),
                                          },
                                        );
                                        CleverTapService.recordEvent(
                                          'Buy Now Clicked',
                                          {
                                            "courseId": serializeParam(
                                              FFAppState().courseIdInt,
                                              ParamType.String,
                                            )
                                          },
                                        );
                                        context.pushNamed(
                                          'OrderPage',
                                          queryParameters: {
                                            'courseId': serializeParam(
                                              FFAppState().courseId,
                                              //  widget.courseIdInt.toString() ==FFAppState().courseIdInt.toString()?FFAppState().courseId:FFAppState().essentialCourseId,
                                              ParamType.String,
                                            ),
                                            'courseIdInt': serializeParam(
                                              FFAppState()
                                                  .courseIdInt
                                                  .toString(),
                                              //   widget.courseIdInt.toString(),
                                              ParamType.String,
                                            ),
                                          }.withoutNulls,
                                        );
                                      },
                                      child: Material(
                                        color: Colors.transparent,
                                        elevation: 2.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    29.0, 13.0, 29.0, 13.0),
                                            child: Text(
                                              'Buy Now',
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
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : null,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ConfettiWidget(
                    confettiController: _controllerCenter,
                    blastDirection: -pi / 2,
                    emissionFrequency: 0.01,
                    numberOfParticles: 20,
                    maxBlastForce: 100,
                    minBlastForce: 80,
                    gravity: 0.3,
                    shouldLoop: false),
              ),
            ],
          );
      },
    );
  }

  Widget buildBody(BuildContext context) {
    return Consumer<PracticeChapterPageModel>(
        builder: (context, practiceChapModel, child) {
      // Use `topicsData` to render the main content
      final openTopics = practiceChapModel.topicsData?['openTopics'] ?? [];
      final lockedTopics = practiceChapModel.topicsData?['lockedTopics'] ?? [];

      if (openTopics.isEmpty && lockedTopics.isEmpty) {
        return Center(child: Text('No topics available.'));
      }

      final totalItems = (openTopics.isNotEmpty ? openTopics.length : 0) +
          (lockedTopics.isNotEmpty ? lockedTopics.length : 0);

      return NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            forceElevated: true,
            actions: [
              false &&
                      (practiceChapModel.courseStatus == "FREE" ||
                          practiceChapModel.courseStatus == "EXPIRED")
                  ? Flexible(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(5, 10, 15, 10),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            foregroundColor:
                                FlutterFlowTheme.of(context).primary,
                            side: BorderSide(
                              color: FlutterFlowTheme.of(context).primary,
                              width: 2.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          onPressed: () async {
                            _controllerCenter.play();
                            bool response =
                                await practiceChapModel.getTrialCourse(context);
                            response ? _controllerCenter.play() : null;
                            practiceChapModel.callNotify();
                          },
                          child: Text(
                            " Get Free Trial",
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .bodyMediumFamily),
                                ),
                          ),
                        ),
                      ),
                    )
                  : Container()
            ],
            pinned: false,
            floating: true,
            snap: false,
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            automaticallyImplyLeading: false,
            title: Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 25.0, 0.0),
                      child: InkWell(
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
                          ))),
                  Flexible(
                    child: Text(
                      'NCERT Abhyas',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).bodyMediumFamily),
                          ),
                    ),
                  ),
                  SizedBox(width: 20),
                ],
              ),
            ),
            centerTitle: false,
            elevation: 0.0,
            iconTheme:
                IconThemeData(color: FlutterFlowTheme.of(context).primary),
          )
        ],
        body: Builder(builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
                child: InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  splashColor: Color.fromARGB(135, 168, 168, 168),
                  focusColor: Color.fromARGB(138, 128, 128, 128),
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    setState(() {
                      FFAppState().showLoading = true;
                    });

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
                          transitionType: PageTransitionType.bottomToTop,
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
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color:
                            FlutterFlowTheme.of(context).secondaryBorderColor,
                      ),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 20.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Search Chapters...',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.normal,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .bodyMediumFamily),
                                ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                4.0, 0.0, 4.0, 0.0),
                            child: Icon(
                              Icons.search_rounded,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount:
                      totalItems + 1, // Add one for the promotional banner
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      if (practiceChapModel.filteredBannersList.isNotEmpty) {
                        return Column(
                          children: [
                            Container(
                              child: carousel.CarouselSlider(
                                options: carousel.CarouselOptions(
                                    height: 250,
                                    viewportFraction: 1,
                                    enableInfiniteScroll: false,
                                    autoPlay: true,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        _current = index;
                                      });
                                    }),
                                items: practiceChapModel.filteredBannersList
                                    .map((banner) {
                                  // You can customize this widget based on the fields in CustomBanner
                                  return PromotionalBanner(banner);
                                }).toList(),
                              ),
                            ),
                          ],
                        );
                      } else
                        return Container(); // Place the banner as the first item
                    } else if (index <= openTopics.length) {
                      // Access open topics, adjusting index by -1 for zero-based index
                      final topic = openTopics[index - 1];
                      return ChapterContainer(context, topic, false, index - 1);
                    } else {
                      // Access locked topics, adjusting for openTopics and banner
                      final topic = lockedTopics[index - openTopics.length - 1];
                      return ChapterContainer(context, topic, true, index - 1);
                    }
                  },
                ),
              ),
            ],
          );
        }),
      );
    });
  }

  Widget ChapterContainer(context, topic, isLocked, index) {
    return Consumer<PracticeChapterPageModel>(
        builder: (context, practiceChapModel, _) {
      return Container(
        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).accent7,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12.0, 4.0, 12.0, 4.0),
                child: AutoSizeText(
                  (topic['name'] ?? 'Unknown Topic')
                      .toString()
                      .toUpperCase()
                      .maybeHandleOverflow(
                        maxChars: 31,
                        replacement: '…',
                      ),
                  textAlign: TextAlign.start,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).bodyMediumFamily,
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 12.0,
                        fontWeight: FontWeight.normal,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).bodyMediumFamily),
                      ),
                ),
              ),
            ),
            ...List<Widget>.from(
              (topic['questionSets']['edges'] as List).map(
                (questionSet) => PracticeChapButtonWidget(
                    key: Key(
                        'Key59l_${questionSet['node']['name']}_of_${index}'),
                    parameter1: questionSet['node']['name'],
                    parameter2: questionSet['node']['numQuestions'],
                    parameter3: questionSet['node']['id'],
                    parameter4: FFAppState().numberOfTabs,
                    courseIdInt: FFAppState().courseIdInt,
                    courseIdInts: FFAppState().courseIdInts,
                    trial: practiceChapModel.trial,
                    isPaidUser: practiceChapModel.isPaidUser,
                    hasChapterAccess: !isLocked,
                    topicId: topic['id']),
              ),
            ),
          ],
        ),
      );
    });
  }
}
