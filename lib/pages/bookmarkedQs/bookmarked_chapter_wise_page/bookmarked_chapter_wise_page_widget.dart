import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neetprep_essential/components/bookmark_chap_button/bookmark_chap_button_widget.dart';
import 'package:neetprep_essential/flutter_flow/flutter_flow_util.dart';
import 'package:neetprep_essential/pages/bookmarkedQs/bookmarked_chapter_wise_page/bookmarked_chapter_wise_page_model.dart';
import 'package:neetprep_essential/providers/commonProvider.dart';
import 'package:neetprep_essential/utlis/text.dart';
import 'package:provider/provider.dart';

import '../../../backend/api_requests/api_calls.dart';
import '../../../clevertap/clevertap_service.dart';
import '../../../components/drawer/darwer_widget.dart';
import '../../../flutter_flow/flutter_flow_icon_button.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';

class BookmarkedChapterWisePageWidget extends StatefulWidget {
  const BookmarkedChapterWisePageWidget({super.key});

  @override
  State<BookmarkedChapterWisePageWidget> createState() =>
      _BookmarkedChapterWisePageWidgetState();
}

class _BookmarkedChapterWisePageWidgetState
    extends State<BookmarkedChapterWisePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    var bookmarkChapterProvider =
        Provider.of<BookmarkedChapterWisePageModel>(context, listen: false);
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FirebaseAnalytics.instance
          .setCurrentScreen(screenName: "BookmarkedChapterWisePageWidget");
      CleverTapService.recordPageView("Bookmarked Chapter Page Opened");
      bookmarkChapterProvider.subjectTopicMap = {};
      bookmarkChapterProvider.isLoading=true;
      bookmarkChapterProvider.selectedCategory = "All";
      bookmarkChapterProvider.showCategory = "All";
      await bookmarkChapterProvider.fetchChaptersData();



    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<BookmarkedChapterWisePageModel, CommonProvider>(
        builder: (context, bookmarkChapterProvider, commonProvider, child) {
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
          drawer: DrawerWidget(DrawerStrings.allBookmarkedQs),
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
                    'Bookmarked Questions',
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
            child: bookmarkChapterProvider.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                        color: FlutterFlowTheme.of(context).primary)):
            Container(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        child:
                            Column(mainAxisSize: MainAxisSize.max, children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 8.0, 5.0, 8.0),
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
                                        showCategoryBottomSheet(context);
                                        setState(() {});
                                      },
                                      child: Container(
                                        height: 50.0,
                                        // width:MediaQuery.of(context).size.width*0.7,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBorderColor,
                                          ),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 0.0, 10.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                bookmarkChapterProvider.showCategory=="All"?"Select Qs Category":bookmarkChapterProvider.showCategory,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily),
                                                        ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        4.0, 0.0, 0.0, 0.0),
                                                child: Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Color(0xFF6E6E6E),
                                                  size: 24.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    context.pushNamed('BookmarkedSearchPage',  queryParameters: {
                                      'courseId': bookmarkChapterProvider.selectedCourseId.toString()
                                    }.withoutNulls,);
                                  },
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        5.0, 8.0, 12.0, 8.0),
                                    child: Container(
                                      height: 50.0,
                                      // width:MediaQuery.of(context).size.width*0.7,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBorderColor,
                                        ),
                                      ),
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      child: Icon(
                                        Icons.search,
                                        color: Color(0xFF6E6E6E),
                                        size: 24.0,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                              bookmarkChapterProvider.subjectTopicMap==null||bookmarkChapterProvider.subjectTopicMap!.isEmpty
                                  ? EmptyBookMarkWidget(context):
                          Expanded(
                            child: ListView.builder(
                              itemCount: bookmarkChapterProvider
                                  .subjectTopicMap?.length,
                              itemBuilder: (context, index) {
                                var entry = bookmarkChapterProvider
                                    .subjectTopicMap?.entries
                                    .elementAt(index);
                                var subject = entry?.key;
                                var topics = entry?.value;

                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 16.0, 16.0, 16.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .accent7,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      12.0, 4.0, 12.0, 4.0),
                                              child: AutoSizeText(
                                                entry!.key
                                                    .toString()
                                                    .toUpperCase()
                                                    .maybeHandleOverflow(
                                                      maxChars: 31,
                                                      replacement: '…',
                                                    ),
                                                textAlign: TextAlign.start,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.normal,
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
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 16.0),
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: topics
                                              !.map(
                                                (topic) =>
                                                    BookmarkChapButtonWidget(
                                                        parameter1: topic[0],
                                                        parameter2: topic[2],
                                                        parameter3: topic[1],
                                                        parameter4: bookmarkChapterProvider.selectedCourseId
                                                    ),
                                              )
                                              .toList()),
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                        ]),
                      ),
          ));
    });
  }


  Widget categoryOption(BuildContext context, String title) {
    return Consumer<BookmarkedChapterWisePageModel>(
      builder: (context, bookmarkProvider, child) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 2), // Reduce vertical padding
          child: Row(
            children: [
              Radio<String>(
                value: title,
                groupValue: bookmarkProvider.selectedCategory, // Get from Provider
                activeColor: Colors.amber,
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (value) {
                  bookmarkProvider.selectedCategory = value!;
                  bookmarkProvider.notifyListeners(); // Notifies UI to rebuild
                },
              ),
              GestureDetector(
                onTap: () {
                  bookmarkProvider.selectedCategory = title!;
                  bookmarkProvider.notifyListeners(); // Notifies UI to rebuild
                },
                child: Text(title,style:FlutterFlowTheme.of(context)
                    .bodyMedium
                    .override(
                  fontFamily: FlutterFlowTheme.of(context)
                      .bodyMediumFamily,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                  useGoogleFonts: GoogleFonts.asMap()
                      .containsKey(
                      FlutterFlowTheme.of(context)
                          .bodyMediumFamily),
                )),
              ),
            ],
          ),
        );
      },
    );
  }


  void showCategoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Consumer<BookmarkedChapterWisePageModel>(
          builder: (context, bookmarkProvider, child) {
            return Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                      "Select Qs Category",
                        style:FlutterFlowTheme.of(context)
                  .titleMedium,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset('assets/images/close_circle.svg',
                            fit: BoxFit.none,
                            color: FlutterFlowTheme.of(context).primaryText),
                      )
                    ],
                  ),
                   SizedBox(height:10),
                  // Category Options
                  Column(
                    children: [
                      categoryOption(context, "All"),
                      categoryOption(context, "NCERT Abhyas"),
                      categoryOption(context, "A/R Power Up"),
                      categoryOption(context, "Abhyas Essential"),
                      categoryOption(context, "Pagewise Flashcard"),
                      categoryOption(context, "Custom Abhyas"),
                    ],
                  ),

                  SizedBox(height: 20),


                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FlutterFlowTheme.of(context).primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.fromLTRB(20.0, 14.0, 20.0,14.0),
                      minimumSize: Size(double.infinity, 50),
                    ),

                    onPressed: () async{
                      bookmarkProvider.showCategory = bookmarkProvider.selectedCategory;
                      bookmarkProvider.notifyListeners();
                       await bookmarkProvider.fetchChaptersData();
                       Navigator.pop(context, bookmarkProvider.selectedCategory);
                    },
                    child: Text("Confirm",style: FlutterFlowTheme.of(context)
                        .bodyMedium
                        .override(
                      fontFamily:
                      FlutterFlowTheme.of(context).titleSmallFamily,
                      color: Colors.white,
                      fontSize: 16.0,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context)
                              .titleSmallFamily),
                    )),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  Widget EmptyBookMarkWidget(context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height*0.5,
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
                        padding: EdgeInsetsDirectional.fromSTEB(
                            50.0, 0.0, 50.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'No Bookmarks Found',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color: FlutterFlowTheme.of(context).accent1,
                                    fontSize: 18.0,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily),
                                  ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 8.0, 0.0, 0.0),
                              child: Text(
                                'You\’ll see your Bookmarks in this section.',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color:
                                          FlutterFlowTheme.of(context).accent1,
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
}
