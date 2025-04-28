import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neetprep_essential/app_state.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../auth/firebase_auth/auth_util.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../utlis/text.dart';
import '../need_help_pop_up/need_help_pop_up_widget.dart';
import '../theme_notifier/theme_notifier.dart';
import '/custom_code/actions/index.dart' as actions;

class DrawerWidget extends StatefulWidget {
  final String pageName;

  const DrawerWidget(this.pageName, {Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget>
    with TickerProviderStateMixin {
  bool isPyqSelected = false;
  bool isMoreSelected = false;
  bool isTestSeriesSelected = false;
  String version = "";

  @override
  void initState() {
    initialize();
    super.initState();
  }

  final ThemeNotifier themeNotifier = ThemeNotifier(
      ThemeMode.light); // Initialize with light mode or retrieve saved state.

  void initialize() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(builder: (context, themeNotifier, child) {
      return SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          color: FlutterFlowTheme.of(context).secondaryBackground,
          child: Drawer(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 8.0, 24.0, 0.0),
                              child: IconButton(
                                  onPressed: () => {Navigator.pop(context)},
                                  icon: Icon(
                                    Icons.arrow_back_rounded,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 24.0,
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  40.0, 8.0, 24.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  FFAppState().isDarkMode
                                      ? SvgPicture.asset(
                                          'assets/images/sun.svg',
                                          width: 24.0,
                                          height: 24.0,
                                        )
                                      : SizedBox(),
                                  Switch(
                                    activeColor:
                                        FlutterFlowTheme.of(context).primary,
                                    value: FFAppState().isDarkMode,
                                    onChanged: (value) {
                                      themeNotifier.toggleDarkMode();
                                    },
                                  ),
                                  !FFAppState().isDarkMode
                                      ? SvgPicture.asset(
                                          'assets/images/moon.svg',
                                          width: 24.0,
                                          height: 24.0,
                                        )
                                      : SizedBox()
                                ],
                              ),
                            ),
                          ]),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            24.0, 8.0, 0.0, 12.0),
                        child: InkWell(
                          onTap: () {
                            context
                                .pushNamed('flutterWebView', queryParameters: {
                              'webUrl':
                                  "${FFAppState().baseUrl}/newui/profilePage?embed=1&disable=home_btn&id_token=${FFAppState().subjectToken}",
                              'title': "Profile Page "
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      valueOrDefault<String>(
                                        currentUserPhoto,
                                        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                      ),
                                      width: 56.0,
                                      height: 56.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 0.0, 0.0, 0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          currentUserDisplayName
                                              .maybeHandleOverflow(
                                            maxChars: 15,
                                            replacement: '…',
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w600,
                                                useGoogleFonts: GoogleFonts
                                                        .asMap()
                                                    .containsKey(
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily),
                                              ),
                                        ),
                                        Text(
                                          currentUserEmail.maybeHandleOverflow(
                                            maxChars: 18,
                                            replacement: '…',
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.normal,
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
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    16.0, 8.0, 16.0, 8.0),
                                child: Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 18.0,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding:
                      //       const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                      //   child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.start,
                      //       children: [
                      //         OutlinedButton(
                      //           onPressed: () {
                      //             context.pushNamed('flutterWebView',
                      //                 queryParameters: {
                      //                   'webUrl':
                      //                       "${FFAppState().baseUrl}/newui/streakLeaderboard?embed=1&disable=home_btn&id_token=${FFAppState().subjectToken}",
                      //                   'title': "Streak Leaderboard"
                      //                 });
                      //           },
                      //           style: ButtonStyle(
                      //             shape: MaterialStateProperty.all(
                      //                 RoundedRectangleBorder(
                      //                     borderRadius:
                      //                         BorderRadius.circular(10.0))),
                      //           ),
                      //           child: Row(
                      //             mainAxisAlignment: MainAxisAlignment.start,
                      //             crossAxisAlignment: CrossAxisAlignment.center,
                      //             children: [
                      //               Image.asset('assets/images/selections.png',
                      //                   width: 25.0,
                      //                   height: 25.0,
                      //                   fit: BoxFit.cover),
                      //               SizedBox(width: 5.0),
                      //               Text('Leaderboard',
                      //                   style: FlutterFlowTheme.of(context)
                      //                       .bodyMedium
                      //                       .override(
                      //                         fontFamily:
                      //                             FlutterFlowTheme.of(context)
                      //                                 .bodyMediumFamily,
                      //                         color:
                      //                             FlutterFlowTheme.of(context)
                      //                                 .primaryText,
                      //                         fontSize: 13.0,
                      //                         fontWeight: FontWeight.normal,
                      //                         useGoogleFonts: GoogleFonts
                      //                                 .asMap()
                      //                             .containsKey(
                      //                                 FlutterFlowTheme.of(
                      //                                         context)
                      //                                     .bodyMediumFamily),
                      //                       )),
                      //             ],
                      //           ),
                      //         ),
                      //         SizedBox(width: 5.0),
                      //         OutlinedButton(
                      //           onPressed: () {
                      //             context.pushNamed(
                      //               'PracticeLog',
                      //             );
                      //           },
                      //           style: ButtonStyle(
                      //             shape: MaterialStateProperty.all(
                      //                 RoundedRectangleBorder(
                      //                     borderRadius:
                      //                         BorderRadius.circular(10.0))),
                      //           ),
                      //           child: Row(
                      //             mainAxisAlignment: MainAxisAlignment.start,
                      //             children: [
                      //               Image.asset('assets/images/qpCalendar.png',
                      //                   width: 25.0,
                      //                   height: 24.0,
                      //                   fit: BoxFit.cover),
                      //               SizedBox(width: 5.0),
                      //               Text('QP Calender',
                      //                   style: FlutterFlowTheme.of(context)
                      //                       .bodyMedium
                      //                       .override(
                      //                         fontFamily:
                      //                             FlutterFlowTheme.of(context)
                      //                                 .bodyMediumFamily,
                      //                         color:
                      //                             FlutterFlowTheme.of(context)
                      //                                 .primaryText,
                      //                         fontSize: 13.0,
                      //                         fontWeight: FontWeight.normal,
                      //                         useGoogleFonts: GoogleFonts
                      //                                 .asMap()
                      //                             .containsKey(
                      //                                 FlutterFlowTheme.of(
                      //                                         context)
                      //                                     .bodyMediumFamily),
                      //                       )),
                      //             ],
                      //           ),
                      //         ),
                      //       ]),
                      // )
                    ]),
                Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 5.0),
                    child: Text('Your Dashboard',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              color: Color(0xFFB9B9B9),
                              fontSize: 13.0,
                              fontWeight: FontWeight.normal,
                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                  FlutterFlowTheme.of(context)
                                      .bodyMediumFamily),
                            ))),
                Expanded(
                  child: Container(
                    //  height: MediaQuery.of(context).size.height * 0.75,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      drawerSection(
                                        context,
                                        widget.pageName,
                                        "Home",
                                        'assets/images/abhyasBatch2.svg',
                                        () async {
                                          if (widget.pageName != "Home") {
                                            // context.pushNamed('abhyasBatch2');

                                            context.pushNamed(
                                              'flutterWebView',
                                              queryParameters: {
                                                'webUrl':
                                                    "${FFAppState().baseUrl}/newui/study",
                                                'title': "Dashboard"
                                              },
                                            );
                                          } else
                                            Scaffold.of(context).closeDrawer();
                                        },
                                      ),
                                      dividerSection(),

                                      drawerSection(
                                        context,
                                        widget.pageName,
                                        DrawerStrings.Course_Catalogue,
                                        'assets/images/abhyasBatch2.svg',
                                        () async {
                                          if (widget.pageName !=
                                              DrawerStrings.Course_Catalogue) {
                                            // context.pushNamed('abhyasBatch2');

                                            context.pushNamed(
                                              'flutterWebViewWithoutAuthToken',
                                              queryParameters: {
                                                'webUrl':
                                                    "${FFAppState().baseUrl}/newui/OffersDisplay",
                                                'title': "Course catalogue"
                                              },
                                            );
                                          } else
                                            Scaffold.of(context).closeDrawer();
                                        },
                                      ),
                                      dividerSection(),
                                      drawerSection(
                                        context,
                                        widget.pageName,
                                        DrawerStrings.TargetBatch,
                                        'assets/images/ncert_abhyas.svg',
                                        () async {
                                          if (widget.pageName !=
                                              DrawerStrings.TargetBatch) {
                                            context.pushNamed(
                                              'flutterWebView',
                                              queryParameters: {
                                                'webUrl':
                                                    "${FFAppState().baseUrl}/newui/product",
                                                'title': "Target Batch"
                                              },
                                            );
                                          } else
                                            Scaffold.of(context).closeDrawer();
                                        },
                                      ),
                                      dividerSection(),
                                      drawerSection(
                                        context,
                                        widget.pageName,
                                        DrawerStrings.ScoreBooster,
                                        'assets/images/book-square.svg',
                                        () async {
                                          if (widget.pageName !=
                                              DrawerStrings.ScoreBooster) {
                                            context.pushNamed(
                                              'flutterWebView',
                                              queryParameters: {
                                                'webUrl':
                                                    "${FFAppState().baseUrl}/newui/scorebooster/coaching-aligned",
                                                'title': "Score Booster"
                                              },
                                            );
                                          } else
                                            Scaffold.of(context).closeDrawer();
                                        },
                                      ),
                                      dividerSection(),
                                      drawerSection(
                                        context,
                                        widget.pageName,
                                        DrawerStrings.customPracticeSession,
                                        'assets/images/book-square.svg',
                                        () async {
                                          if (widget.pageName !=
                                              DrawerStrings
                                                  .customPracticeSession) {
                                            context.pushNamed(
                                              'flutterWebView',
                                              queryParameters: {
                                                'webUrl':
                                                    "${FFAppState().baseUrl}/newui/subjectSelection",
                                                'title':
                                                    "Custom Practice Session"
                                              },
                                            );
                                          } else
                                            Scaffold.of(context).closeDrawer();
                                        },
                                      ),
                                      dividerSection(),

                                      drawerSection(
                                        context,
                                        widget.pageName,
                                        DrawerStrings.flashCards,
                                        'assets/images/book-square.svg',
                                        () async {
                                          if (widget.pageName !=
                                              DrawerStrings.flashCards) {
                                            context.pushNamed(
                                              'flutterWebView',
                                              queryParameters: {
                                                'webUrl':
                                                    "${FFAppState().baseUrl}/newui/subjectSelection",
                                                'title': "Flash Cards"
                                              },
                                            );
                                          } else
                                            Scaffold.of(context).closeDrawer();
                                        },
                                      ),
                                      dividerSection(),
                                      // pyqMarkedNcertSection(),
                                      // drawerSection(
                                      //     context,
                                      //     widget.pageName,
                                      //     DrawerStrings.incorrectQsHighlight,
                                      //     'assets/images/incorrectQsHighlight.svg',
                                      //     () async {
                                      //   if (widget.pageName !=
                                      //       DrawerStrings
                                      //           .incorrectQsHighlight) {
                                      //     print(widget.pageName);
                                      //     context.pushNamed(
                                      //       'ncertAnnotation',
                                      //       queryParameters: {
                                      //         'webUrl':
                                      //             "${FFAppState().baseUrl}/ncert-book/chapters?embed=1",
                                      //         'title': DrawerStrings
                                      //             .incorrectQsHighlight
                                      //       },
                                      //       extra: <String, dynamic>{
                                      //         kTransitionInfoKey:
                                      //             TransitionInfo(
                                      //           hasTransition: true,
                                      //           transitionType:
                                      //               PageTransitionType
                                      //                   .rightToLeft,
                                      //         ),
                                      //       },
                                      //     );
                                      //     Scaffold.of(context).closeDrawer();
                                      //   } else
                                      //     Scaffold.of(context).closeDrawer();
                                      // }),
                                      // dividerSection(),
                                      // // drawerSection(
                                      // //   context,
                                      // //   widget.pageName,
                                      // //   DrawerStrings.practiceLog,
                                      // //   'assets/images/calendar-tick.svg',
                                      // //   () async {
                                      // //     if (widget.pageName !=
                                      // //         DrawerStrings
                                      // //             .homeTestSeriesBooks) {
                                      // //       Scaffold.of(context).closeDrawer();
                                      // //       context.pushNamed('PracticeLog');
                                      // //     } else
                                      // //       Scaffold.of(context).closeDrawer();
                                      // //   },
                                      // // ),
                                      // // dividerSection(),
                                      // drawerSection(
                                      //     context,
                                      //     widget.pageName,
                                      //     DrawerStrings.allBookmarkedQs,
                                      //     'assets/images/bookmarkedQs.svg',
                                      //     () async {
                                      //   if (widget.pageName !=
                                      //       DrawerStrings.allBookmarkedQs) {
                                      //     context.goNamed(
                                      //         'BookmarkedChapterWisePage');
                                      //   } else
                                      //     Scaffold.of(context).closeDrawer();
                                      // }),
                                      // dividerSection(),
                                      // drawerSection(
                                      //     context,
                                      //     widget.pageName,
                                      //     DrawerStrings.allStarmarkedQs,
                                      //     'assets/images/star.svg', () async {
                                      //   context.goNamed(
                                      //       'StarmarkedChapterWisePage');
                                      //   Scaffold.of(context).closeDrawer();
                                      // }),
                                      // dividerSection(),
                                      // moreSection()
                                    ]),
                              ],
                            ),
                          ),
                          SizedBox(height: 200),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    children: [
                      PointerInterceptor(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {},
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                30.0, 0.0, 24.0, 5.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(0.0),
                                  child: SvgPicture.asset(
                                      'assets/images/messages-info.svg',
                                      width: 25.0,
                                      height: 24.0,
                                      fit: BoxFit.cover,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 0.0, 0.0),
                                  child: Text(
                                    'Feedback | Support',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.normal,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      PointerInterceptor(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              30.0, 8.0, 24.0, 5.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(0.0),
                                child: Image.asset('assets/images/star.png',
                                    width: 25.0,
                                    height: 24.0,
                                    fit: BoxFit.cover,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 0.0, 0.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    // await InAppReview.instance
                                    //     .requestReview();
                                    // FFAppState().showRatingPrompt = -1;
                                    await launchURL(
                                        'https://play.google.com/store/apps/details?id=com.neetprep.ios');
                                    return;
                                  },
                                  child: Text(
                                    'Rate us in Playstore',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.normal,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      PointerInterceptor(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              30.0, 8.0, 24.0, 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(0.0),
                                    child: Image.asset(
                                        'assets/images/logout.png',
                                        width: 25.0,
                                        height: 24.0,
                                        fit: BoxFit.cover,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 0.0, 0.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        final prefs = await SharedPreferences
                                            .getInstance();

                                        FFAppState().subjectToken = '';
                                        FFAppState().newToken = '';
                                        FFAppState().userName = '';
                                        FFAppState().userIdInt = 0;
                                        FFAppState().emailId = '';
                                        FFAppState().displayImage = '';
                                        FFAppState().isFormCompleted = false;
                                        FFAppState().clearUserInfoQueryCacheKey(
                                            FFAppState().userIdInt.toString());
                                        GoRouter.of(context)
                                            .prepareAuthEvent(true);
                                        await authManager.signOut();
                                        GoRouter.of(context)
                                            .clearRedirectLocation();

                                        await actions.refreshWebpage();

                                        context.goNamedAuth(
                                          'LoginPage',
                                          context.mounted,
                                          ignoreRedirect: true,
                                        );
                                      },
                                      child: Text(
                                        'Log out',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
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
                                ],
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0.w, 0.0.h, 15.0.w, 0.0.h),
                                child: Container(
                                  width: 61.0.w,
                                  height: 26.0.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0.r),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                  ),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      await launchURL(
                                          'https://www.reflexprep.com/cont/tos');
                                    },
                                    child: Center(
                                      child: Text(
                                        'V ${version}',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .accent8,
                                              fontSize: 10.0.sp,
                                              fontWeight: FontWeight.w400,
                                              useGoogleFonts:
                                                  GoogleFonts.asMap()
                                                      .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                              ),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget dividerSection() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Container(
        height: 1.0, // Set the height of the divider
        color: FlutterFlowTheme.of(context)
            .accent6, // Set the color of the divider
      ),
    );
  }

  Widget drawerSection(context, pageName, text, image, onTapMethod) {
    return PointerInterceptor(
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          onTapMethod();
        },
        child: Container(
          decoration: new BoxDecoration(
            color: pageName == text
                ? FlutterFlowTheme.of(context).sectionBackgroundColor
                : FlutterFlowTheme.of(context).secondaryBackground,
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(30.0, 5.0, 0.0, 5.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(0.0),
                  child: SvgPicture.asset(image,
                      width: 25.0,
                      height: 25.0,
                      fit: BoxFit.cover,
                      color: pageName == text
                          ? FlutterFlowTheme.of(context).primary
                          : FlutterFlowTheme.of(context).primaryText),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
                  child: Text(
                    text,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          color: pageName == text
                              ? FlutterFlowTheme.of(context).primary
                              : FlutterFlowTheme.of(context).primaryText,
                          fontSize: 13.0,
                          fontWeight: pageName == text
                              ? FontWeight.w600
                              : FontWeight.w400,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).bodyMediumFamily),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget pyqMarkedNcertSection() {
    return PointerInterceptor(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                isPyqSelected = !isPyqSelected;
                isTestSeriesSelected = false;
                isMoreSelected = false;
                setState(() {});
              },
              child: Container(
                decoration: new BoxDecoration(
                  color: isPyqSelected
                      ? FlutterFlowTheme.of(context).sectionBackgroundColor
                      : FlutterFlowTheme.of(context).secondaryBackground,
                ),
                padding: EdgeInsetsDirectional.fromSTEB(30.0, 8.0, 40.0, 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(0.0),
                      child: SvgPicture.asset(
                        color: isPyqSelected
                            ? FlutterFlowTheme.of(context).primary
                            : FlutterFlowTheme.of(context).primaryText,
                        'assets/images/bookmark.svg',
                        width: 25.0,
                        height: 25.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'PYQ Marked NCERT',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              color: isPyqSelected
                                  ? FlutterFlowTheme.of(context).primary
                                  : FlutterFlowTheme.of(context).primaryText,
                              fontSize: 14.0,
                              fontWeight: isPyqSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                  FlutterFlowTheme.of(context)
                                      .bodyMediumFamily),
                            ),
                      ),
                    ),
                    Spacer(),
                    isPyqSelected
                        ? SvgPicture.asset("assets/images/arrow-up.svg",
                            color: FlutterFlowTheme.of(context).primary)
                        : SvgPicture.asset("assets/images/arrow-down.svg",
                            color: isPyqSelected
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).primaryText)
                  ],
                ),
              ),
            ),
            dividerSection(),
            Visibility(
                visible: isPyqSelected,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Scaffold.of(context).closeDrawer();
                          context.pushNamed(
                            'ncertAnnotation',
                            queryParameters: {
                              'webUrl':
                                  "${FFAppState().baseUrl}/ncert-book?embed=1",
                              'title': DrawerStrings.ncertAnnotation
                            },
                            extra: <String, dynamic>{
                              kTransitionInfoKey: TransitionInfo(
                                hasTransition: true,
                                transitionType: PageTransitionType.rightToLeft,
                              ),
                            },
                          );
                        },
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              60.0, 10.0, 40.0, 10),
                          child: Row(children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text("P+C+B",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: widget.pageName ==
                                                  DrawerStrings.ncertAnnotation
                                              ? FlutterFlowTheme.of(context)
                                                  .primary
                                              : FlutterFlowTheme.of(context)
                                                  .primaryText,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.normal,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily))),
                            ),
                          ]),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 60, right: 20),
                        child: Container(
                          height: 1.0, // Set the height of the divider
                          color: FlutterFlowTheme.of(context)
                              .accent4, // Set the color of the divider
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Scaffold.of(context).closeDrawer();
                          context.pushNamed('NotesPage');
                        },
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              60.0, 10.0, 40.0, 10),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text("Bio NCERT (PDF)",
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                            fontFamily:
                                                FlutterFlowTheme
                                                        .of(context)
                                                    .bodyMediumFamily,
                                            color: widget
                                                        .pageName ==
                                                    DrawerStrings.bioNcert
                                                ? FlutterFlowTheme.of(context)
                                                    .primary
                                                : FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.normal,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily))),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 60, right: 20),
                        child: Container(
                          height: 1.0, // Set the height of the divider
                          color: FlutterFlowTheme.of(context)
                              .accent6, // Set the color of the divider
                        ),
                      ),
                    ])),
          ]),
    );
  }
}
