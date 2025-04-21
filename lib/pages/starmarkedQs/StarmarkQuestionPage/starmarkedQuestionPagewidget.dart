import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:neetprep_essential/custom_code/widgets/android_web_view.dart';
import 'package:neetprep_essential/flutter_flow/flutter_flow_util.dart';
import 'package:neetprep_essential/pages/starmarkedQs/StarmarkQuestionPage/starmarkedQuestionPagemodel.dart';
import 'package:neetprep_essential/providers/commonProvider.dart';
import 'package:provider/provider.dart';
import '../../../clevertap/clevertap_service.dart';
import '../../../flutter_flow/flutter_flow_icon_button.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '../../../components/custom_html_view/custom_html_view_widget.dart';
import '../../../components/html_question/html_question_widget.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import 'dart:io' show Platform;

class StarmarkedQuestionsPageWidget extends StatefulWidget {
  const StarmarkedQuestionsPageWidget(
      {Key? key, String? chapterId, String? topicName, int? count})
      : this.chapterId = chapterId ?? 'dfgdfg',
        this.topicName = topicName ?? "",
        this.count = count ?? 0,
        super(key: key);

  final String chapterId;
  final String topicName;
  final int count;

  @override
  State<StarmarkedQuestionsPageWidget> createState() =>
      _StarmarkedQuestionsPageWidgetState();
}

class _StarmarkedQuestionsPageWidgetState
    extends State<StarmarkedQuestionsPageWidget> {
  // List<dynamic> data = [];
  // List<List<dynamic>> cache = [];
  // int offset = 0;
  // bool isLoading = false;// Adjust per your API response
  //List<dynamic> _allData = [];

  final PageController _pageController = PageController();

  @override
  void initState() {
    var starmarkedQsPageModel =
        Provider.of<StarmarkedQuestionPageModel>(context, listen: false);
    starmarkedQsPageModel.getUserStarmarkedQuestions(
        0, int.parse(widget.chapterId), FFAppState().newToken);
    starmarkedQsPageModel.currentPageIndex = 0;
    starmarkedQsPageModel.showExplanation=true;
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "StarmarkedQuestionsPage");
    CleverTapService.recordEvent("Starmarked Questions Page Opened",{
      "chapterId":widget.chapterId,
      "topicName":widget.topicName,
      "qsCount":widget.count
    });
  //  starmarkedQsPageModel.showExplanation =   starmarkedQsPageModel.explanations[  starmarkedQsPageModel.currentPageIndex].isNotEmpty? true:false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home:
        Consumer2<StarmarkedQuestionPageModel, CommonProvider>(
            builder: (context, starmarkedQsProvider, commonProvider, child) {
      return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
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
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  context.pop();
                },
                child: Icon(
                  Icons.arrow_back,
                  color:FlutterFlowTheme.of(context).primaryText,
                  size: 29.0,
                ),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.topicName.maybeHandleOverflow(
                    maxChars: 25,
                    replacement: '…',
                  ),
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).headlineMediumFamily,
                        color:FlutterFlowTheme.of(context).primaryText,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).headlineMediumFamily),
                      ),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    showJumpToFlashcardSheet();

                    // setState(() {});
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      'assets/images/category.png',
                      width: 25.0,
                      height: 25.0,
                      fit: BoxFit.contain,
                      color:FlutterFlowTheme.of(context).primaryText
                    ),
                  ),
                ),
              ],
            ),
            elevation: 0.0,
          ),
          body: starmarkedQsProvider.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                      color: FlutterFlowTheme.of(context).primary))
              : starmarkedQsProvider.questions.isEmpty
                  ? Center(child: Text("No Questions Yet", style: FlutterFlowTheme.of(context).bodyMedium))
                  : SafeArea(
                      top: true,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if (!starmarkedQsProvider.isLoading)
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color:FlutterFlowTheme.of(context).primaryBackground,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(15, 0, 15, 0),
                                        width: double.infinity,
                                        height: 100.0,
                                        decoration: BoxDecoration(
                                          color:FlutterFlowTheme.of(context).primaryBackground,
                                        ),
                                        child: page(),
                                      ),
                                    ),
                                    footer(
                                        starmarkedQsProvider.currentPageIndex)
                                  ],
                                ),
                              ),
                            ),
                          if (starmarkedQsProvider.isLoading)
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color:FlutterFlowTheme.of(context).primaryBackground
                                ),
                                width: double.infinity,
                                height: 200.0,
                                child: custom_widgets.CustomLoader(
                                  width: double.infinity,
                                  height: 200.0,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ));
    }));
  }

  Widget page() {
    return Consumer<StarmarkedQuestionPageModel>(
        builder: (context, starmarkedQsProvider, _) {
      return PageView.builder(
        controller: starmarkedQsProvider.pageController,
        itemCount: starmarkedQsProvider.dataList.length,
        // Add 1 for loading indicator
        itemBuilder: (context, index) {
          return Container(
            height: MediaQuery.of(context).size.height,
            decoration:BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        starmarkedQsProvider.isNcert[index]
                            ? Container(
                                margin: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 16.0, 0.0, 0.0),
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).primaryBackground,
                                  border:Border.all(width: 1, color:FlutterFlowTheme.of(context).primary ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      12.0, 4.0, 12.0, 4.0),
                                  child: Text(
                                    'NCERT',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: FlutterFlowTheme.of(context).primary,
                                          fontSize: 12.0,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                        ),
                                  ),
                                ),
                              )
                            : SizedBox(),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              5.0, 16.0, 10.0, 0.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primaryBackground,
                              border:Border.all(width: 1, color: FlutterFlowTheme.of(context).primary),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                starmarkedQsProvider.examList[index] != null
                                    ? Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            12.0, 4.0, 1.5, 4.0),
                                        child: Text(
                                          starmarkedQsProvider
                                                  .examList[index] ??
                                              "",
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color: FlutterFlowTheme.of(context).primary,
                                                fontSize: 12.0,
                                                useGoogleFonts: GoogleFonts
                                                        .asMap()
                                                    .containsKey(
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily),
                                              ),
                                        ),
                                      )
                                    : SizedBox(),
                                starmarkedQsProvider.yearList[index] != null
                                    ? Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 4.0, 12.0, 4.0),
                                        child: Text(
                                          starmarkedQsProvider.yearList[index]
                                                  .toString() ??
                                              "PYQ",
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color: FlutterFlowTheme
                                                    .of(context)
                                                    .primary,
                                                fontSize: 12.0,
                                                useGoogleFonts: GoogleFonts
                                                        .asMap()
                                                    .containsKey(
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily),
                                              ),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                        )
                      ]),
                  SizedBox(height:10),
                  Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(10.0),

                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 20.0),
                      child: kIsWeb || Platform.isIOS
                          ? HtmlQuestionWidget(
                              key: Key(
                                  'Key92a_${index}_of_${starmarkedQsProvider.dataList.length}'),
                              questionHtmlStr: starmarkedQsProvider
                                  .questions[index]
                                  .toString(),
                            )
                          : Container(
                              height: 300,
                              child: AndroidWebView(
                                  html: starmarkedQsProvider.questions[index]
                                      .toString()),
                            ),
                    ),
                  ),
                  starmarkedQsProvider.userAttemptedIndices[index] != null
                      ? Container(
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          padding: EdgeInsets.fromLTRB(15, 16, 15, 16),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primary,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                              "Attempted Answer: " +
                                  (starmarkedQsProvider
                                              .userAttemptedIndices[index]! +
                                          1)
                                      .toString(),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily),
                                color:Colors.white
                                  )),
                        )
                      : SizedBox(),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 20),
                    padding: EdgeInsets.fromLTRB(15, 16, 15, 16),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).greenBackground,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                        "Correct Answer: " +
                            (starmarkedQsProvider.correctOptionIndices[index] +
                                    1)
                                .toString(),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                  FlutterFlowTheme.of(context)
                                      .bodyMediumFamily),
                          color:Colors.white,

                            )),
                  ),
                  starmarkedQsProvider.explanations[index].isEmpty ?
                  SizedBox():
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 25),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          // mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  starmarkedQsProvider.showExplanation =
                                      !starmarkedQsProvider.showExplanation;
                                  showDialog(
                                    context:context,
                                    builder:(context){
                                      return SingleChildScrollView(
                                        child: Container(
                                          height: MediaQuery.of(context).size.height,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(
                                                    8.0, 16.0, 8.0, 16.0),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    if ((String var1) {
                                                      return !RegExp(
                                                          r'<(audio|iframe|table)\b[^>]*>')
                                                          .hasMatch(var1);
                                                    }(starmarkedQsProvider.explanations[index]
                                                        .toString()))
                                                      Material(
                                                        color: Colors.transparent,
                                                        elevation: 0.0,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius.circular(12.0),
                                                        ),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: FlutterFlowTheme.of(context)
                                                                .secondaryBackground,
                                                            borderRadius:
                                                            BorderRadius.circular(8.0),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme.of(context)
                                                                  .secondaryBorderColor,
                                                              width: 1.0,
                                                            ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                blurRadius: 15.0,
                                                                color:
                                                                Color.fromARGB(16, 0, 0, 0),
                                                                offset: Offset(0.0, 10.0),
                                                              )
                                                            ],
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:MainAxisAlignment.start,
                                                            children: [
                                                              InkWell(onTap:(){
                                                                Navigator.pop(context);
                                                              },child: Align(
                                                                alignment: AlignmentDirectional.topEnd,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: Icon(Icons.close),
                                                                ),
                                                              )),
                                                              Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: kIsWeb || Platform.isIOS
                                                                    ? CustomHtmlViewWidget(
                                                                  questionStr:
                                                                  starmarkedQsProvider
                                                                      .explanations[index]
                                                                      .toString(),
                                                                )
                                                                    : Container(
                                                                  height: MediaQuery.of(context).size.height*0.8,
                                                                  child: AndroidWebView(
                                                                      html:
                                                                      starmarkedQsProvider
                                                                          .explanations[
                                                                      index]
                                                                          .toString()),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    if ((String var1) {
                                                      return RegExp(
                                                          r'<(audio|iframe|table)\b[^>]*>')
                                                          .hasMatch(var1) ||
                                                          RegExp(r'(<math.*>.*</math>|math-tex)')
                                                              .hasMatch(var1);
                                                    }(starmarkedQsProvider.explanations[index]
                                                        .toString()))
                                                      Material(
                                                        color: Colors.transparent,
                                                        elevation: 0.0,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius.circular(12.0),
                                                        ),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: FlutterFlowTheme.of(context)
                                                                .secondaryBackground,
                                                            borderRadius:
                                                            BorderRadius.circular(8.0),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme.of(context)
                                                                  .secondaryBorderColor,
                                                              width: 1.0,
                                                            ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                blurRadius: 15.0,
                                                                color:
                                                                Color.fromARGB(16, 0, 0, 0),
                                                                offset: Offset(0.0, 10.0),
                                                              )
                                                            ],
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:MainAxisAlignment.start,
                                                            children: [
                                                              InkWell(onTap:(){
                                                                Navigator.pop(context);
                                                              },child: Align(
                                                                alignment: AlignmentDirectional.topEnd,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: Icon(Icons.close),
                                                                ),
                                                              )),
                                                              Padding(
                                                                padding:
                                                                EdgeInsetsDirectional.fromSTEB(
                                                                    5, 5, 5, 5),
                                                                child: kIsWeb || Platform.isIOS
                                                                    ? custom_widgets.CustomWebView(
                                                                  width:
                                                                  MediaQuery.of(context)
                                                                      .size
                                                                      .width *
                                                                      0.9,
                                                                  height: 400,
                                                                  src: starmarkedQsProvider
                                                                      .explanations[index]
                                                                      .toString(),
                                                                )
                                                                    : Container(
                                                                  height: MediaQuery.of(context).size.height*0.8,
                                                                  child: AndroidWebView(
                                                                      html: starmarkedQsProvider
                                                                          .explanations[index]
                                                                          .toString()),
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
                                      );
                                    }
                                  );
                                  starmarkedQsProvider.notifyListeners();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: Color(0xFF252525),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 8.0, 12.0, 8.0),
                                    child: Text(
                                       'Show Explanation',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: FlutterFlowTheme.of(context)
                                                .bodyMediumFamily,
                                            fontSize: 12.0,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
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
                    ],
                  ),

                ],
              ),
            ),
          );
        },
        onPageChanged: (index) async {
          starmarkedQsProvider.currentPageIndex = index;
          starmarkedQsProvider.showExplanation = true;
          starmarkedQsProvider.notifyListeners();
        },
      );
    });
  }

  Widget footer(index) {
    return Consumer<StarmarkedQuestionPageModel>(
      builder: (context, starmarkedQsModel, child) => Container(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        decoration: BoxDecoration(
            color:FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: [
            BoxShadow(color: FlutterFlowTheme.of(context).primaryBackground, spreadRadius: 3),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                decoration: BoxDecoration(
                  color:FlutterFlowTheme.of(context).tertiaryBackground,
                  border: Border.all(color: FlutterFlowTheme.of(context).secondaryBorderColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    (index + 1).toString() + ".",
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).headlineMediumFamily,
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context)
                                  .headlineMediumFamily),
                        ),
                  ),
                )),
            Spacer(),
            InkWell(
              onTap: () {
                starmarkedQsModel.navigateToPage(true);
                starmarkedQsModel.showExplanation = true;
                starmarkedQsModel.currentPageIndex = index;
                starmarkedQsModel.notifyListeners();
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: index == 0
                        ? FlutterFlowTheme.of(context).secondaryBackground
                        : FlutterFlowTheme.of(context).primary,
                    border: Border.all(
                        width: 1,
                        color: index == 0
                            ? Color(0xff858585)
                            : FlutterFlowTheme.of(context).primary),
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(
                  FontAwesomeIcons.angleLeft,
                  color: index == 0 ?Color(0xff858585): Colors.white,
                  size: 20,
                ),
              ),
            ),
            SizedBox(width: 10),
            InkWell(
              onTap: () {
                starmarkedQsModel.navigateToPage(false);
                starmarkedQsModel.showExplanation = true;
                starmarkedQsModel.currentPageIndex = index;
                starmarkedQsModel.notifyListeners();
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: index == starmarkedQsModel.questions.length - 1
                        ? FlutterFlowTheme.of(context).secondaryBackground
                        : FlutterFlowTheme.of(context).primary,
                    border: Border.all(
                        width: 1,
                        color: index == starmarkedQsModel.questions.length - 1
                            ? Color(0xff858585)
                            : FlutterFlowTheme.of(context).primary),
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(
                  FontAwesomeIcons.angleRight,
                  color: index == starmarkedQsModel.questions.length - 1
                      ?Color(0xff858585)
                      : Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showJumpToFlashcardSheet() async {
    var starmarkedQsPageModel =
        Provider.of<StarmarkedQuestionPageModel>(context, listen: false);
    await showModalBottomSheet(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15.0),
        ),
      ),
      context: context,
      builder: (context) {
        return Consumer<StarmarkedQuestionPageModel>(
            builder: (context, starmarkedQsProvider, child) {
          return Container(
            color:FlutterFlowTheme.of(context).secondaryBackground,
              padding: EdgeInsets.fromLTRB(16, 20, 16, 20),
              height: MediaQuery.of(context).size.height * 0.55,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Jump To Question",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                      fontSize: 20,
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily)),
                          FlutterFlowIconButton(
                            borderColor: Colors.white,
                            borderRadius: 20.0,
                            borderWidth: 0.0,
                            buttonSize: 40.0,
                            fillColor: Colors.white,
                            icon: FaIcon(
                              FontAwesomeIcons.timesCircle,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24.0,
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                          )
                        ]),
                    Text("Enter Question number on which you want to jump",
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontSize: 14,
                            color: Color(0xffb9b9b9),
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            fontWeight: FontWeight.w400)),
                    SizedBox(height: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 20.0, 0.0, 0.0),
                              child: Container(
                                decoration: BoxDecoration(),
                                child: Builder(
                                  builder: (context) {
                                    final quetionList = starmarkedQsProvider
                                            .dataList
                                            ?.toList() ??
                                        [];
                                    return GridView.builder(
                                      padding: EdgeInsets.zero,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 5,
                                              crossAxisSpacing: 16.0,
                                              mainAxisSpacing: 20.0,
                                              childAspectRatio: 1.5),
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount: quetionList.length,
                                      itemBuilder: (context, quetionListIndex) {
                                        final quetionListItem =
                                            quetionList[quetionListIndex];
                                        return InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            Navigator.pop(
                                                context, quetionListIndex);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context).tertiaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                color: starmarkedQsProvider
                                                            .currentPageIndex ==
                                                        quetionListIndex
                                                    ? FlutterFlowTheme.of(
                                                            context)
                                                        .primary
                                                    : Color(0xFFD9D9D9),
                                                width: 1.5,
                                              ),
                                            ),
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 6.0, 0, 6.0),
                                              child: AutoSizeText(
                                                'Q-${(quetionListIndex + 1).toString()}',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color: Color(0xFFB9B9B9),
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
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]));
        });
      },
    ).then((value) =>
        setState(() => starmarkedQsPageModel.selectedPageNumber = value));
    if (starmarkedQsPageModel.selectedPageNumber != null)
      await starmarkedQsPageModel.pageController?.animateToPage(
        starmarkedQsPageModel.selectedPageNumber!,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
  }
}
