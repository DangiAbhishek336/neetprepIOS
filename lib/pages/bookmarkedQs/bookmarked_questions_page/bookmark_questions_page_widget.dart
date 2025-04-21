import 'dart:convert';

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
import 'package:neetprep_essential/providers/commonProvider.dart';
import 'package:provider/provider.dart';
import '../../../backend/api_requests/api_calls.dart';
import '../../../clevertap/clevertap_service.dart';
import '../../../flutter_flow/flutter_flow_icon_button.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '../../../components/custom_html_view/custom_html_view_widget.dart';
import '../../../components/html_question/html_question_widget.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import 'bookmarked_questions_page_model.dart';
import 'dart:io' show Platform;
import '/flutter_flow/custom_functions.dart' as functions;
class BookmarkedQuestionsPageWidget extends StatefulWidget {
  const BookmarkedQuestionsPageWidget(
      {Key? key, String? chapterId, String? topicName,String? courseId, int? count})
      : this.chapterId = chapterId ?? 'dfgdfg',
        this.topicName = topicName ?? "",
        this.courseId = courseId ?? null,
        this.count = count ?? 0,
        super(key: key);

  final String chapterId;
  final String topicName;
  final String? courseId;
  final int count;

  @override
  State<BookmarkedQuestionsPageWidget> createState() =>
      _BookmarkedQuestionsPageWidgetState();
}

class _BookmarkedQuestionsPageWidgetState
    extends State<BookmarkedQuestionsPageWidget> {
  // List<dynamic> data = [];
  // List<List<dynamic>> cache = [];
  // int offset = 0;
  // bool isLoading = false;// Adjust per your API response
  //List<dynamic> _allData = [];

  final PageController _pageController = PageController();

  @override
  void initState() {
    var bookmarkedQsPageModel =
        Provider.of<BookmarkedQuestionPageModel>(context, listen: false);
    bookmarkedQsPageModel.getUserBookmarkedQuestions(
        0, int.parse(widget.chapterId),widget.courseId);
    bookmarkedQsPageModel.currentPageIndex = 0;
    bookmarkedQsPageModel.showExplanation=true;
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "BookmarkedQuestionsPage");
    CleverTapService.recordEvent("Bookmarked Questions Page Opened",{
      "chapterId":widget.chapterId,
      "topicName":widget.topicName
    });
    bookmarkedQsPageModel.isBookmarkVisible = true;
  //  bookmarkedQsPageModel.showExplanation =   bookmarkedQsPageModel.explanations[  bookmarkedQsPageModel.currentPageIndex].isNotEmpty? true:false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home:
        Consumer2<BookmarkedQuestionPageModel, CommonProvider>(
            builder: (context, bookmarkedQsProvider, commonProvider, child) {
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
                  context.pop(context);
                  context.pushNamed("BookmarkedChapterWisePage");
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
          body: WillPopScope(onWillPop: () async {
            context.pop(context);
            context.pushNamed("BookmarkedChapterWisePage");
            return false;
          },

            child: bookmarkedQsProvider.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                        color: FlutterFlowTheme.of(context).primary))
                : bookmarkedQsProvider.questions.isEmpty
                    ? Center(child: Text("No Questions Yet", style: FlutterFlowTheme.of(context).bodyMedium))
                    : SafeArea(
                        top: true,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            if (!bookmarkedQsProvider.isLoading)
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .accent9,
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
                                            color: FlutterFlowTheme.of(context)
                                                .accent9,
                                          ),
                                          child: page(),
                                        ),
                                      ),
                                      footer(
                                          bookmarkedQsProvider.currentPageIndex)
                                    ],
                                  ),
                                ),
                              ),
                            if (bookmarkedQsProvider.isLoading)
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
                      ),
          ));
    }));
  }

  Widget page() {
    return Consumer<BookmarkedQuestionPageModel>(
        builder: (context, bookmarkedQsProvider, _) {
      return PageView.builder(
        controller: bookmarkedQsProvider.pageController,
        itemCount: bookmarkedQsProvider.dataList.length,
        // Add 1 for loading indicator
        itemBuilder: (context, index) {
          return Container(
            height: MediaQuery.of(context).size.height,
            decoration:BoxDecoration(
              color: FlutterFlowTheme.of(context)
                  .accent9,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      bookmarkedQsProvider.isNcert[index]
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
                      bookmarkedQsProvider.examList[index] != null? Padding(
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
                              bookmarkedQsProvider.examList[index] != null
                                  ? Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          12.0, 4.0, 1.5, 4.0),
                                      child: Text(
                                        bookmarkedQsProvider
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
                              bookmarkedQsProvider.yearList[index] != null
                                  ? Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 4.0, 12.0, 4.0),
                                      child: Text(
                                        bookmarkedQsProvider.yearList[index]
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
                      ):SizedBox(),
                    ]),

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
                                'Key92a_${index}_of_${bookmarkedQsProvider.dataList.length}'),
                            questionHtmlStr: bookmarkedQsProvider
                                .questions[index]
                                .toString(),
                          )
                        : Container(
                            height: 250,
                            child: AndroidWebView(
                                html: bookmarkedQsProvider.questions[index]
                                    .toString()),
                          ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children:[
                    Container(
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: bookmarkedQsProvider.allStarmarkedQsStatus[index]?Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {

                              var result = await CreateOrDeleteStarmarkQuestionCall().call(
                                questionId:  base64Encode(utf8.encode('Question:${bookmarkedQsProvider.questionIds[index]}')),
                                userId: functions.getBase64OfUserId(FFAppState().userIdInt)??"",
                                authToken: FFAppState().subjectToken,
                              );
                              print( base64Encode(utf8.encode('Question:${bookmarkedQsProvider.questionIds[index]}')));
                              print(result.jsonBody.toString());
                              if(result.succeeded){
                                bookmarkedQsProvider.allStarmarkedQsStatus[index] = false;
                              }

                              setState(() {});
                            },
                            child:SvgPicture.asset('assets/images/star.svg', width: 22.0, height: 22.0, fit: BoxFit.cover, color: FlutterFlowTheme.of(context).primaryText),
                          ),
                        ):Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {

                              var result = await CreateOrDeleteStarmarkQuestionCall().call(
                                questionId:  base64Encode(utf8.encode('Question:${bookmarkedQsProvider.questionIds[index]}')),
                                userId: functions.getBase64OfUserId(FFAppState().userIdInt)??"",
                                authToken: FFAppState().subjectToken,
                              );
                              print( base64Encode(utf8.encode('Question:${bookmarkedQsProvider.questionIds[index]}')));
                              print(result.jsonBody.toString());
                              if(result.succeeded){
                                bookmarkedQsProvider.allStarmarkedQsStatus[index] = true;
                              }

                              setState(() {});
                            },
                            child:  SvgPicture.asset('assets/images/star_outline.svg', width: 22.0, height: 22.0, fit: BoxFit.cover, color: FlutterFlowTheme.of(context).primaryText),
                          ),
                        )

                    ),
                    SizedBox(width:10),
                    Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: bookmarkedQsProvider.allBookmarkQsStatus[index]?Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {

                              var result = await PracticeGroup.createOrDeleteBookmarkForAPracticeQuestionByAUserCall.call(
                                questionId:  base64Encode(utf8.encode('Question:${bookmarkedQsProvider.questionIds[index]}')),
                                userId: functions.getBase64OfUserId(FFAppState().userIdInt),
                                authToken: FFAppState().subjectToken,
                              );
                              print( base64Encode(utf8.encode('Question:${bookmarkedQsProvider.questionIds[index]}')));
                              print(result.jsonBody.toString());
                              if(result.succeeded){
                                bookmarkedQsProvider.allBookmarkQsStatus[index] = false;
                              }

                              setState(() {});
                            },
                            child: Icon(
                              Icons.bookmark_sharp,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 22.0,
                            ),
                          ),
                        ):Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {

                            var result = await PracticeGroup.createOrDeleteBookmarkForAPracticeQuestionByAUserCall.call(
                              questionId:  base64Encode(utf8.encode('Question:${bookmarkedQsProvider.questionIds[index]}')),
                              userId: functions.getBase64OfUserId(FFAppState().userIdInt),
                              authToken: FFAppState().subjectToken,
                            );
                            print( base64Encode(utf8.encode('Question:${bookmarkedQsProvider.questionIds[index]}')));
                            print(result.jsonBody.toString());
                            if(result.succeeded){
                              bookmarkedQsProvider.allBookmarkQsStatus[index] = true;
                            }

                            setState(() {});
                          },
                          child: Icon(
                            Icons.bookmark_border,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 22.0,
                          ),
                        ),
                      )

                    ),

                  ]
                ),
                bookmarkedQsProvider.userAttemptedIndices[index] != null
                    ? Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        padding: EdgeInsets.fromLTRB(15, 16, 15, 16),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primary,
                          borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: FlutterFlowTheme.of(context).primary,width:2.0)

                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Text(
                                "Attempted Answer: " +
                                    (bookmarkedQsProvider
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
                          ],
                        ),
                      )
                    : Container(),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 20),
                  padding: EdgeInsets.fromLTRB(15, 16, 15, 16),
                  decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(8.0),

                      border: Border.all(color: FlutterFlowTheme.of(context).success,width:2.0)

                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      SvgPicture.asset("assets/images/right_icon.svg", width: 20.0, height: 20.0,),
                      SizedBox(width:10.0),
                      Text(
                          "Correct Answer: " +
                              (bookmarkedQsProvider.correctOptionIndices[index] +
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

                            color:FlutterFlowTheme.of(context).success

                              )),
                    ],
                  ),
                ),

                bookmarkedQsProvider.explanations[index].isEmpty ?
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
                                bookmarkedQsProvider.notifyListeners();
                                showDialog(
                                   context:context,
                                    builder: (context){
                                  return  SingleChildScrollView(
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
                                                }(bookmarkedQsProvider.explanations[index]
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
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: kIsWeb || Platform.isIOS
                                                            ? CustomHtmlViewWidget(
                                                          questionStr:
                                                          bookmarkedQsProvider
                                                              .explanations[index]
                                                              .toString(),
                                                        )
                                                            : Container(
                                                          height: MediaQuery.of(context).size.height*0.8,
                                                          child: AndroidWebView(
                                                              html:
                                                              bookmarkedQsProvider
                                                                  .explanations[
                                                              index]
                                                                  .toString()),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                if ((String var1) {
                                                  return RegExp(
                                                      r'<(audio|iframe|table)\b[^>]*>')
                                                      .hasMatch(var1) ||
                                                      RegExp(r'(<math.*>.*</math>|math-tex)')
                                                          .hasMatch(var1);
                                                }(bookmarkedQsProvider.explanations[index]
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
                                                              src: bookmarkedQsProvider
                                                                  .explanations[index]
                                                                  .toString(),
                                                            )
                                                                : Container(
                                                              height: MediaQuery.of(context).size.height*0.8,
                                                              child: AndroidWebView(
                                                                  html: bookmarkedQsProvider
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
                                });
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
          );
        },
        onPageChanged: (index) async {
          bookmarkedQsProvider.currentPageIndex = index;
          bookmarkedQsProvider.showExplanation = true;
          bookmarkedQsProvider.isBookmarkVisible = true;
          bookmarkedQsProvider.notifyListeners();
        },
      );
    });
  }

  Widget footer(index) {
    return Consumer<BookmarkedQuestionPageModel>(
      builder: (context, bookmarkedQsModel, child) => Container(
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
                bookmarkedQsModel.navigateToPage(true);
                bookmarkedQsModel.showExplanation = true;
                bookmarkedQsModel.currentPageIndex = index;
                bookmarkedQsModel.notifyListeners();
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
                bookmarkedQsModel.navigateToPage(false);
                bookmarkedQsModel.showExplanation = true;
                bookmarkedQsModel.currentPageIndex = index;
                bookmarkedQsModel.notifyListeners();
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: index == bookmarkedQsModel.questions.length - 1
                        ? FlutterFlowTheme.of(context).secondaryBackground
                        : FlutterFlowTheme.of(context).primary,
                    border: Border.all(
                        width: 1,
                        color: index == bookmarkedQsModel.questions.length - 1
                            ? Color(0xff858585)
                            : FlutterFlowTheme.of(context).primary),
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(
                  FontAwesomeIcons.angleRight,
                  color: index == bookmarkedQsModel.questions.length - 1
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
    var bookmarkedQsPageModel =
        Provider.of<BookmarkedQuestionPageModel>(context, listen: false);
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
        return Consumer<BookmarkedQuestionPageModel>(
            builder: (context, bookmarkedQsProvider, child) {
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
                                    final quetionList = bookmarkedQsProvider
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
                                                color: bookmarkedQsProvider
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
        setState(() => bookmarkedQsPageModel.selectedPageNumber = value));
    if (bookmarkedQsPageModel.selectedPageNumber != null)
      await bookmarkedQsPageModel.pageController?.animateToPage(
        bookmarkedQsPageModel.selectedPageNumber!,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
  }
}
