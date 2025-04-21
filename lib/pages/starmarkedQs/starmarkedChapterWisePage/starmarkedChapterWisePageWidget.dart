import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neetprep_essential/components/starmark_chap_button/starmark_chap_button_widget.dart';
import 'package:neetprep_essential/flutter_flow/flutter_flow_util.dart';
import 'package:neetprep_essential/pages/starmarkedQs/starmarkedChapterWisePage/starmarkedChapterWisePageModel.dart';
import 'package:neetprep_essential/providers/commonProvider.dart';
import 'package:neetprep_essential/utlis/text.dart';
import 'package:provider/provider.dart';

import '../../../backend/api_requests/api_calls.dart';
import '../../../clevertap/clevertap_service.dart';
import '../../../components/drawer/darwer_widget.dart';
import '../../../flutter_flow/flutter_flow_icon_button.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';

class StarmarkedChapterWisePageWidget extends StatefulWidget {
  const StarmarkedChapterWisePageWidget({super.key});

  @override
  State<StarmarkedChapterWisePageWidget> createState() =>
      _StarmarkedChapterWisePageWidgetState();
}

class _StarmarkedChapterWisePageWidgetState
    extends State<StarmarkedChapterWisePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    var starmarkedChapterProvider =
        Provider.of<StarmarkedChapterWisePageModel>(context, listen: false);
    FirebaseAnalytics.instance
        .setCurrentScreen(screenName: "StarmarkedChapterWisePage");
    CleverTapService.recordPageView("Starmarked Chapter Page Opened");
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      starmarkedChapterProvider.subjectTopicMap = {};
      print(FFAppState().newToken.toString() + " new token");

      await starmarkedChapterProvider.fetchNewToken(FFAppState().subjectToken);

      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<StarmarkedChapterWisePageModel, CommonProvider>(
        builder: (context, starmarkedChapterProvider, commonProvider, child) {
      return Scaffold(
          key: scaffoldKey,
          floatingActionButton: !FFAppState().isScreenshotCaptureDisabled &&
                  !commonProvider.isFeedbackSubmitted
              ? FloatingActionButton(
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
                )
              : null,
          drawer: DrawerWidget(DrawerStrings.allStarmarkedQs),
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 25.0, 0.0),
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
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      )),
                ),
                Flexible(
                  child: Text(
                    'Starmarked Questions',
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
              ],
            ),
            actions: [],
            centerTitle: false,
            elevation: 0.0,
          ),
          body: SafeArea(
            child: starmarkedChapterProvider.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                        color: FlutterFlowTheme.of(context).primary))
                : FutureBuilder<dynamic>(
                    future: starmarkedChapterProvider
                        .fetchChaptersData(FFAppState().newToken),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: CircularProgressIndicator(
                                color: FlutterFlowTheme.of(context).primary));
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError)
                          return Center(
                              child: Text('Something went wrong!',
                                  style:
                                      FlutterFlowTheme.of(context).bodySmall));
                        else {
                          if (snapshot.hasData) {
                            return starmarkedChapterProvider
                                    .chapterIdList.isEmpty
                                ? EmptyStarMarkWidget(context)
                                : Container(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    12.0, 16.0, 12.0, 8.0),
                                            child: InkWell(
                                              customBorder:
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              splashColor: Color.fromARGB(
                                                  135, 168, 168, 168),
                                              focusColor: Color.fromARGB(
                                                  138, 128, 128, 128),
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                // setState(() {
                                                //   FFAppState().showLoading = true;
                                                // });

                                                context.pushNamed(
                                                    'StarmarkedSearchPage');
                                                // setState(() {
                                                //   FFAppState().showLoading = false;
                                                // });
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                height: 50.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBorderColor,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          16.0, 0.0, 20.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Search Chapters...',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  fontSize:
                                                                      12.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily),
                                                                ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    4.0,
                                                                    0.0,
                                                                    4.0,
                                                                    0.0),
                                                        child: Icon(
                                                          Icons.search_rounded,
                                                          color:
                                                              Color(0xFF6E6E6E),
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
                                              itemCount:
                                                  starmarkedChapterProvider
                                                      .subjectTopicMap.length,
                                              itemBuilder: (context, index) {
                                                var entry =
                                                    starmarkedChapterProvider
                                                        .subjectTopicMap.entries
                                                        .elementAt(index);
                                                var subject = entry.key;
                                                var topics = entry.value;
                                                int chapterId =
                                                    starmarkedChapterProvider
                                                        .chapterIdList[index];
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .accent7,
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
                                                                entry.key
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
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
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
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  0.0,
                                                                  16.0,
                                                                  16.0),
                                                      child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: topics
                                                              .map(
                                                                (topic) => StarmarkChapButtonWidget(
                                                                    parameter1:
                                                                        topic[
                                                                            0],
                                                                    parameter2:
                                                                        topic[
                                                                            2],
                                                                    parameter3:
                                                                        topic[
                                                                            1]),
                                                              )
                                                              .toList()),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          )
                                        ]),
                                  );
                          } else {
                            return Text("No Starmark questions yet!");
                          }
                        }
                      }
                      return Container(child: Text("sweet"));
                    },
                  ),
          ));
    });
  }
}

Widget EmptyStarMarkWidget(context) {
  return Container(
    width: double.infinity,
    height: MediaQuery.of(context).size.height,
    decoration: BoxDecoration(
      color: FlutterFlowTheme.of(context).primaryBackground,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            height: 100.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {},
                    child: Image.asset(
                      'assets/images/illustration3.png',
                      width: 180.0,
                      height: 180.0,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                    ),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(50.0, 0.0, 50.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'No Starmarks Found',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  color: FlutterFlowTheme.of(context).accent1,
                                  fontSize: 18.0,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .bodyMediumFamily),
                                ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 8.0, 0.0, 0.0),
                            child: Text(
                              'You\’ll see your Starmarks in this section.',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color: FlutterFlowTheme.of(context).accent1,
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
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
