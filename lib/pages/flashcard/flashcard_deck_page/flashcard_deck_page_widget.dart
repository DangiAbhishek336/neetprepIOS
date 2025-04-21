
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neetprep_essential/components/html_question/html_question_widget.dart';
import 'package:neetprep_essential/custom_code/widgets/android_web_view.dart';
import 'package:neetprep_essential/pages/flashcard/flashcard_limit_popup/flashcard_limit_popup_widget.dart';
import 'package:neetprep_essential/providers/commonProvider.dart';
import 'package:provider/provider.dart';
import '../../../clevertap/clevertap_service.dart';
import '../../../flutter_flow/custom_functions.dart';
import '../../../flutter_flow/flutter_flow_icon_button.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '/backend/api_requests/api_calls.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:io' show Platform;
import 'flashcard_deck_page_model.dart';
import 'flashcard_deck_page_provider.dart';

export 'flashcard_deck_page_model.dart';

class FlashcardDeckPageWidget extends StatefulWidget {
  const FlashcardDeckPageWidget({
    Key? key,
    this.deckId,
  }) : super(key: key);

  final String? deckId;

  @override
  _FlashcardDeckPageWidgetState createState() =>
      _FlashcardDeckPageWidgetState();
}

class _FlashcardDeckPageWidgetState extends State<FlashcardDeckPageWidget>
    with TickerProviderStateMixin {
  bool justopened = true;
  bool isSecondTabClicked = false;
  String questionStr = "<span class=\"display_webview\"></span>";
  late TabController tabController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = {
    'imageOnActionTriggerAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onActionTrigger,
      applyInitialState: false,
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
    'imageOnActionTriggerAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onActionTrigger,
      applyInitialState: false,
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
  final formKey = GlobalKey<FormState>();

  late FlashcardDeckPageModel _model;

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance
        .setCurrentScreen(screenName: "FlashcardDeckPage");
    CleverTapService.recordPageView("Flashcard Deck Page Opened");
    _model = createModel(context, () => FlashcardDeckPageModel());
    justopened = true;
    tabController = TabController(length: 2, vsync: this);
    _model.isLoading = false;
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    print(widget.deckId);
    return FutureBuilder<ApiCallResponse>(
      future:
          FlashcardGroup.getDeckDetailsByDeckIdCall.call(deckId: widget.deckId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
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
        final flashcardDeckPageGetDeckDetailsByDeckIdResponse = snapshot.data!;
        return Title(
            title: 'FlashcardDeckPage',
            color: FlutterFlowTheme.of(context).primaryBackground,
            child: Consumer<CommonProvider>(
              builder: (context,commonProvider,child) {
                return Scaffold(
                    backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                    key: scaffoldKey,
                    floatingActionButton: !FFAppState().isScreenshotCaptureDisabled && !commonProvider.isFeedbackSubmitted  ?
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
                      backgroundColor:FlutterFlowTheme.of(context).secondaryBackground,
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
                                    setState(() {
                                      FFAppState().pageNumber = 0;
                                    });

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
                                    getJsonField(
                                      flashcardDeckPageGetDeckDetailsByDeckIdResponse
                                          .jsonBody,
                                      r'''$.data.deck.name''',
                                    ).toString().maybeHandleOverflow(
                                          maxChars: 25,
                                          replacement: '…',
                                        ),
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .override(
                                          fontFamily: FlutterFlowTheme.of(context)
                                              .headlineMediumFamily,
                                          color: FlutterFlowTheme.of(context).primaryText,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.normal,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
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
                        child: Container(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          child: DefaultTabController(
                            length: 2,
                            initialIndex: 0,
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment(0.0, 0),
                                  child: TabBar(
                                    onTap: (selectedIndex) async {
                                      if (selectedIndex == 1) {
                                        setState(() {
                                          _model.isLoading = true;
                                          justopened = true;
                                        });
                                        await _model.reloadQuestionsStatus(
                                          context,
                                          deckId: widget.deckId,
                                        );
                                        Provider.of<FlashcardDeckProvider>(context,
                                                listen: false)
                                            .updateIndex(0);
                                        setState(() {
                                          _model.isLoading = false;
                                        });
                                        await Future.delayed(Duration(seconds: 50));
                                      }
                                    },
                                    controller: tabController,
                                    labelColor:
                                        FlutterFlowTheme.of(context).primary,
                                    unselectedLabelColor:
                                        FlutterFlowTheme.of(context).secondaryText,
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          fontFamily: FlutterFlowTheme.of(context)
                                              .titleMediumFamily,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.normal,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .titleMediumFamily),
                                        ),
                                    indicatorColor:
                                        FlutterFlowTheme.of(context).primary,
                                    tabs: [
                                      Tab(
                                        text: 'Flashcards',
                                      ),
                                      Tab(
                                        text: 'Bookmarks',
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: TabBarView(
                                    controller: tabController,
                                    physics: const NeverScrollableScrollPhysics(),
                                    children: [
                                      KeepAliveWidgetWrapper(
                                        builder: (context) => Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              0.0, 20.0, 0.0, 0.0),
                                          child: FutureBuilder<ApiCallResponse>(
                                            future: SignupGroup
                                                .loggedInUserInformationAndCourseAccessCheckingApiCall
                                                .call(
                                              authToken: FFAppState().subjectToken,
                                              courseIdInt:
                                                  FFAppState().flashcardCourseIdInt,
                                              altCourseIds: FFAppState()
                                                  .flashcardCourseIdInts,
                                            ),
                                            builder: (context, snapshot) {
                                              // Customize what your widget looks like when it's loading.
                                              if (!snapshot.hasData) {
                                                return Center(
                                                  child: SizedBox(
                                                    width: 50.0,
                                                    height: 50.0,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: FlutterFlowTheme.of(
                                                              context)
                                                          .primary,
                                                    ),
                                                  ),
                                                );
                                              }
                                              final containerLoggedInUserInformationAndCourseAccessCheckingApiResponse =
                                                  snapshot.data!;
                                              return Container(
                                                width: double.infinity,
                                                height: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(context).primaryBackground,
                                                ),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      16.0,
                                                                      0.0,
                                                                      9.0,
                                                                      0.0),
                                                          child: Container(
                                                            height: 36.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(8),
                                                              color:
                                                                  Color(0xFFF5F5F5),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          14.0,
                                                                          6.0,
                                                                          14.0,
                                                                          6.0),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    'Flashcards: ',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context)
                                                                                  .bodyMediumFamily,
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .normal,
                                                                          useGoogleFonts: GoogleFonts
                                                                                  .asMap()
                                                                              .containsKey(
                                                                                  FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                        ),
                                                                  ),
                                                                  Text(
                                                                    '${getJsonField(
                                                                      flashcardDeckPageGetDeckDetailsByDeckIdResponse
                                                                          .jsonBody,
                                                                      r'''$.data.deck.numCards''',
                                                                    ).toString()}',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context)
                                                                                  .bodyMediumFamily,
                                                                          color:  Colors.black,
                                                                          useGoogleFonts: GoogleFonts
                                                                                  .asMap()
                                                                              .containsKey(
                                                                                  FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        if (valueOrDefault<bool>(
                                                          getJsonField(
                                                                flashcardDeckPageGetDeckDetailsByDeckIdResponse
                                                                    .jsonBody,
                                                                r'''$.data.deck.sections''',
                                                              ) !=
                                                              null,
                                                          false,
                                                        ))
                                                          InkWell(
                                                            splashColor:
                                                                Colors.transparent,
                                                            focusColor:
                                                                Colors.transparent,
                                                            hoverColor:
                                                                Colors.transparent,
                                                            highlightColor:
                                                                Colors.transparent,
                                                            onTap: () async {
                                                              // context.pushNamed(
                                                              //     'OrderPage');
                                                            },
                                                            child: Container(
                                                              height: 36.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                color: Color(
                                                                    0xFFF5F5F5),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            14.0,
                                                                            6.0,
                                                                            14.0,
                                                                            6.0),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Text(
                                                                      'Topics: ',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                        color:Colors.black,
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                            fontWeight:
                                                                                FontWeight.normal,
                                                                            useGoogleFonts:
                                                                                GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                          ),
                                                                    ),
                                                                    Text(
                                                                      ((List<String>?
                                                                              var1) {
                                                                        return var1 ==
                                                                                null
                                                                            ? 1
                                                                            : var1
                                                                                .length;
                                                                      }((getJsonField(
                                                                        flashcardDeckPageGetDeckDetailsByDeckIdResponse
                                                                            .jsonBody,
                                                                        r'''$.data.deck.sections''',
                                                                      ) as List)
                                                                              .map<String>((s) => s.toString())
                                                                              .toList()))
                                                                          .toString(),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium.override(
                                                                        color: Colors.black,
                                                                        fontFamily:
                                                                        FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        fontWeight:
                                                                        FontWeight.w500,
                                                                        useGoogleFonts:
                                                                        GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsetsDirectional
                                                          .fromSTEB(15.0, 12.0,
                                                              16.0, 12.0),
                                                      child: InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          var _shouldSetState =
                                                              false;
                                                          if ((getJsonField(
                                                                    containerLoggedInUserInformationAndCourseAccessCheckingApiResponse
                                                                        .jsonBody,
                                                                    r'''$.data.me.userCourses.edges''',
                                                                  ) !=
                                                                  null) &&
                                                              (SignupGroup
                                                                      .loggedInUserInformationAndCourseAccessCheckingApiCall
                                                                      .courses(
                                                                        containerLoggedInUserInformationAndCourseAccessCheckingApiResponse
                                                                            .jsonBody,
                                                                      )
                                                                      .length !=
                                                                  0)) {
                                                            _model.offSetN1 =
                                                                await actions
                                                                    .getOffset(
                                                              getJsonField(
                                                                flashcardDeckPageGetDeckDetailsByDeckIdResponse
                                                                    .jsonBody,
                                                                r'''$.data.deck.sectionNumQues''',
                                                              )!,
                                                              0,
                                                            );
                                                            _shouldSetState = true;

                                                            if (FFAppState()
                                                                    .showRatingPrompt !=
                                                                -1) {
                                                              FFAppState()
                                                                  .showRatingPrompt++;
                                                            }

                                                            context.pushNamed(
                                                              'FlashcardPage',
                                                              queryParameters: {
                                                                'deckName':
                                                                    getJsonField(
                                                                  flashcardDeckPageGetDeckDetailsByDeckIdResponse
                                                                      .jsonBody,
                                                                  r'''$.data.deck.name''',
                                                                ).toString(),
                                                                'deckId':
                                                                    serializeParam(
                                                                  widget.deckId,
                                                                  ParamType.String,
                                                                ),
                                                                'offset':
                                                                    serializeParam(
                                                                  0,
                                                                  ParamType.int,
                                                                ),
                                                                'numberOfQuestions':
                                                                    serializeParam(
                                                                  getJsonField(
                                                                    flashcardDeckPageGetDeckDetailsByDeckIdResponse
                                                                        .jsonBody,
                                                                    r'''$.data.deck.numCards''',
                                                                  ),
                                                                  ParamType.int,
                                                                ),
                                                                'sectionPointer':
                                                                    serializeParam(
                                                                  0,
                                                                  ParamType.int,
                                                                ),
                                                              }.withoutNulls,
                                                              extra: <String,
                                                                  dynamic>{
                                                                kTransitionInfoKey:
                                                                    TransitionInfo(
                                                                  hasTransition:
                                                                      true,
                                                                  transitionType:
                                                                      PageTransitionType
                                                                          .rightToLeft,
                                                                ),
                                                              },
                                                            );

                                                            if (_shouldSetState)
                                                              setState(() {});
                                                            return;
                                                          } else {
                                                            if (true) {
                                                              await showModalBottomSheet(
                                                                isScrollControlled:
                                                                    true,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                context: context,
                                                                builder: (context) {
                                                                  return GestureDetector(
                                                                    onTap: () => FocusScope.of(
                                                                            context)
                                                                        .requestFocus(
                                                                            _model
                                                                                .unfocusNode),
                                                                    child: Padding(
                                                                        padding: MediaQuery.of(
                                                                                context)
                                                                            .viewInsets,
                                                                        child:
                                                                            FlashcardLimitPopupWidget()),
                                                                  );
                                                                },
                                                              ).then((value) =>
                                                                  setState(() {}));
                                                            } else {
                                                              _model.offSetN =
                                                                  await actions
                                                                      .getOffset(
                                                                getJsonField(
                                                                  flashcardDeckPageGetDeckDetailsByDeckIdResponse
                                                                      .jsonBody,
                                                                  r'''$.data.deck.sectionNumQues''',
                                                                )!,
                                                                0,
                                                              );
                                                              _shouldSetState =
                                                                  true;

                                                              context.pushNamed(
                                                                'PracticeQuetionsPage',
                                                                queryParameters: {
                                                                  'testId':
                                                                      serializeParam(
                                                                    widget.deckId,
                                                                    ParamType
                                                                        .String,
                                                                  ),
                                                                  'offset':
                                                                      serializeParam(
                                                                    0,
                                                                    ParamType.int,
                                                                  ),
                                                                  'numberOfQuestions':
                                                                      serializeParam(
                                                                    getJsonField(
                                                                      flashcardDeckPageGetDeckDetailsByDeckIdResponse
                                                                          .jsonBody,
                                                                      r'''$.data.deck.numCards''',
                                                                    ),
                                                                    ParamType.int,
                                                                  ),
                                                                  'sectionPointer':
                                                                      serializeParam(
                                                                    1,
                                                                    ParamType.int,
                                                                  ),
                                                                }.withoutNulls,
                                                                extra: <String,
                                                                    dynamic>{
                                                                  kTransitionInfoKey:
                                                                      TransitionInfo(
                                                                    hasTransition:
                                                                        true,
                                                                    transitionType:
                                                                        PageTransitionType
                                                                            .rightToLeft,
                                                                  ),
                                                                },
                                                              );

                                                              if (_shouldSetState)
                                                                setState(() {});
                                                              return;
                                                            }
                                                          }

                                                          if (_shouldSetState)
                                                            setState(() {});
                                                        },
                                                        child: Material(
                                                          color: Colors.transparent,
                                                          elevation: 2.0,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(16.0),
                                                          ),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  blurRadius: 60.0,
                                                                  color: Color(
                                                                      0x04060F0D),
                                                                  offset: Offset(
                                                                      0.0, 4.0),
                                                                )
                                                              ],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16.0),
                                                            ),
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize.max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Expanded(
                                                                  child: Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            16.0,
                                                                            20.0,
                                                                            15.0,
                                                                            20.0),
                                                                    child: Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          getJsonField(
                                                                            flashcardDeckPageGetDeckDetailsByDeckIdResponse
                                                                                .jsonBody,
                                                                            r'''$.data.deck.name''',
                                                                          )
                                                                              .toString()
                                                                              .maybeHandleOverflow(
                                                                                maxChars:
                                                                                    27,
                                                                                replacement:
                                                                                    '…',
                                                                              ),
                                                                          style: FlutterFlowTheme.of(
                                                                                  context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily:
                                                                                    FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                fontSize:
                                                                                    16.0,
                                                                                useGoogleFonts:
                                                                                    GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                              ),
                                                                        ),
                                                                        Text(
                                                                          '${'${getJsonField(
                                                                            flashcardDeckPageGetDeckDetailsByDeckIdResponse
                                                                                .jsonBody,
                                                                            r'''$.data.deck.numCards''',
                                                                          ).toString()}'} Flashcards',
                                                                          style: FlutterFlowTheme.of(
                                                                                  context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily:
                                                                                    FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                color:
                                                                                    Color(0xFF858585),
                                                                                fontSize:
                                                                                    14.0,
                                                                                fontWeight:
                                                                                    FontWeight.normal,
                                                                                useGoogleFonts:
                                                                                    GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                              ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                if (SignupGroup
                                                                        .loggedInUserInformationAndCourseAccessCheckingApiCall
                                                                        .courses(
                                                                          containerLoggedInUserInformationAndCourseAccessCheckingApiResponse
                                                                              .jsonBody,
                                                                        )
                                                                        .length >
                                                                    0)
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            16.0,
                                                                            0.0,
                                                                            20.0,
                                                                            0.0),
                                                                    child:
                                                                        Image.asset(
                                                                      'assets/images/arrow-right.png',
                                                                      width: 24.0,
                                                                      height: 24.0,
                                                                      fit: BoxFit.cover,
                                                                          color:FlutterFlowTheme.of(context).primaryText
                                                                    ),
                                                                  ),
                                                                if (SignupGroup
                                                                        .loggedInUserInformationAndCourseAccessCheckingApiCall
                                                                        .courses(
                                                                          containerLoggedInUserInformationAndCourseAccessCheckingApiResponse
                                                                              .jsonBody,
                                                                        )
                                                                        .length ==
                                                                    0)
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            16.0,
                                                                            0.0,
                                                                            20.0,
                                                                            0.0),
                                                                    child:
                                                                        Image.asset(
                                                                      'assets/images/lock.png',
                                                                      width: 24.0,
                                                                      height: 24.0,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                          color:FlutterFlowTheme.of(context).primaryText
                                                                    ).animateOnActionTrigger(
                                                                      animationsMap[
                                                                          'imageOnActionTriggerAnimation1']!,
                                                                    ),
                                                                  ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(0.0, 24.0,
                                                                    0.0, 0.0),
                                                        child: Container(
                                                          width: double.infinity,
                                                          height: 100.0,
                                                          decoration: BoxDecoration(
                                                            color: FlutterFlowTheme.of(context).primaryBackground
                                                          ),
                                                          child: Visibility(
                                                            visible: valueOrDefault<
                                                                bool>(
                                                              getJsonField(
                                                                    flashcardDeckPageGetDeckDetailsByDeckIdResponse
                                                                        .jsonBody,
                                                                    r'''$.data.deck.sections''',
                                                                  ) !=
                                                                  null,
                                                              false,
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          16.0,
                                                                          8.0,
                                                                          16.0,
                                                                          0.0),
                                                              child: Builder(
                                                                builder: (context) {
                                                                  final practiceTestSections =
                                                                      FlashcardGroup
                                                                              .getDeckDetailsByDeckIdCall
                                                                              .sections(
                                                                                flashcardDeckPageGetDeckDetailsByDeckIdResponse.jsonBody,
                                                                              )
                                                                              ?.toList() ??
                                                                          [];

                                                                  return ListView
                                                                      .builder(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    scrollDirection:
                                                                        Axis.vertical,
                                                                    itemCount:
                                                                        practiceTestSections
                                                                            .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            practiceTestSectionsIndex) {
                                                                      final practiceTestSectionsItem =
                                                                          practiceTestSections[
                                                                              practiceTestSectionsIndex];
                                                                      return Padding(
                                                                        padding: EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                                0.0,
                                                                                0.0,
                                                                                0.0,
                                                                                12.0),
                                                                        child:
                                                                            InkWell(
                                                                          splashColor:
                                                                              Colors
                                                                                  .transparent,
                                                                          focusColor:
                                                                              Colors
                                                                                  .transparent,
                                                                          hoverColor:
                                                                              Colors
                                                                                  .transparent,
                                                                          highlightColor:
                                                                              Colors
                                                                                  .transparent,
                                                                          onTap:
                                                                              () async {
                                                                            var _shouldSetState =
                                                                                false;
                                                                            if ((getJsonField(
                                                                                      containerLoggedInUserInformationAndCourseAccessCheckingApiResponse.jsonBody,
                                                                                      r'''$.data.me.userCourses.edges''',
                                                                                    ) !=
                                                                                    null) &&
                                                                                (SignupGroup.loggedInUserInformationAndCourseAccessCheckingApiCall
                                                                                        .courses(
                                                                                          containerLoggedInUserInformationAndCourseAccessCheckingApiResponse.jsonBody,
                                                                                        )
                                                                                        .length !=
                                                                                    0)) {
                                                                              _model.offSetN1Copy =
                                                                                  await actions.getOffset(
                                                                                getJsonField(
                                                                                  flashcardDeckPageGetDeckDetailsByDeckIdResponse.jsonBody,
                                                                                  r'''$.data.deck.sectionNumQues''',
                                                                                )!,
                                                                                practiceTestSectionsIndex,
                                                                              );
                                                                              _shouldSetState =
                                                                                  true;

                                                                              if (FFAppState().showRatingPrompt !=
                                                                                  -1) {
                                                                                FFAppState().showRatingPrompt++;
                                                                              }

                                                                              context
                                                                                  .pushNamed(
                                                                                'FlashcardPage',
                                                                                queryParameters:
                                                                                    {
                                                                                  'deckName': getJsonField(
                                                                                    flashcardDeckPageGetDeckDetailsByDeckIdResponse.jsonBody,
                                                                                    r'''$.data.deck.name''',
                                                                                  ).toString(),
                                                                                  'deckId': serializeParam(
                                                                                    widget.deckId,
                                                                                    ParamType.String,
                                                                                  ),
                                                                                  'offset': serializeParam(
                                                                                    _model.offSetN1Copy,
                                                                                    ParamType.int,
                                                                                  ),
                                                                                  'numberOfQuestions': serializeParam(
                                                                                    getJsonField(
                                                                                      flashcardDeckPageGetDeckDetailsByDeckIdResponse.jsonBody,
                                                                                      r'''$.data.deck.numCards''',
                                                                                    ),
                                                                                    ParamType.int,
                                                                                  ),
                                                                                  'sectionPointer': serializeParam(
                                                                                    practiceTestSectionsIndex,
                                                                                    ParamType.int,
                                                                                  ),
                                                                                }.withoutNulls,
                                                                                extra: <String,
                                                                                    dynamic>{
                                                                                  kTransitionInfoKey: TransitionInfo(
                                                                                    hasTransition: true,
                                                                                    transitionType: PageTransitionType.rightToLeft,
                                                                                  ),
                                                                                },
                                                                              );

                                                                              if (_shouldSetState)
                                                                                setState(() {});
                                                                              return;
                                                                            } else {
                                                                              if (true) {
                                                                                await showModalBottomSheet(
                                                                                  isScrollControlled: true,
                                                                                  backgroundColor: Colors.transparent,
                                                                                  context: context,
                                                                                  builder: (context) {
                                                                                    return GestureDetector(
                                                                                      onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
                                                                                      child: Padding(padding: MediaQuery.of(context).viewInsets, child: FlashcardLimitPopupWidget()),
                                                                                    );
                                                                                  },
                                                                                ).then((value) =>
                                                                                    setState(() {}));
                                                                              } else {
                                                                                if (animationsMap['imageOnActionTriggerAnimation2'] !=
                                                                                    null) {
                                                                                  animationsMap['imageOnActionTriggerAnimation2']!.controller.forward(from: 0.0);
                                                                                }
                                                                                _model.offSetNCopy =
                                                                                    await actions.getOffset(
                                                                                  getJsonField(
                                                                                    flashcardDeckPageGetDeckDetailsByDeckIdResponse.jsonBody,
                                                                                    r'''$.data.deck.sectionNumQues''',
                                                                                  )!,
                                                                                  practiceTestSectionsIndex,
                                                                                );
                                                                                _shouldSetState =
                                                                                    true;

                                                                                context.pushNamed(
                                                                                  'PracticeQuetionsPage',
                                                                                  queryParameters: {
                                                                                    'testId': serializeParam(
                                                                                      widget.deckId,
                                                                                      ParamType.String,
                                                                                    ),
                                                                                    'offset': serializeParam(
                                                                                      _model.offSetNCopy,
                                                                                      ParamType.int,
                                                                                    ),
                                                                                    'numberOfQuestions': serializeParam(
                                                                                      getJsonField(
                                                                                        flashcardDeckPageGetDeckDetailsByDeckIdResponse.jsonBody,
                                                                                        r'''$.data.deck.numCards''',
                                                                                      ),
                                                                                      ParamType.int,
                                                                                    ),
                                                                                    'sectionPointer': serializeParam(
                                                                                      practiceTestSectionsIndex,
                                                                                      ParamType.int,
                                                                                    ),
                                                                                  }.withoutNulls,
                                                                                  extra: <String, dynamic>{
                                                                                    kTransitionInfoKey: TransitionInfo(
                                                                                      hasTransition: true,
                                                                                      transitionType: PageTransitionType.rightToLeft,
                                                                                    ),
                                                                                  },
                                                                                );

                                                                                if (_shouldSetState)
                                                                                  setState(() {});
                                                                                return;
                                                                              }
                                                                            }

                                                                            if (_shouldSetState)
                                                                              setState(
                                                                                  () {});
                                                                          },
                                                                          child:
                                                                              Material(
                                                                            color: Colors
                                                                                .transparent,
                                                                            elevation:
                                                                                2.0,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(16.0),
                                                                            ),
                                                                            child:
                                                                                Container(
                                                                              width:
                                                                                  100.0,
                                                                              decoration:
                                                                                  BoxDecoration(
                                                                                color:
                                                                                   FlutterFlowTheme.of(context).secondaryBackground,
                                                                                boxShadow: [
                                                                                  BoxShadow(
                                                                                    blurRadius: 60.0,
                                                                                    color: Color(0x04060F0D),
                                                                                    offset: Offset(0.0, 4.0),
                                                                                  )
                                                                                ],
                                                                                borderRadius:
                                                                                    BorderRadius.circular(16.0),
                                                                              ),
                                                                              alignment: AlignmentDirectional(
                                                                                  0.0,
                                                                                  0.0),
                                                                              child:
                                                                                  Row(
                                                                                mainAxisSize:
                                                                                    MainAxisSize.max,
                                                                                mainAxisAlignment:
                                                                                    MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(16.0, 20.0, 15.0, 20.0),
                                                                                      child: Column(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Text(
                                                                                            getJsonField(
                                                                                              practiceTestSectionsItem,
                                                                                              r'''$[0]''',
                                                                                            ).toString().maybeHandleOverflow(
                                                                                                  maxChars: 27,
                                                                                                  replacement: '…',
                                                                                                ),
                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                  fontSize: 16.0,
                                                                                                  useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                                ),
                                                                                          ),
                                                                                          Text(
                                                                                            '${functions.numberOfQuestins(getJsonField(
                                                                                                  flashcardDeckPageGetDeckDetailsByDeckIdResponse.jsonBody,
                                                                                                  r'''$.data.deck.sectionNumQues''',
                                                                                                )!, practiceTestSectionsIndex).toString()} Flashcards',
                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                  color: Color(0xFF858585),
                                                                                                  fontSize: 14.0,
                                                                                                  fontWeight: FontWeight.normal,
                                                                                                  useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                                ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  if (SignupGroup.loggedInUserInformationAndCourseAccessCheckingApiCall
                                                                                          .courses(
                                                                                            containerLoggedInUserInformationAndCourseAccessCheckingApiResponse.jsonBody,
                                                                                          )
                                                                                          .length >
                                                                                      0)
                                                                                    Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 20.0, 0.0),
                                                                                      child: Image.asset(
                                                                                        'assets/images/arrow-right.png',
                                                                                        width: 24.0,
                                                                                        height: 24.0,
                                                                                        fit: BoxFit.cover,
                                                                                        color:FlutterFlowTheme.of(context).primaryText
                                                                                      ).animateOnActionTrigger(
                                                                                        animationsMap['imageOnActionTriggerAnimation2']!,
                                                                                      ),
                                                                                    ),
                                                                                  if (SignupGroup.loggedInUserInformationAndCourseAccessCheckingApiCall
                                                                                          .courses(
                                                                                            containerLoggedInUserInformationAndCourseAccessCheckingApiResponse.jsonBody,
                                                                                          )
                                                                                          .length ==
                                                                                      0)
                                                                                    Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 20.0, 0.0),
                                                                                      child: Image.asset(
                                                                                        'assets/images/lock.png',
                                                                                        width: 24.0,
                                                                                        height: 24.0,
                                                                                        fit: BoxFit.cover,
                                                                                          color:FlutterFlowTheme.of(context).primaryText
                                                                                      ),
                                                                                    ),
                                                                                ],
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
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme.of(
                                                                context)
                                                            .secondaryBackground,
                                                      ),
                                                      child: Visibility(
                                                        visible: SignupGroup
                                                                .loggedInUserInformationAndCourseAccessCheckingApiCall
                                                                .courses(
                                                                  containerLoggedInUserInformationAndCourseAccessCheckingApiResponse
                                                                      .jsonBody,
                                                                )
                                                                .length ==
                                                            0,
                                                        child: FutureBuilder<
                                                            ApiCallResponse>(
                                                          future: PaymentGroup
                                                              .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                                                              .call(
                                                            courseId: FFAppState()
                                                                .flashcardCourseId,
                                                          ),
                                                          builder:
                                                              (context, snapshot) {
                                                            // Customize what your widget looks like when it's loading.
                                                            if (!snapshot.hasData) {
                                                              return Center(
                                                                child:
                                                                    LinearProgressIndicator(
                                                                  color: FlutterFlowTheme
                                                                          .of(context)
                                                                      .primary,
                                                                ),
                                                              );
                                                            }
                                                            final containerGetCoursePriceAndCourseOffersToSelectFromToStartPaymentResponse =
                                                                snapshot.data!;
                                                            return Container(
                                                              width:
                                                                  double.infinity,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Color(
                                                                    0xFFB27A14),
                                                                image:
                                                                    DecorationImage(
                                                                  fit: BoxFit.cover,
                                                                  image:
                                                                      Image.asset(
                                                                    'assets/images/Header-Curves.png',
                                                                  ).image,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12.0),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            16.0,
                                                                            23.0,
                                                                            16.0,
                                                                            25.0),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                                0.0,
                                                                                0.0,
                                                                                10.0,
                                                                                0.0),
                                                                        child: Wrap(
                                                                          spacing:
                                                                              0.0,
                                                                          runSpacing:
                                                                              0.0,
                                                                          alignment:
                                                                              WrapAlignment
                                                                                  .start,
                                                                          crossAxisAlignment:
                                                                              WrapCrossAlignment
                                                                                  .start,
                                                                          direction:
                                                                              Axis.horizontal,
                                                                          runAlignment:
                                                                              WrapAlignment
                                                                                  .start,
                                                                          verticalDirection:
                                                                              VerticalDirection
                                                                                  .down,
                                                                          clipBehavior:
                                                                              Clip.none,
                                                                          children: [
                                                                            // Text(
                                                                            //   'Pay only ',
                                                                            //   style: FlutterFlowTheme.of(context)
                                                                            //       .bodyMedium
                                                                            //       .override(
                                                                            //         fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                            //         color: Colors.white,
                                                                            //         fontWeight: FontWeight.normal,
                                                                            //         useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                            //       ),
                                                                            // ),
                                                                            // Text(
                                                                            //   '₹ ${(String var1) {
                                                                            //     return var1.split('.').first;
                                                                            //   }((PaymentGroup.getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall.offerDiscountedFees(
                                                                            //     containerGetCoursePriceAndCourseOffersToSelectFromToStartPaymentResponse.jsonBody,
                                                                            //   ) as List).map<String>((s) => s.toString()).toList().first)}',
                                                                            //   style: FlutterFlowTheme.of(context)
                                                                            //       .bodyMedium
                                                                            //       .override(
                                                                            //         fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                            //         color: Colors.white,
                                                                            //         fontWeight: FontWeight.bold,
                                                                            //         useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                            //       ),
                                                                            // ),
                                                                            // Text(
                                                                            //   ' & ',
                                                                            //   style: FlutterFlowTheme.of(context)
                                                                            //       .bodyMedium
                                                                            //       .override(
                                                                            //         fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                            //         color: Colors.white,
                                                                            //         fontWeight: FontWeight.normal,
                                                                            //         useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                            //       ),
                                                                            // ),
                                                                            Text(
                                                                              'Get ',
                                                                              style: FlutterFlowTheme.of(context)
                                                                                  .bodyMedium
                                                                                  .override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.normal,
                                                                                    useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                  ),
                                                                            ),
                                                                            Text(
                                                                              'access ',
                                                                              style: FlutterFlowTheme.of(context)
                                                                                  .bodyMedium
                                                                                  .override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.normal,
                                                                                    useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                  ),
                                                                            ),
                                                                            Text(
                                                                              'to ',
                                                                              style: FlutterFlowTheme.of(context)
                                                                                  .bodyMedium
                                                                                  .override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.normal,
                                                                                    useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                  ),
                                                                            ),
                                                                            Text(
                                                                              'the ',
                                                                              style: FlutterFlowTheme.of(context)
                                                                                  .bodyMedium
                                                                                  .override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.normal,
                                                                                    useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                  ),
                                                                            ),
                                                                            Text(
                                                                              'chapters.',
                                                                              style: FlutterFlowTheme.of(context)
                                                                                  .bodyMedium
                                                                                  .override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.normal,
                                                                                    useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                  ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      splashColor:
                                                                          Colors
                                                                              .transparent,
                                                                      focusColor: Colors
                                                                          .transparent,
                                                                      hoverColor: Colors
                                                                          .transparent,
                                                                      highlightColor:
                                                                          Colors
                                                                              .transparent,
                                                                      onTap:
                                                                          () async {
                                                                        FirebaseAnalytics
                                                                            .instance
                                                                            .logEvent(
                                                                          name:
                                                                              'buy_now_button_click',
                                                                          parameters: {
                                                                            "courseId": FFAppState()
                                                                                .flashcardCourseIdInt
                                                                                .toString(),
                                                                          },
                                                                        );
                                                                        CleverTapService.recordEvent(
                                                                          'Buy Now Clicked',
                                                                          {"courseId":serializeParam(
                                                                            FFAppState().flashcardCourseIdInt,
                                                                            ParamType.String,
                                                                          )
                                                                          },
                                                                        );
                                                                        context
                                                                            .pushNamed(
                                                                          'OrderPage',
                                                                          queryParameters:
                                                                              {
                                                                            'courseId':
                                                                                serializeParam(
                                                                              FFAppState()
                                                                                  .courseId,
                                                                              ParamType
                                                                                  .String,
                                                                            ),
                                                                            'courseIdInt':
                                                                                serializeParam(
                                                                              FFAppState()
                                                                                  .courseIdInt
                                                                                  .toString(),
                                                                              ParamType
                                                                                  .String,
                                                                            ),
                                                                          }.withoutNulls,
                                                                        );
                                                                      },
                                                                      child:
                                                                          Material(
                                                                        color: Colors
                                                                            .transparent,
                                                                        elevation:
                                                                            2.0,
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(
                                                                                  10.0),
                                                                        ),
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color: FlutterFlowTheme.of(context)
                                                                                .secondaryBackground,
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                29.0,
                                                                                13.0,
                                                                                29.0,
                                                                                13.0),
                                                                            child:
                                                                                Text(
                                                                              'Buy Now',
                                                                              style: FlutterFlowTheme.of(context)
                                                                                  .bodyMedium
                                                                                  .override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                    color: Color(0xFFB27A14),
                                                                                    fontSize: 16.0,
                                                                                    useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      KeepAliveWidgetWrapper(
                                          builder: (context) => bookmarkedTab(context))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )));
              }
            ));
      },
    );
  }

  Widget bookmarkedTab(context) {
    return Consumer<FlashcardDeckProvider>(
      builder: (context,flashcardDeckProvider,_ ){
        return _model.isLoading
            ? Center(child: CircularProgressIndicator(color: Color(0xffE6A123)))
            :flashcardDeckProvider.myList.isEmpty && flashcardDeckProvider.myList.length==0
            ? Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.8,
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
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
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
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
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
                                                  fontFamily:
                                                      FlutterFlowTheme.of(context)
                                                          .bodyMediumFamily,
                                                  color: FlutterFlowTheme.of(context).primaryText,
                                                  fontSize: 18.0,
                                                  useGoogleFonts: GoogleFonts
                                                          .asMap()
                                                      .containsKey(
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumFamily),
                                                ),
                                          ),
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                0.0, 8.0, 0.0, 0.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: FlutterFlowTheme.of(context)
                                                    .primaryBackground,
                                              ),
                                              child: Text(
                                                'You\’ll see your Bookmarks in this section.',
                                                textAlign: TextAlign.center,
                                                style: FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumFamily,
                                                      color: Color(0xFFB9B9B9),
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
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(mainAxisSize: MainAxisSize.max, children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  child: PageView.builder(
                    controller: _model.pageViewController ??=
                        PageController(
                            initialPage: min(
                                0, flashcardDeckProvider.myList.length - 1)),
                    itemCount: flashcardDeckProvider.myList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder:
                        (BuildContext context, int quetionListIndex) {
                      flashcardDeckProvider.index = quetionListIndex;
                      return flashcardDeckProvider.myList.isNotEmpty && flashcardDeckProvider.myList.length==0 ?
                      Container():
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Stack(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    constraints: BoxConstraints(
                                      minWidth: double.infinity,
                                      minHeight: double.infinity,
                                      maxWidth: double.infinity,
                                      maxHeight: double.infinity,
                                    ),
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).primaryBackground,
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize:
                                        MainAxisSize.max,
                                        children: [
                                          Center(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  top: 35),
                                              height: MediaQuery.of(
                                                  context)
                                                  .size
                                                  .height *
                                                  0.6,
                                              width: MediaQuery.of(
                                                  context)
                                                  .size
                                                  .width *
                                                  0.85,
                                              child: FlipCard(
                                                controller: _model
                                                    .flipController,
                                                back: Card(
                                                  color: Colors
                                                      .transparent,
                                                  elevation: 5,
                                                  shape:
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        12.0),
                                                  ),
                                                  child: Container(
                                                    width: MediaQuery.of(
                                                        context)
                                                        .size
                                                        .width *
                                                        0.85,
                                                    decoration:
                                                    BoxDecoration(
                                                      color: FlutterFlowTheme.of(
                                                          context)
                                                          .secondaryBackground,
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          8.0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          blurRadius:
                                                          15.0,
                                                          color: Color
                                                              .fromARGB(
                                                              16,
                                                              0,
                                                              0,
                                                              0),
                                                          offset:
                                                          Offset(
                                                              0.0,
                                                              10.0),
                                                        )
                                                      ],
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      mainAxisSize:
                                                      MainAxisSize
                                                          .max,
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                              16,
                                                              16,
                                                              16,
                                                              8),
                                                          width: double
                                                              .infinity,
                                                          child: Row(
                                                            // mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Container(
                                                                decoration:
                                                                BoxDecoration(
                                                                  color:
                                                                  FlutterFlowTheme.of(context).tertiaryBackground,
                                                                  borderRadius:
                                                                  BorderRadius.circular(8.0),
                                                                  border:
                                                                  Border.all(
                                                                    color: FlutterFlowTheme.of(context).secondaryBorderColor,
                                                                    width: 1.0,
                                                                  ),
                                                                ),
                                                                child:
                                                                Padding(
                                                                  padding:
                                                                  EdgeInsetsDirectional.all(10.0),
                                                                  child:
                                                                  InkWell(
                                                                    splashColor: Colors.transparent,
                                                                    focusColor: Colors.transparent,
                                                                    hoverColor: Colors.transparent,
                                                                    highlightColor: Colors.transparent,
                                                                    onTap: () async {
                                                                      showAlertDialogBox(flashcardDeckProvider.myList[quetionListIndex]["contentWoQuetion"], "Answer", context);
                                                                    },
                                                                    child: SvgPicture.asset("assets/images/enlarge.svg",color:FlutterFlowTheme.of(context).primaryText),
                                                                  ),
                                                                ),
                                                              ),
                                                              Center(
                                                                child: Text(
                                                                    "Answer",
                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(fontSize: 16, fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily)),
                                                              ),
                                                              flashcardDeckProvider.myList.isNotEmpty &&
                                                                  flashcardDeckProvider.myList[quetionListIndex]['questionId'] == null
                                                                  ? SizedBox(width:0)
                                                                  : OutlinedButton(
                                                                style: ButtonStyle(
                                                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
                                                                  side: MaterialStateProperty.all(BorderSide(color: FlutterFlowTheme.of(context).primary, width: 1.0, style: BorderStyle.solid)),
                                                                ),
                                                                onPressed: () {
                                                                  String questionId = flashcardDeckProvider.myList[quetionListIndex]['questionId'].toString();
                                                                  context.pushNamed(
                                                                    'FlashcardQuestionPage',
                                                                    queryParameters: {
                                                                      'questionId': getBase64forQuestion(questionId),
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
                                                          child:
                                                          Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(
                                                                20,
                                                                8,
                                                                20,
                                                                18),
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(
                                                                    10),
                                                                border:
                                                                Border.all(color: FlutterFlowTheme.of(context).secondaryBorderColor,)),
                                                            child:
                                                            Center(
                                                              child:
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .all(
                                                                    5),
                                                                child:
                                                                HtmlQuestionWidget(
                                                                  key:
                                                                  Key('Key92a_${quetionListIndex}_of_${flashcardDeckProvider.myList.length}'),
                                                                  questionHtmlStr:
                                                                  flashcardDeckProvider.myList[quetionListIndex]['contentWoQuetion'],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                front: Card(
                                                  color: Colors
                                                      .transparent,
                                                  elevation: 2,
                                                  shape:
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        12.0),
                                                  ),
                                                  child: Container(
                                                    decoration:
                                                    BoxDecoration(
                                                      color: FlutterFlowTheme.of(
                                                          context)
                                                          .secondaryBackground,
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          8.0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          blurRadius:
                                                          15.0,
                                                          color: Color
                                                              .fromARGB(
                                                              16,
                                                              0,
                                                              0,
                                                              0),
                                                          offset:
                                                          Offset(
                                                              0.0,
                                                              10.0),
                                                        )
                                                      ],
                                                    ),
                                                    child:
                                                    SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(
                                                                16,
                                                                16,
                                                                16,
                                                                8),
                                                            width: double
                                                                .infinity,
                                                            child:
                                                            Row(
                                                              // mainAxisSize: MainAxisSize.min,
                                                              mainAxisAlignment:
                                                              MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Container(
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    color: FlutterFlowTheme.of(context).tertiaryBackground,
                                                                    borderRadius: BorderRadius.circular(8.0),
                                                                    border: Border.all(
                                                                      color: FlutterFlowTheme.of(context).secondaryBorderColor,
                                                                      width: 1.0,
                                                                    ),
                                                                  ),
                                                                  child:
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional.all(10.0),
                                                                    child: InkWell(
                                                                      splashColor: Colors.transparent,
                                                                      focusColor: Colors.transparent,
                                                                      hoverColor: Colors.transparent,
                                                                      highlightColor: Colors.transparent,
                                                                      onTap: () async {
                                                                        showAlertDialogBox(flashcardDeckProvider.myList[quetionListIndex]['title'], "Question", context);
                                                                      },
                                                                      child: SvgPicture.asset("assets/images/enlarge.svg",color:FlutterFlowTheme.of(context).primaryText),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Center(
                                                                  child:
                                                                  Text("FC-" + (quetionListIndex + 1).toString(), style: FlutterFlowTheme.of(context).bodyMedium.override(fontSize: 16, fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily)),
                                                                ),
                                                                Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                                                          padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
                                                                          child: InkWell(
                                                                            splashColor: Colors.transparent,
                                                                            focusColor: Colors.transparent,
                                                                            hoverColor: Colors.transparent,
                                                                            highlightColor: Colors.transparent,
                                                                            onTap: () async {
                                                                              String cardId = flashcardDeckProvider.myList[quetionListIndex]['id'];
                                                                              await _model.getQuestionIssueList();
                                                                              String cardIdInt = _model.base64DecodeString(cardId);
                                                                              _model.showIssueTypeBottomSheet(context, widget.deckId, cardIdInt);
                                                                            },
                                                                            child: SvgPicture.asset("assets/images/alert.svg",color:FlutterFlowTheme.of(context).primaryText,),
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
                                                                                  color: FlutterFlowTheme.of(context).secondaryBorderColor,
                                                                                  width: 1.0,
                                                                                ),
                                                                              ),
                                                                              child: Visibility(
                                                                                visible: getJsonField(
                                                                                  FFAppState().allFlashcardBookmarkedQuestionsStatus[quetionListIndex],
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
                                                                                      await FlashcardGroup.createOrDeleteBookmarkForAFlashcardByAUserCall.call(
                                                                                        cardId: flashcardDeckProvider.myList[quetionListIndex]['id'],
                                                                                        userId: functions.getBase64OfUserId(FFAppState().userIdInt),
                                                                                        authToken: FFAppState().subjectToken,
                                                                                      );
                                                                                      flashcardDeckProvider.index = quetionListIndex;
                                                                                      flashcardDeckProvider.deleteItem(quetionListIndex);
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
                                                                                  FFAppState().allFlashcardBookmarkedQuestionsStatus[quetionListIndex],
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
                                                                                        FFAppState().allFlashcardBookmarkedQuestionsStatus = functions.getUpdatedBookmarkForFlashcard(FFAppState().allFlashcardBookmarkedQuestionsStatus.toList(), FFAppState().bookMarkEmptyJson, quetionListIndex).toList().cast<dynamic>();
                                                                                      });
                                                                                      var response = await FlashcardGroup.createOrDeleteBookmarkForAFlashcardByAUserCall.call(
                                                                                        cardId: flashcardDeckProvider.myList[quetionListIndex]['id'],
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
                                                            padding:
                                                            const EdgeInsets
                                                                .all(
                                                                5),
                                                            child: HtmlQuestionWidget(
                                                                key: Key(
                                                                    'Key92a_${quetionListIndex}_of_${flashcardDeckProvider.myList.length}'),
                                                                questionHtmlStr:
                                                                flashcardDeckProvider.myList[quetionListIndex]['title']),
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
                            ),
                          ],
                        ),
                      );

                    },
                    onPageChanged: (_) async {
                      flashcardDeckProvider.updateIndex(
                          _model.pageViewController!.page!.round() ??
                              0);
                    },
                  ),
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
                                  padding: EdgeInsets.fromLTRB(
                                      16.0, 8.0, 16.0, 8.0),
                                  child: Text(
                                      (flashcardDeckProvider.index + 1)
                                          .toString() +
                                          "/" +
                                          flashcardDeckProvider.myList.length
                                              .toString(),
                                      style:
                                      FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                        fontSize: 14,
                                        fontFamily:
                                        FlutterFlowTheme.of(
                                            context)
                                            .bodyMediumFamily,
                                        color:
                                        Color(0xff858585),
                                      )))),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.zero,
                        child: Container(
                          color:FlutterFlowTheme.of(context).secondaryBackground,
                          padding: EdgeInsets.fromLTRB(
                              16.0, 16.0, 16.0, 16.0),
                          child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    await _model.pageViewController
                                        ?.animateToPage(
                                      0,
                                      duration:
                                      Duration(milliseconds: 100),
                                      curve: Curves.ease,
                                    );
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(12.0),
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).tertiaryBackground,
                                        borderRadius:
                                        BorderRadius.all(
                                            Radius.circular(8.0)),
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context).secondaryBorderColor,
                                        ),
                                      ),
                                      child: SvgPicture.asset(
                                          "assets/images/restart_icon.svg",color:FlutterFlowTheme.of(context).primaryText)),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await _model.pageViewController
                                        ?.previousPage(
                                        duration: Duration(
                                            milliseconds: 100),
                                        curve: Curves.linear);
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        color:
                                        flashcardDeckProvider
                                            .index==0
                                            ? FlutterFlowTheme.of(context).secondaryBackground
                                            : FlutterFlowTheme.of(
                                            context)
                                            .primary,
                                        borderRadius:
                                        BorderRadius.all(
                                            Radius.circular(8.0)),
                                        border: Border.all(
                                          width: 1,
                                          color: flashcardDeckProvider
                                              .index ==
                                              0
                                              ? Color(0xff858585)
                                              : FlutterFlowTheme.of(
                                              context)
                                              .primary,
                                        ),
                                      ),
                                      child: Icon(
                                          FontAwesomeIcons.angleLeft,
                                          color:
                                          flashcardDeckProvider.index ==
                                              0
                                              ?Color(0xff858585)
                                              : Colors.white)),
                                ),
                                FFButtonWidget(
                                  onPressed: () async {
                                    await _model.flipController
                                        .toggleCard();
                                  },
                                  text: 'Show Answer',
                                  options: FFButtonOptions(
                                    padding: EdgeInsetsDirectional
                                        .fromSTEB(
                                        16.0, 12.0, 16.0, 12.0),
                                    iconPadding: EdgeInsetsDirectional
                                        .fromSTEB(
                                        16.0, 8.0, 16.0, 8.0),
                                    iconSize: 13,
                                    color:
                                    FlutterFlowTheme.of(context)
                                        .primary,
                                    textStyle:
                                    FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                      fontFamily:
                                      FlutterFlowTheme.of(
                                          context)
                                          .titleSmallFamily,
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      useGoogleFonts: GoogleFonts
                                          .asMap()
                                          .containsKey(
                                          FlutterFlowTheme.of(
                                              context)
                                              .titleSmallFamily),
                                    ),
                                    elevation: 3.0,
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 1.0,
                                    ),
                                    borderRadius:
                                    BorderRadius.circular(8.0),
                                    hoverBorderSide: BorderSide(
                                      color:
                                      FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      width: 1.0,
                                    ),
                                    hoverElevation: 5.0,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await _model.pageViewController
                                        ?.nextPage(
                                        duration: Duration(
                                            milliseconds: 100),
                                        curve: Curves.linear);
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        color: flashcardDeckProvider.index ==
                                            flashcardDeckProvider.myList
                                                .length -
                                                1
                                            ? FlutterFlowTheme.of(context).secondaryBackground
                                            : FlutterFlowTheme.of(
                                            context)
                                            .primary,
                                        borderRadius:
                                        BorderRadius.all(
                                            Radius.circular(8.0)),
                                        border: Border.all(
                                          width: 1,
                                          color: flashcardDeckProvider
                                              .index ==
                                              flashcardDeckProvider
                                                  .myList
                                                  .length -
                                                  1
                                              ? Color(0xff858585)
                                              : FlutterFlowTheme.of(
                                              context)
                                              .primary,
                                        ),
                                      ),
                                      child: Icon(
                                          FontAwesomeIcons.angleRight,
                                          color: flashcardDeckProvider
                                              .index ==
                                              flashcardDeckProvider
                                                  .myList
                                                  .length -
                                                  1
                                              ? Color(0xff858585)
                                              : Colors.white)),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await showJumpToFlashcardSheet(
                                        flashcardDeckProvider.myList.length);
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(12.0),
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).tertiaryBackground,
                                        borderRadius:
                                        BorderRadius.all(
                                            Radius.circular(8.0)),
                                        border: Border.all(
                                          color:FlutterFlowTheme.of(context).secondaryBorderColor,
                                        ),
                                      ),
                                      child: SvgPicture.asset(
                                          "assets/images/book.svg",color:FlutterFlowTheme.of(context).primaryText)),
                                ),
                              ]),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ]);
      }
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
                        kIsWeb||Platform.isIOS? HtmlQuestionWidget(questionHtmlStr: htmlString):Container(
                          height:200,
                          child:AndroidWebView(
                            html:htmlString ,
                          )
                        )
                      ]),
                    ),
                  ),
                ),
              ));
        });
  }

  Future<void> showJumpToFlashcardSheet(numBookmarkedCards) async {
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
        return Consumer<FlashcardDeckProvider>(
          builder: (context,flashcardDeckProvider,_) {
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
                                      final quetionList = flashcardDeckProvider.myList ??
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
                                                  color: flashcardDeckProvider.index ==
                                                          quetionListIndex
                                                      ? FlutterFlowTheme.of(context)
                                                          .primary
                                                      :  Color(0xFFD9D9D9),
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
                                                            color: Color(0xffb9b9b9),
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
          }
        );
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
