import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:neetprep_essential/custom_code/widgets/android_web_view.dart';
import 'package:neetprep_essential/providers/commonProvider.dart';
import 'package:provider/provider.dart';
import '../../../clevertap/clevertap_service.dart';
import '../../../flutter_flow/flutter_flow_animations.dart';
import '../../../flutter_flow/flutter_flow_icon_button.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '../../../components/html_question/html_question_widget.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neetprep_essential/backend/api_requests/api_calls.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'flashcard_page_model.dart';
import '/custom_code/actions/index.dart' as actions;
import 'dart:io' show Platform;
class FlashcardPageWidget extends StatefulWidget {
  const FlashcardPageWidget({
    Key? key,
    String? deckName,
    String? deckId,
    int? offset,
    int? numberOfQuestions,
    int? sectionPointer,
  })  : this.deckName = deckName ?? "",
        this.deckId = deckId ?? 'dfgdfg',
        this.offset = offset ?? 0,
        this.numberOfQuestions = numberOfQuestions ?? 0,
        this.sectionPointer = sectionPointer ?? 0,
        super(key: key);

  final String deckId;
  final String deckName;
  final int offset;
  final int numberOfQuestions;
  final int sectionPointer;

  @override
  _FlashcardPageWidgetState createState() => _FlashcardPageWidgetState();
}

class _FlashcardPageWidgetState extends State<FlashcardPageWidget>
    with TickerProviderStateMixin {
  late FlashcardPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool firstQuestion = true;
  bool justopened = true;
  final animationsMap = {
    'containerOnActionTriggerAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onActionTrigger,
      applyInitialState: true,
      effects: [
        VisibilityEffect(duration: 1.ms),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 2000.ms,
          duration: 600.ms,
          begin: Offset(0.0, 0.0),
          end: Offset(0.0, 74.0),
        ),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 2000.ms,
          duration: 400.ms,
          begin: 1.0,
          end: 0.0,
        ),
      ],
    ),
  };
  String questionStr = "<span class=\"display_webview\"></span>";

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FlashcardPageModel());
    _model.flipController = FlipCardController();
    _model.swipeController = PageController(initialPage: 0);
    _model.issueDescriptionController.clear();
    _model.selectedIssueId = "";
    FirebaseAnalytics.instance
        .setCurrentScreen(screenName: "FlashcardPageWidget");
    CleverTapService.recordEvent("Flashcard Page Opened",{
       "deckName":widget.deckName,
       "deckId": widget.deckId});
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.userAccessJson = await SignupGroup
          .loggedInUserInformationAndCourseAccessCheckingApiCall
          .call(
        authToken: FFAppState().subjectToken,
        courseIdInt: FFAppState().flashcardCourseIdInt,
        altCourseIds: FFAppState().flashcardCourseIdInts,
      );
      if (SignupGroup.loggedInUserInformationAndCourseAccessCheckingApiCall
              .courses(
                (_model.userAccessJson?.jsonBody ?? ''),
              )
              .length >
          0) {
        setState(() {
          _model.isLoading = true;
          _model.quesTitleNumber = widget.offset;
          _model.sectionNumber = widget.sectionPointer;
        });

        _model.statusList = await FlashcardGroup
            .getFlashcardsForDeckGivenIdOffsetAndFirstNLimitCall
            .call(
          deckId: widget.deckId,
          first: widget.numberOfQuestions,
          offset: 0,
        );
        _model.newStatusList = actions.chkJson(
          FlashcardGroup.getFlashcardsForDeckGivenIdOffsetAndFirstNLimitCall
              .deckCards(
                (_model.statusList?.jsonBody ?? ''),
              )!
              .toList(),
        );
        setState(() {
          FFAppState().allFlashcardQuestionsStatus =
              _model.newStatusList!.toList().cast<dynamic>();
        });
        setState(() {
          _model.isLoading = false;
        });
        return;
      } else {
        context.goNamed(
          'FlashcardDeckPage',
          queryParameters: {
            'deckId': serializeParam(
              widget.deckId,
              ParamType.String,
            ),
          }.withoutNulls,
        );

        return;
      }
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    setState(() {});
    return FutureBuilder<ApiCallResponse>(
      future: SignupGroup.loggedInUserInformationAndCourseAccessCheckingApiCall
          .call(
        authToken: FFAppState().subjectToken,
        courseIdInt: FFAppState().flashcardCourseIdInt,
        altCourseIds: FFAppState().flashcardCourseIdInts,
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Container(
              decoration:
              BoxDecoration(
                color: FlutterFlowTheme.of(
                    context)
                    .primaryBackground,
              ),
              child: Center(
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
            ),
          );
        }
        return Consumer<CommonProvider>(
            builder: (context, commonProvider, child) {
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
              title: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 29.0,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            widget.deckName.trim().maybeHandleOverflow(
                                  maxChars: 25,
                                  replacement: '…',
                                ),
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .headlineMediumFamily,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .headlineMediumFamily),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [],
              centerTitle: false,
              elevation: 0.0,
            ),
            body: SafeArea(
              top: true,
              child: Stack(children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (!_model.isLoading)
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                  ),
                                  child: Builder(
                                    builder: (context) {
                                      final quetionList = functions
                                              .testQueTempList(
                                                  widget.numberOfQuestions)
                                              ?.toList() ??
                                          [];
                                      if (justopened) {
                                        _model.quesTitleNumber = widget.offset;
                                        justopened = false;
                                      }
                                      return Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        child: PageView.builder(
                                          controller: _model
                                                  .pageViewController ??=
                                              PageController(
                                                  initialPage: min(
                                                      valueOrDefault<int>(
                                                        widget.offset,
                                                        0,
                                                      ),
                                                      quetionList.length - 1)),
                                          onPageChanged: (_) async {
                                            setState(() {
                                              if (justopened) {
                                                _model.quesTitleNumber =
                                                    widget.offset;
                                                justopened = false;
                                              } else {
                                                _model.quesTitleNumber = _model
                                                        .pageViewController!
                                                        .page!
                                                        .round() ??
                                                    0;
                                              }
                                              firstQuestion = false;
                                            });
                                          },
                                          scrollDirection: Axis.horizontal,
                                          itemCount: quetionList.length,
                                          itemBuilder:
                                              (context, quetionListIndex) {
                                            final quetionListItem =
                                                quetionList[quetionListIndex];
                                            return Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              child: Stack(
                                                children: [
                                                  FutureBuilder<
                                                      ApiCallResponse>(
                                                    future: FFAppState()
                                                        .deckCardsCache(
                                                      uniqueQueryKey:
                                                          '${widget.deckId}${functions.getOffsetInt(quetionListIndex).toString()}10${'${DateTime.now().day}-${DateTime.now().month}'}',
                                                      overrideCache:
                                                          FFAppState()
                                                                  .userIdInt ==
                                                              null,
                                                      requestFn: () =>
                                                          FlashcardGroup
                                                              .getFlashcardsForDeckGivenIdOffsetAndFirstNLimitCall
                                                              .call(
                                                        deckId: widget.deckId,
                                                        offset: functions
                                                            .getOffsetInt(
                                                                quetionListIndex),
                                                        first: 10,
                                                      ),
                                                    ),
                                                    builder:
                                                        (context, snapshot) {
                                                      // Customize what your widget looks like when it's loading.
                                                      if (!snapshot.hasData) {
                                                        return Container(
                                                          decoration:
                                                          BoxDecoration(
                                                            color: FlutterFlowTheme.of(
                                                                context)
                                                                .primaryBackground,
                                                          ),
                                                          child: Center(
                                                            child: SizedBox(
                                                              width: 50.0,
                                                              height: 50.0,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color: FlutterFlowTheme
                                                                        .of(context)
                                                                    .primary,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                      final columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse =
                                                          snapshot.data!;

                                                      return Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          // if(quetionListIndex == )
                                                          FutureBuilder<
                                                              ApiCallResponse>(
                                                            future: FlashcardGroup
                                                                .getDeckDetailsByDeckIdCall
                                                                .call(
                                                              deckId:
                                                                  widget.deckId,
                                                            ),
                                                            builder: (context,
                                                                snapshot) {
                                                              // Customize what your widget looks like when it's loading.
                                                              if (!snapshot
                                                                  .hasData) {
                                                                return Center(
                                                                    child: Container(
                                                                        height:
                                                                            0,
                                                                        width:
                                                                            0,
                                                                        child: Text(
                                                                            "Loading...")));
                                                              }
                                                              final containerGetDeckDetailsResponse =
                                                                  snapshot
                                                                      .data!;
                                                              //gets index of first question of each section
                                                              List<dynamic>
                                                                  sortedList =
                                                                  (((FlashcardGroup.getDeckDetailsByDeckIdCall
                                                                                  .sectionFirstQues(
                                                                                containerGetDeckDetailsResponse.jsonBody,
                                                                              ) ??
                                                                              [])
                                                                          as List)
                                                                      .map<dynamic>(
                                                                          (s) =>
                                                                              (s))
                                                                      .toList());
                                                              //we run search on the list to get the index of the question which is less than or equal to the current question number or target
                                                              int target = _model
                                                                  .quesTitleNumber;
                                                              int upperBound(
                                                                  List<dynamic>
                                                                      sortedList,
                                                                  int target) {
                                                                int start = 0;
                                                                int end = sortedList
                                                                        .length -
                                                                    1;
                                                                int result = 0;

                                                                while (start <=
                                                                    end) {
                                                                  int mid = start +
                                                                      ((end - start) ~/
                                                                          2);

                                                                  if (sortedList[
                                                                          mid] <=
                                                                      target) {
                                                                    result =
                                                                        mid;
                                                                    start =
                                                                        mid + 1;
                                                                  } else {
                                                                    end =
                                                                        mid - 1;
                                                                  }
                                                                }

                                                                return result;
                                                              }

                                                              _model.sectionNumber =
                                                                  upperBound(
                                                                      sortedList,
                                                                      target +
                                                                          1);
                                                              String temp = _model
                                                                  .subTopicName;
                                                              //get the name of current section
                                                              _model
                                                                  .subTopicName = (FlashcardGroup
                                                                      .getDeckDetailsByDeckIdCall
                                                                      .sections(
                                                                containerGetDeckDetailsResponse
                                                                    .jsonBody,
                                                              ) as List)
                                                                  .map<dynamic>(
                                                                      (s) => s)
                                                                  .toList()[_model
                                                                      .sectionNumber]
                                                                  .first
                                                                  .toString();
                                                              if (temp !=
                                                                  _model
                                                                      .subTopicName) {}
                                                              firstQuestion = (_model
                                                                              .quesTitleNumber +
                                                                          1 ==
                                                                      sortedList[
                                                                          _model
                                                                              .sectionNumber])
                                                                  ? true
                                                                  : false;

                                                              return Container(
                                                                height: 0,
                                                                width: 0,
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    if (false)
                                                                      ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                        child: Image
                                                                            .asset(
                                                                          'assets/images/Screenshot_2023-07-04_125804.png',
                                                                          width:
                                                                              50.0,
                                                                          height:
                                                                              70.0,
                                                                          fit: BoxFit
                                                                              .contain,
                                                                        ),
                                                                      ),
                                                                    if (false)
                                                                      Flexible(
                                                                        child:
                                                                            Text(
                                                                          // Congratulations! You have completed the questions of
                                                                          'Congratulations! You have completed all the questions of ${(PracticeGroup.getPracticeTestDetailsForAnExampleSubjectAnatomyCall.sections(
                                                                            containerGetDeckDetailsResponse.jsonBody,
                                                                          ) as List).map<dynamic>((s) => s).toList()[_model.sectionNumber].first.toString()}. Let\'s do some more.',
                                                                          style:
                                                                              FlutterFlowTheme.of(context).bodyMedium,
                                                                        ),
                                                                      ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              width: double
                                                                  .infinity,
                                                              height: double
                                                                  .infinity,
                                                              constraints:
                                                                  BoxConstraints(
                                                                minWidth: double
                                                                    .infinity,
                                                                minHeight: double
                                                                    .infinity,
                                                                maxWidth: double
                                                                    .infinity,
                                                                maxHeight: double
                                                                    .infinity,
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                              ),
                                                              child:
                                                                  SingleChildScrollView(
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    if (firstQuestion &&
                                                                        _model.subTopicName !=
                                                                            '')
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            16,
                                                                            16,
                                                                            16,
                                                                            0),
                                                                        child:
                                                                            Container(
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).sectionBackgroundColor,
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                16,
                                                                                16,
                                                                                16,
                                                                                16),
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Icon(
                                                                                  Icons.info_outline_rounded,
                                                                                  color: FlutterFlowTheme.of(context).primaryText,
                                                                                  size: 24,
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                                                                  child: Text(
                                                                                    'You are on section: ${_model.subTopicName}',
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      color:FlutterFlowTheme.of(context).primaryText,
                                                                                      fontSize: 15,
                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily

                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    Center(
                                                                      child:
                                                                          Container(
                                                                        margin: EdgeInsets.only(
                                                                            top:
                                                                                35),
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.6,
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.85,
                                                                        child:
                                                                            FlipCard(
                                                                          controller:
                                                                              _model.flipController,
                                                                          back:
                                                                              Card(
                                                                            color:
                                                                                Colors.transparent,
                                                                            elevation:
                                                                                2,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(12.0),
                                                                            ),
                                                                            child:
                                                                                Container(
                                                                              width: MediaQuery.of(context).size.width * 0.85,
                                                                              decoration: BoxDecoration(
                                                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                // border: Border.all(
                                                                                //   color: Color(0xFFF0F1F3),
                                                                                //   width: 1.0,
                                                                                // ),
                                                                                boxShadow: [
                                                                                  BoxShadow(
                                                                                    blurRadius: 15.0,
                                                                                    color: Color.fromARGB(16, 0, 0, 0),
                                                                                    offset: Offset(0.0, 10.0),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                children: [
                                                                                  Container(
                                                                                    margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
                                                                                    width: double.infinity,
                                                                                    child: Row(
                                                                                      // mainAxisSize: MainAxisSize.min,
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Container(
                                                                                          decoration: BoxDecoration(
                                                                                            color: FlutterFlowTheme.of(context).tertiaryBackground,
                                                                                            borderRadius: BorderRadius.circular(8.0),
                                                                                            border: Border.all(
                                                                                              color: FlutterFlowTheme.of(context).secondaryBorderColor,
                                                                                              width: 1.0,
                                                                                            ),
                                                                                          ),
                                                                                          child: Padding(
                                                                                            padding: EdgeInsetsDirectional.all(10.0),
                                                                                            child: InkWell(
                                                                                              splashColor: Colors.transparent,
                                                                                              focusColor: Colors.transparent,
                                                                                              hoverColor: Colors.transparent,
                                                                                              highlightColor: Colors.transparent,
                                                                                              onTap: () async {
                                                                                                showAlertDialogBox(
                                                                                                    (FlashcardGroup.getFlashcardsForDeckGivenIdOffsetAndFirstNLimitCall.deckCardContentWoQuestionArr(
                                                                                                      columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                                    ) as List)
                                                                                                        .map<String>((s) => s.toString())
                                                                                                        .toList()[functions.getOffsetListQueIndex(quetionListIndex)],
                                                                                                    "Answer",
                                                                                                    context);
                                                                                              },
                                                                                              child: SvgPicture.asset("assets/images/enlarge.svg", color: FlutterFlowTheme.of(context).primaryText),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Center(
                                                                                          child: Text("Answer", style: FlutterFlowTheme.of(context).bodyMedium.override(fontSize: 16, fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily)),
                                                                                        ),
                                                                                        FlashcardGroup.getFlashcardsForDeckGivenIdOffsetAndFirstNLimitCall.deckCards(
                                                                                                  columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                                )[functions.getOffsetListQueIndex(quetionListIndex)]['questionId'] ==
                                                                                                null
                                                                                            ? Container()
                                                                                            : OutlinedButton(
                                                                                                style: ButtonStyle(
                                                                                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
                                                                                                  side: MaterialStateProperty.all(BorderSide(color: FlutterFlowTheme.of(context).primary, width: 1.0, style: BorderStyle.solid)),
                                                                                                ),
                                                                                                onPressed: () {
                                                                                                  String questionId = _model.getBase64forQuestion(FlashcardGroup.getFlashcardsForDeckGivenIdOffsetAndFirstNLimitCall
                                                                                                      .deckCards(
                                                                                                        columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                                      )[functions.getOffsetListQueIndex(quetionListIndex)]['questionId']
                                                                                                      .toString());
                                                                                                  context.pushNamed(
                                                                                                    'FlashcardQuestionPage',
                                                                                                    queryParameters: {
                                                                                                      'questionId': questionId,
                                                                                                    },
                                                                                                    extra: <String, dynamic>{
                                                                                                      kTransitionInfoKey: TransitionInfo(
                                                                                                        hasTransition: true,
                                                                                                        transitionType: PageTransitionType.rightToLeft,
                                                                                                      ),
                                                                                                    },
                                                                                                  );
                                                                                                },
                                                                                                child: Row(
                                                                                                  children: [
                                                                                                    SvgPicture.asset("assets/images/questions.svg", height: 20, width: 20),
                                                                                                    Text(
                                                                                                      ' Question',
                                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                            color: FlutterFlowTheme.of(context).primary,
                                                                                                            fontSize: 14.0,
                                                                                                            useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                                          ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              )
                                                                                        // :Container()
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Container(
                                                                                      margin: EdgeInsets.fromLTRB(20, 8, 20, 18),
                                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: FlutterFlowTheme.of(context).secondaryBorderColor)),
                                                                                      child: Center(
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(5),
                                                                                          child: HtmlQuestionWidget(
                                                                                              key: Key('Key92a_${quetionListIndex}_of_${quetionList.length}'),
                                                                                              questionHtmlStr: (FlashcardGroup.getFlashcardsForDeckGivenIdOffsetAndFirstNLimitCall.deckCardContentWoQuestionArr(
                                                                                                columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                              ) as List)
                                                                                                  .map<String>((s) => s.toString())
                                                                                                  .toList()[functions.getOffsetListQueIndex(quetionListIndex)]),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          front:
                                                                              Card(
                                                                            color:
                                                                                Colors.transparent,
                                                                            elevation:
                                                                                2,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(12.0),
                                                                            ),
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(
                                                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                // border: Border.all(
                                                                                //   color: Color(0xFFF0F1F3),
                                                                                //   width: 1.0,
                                                                                // ),
                                                                                boxShadow: [
                                                                                  BoxShadow(
                                                                                    blurRadius: 15.0,
                                                                                    color: Color.fromARGB(16, 0, 0, 0),
                                                                                    offset: Offset(0.0, 10.0),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              child: SingleChildScrollView(
                                                                                child: Column(
                                                                                  children: [
                                                                                    Container(
                                                                                      margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
                                                                                      width: double.infinity,
                                                                                      child: Row(
                                                                                        // mainAxisSize: MainAxisSize.min,
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                                                            child: Padding(
                                                                                              padding: EdgeInsetsDirectional.all(10.0),
                                                                                              child: InkWell(
                                                                                                splashColor: Colors.transparent,
                                                                                                focusColor: Colors.transparent,
                                                                                                hoverColor: Colors.transparent,
                                                                                                highlightColor: Colors.transparent,
                                                                                                onTap: () async {
                                                                                                  showAlertDialogBox(
                                                                                                      (FlashcardGroup.getFlashcardsForDeckGivenIdOffsetAndFirstNLimitCall.deckCardTitleArr(
                                                                                                        columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                                      ) as List)
                                                                                                          .map<String>((s) => s.toString())
                                                                                                          .toList()[functions.getOffsetListQueIndex(quetionListIndex)],
                                                                                                      "Question",
                                                                                                      context);
                                                                                                },
                                                                                                child: SvgPicture.asset("assets/images/enlarge.svg", color: FlutterFlowTheme.of(context).primaryText),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Center(
                                                                                            child: Text("FC-" + (_model.quesTitleNumber + 1).toString(), style: FlutterFlowTheme.of(context).bodyMedium.override(fontSize: 16, fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily)),
                                                                                          ),
                                                                                          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                                                                            Container(
                                                                                              decoration: BoxDecoration(
                                                                                                color: FlutterFlowTheme.of(context).tertiaryBackground,
                                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                                border: Border.all(
                                                                                                  color: FlutterFlowTheme.of(context).secondaryBorderColor,
                                                                                                  width: 1.0,
                                                                                                ),
                                                                                              ),
                                                                                              child: Padding(
                                                                                                padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
                                                                                                child: InkWell(
                                                                                                  splashColor: Colors.transparent,
                                                                                                  focusColor: Colors.transparent,
                                                                                                  hoverColor: Colors.transparent,
                                                                                                  highlightColor: Colors.transparent,
                                                                                                  onTap: () async {
                                                                                                    String cardId = (FlashcardGroup.getFlashcardsForDeckGivenIdOffsetAndFirstNLimitCall.deckCardIdArr(
                                                                                                      columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                                    ) as List)
                                                                                                        .map<String>((s) => s.toString())
                                                                                                        .toList()[functions.getOffsetListQueIndex(quetionListIndex)];
                                                                                                    await _model.getQuestionIssueList();
                                                                                                    String cardIdInt = _model.base64DecodeString(cardId);
                                                                                                    _model.showIssueTypeBottomSheet(context, widget.deckId, cardIdInt);
                                                                                                    print(cardId);
                                                                                                  },
                                                                                                  child: SvgPicture.asset("assets/images/alert.svg", color: FlutterFlowTheme.of(context).primaryText),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(width: 10),
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
                                                                                                      visible: getJsonField(
                                                                                                            FFAppState().allFlashcardQuestionsStatus[quetionListIndex],
                                                                                                            r'''$.bookmark''',
                                                                                                          ) !=
                                                                                                          null,
                                                                                                      child: Padding(
                                                                                                        padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
                                                                                                        child: InkWell(
                                                                                                          splashColor: Colors.transparent,
                                                                                                          focusColor: Colors.transparent,
                                                                                                          hoverColor: Colors.transparent,
                                                                                                          highlightColor: Colors.transparent,
                                                                                                          onTap: () async {
                                                                                                            setState(() {
                                                                                                              FFAppState().allFlashcardQuestionsStatus = functions.getUpdatedBookmarkRemoveForFlashCard(FFAppState().allFlashcardQuestionsStatus.toList(), FFAppState().bookMarkEmptyJson, quetionListIndex).toList().cast<dynamic>();
                                                                                                            });
                                                                                                            _model.apiResultdn0 = await FlashcardGroup.createOrDeleteBookmarkForAFlashcardByAUserCall.call(
                                                                                                              cardId: (FlashcardGroup.getFlashcardsForDeckGivenIdOffsetAndFirstNLimitCall.deckCardIdArr(
                                                                                                                columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                                              ) as List)
                                                                                                                  .map<String>((s) => s.toString())
                                                                                                                  .toList()[functions.getOffsetListQueIndex(quetionListIndex)],
                                                                                                              userId: functions.getBase64OfUserId(FFAppState().userIdInt),
                                                                                                              authToken: FFAppState().subjectToken,
                                                                                                            );
                                                                                                            setState(() {});
                                                                                                          },
                                                                                                          child: Icon(
                                                                                                            Icons.bookmark_sharp,
                                                                                                            color: FlutterFlowTheme.of(context).primaryText,
                                                                                                            size: 20.0,
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
                                                                                                        color: FlutterFlowTheme.of(context).secondaryBorderColor,
                                                                                                        width: 1.0,
                                                                                                      ),
                                                                                                    ),
                                                                                                    child: Visibility(
                                                                                                      visible: getJsonField(
                                                                                                            FFAppState().allFlashcardQuestionsStatus[quetionListIndex],
                                                                                                            r'''$.bookmark''',
                                                                                                          ) ==
                                                                                                          null,
                                                                                                      child: Padding(
                                                                                                        padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
                                                                                                        child: InkWell(
                                                                                                          splashColor: Colors.transparent,
                                                                                                          focusColor: Colors.transparent,
                                                                                                          hoverColor: Colors.transparent,
                                                                                                          highlightColor: Colors.transparent,
                                                                                                          onTap: () async {
                                                                                                            setState(() {
                                                                                                              FFAppState().allFlashcardQuestionsStatus = functions.getUpdatedBookmarkForFlashcard(FFAppState().allFlashcardQuestionsStatus.toList(), FFAppState().bookMarkEmptyJson, quetionListIndex).toList().cast<dynamic>();
                                                                                                            });
                                                                                                            _model.apiResultdn1 = await FlashcardGroup.createOrDeleteBookmarkForAFlashcardByAUserCall.call(
                                                                                                              cardId: (FlashcardGroup.getFlashcardsForDeckGivenIdOffsetAndFirstNLimitCall.deckCardIdArr(
                                                                                                                columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                                              ) as List)
                                                                                                                  .map<String>((s) => s.toString())
                                                                                                                  .toList()[functions.getOffsetListQueIndex(quetionListIndex)],
                                                                                                              userId: functions.getBase64OfUserId(FFAppState().userIdInt),
                                                                                                              authToken: FFAppState().subjectToken,
                                                                                                            );
                                                                                                          },
                                                                                                          child: Icon(
                                                                                                            Icons.bookmark_border,
                                                                                                            color: FlutterFlowTheme.of(context).primaryText,
                                                                                                            size: 20.0,
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ]),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.all(5),
                                                                                      child: HtmlQuestionWidget(
                                                                                          key: Key('Key92a_${quetionListIndex}_of_${quetionList.length}'),
                                                                                          questionHtmlStr: (FlashcardGroup.getFlashcardsForDeckGivenIdOffsetAndFirstNLimitCall.deckCardTitleArr(
                                                                                            columnGetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsResponse.jsonBody,
                                                                                          ) as List)
                                                                                              .map<String>((s) => s.toString())
                                                                                              .toList()[functions.getOffsetListQueIndex(quetionListIndex)]),
                                                                                    ),
                                                                                  ],
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
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (_model.isLoading)
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                            ),
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
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 20),
                        child: Center(
                          child: Card(
                              child: Container(
                                  padding:
                                      EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                                  child: Text(
                                      (_model.quesTitleNumber + 1).toString() +
                                          "/" +
                                          widget.numberOfQuestions.toString(),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontSize: 14,
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: Color(0xff858585),
                                          )))),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.zero,
                        child: Container(
                          color:FlutterFlowTheme.of(context).secondaryBackground,
                          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    await _model.pageViewController
                                        ?.animateToPage(
                                      0,
                                      duration: Duration(milliseconds: 100),
                                      curve: Curves.ease,
                                    );
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(12.0),
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).tertiaryBackground,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context).secondaryBorderColor,
                                        ),
                                      ),
                                      child: SvgPicture.asset(
                                          "assets/images/restart_icon.svg",
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText)),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await _model.pageViewController
                                        ?.previousPage(
                                            duration:
                                                Duration(milliseconds: 100),
                                            curve: Curves.linear);
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        color: _model.quesTitleNumber == 0
                                            ? FlutterFlowTheme.of(context).secondaryBackground
                                            : FlutterFlowTheme.of(context)
                                                .primary,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        border: Border.all(
                                          width:  1,
                                          color: _model.quesTitleNumber == 0
                                              ? Color(0xff858585)
                                              : FlutterFlowTheme.of(context)
                                                  .primary,
                                        ),
                                      ),
                                      child: Icon(FontAwesomeIcons.angleLeft,
                                          color: _model.quesTitleNumber == 0
                                              ? Color(0xff858585)
                                              : Colors.white)),
                                ),
                                FFButtonWidget(
                                  onPressed: () async {
                                    await _model.flipController.toggleCard();
                                  },
                                  text: 'Show Answer',
                                  options: FFButtonOptions(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 12.0, 16.0, 12.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 8.0, 16.0, 8.0),
                                    iconSize: 13,
                                    color: FlutterFlowTheme.of(context).primary,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmallFamily,
                                          color: Colors.white,
                                          fontSize: 15.0,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmallFamily),
                                        ),
                                    elevation: 3.0,
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                    hoverBorderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      width: 1.0,
                                    ),
                                    hoverElevation: 5.0,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await _model.pageViewController?.nextPage(
                                        duration: Duration(milliseconds: 100),
                                        curve: Curves.linear);
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        color: _model.quesTitleNumber ==
                                                widget.numberOfQuestions - 1
                                            ? FlutterFlowTheme.of(context).secondaryBackground
                                            : FlutterFlowTheme.of(context)
                                                .primary,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        border: Border.all(
                                          width:1,
                                          color: _model.quesTitleNumber ==
                                                  widget.numberOfQuestions - 1
                                              ?Color(0xff858585)
                                              : FlutterFlowTheme.of(context)
                                                  .primary,
                                        ),
                                      ),
                                      child: Icon(FontAwesomeIcons.angleRight,
                                          color: _model.quesTitleNumber ==
                                                  widget.numberOfQuestions - 1
                                              ? Color(0xff858585)
                                              : Colors.white)),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await showJumpToFlashcardSheet();
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(12.0),
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).tertiaryBackground,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        border: Border.all(
                                          color:  FlutterFlowTheme.of(context).secondaryBorderColor,
                                        ),
                                      ),
                                      child: SvgPicture.asset(
                                          "assets/images/book.svg",
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText)),
                                ),
                              ]),
                        ),
                      )
                    ],
                  ),
                )
              ]),
            ),
          );
        });
      },
    );
  }

  Future<void> showAlertDialogBox(
      String htmlString, String title, context) async {
    htmlString = htmlString + questionStr;
    await showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.2),
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5)),
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    child: SingleChildScrollView(
                      child: Column(mainAxisSize: MainAxisSize.max, children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(title,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                          fontSize: 16,
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .headlineLargeFamily)),
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
                              )
                            ]),
                        kIsWeb|| Platform.isIOS?HtmlQuestionWidget(questionHtmlStr: htmlString):Container(height:200, child: AndroidWebView(html: htmlString))
                      ]),
                    ),
                  ),
                ),
              ));
        });
  }

  Future<void> showJumpToFlashcardSheet() async {
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
        return Container(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 20),
            height: MediaQuery.of(context).size.height * 0.55,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Jump To Flashcard",
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
                  Text("Enter Flashcard number on which you want to jump",
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
                                  final quetionList = functions
                                          .testQueTempList(
                                              widget.numberOfQuestions)
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
                                            color: FlutterFlowTheme.of(context)
                                                .tertiaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                              color: _model.quesTitleNumber ==
                                                      quetionListIndex
                                                  ? FlutterFlowTheme.of(context)
                                                      .primary
                                                  : Color(0xFFD9D9D9),
                                              width: 1.5,
                                            ),
                                          ),
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 6.0, 0, 6.0),
                                            child: AutoSizeText(
                                              'FC-${(quetionListIndex + 1).toString()}',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
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
      },
    ).then((value) => setState(() => _model.selectedPageNumber = value));
    if (_model.selectedPageNumber != null)
      await _model.pageViewController?.animateToPage(
        _model.selectedPageNumber!,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
  }
}
