import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neetprep_essential/providers/commonProvider.dart';
import 'package:provider/provider.dart';
import '../../../../backend/api_requests/api_calls.dart';
import '../../../../components/custom_html_view/custom_html_view_widget.dart';
import '../../../../components/html_question/html_question_widget.dart';
import '../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../clevertap/clevertap_service.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'flashcard_question_page_model.dart';
class FlashcardQuestionPage extends StatefulWidget {
  const FlashcardQuestionPage({
    Key? key,
    this.questionId,
  }) : super(key: key);

  final String? questionId;

  @override
  State<FlashcardQuestionPage> createState() => _FlashcardQuestionPageState();
}

class _FlashcardQuestionPageState extends State<FlashcardQuestionPage> {

  @override
  void initState() {
    var flashcardQsModel = Provider.of<FlashcardQuestionPageModel>(context,listen:false);
    FirebaseAnalytics.instance
        .setCurrentScreen(screenName: "FlashcardQuestionPage");
    CleverTapService.recordEvent("Flashcard Question Page Opened",{
      "questionId":widget.questionId,});
    print(widget.questionId);
    flashcardQsModel.fetchFlashcardQuestion(widget.questionId!);
    flashcardQsModel.selectedIndex = -1;
    flashcardQsModel.currentPageIndex =0;
    flashcardQsModel.customHtmlViewModels1 =
        FlutterFlowDynamicModels(() => CustomHtmlViewModel());
    flashcardQsModel.customHtmlViewModels2 =
        FlutterFlowDynamicModels(() => CustomHtmlViewModel());
    flashcardQsModel.showExplanation  = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Consumer2<FlashcardQuestionPageModel,CommonProvider>(
            builder: (context,flashcardQsModel,commonProvider,child) {
              return Scaffold(
                backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                  floatingActionButton: !FFAppState().isScreenshotCaptureDisabled && !commonProvider.isFeedbackSubmitted ?
                  FloatingActionButton(
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
                  ):null,
                  appBar: AppBar(
                    backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                    automaticallyImplyLeading: false,
                    leading: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, 0.0),
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
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 29.0,
                        ),
                      ),
                    ),
                    title: Text(
                      ' Similar Question',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context)
                          .headlineMedium
                          .override(
                        fontFamily: FlutterFlowTheme.of(context)
                            .headlineMediumFamily,
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context)
                                .headlineMediumFamily),
                      ),
                    ),
                    elevation: 0.0,
                  ),
                  body:  flashcardQsModel.isLoading?
                  Center(
                      child:CircularProgressIndicator(
                          color:FlutterFlowTheme.of(context).primary
                      ))
                      :
                  SafeArea(
                    top: true,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (!flashcardQsModel.isLoading)
                          Expanded(
                            child: Container(
                              width: double.infinity,
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
                                      child: page(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (flashcardQsModel.isLoading)
                          Expanded(
                            child: Container(
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
                  )

              );
            }
        ));


  }
  Widget page(){
    return Consumer<FlashcardQuestionPageModel>(
      builder:(context,flashcardQsModel,child)=>
          Container(
              width: double.infinity,
              height: double.infinity,
              color: FlutterFlowTheme.of(context).primaryBackground,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.fromLTRB(16, 15, 16, 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children:[
                                flashcardQsModel.isQuestionFromNCERT(flashcardQsModel.apiResponse['ncert'])?
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 15.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).primary,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(12.0, 4.0, 12.0, 4.0),
                                      child: Text(
                                        'NCERT',
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                          color: Colors.white,
                                          fontSize: 12.0,
                                          useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                    :SizedBox(),
                                flashcardQsModel.testIsExam(flashcardQsModel.apiResponse)?
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 15.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).primary,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(12.0, 4.0, 1.5, 4.0),
                                          child: Text(
                                            flashcardQsModel.getExam(flashcardQsModel.apiResponse)??""
                                            ,
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                              color: Colors.white,
                                              fontSize: 12.0,
                                              useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 12.0, 4.0),
                                          child: Text(
                                            flashcardQsModel.getYear(flashcardQsModel.apiResponse)??"",
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                              color: Colors.white,
                                              fontSize: 12.0,
                                              useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ):SizedBox(),
                              ]
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).tertiaryBackground,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                      color:FlutterFlowTheme.of(context).secondaryBorderColor,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Visibility(
                                    visible: flashcardQsModel.isBookmarked,
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          setState(() {
                                          flashcardQsModel.isBookmarked = false;
                                          });
                                          await PracticeGroup.createOrDeleteBookmarkForAPracticeQuestionByAUserCall.call(
                                            questionId: widget.questionId,
                                            userId: functions.getBase64OfUserId(FFAppState().userIdInt),
                                            authToken: FFAppState().subjectToken,
                                          );

                                          setState(() {});
                                        },
                                        child: Icon(
                                          Icons.bookmark_sharp,
                                          color: FlutterFlowTheme.of(context).primaryText,
                                          size: 24.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).tertiaryBackground,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                      color:  FlutterFlowTheme.of(context).secondaryBorderColor,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Visibility(
                                    visible: !flashcardQsModel.isBookmarked ,
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          setState(() {
                                            flashcardQsModel.isBookmarked = true;
                                          });
                                          await PracticeGroup.createOrDeleteBookmarkForAPracticeQuestionByAUserCall.call(
                                            questionId: widget.questionId,
                                            userId: functions.getBase64OfUserId(FFAppState().userIdInt),
                                            authToken: FFAppState().subjectToken,
                                          );

                                          setState(() {});
                                        },
                                        child: Icon(
                                          Icons.bookmark_border,
                                          color: FlutterFlowTheme.of(context).primaryText,
                                          size: 24.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height:5),
                      Material(
                        color: Colors.transparent,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Container(
                          width:MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 15.0,
                                color: Color.fromARGB(16, 0, 0, 0),
                                offset: Offset(0.0, 10.0),
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: HtmlQuestionWidget(
                              questionHtmlStr: flashcardQsModel.question,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10.0, 20.0, 11.0, 0.0),
                        child: Builder(
                          builder: (context) {
                            final queNumbers = FFAppState().questionNumbers.toList();
                            return Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(queNumbers.length, (queNumbersIndex) {
                                final queNumbersItem = queNumbers[queNumbersIndex];
                                return Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 5.0, 0.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        if (flashcardQsModel.userAnswer(flashcardQsModel.apiResponse)==null) {

                                          await PracticeGroup.createAnswerForAPracticeQuestionByAUserWithSpecificMarkedOptionCall.call(
                                            questionId:widget.questionId,
                                            userId: functions.getBase64OfUserId(FFAppState().userIdInt),
                                            userAnswer: queNumbersIndex,
                                            authToken: FFAppState().subjectToken,
                                          );


                                          flashcardQsModel.selectedIndex = queNumbersIndex;
                                          flashcardQsModel.notifyListeners();

                                        }},
                                      child: Material(
                                        color: Colors.transparent,
                                        elevation: 2.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        child: Container(
                                          height: 50.0,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFFfffff),
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 15.0,
                                                color: Color.fromARGB(14, 0, 0, 0),
                                                offset: Offset(0.0, 10.0),
                                              )
                                            ],
                                            borderRadius: BorderRadius.circular(12.0),
                                            border: Border.all(
                                              color: valueOrDefault<Color>(
                                                (flashcardQsModel.selectedIndex!=-1 || flashcardQsModel.userAnswer(flashcardQsModel.apiResponse)!=null)
                                                    ? flashcardQsModel.correctOptionIndex(flashcardQsModel.apiResponse)==queNumbersIndex.toString()
                                                    ? Color(0xFF5EB85E)
                                                    : (
                                                    flashcardQsModel.userAnswer(flashcardQsModel.apiResponse).toString()==
                                                        queNumbersIndex.toString() || flashcardQsModel.selectedIndex ==queNumbersIndex

                                                        ? Color(0xFFFF2424)
                                                        :
                                                    flashcardQsModel.selectedIndex!=queNumbersIndex||flashcardQsModel.userAnswer(flashcardQsModel.apiResponse).toString()!= queNumbersIndex.toString()
                                                        ?  Color(0xFF5E5E5E)
                                                        : Color(0xFF5EB85E))
                                                    : FlutterFlowTheme.of(context).primaryBackground,
                                                FlutterFlowTheme.of(context).lineColor,
                                              ),
                                              width: 2.0,
                                            ),
                                          ),
                                          alignment: AlignmentDirectional(0.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                queNumbersItem.toString(),
                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                  color: Color(0xFFB9B9B9),
                                                  fontWeight: FontWeight.w500,
                                                  useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                ),
                                              ),
                                              if ((flashcardQsModel.selectedIndex!=-1 ||flashcardQsModel.userAnswer(flashcardQsModel.apiResponse) != null) &&
                                                  flashcardQsModel.correctOptionIndex(flashcardQsModel.apiResponse) !=
                                                      null &&
                                                  flashcardQsModel.correctOptionIndex(flashcardQsModel.apiResponse) !='' && (flashcardQsModel.apiResponse['analytics']!=null ))
                                                Text(

                                                 ' ( ${functions.getOptionCorrectPercentage(flashcardQsModel.apiResponse, queNumbersIndex)}% ) ',
                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                    color: Color(0xFFB9B9B9),
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w500,
                                                    useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                        ),
                      ),
                      if ( (flashcardQsModel.selectedIndex!=-1 || flashcardQsModel.userAnswer(flashcardQsModel.apiResponse)!=null)&&
                          ( flashcardQsModel.getExplanation(flashcardQsModel.apiResponse)!=null
                          ))
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 40.0, 0.0, 0.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(0, 241, 241, 241),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  // mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: Container(
                                        height: 2,
                                        color: Color(0xffe9e9e9),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          flashcardQsModel.showExplanation = !flashcardQsModel.showExplanation;
                                          flashcardQsModel.notifyListeners();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                            borderRadius: BorderRadius.circular(10.0),
                                            border: Border.all(
                                              color: Color(0xFF252525),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
                                            child: Text(
                                              flashcardQsModel.showExplanation ? 'Show Explanation' : 'Hide Explanation',
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                fontSize: 12.0,
                                                useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      if (!flashcardQsModel.showExplanation)
                                        Padding(
                                          padding: const EdgeInsets.only(top:16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              if ((String var1) {
                                                return !RegExp(r'<(iframe)\b[^>]*>').hasMatch(var1);
                                              }(flashcardQsModel.getExplanation(flashcardQsModel.apiResponse)??""))
                                                wrapWithModel(
                                                  model: flashcardQsModel.customHtmlViewModels2.getModel(
                                                    'QuestionListId:${flashcardQsModel.apiResponse['id']}',
                                                    0,
                                                  ),
                                                  updateCallback: () => setState(() {}),
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    elevation: 0.0,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12.0),
                                                    ),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                                        borderRadius: BorderRadius.circular(8.0),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 15.0,
                                                            color: Color.fromARGB(16, 0, 0, 0),
                                                            offset: Offset(0.0, 10.0),
                                                          )
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: CustomHtmlViewWidget(
                                                          questionStr: flashcardQsModel.getExplanation(flashcardQsModel.apiResponse),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              if ((String var1) {
                                                return RegExp(r'<(iframe)\b[^>]*>').hasMatch(var1) || RegExp(r'(<math.*>.*</math>|math-tex)').hasMatch(var1);
                                              }(flashcardQsModel.getExplanation(flashcardQsModel.apiResponse)??""))
                                                Material(
                                                  color: Colors.transparent,
                                                  elevation: 0.0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12.0),
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                                      borderRadius: BorderRadius.circular(8.0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          blurRadius: 15.0,
                                                          color: Color.fromARGB(16, 0, 0, 0),
                                                          offset: Offset(0.0, 10.0),
                                                        )
                                                      ],
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                                      child: custom_widgets.CustomWebView(
                                                        width: MediaQuery.of(context).size.width * 0.9,
                                                        height: 400,
                                                        src: flashcardQsModel.getExplanation(flashcardQsModel.apiResponse)??"",
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              )
          ),
    );
  }


}
