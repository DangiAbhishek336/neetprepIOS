import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:neetprep_essential/clevertap/clevertap_service.dart';
import 'package:neetprep_essential/components/drawer/darwer_widget.dart';
import 'package:provider/provider.dart';
import '../../../flutter_flow/flutter_flow_icon_button.dart';
import '../../../utlis/text.dart';
import '../test_limit_popup/test_limit_popup_widget.dart';
import '/backend/api_requests/api_calls.dart';
import '/components/no_data_component/no_data_component_widget.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'create_and_preview_test_page_model.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
export 'create_and_preview_test_page_model.dart';

class CreateAndPreviewTestPageWidget extends StatefulWidget {
  const CreateAndPreviewTestPageWidget({Key? key}) : super(key: key);

  @override
  _CreateAndPreviewTestPageWidgetState createState() =>
      _CreateAndPreviewTestPageWidgetState();
}

class _CreateAndPreviewTestPageWidgetState
    extends State<CreateAndPreviewTestPageWidget>
    with TickerProviderStateMixin {
  late CreateAndPreviewTestPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = {
    'containerOnPageLoadAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(-400.0, 0.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
    'containerOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(400.0, 0.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
    'containerOnPageLoadAnimation3': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(-400.0, 0.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
    'containerOnPageLoadAnimation4': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(400.0, 0.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
  };

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "CreateAndPreviewTestPage",);
    CleverTapService.recordPageView("Create And Preview Test Page Opened");
    _model = createModel(context, () => CreateAndPreviewTestPageModel());
    FFAppState().isCreatedTest = false;
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

    return FutureBuilder<ApiCallResponse>(
      future: SignupGroup
          .loggedInUserInformationAndCourseAccessCheckingApiCall
          .call(
        authToken: FFAppState().subjectToken,
        courseIdInt: FFAppState().testCourseIdInt,
        altCourseIds: FFAppState().testCourseIdInts,
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
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
        final createAndPreviewTestPageLoggedInUserInformationAndCourseAccessCheckingApiResponse =
            snapshot.data!;
        return Title(
            title: 'CreateAndPreviewTestPage',
            color: FlutterFlowTheme.of(context).primaryBackground,
            child: WillPopScope(
              onWillPop: () async {
                context.goNamed('PracticeChapterWisePage');
                return false;
              },
              child: Scaffold(
                key: scaffoldKey,
                backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                drawer: DrawerWidget(DrawerStrings.testCourse),
                appBar: AppBar(
                  iconTheme: IconThemeData(color: FlutterFlowTheme.of(context).accent1),
                  elevation: 1.2,
                  backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                  title: Text('All India Test Series',
                      style:FlutterFlowTheme.of(
                          context)
                          .bodyMedium
                          .override(
                        fontFamily:
                        FlutterFlowTheme.of(context).bodyMediumFamily,
                        fontSize:
                        16.0,
                        useGoogleFonts:
                        GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                  ),),
                ),
                body:SafeArea(
                  top: true,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment:MainAxisAlignment.start,
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                     if (
                       createAndPreviewTestPageLoggedInUserInformationAndCourseAccessCheckingApiResponse.jsonBody!=null &&
                        SignupGroup.loggedInUserInformationAndCourseAccessCheckingApiCall.courses(
                          createAndPreviewTestPageLoggedInUserInformationAndCourseAccessCheckingApiResponse.jsonBody
                        ).length > 0
                        )
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: 100.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primaryBackground,
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              child: FutureBuilder<ApiCallResponse>(
                                future: TestGroup
                                    .listOfCustomCreatedTestsByTheUserOrderedByDateOfCreationDescendingCall
                                    .call(
                                  authToken: FFAppState().subjectToken,
                                  first: 1,
                                  offset: 0,
                                ),
                                builder: (context, snapshot) {
                                  // Customize what your widget looks like when it's loading.
                                  if (!snapshot.hasData) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color:FlutterFlowTheme.of(context).primaryBackground
                                      ),
                                      child: Center(
                                        child: SizedBox(
                                          width: 50.0,
                                          height: 50.0,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  final columnListOfCustomCreatedTestsByTheUserOrderedByDateOfCreationDescendingResponse =
                                  snapshot.data!;
                                  return Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      if (FFAppState().isCreatedTest &&
                                          (SignupGroup
                                              .loggedInUserInformationAndCourseAccessCheckingApiCall
                                              .courses(
                                            createAndPreviewTestPageLoggedInUserInformationAndCourseAccessCheckingApiResponse
                                                .jsonBody,
                                          )
                                              .length >
                                              0) &&
                                          (TestGroup
                                              .listOfCustomCreatedTestsByTheUserOrderedByDateOfCreationDescendingCall
                                              .myCustomTestNodes(
                                            columnListOfCustomCreatedTestsByTheUserOrderedByDateOfCreationDescendingResponse
                                                .jsonBody,
                                          )
                                              .length >
                                              0))
                                        Expanded(
                                          child: Container(
                                            width: double.infinity,
                                            height: 100.0,
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context).primaryBackground,
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: FlutterFlowTheme.of(context).primaryBackground,
                                              ),
                                              child: PagedListView<
                                                  ApiPagingParams, dynamic>(
                                                pagingController: _model
                                                    .setListViewController1(
                                                      (nextPageMarker) => TestGroup
                                                      .listOfCustomCreatedTestsByTheUserOrderedByDateOfCreationDescendingCall
                                                      .call(
                                                    authToken:
                                                    functions.checkString(
                                                        FFAppState()
                                                            .subjectToken),
                                                    first: 10,
                                                    offset: functions
                                                        .getPageNumber(
                                                        nextPageMarker
                                                            .nextPageNumber),
                                                    courseId:
                                                    FFAppState().courseId,
                                                  ),
                                                ),
                                                padding: EdgeInsets.zero,
                                                reverse: false,
                                                scrollDirection:
                                                Axis.vertical,
                                                builderDelegate:
                                                PagedChildBuilderDelegate<
                                                    dynamic>(
                                                  // Customize what your widget looks like when it's loading the first page.
                                                  firstPageProgressIndicatorBuilder:
                                                      (_) => Center(
                                                    child: SizedBox(
                                                      width: 50.0,
                                                      height: 50.0,
                                                      child:
                                                      CircularProgressIndicator(
                                                        valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
                                                          FlutterFlowTheme.of(
                                                              context)
                                                              .primary,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  // Customize what your widget looks like when it's loading another page.
                                                  newPageProgressIndicatorBuilder:
                                                      (_) => Center(
                                                    child: SizedBox(
                                                      width: 50.0,
                                                      height: 50.0,
                                                      child:
                                                      CircularProgressIndicator(
                                                        valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
                                                          FlutterFlowTheme.of(
                                                              context)
                                                              .primary,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  noItemsFoundIndicatorBuilder:
                                                      (_) => Image.asset(
                                                    'https://i.pinimg.com/originals/49/e5/8d/49e58d5922019b8ec4642a2e2b9291c2.png',
                                                  ),
                                                  itemBuilder: (context, _,
                                                      customTestListIndex) {
                                                    final customTestListItem =
                                                    _model.listViewPagingController1!
                                                        .itemList![
                                                    customTestListIndex];
                                                    return Padding(
                                                      padding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          16.0,
                                                          0.0,
                                                          16.0,
                                                          12.0),
                                                      child: Material(
                                                        color: Colors
                                                            .transparent,
                                                        elevation: 4.0,
                                                        shape:
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              16.0),
                                                        ),
                                                        child: Container(
                                                          width:
                                                          double.infinity,
                                                          height: 90.0,
                                                          decoration:
                                                          BoxDecoration(
                                                            color:
                                                            FlutterFlowTheme.of(context).secondaryBackground,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                blurRadius:
                                                                60.0,
                                                                color: Color(
                                                                    0x04060F0D),
                                                                offset:
                                                                Offset(
                                                                    0.0,
                                                                    2.0),
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
                                                            MainAxisSize
                                                                .max,
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    16.0,
                                                                    15.0,
                                                                    16.0,
                                                                    15.0),
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
                                                                        customTestListItem,
                                                                        r'''$.name''',
                                                                      ).toString(),
                                                                      style: FlutterFlowTheme.of(context)
                                                                          .bodyMedium
                                                                          .override(
                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        fontSize: 14.0,
                                                                        fontWeight: FontWeight.w600,
                                                                        useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      '${getJsonField(
                                                                        customTestListItem,
                                                                        r'''$.numQuestions''',
                                                                      ).toString()}Qs . ${getJsonField(
                                                                        customTestListItem,
                                                                        r'''$.durationInMin''',
                                                                      ).toString()} mins',
                                                                      style: FlutterFlowTheme.of(context)
                                                                          .bodyMedium
                                                                          .override(
                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        fontSize: 12.0,
                                                                        fontWeight: FontWeight.normal,
                                                                        useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    20.0,
                                                                    0.0),
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
                                                                    if (getJsonField(
                                                                      customTestListItem,
                                                                      r'''$.completedAttempt''',
                                                                    ) !=
                                                                        null) {
                                                                      setState(
                                                                              () {
                                                                            FFAppState().testAttemptId =
                                                                                getJsonField(
                                                                                  customTestListItem,
                                                                                  r'''$.completedAttempt.id''',
                                                                                ).toString();
                                                                          });

                                                                      context
                                                                          .pushNamed(
                                                                        'CreateTestResultPage',
                                                                        queryParameters:
                                                                        {
                                                                          'testAttemptId':
                                                                          serializeParam(
                                                                            getJsonField(
                                                                              customTestListItem,
                                                                              r'''$.completedAttempt.id''',
                                                                            ).toString(),
                                                                            ParamType.String,
                                                                          ),
                                                                          'courseIdInt': serializeParam(
                                                                            FFAppState().testCourseIdInt
                                                                                .toString(),
                                                                            ParamType.String,
                                                                          ),
                                                                        }.withoutNulls,
                                                                      );
                                                                    } else {
                                                                      context
                                                                          .pushNamed(
                                                                        'StartTestPage',
                                                                        queryParameters:
                                                                        {
                                                                          'testId':
                                                                          serializeParam(
                                                                            getJsonField(
                                                                              customTestListItem,
                                                                              r'''$.id''',
                                                                            ).toString(),
                                                                            ParamType.String,
                                                                          ),
                                                                          'courseIdInt': serializeParam(
                                                                            FFAppState().testCourseIdInt
                                                                                .toString(),
                                                                            ParamType.String,
                                                                          ),
                                                                        }.withoutNulls,
                                                                      );
                                                                    }
                                                                  },
                                                                  child:
                                                                  Container(
                                                                    width:
                                                                    94.0,
                                                                    height:
                                                                    34.0,
                                                                    decoration:
                                                                    BoxDecoration(
                                                                      color: getJsonField(
                                                                        customTestListItem,
                                                                        r'''$.completedAttempt''',
                                                                      ) !=
                                                                          null
                                                                          ? FlutterFlowTheme.of(context).secondaryBackground
                                                                          : FlutterFlowTheme.of(context).primary,
                                                                      borderRadius:
                                                                      BorderRadius.circular(10.0),
                                                                      border:
                                                                      Border.all(
                                                                        color:
                                                                        FlutterFlowTheme.of(context).primary,
                                                                        width:
                                                                        1.0,
                                                                      ),
                                                                    ),
                                                                    child:
                                                                    Align(
                                                                      alignment: AlignmentDirectional(
                                                                          0.0,
                                                                          0.05),
                                                                      child:
                                                                      Text(
                                                                        getJsonField(
                                                                          customTestListItem,
                                                                          r'''$.completedAttempt''',
                                                                        ) !=
                                                                            null
                                                                            ? 'View Result'
                                                                            : 'Start Test',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          color: getJsonField(
                                                                            customTestListItem,
                                                                            r'''$.completedAttempt''',
                                                                          ) !=
                                                                              null
                                                                              ? FlutterFlowTheme.of(context).primary
                                                                              : Colors.white,
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
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ).animateOnPageLoad(animationsMap[
                                          'containerOnPageLoadAnimation1']!),
                                        ),
                                      if (FFAppState().isCreatedTest &&
                                          (SignupGroup
                                              .loggedInUserInformationAndCourseAccessCheckingApiCall
                                              .courses(
                                            createAndPreviewTestPageLoggedInUserInformationAndCourseAccessCheckingApiResponse
                                                .jsonBody,
                                          )
                                              .length >
                                              0) &&
                                          (TestGroup
                                              .listOfCustomCreatedTestsByTheUserOrderedByDateOfCreationDescendingCall
                                              .myCustomTestNodes(
                                            columnListOfCustomCreatedTestsByTheUserOrderedByDateOfCreationDescendingResponse
                                                .jsonBody,
                                          )
                                              .length >
                                              0))
                                        Padding(
                                          padding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              16.0, 24.0, 16.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor:
                                            Colors.transparent,
                                            onTap: () async {
                                              context.pushNamed(
                                                  'CreateTestPage');
                                            },
                                            child: Container(
                                              width: 150.0,
                                              height: 40.0,
                                              decoration: BoxDecoration(
                                                color: FlutterFlowTheme.of(
                                                    context)
                                                    .primary,
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 6.0,
                                                    color: Color(0x33000000),
                                                    offset: Offset(0.0, 4.0),
                                                    spreadRadius: 1.0,
                                                  )
                                                ],
                                                borderRadius:
                                                BorderRadius.circular(
                                                    10.0),
                                              ),
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: Text(
                                                'Create your test',
                                                style: FlutterFlowTheme.of(
                                                    context)
                                                    .bodyMedium
                                                    .override(
                                                  fontFamily:
                                                  FlutterFlowTheme.of(
                                                      context)
                                                      .bodyMediumFamily,
                                                  color: Colors.white,
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
                                        ),
                                      if (!FFAppState().isCreatedTest)
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsetsDirectional
                                                .fromSTEB(0.0, 5.0, 0.0, 0.0),
                                            child: FutureBuilder<
                                                ApiCallResponse>(
                                              future: TestGroup
                                                  .getPreviousYearTestsInTestsTabCall
                                                  .call(
                                                authToken:
                                                FFAppState().subjectToken,
                                                courseId:
                                                FFAppState().testCourseId,
                                              ),
                                              builder: (context, snapshot) {
                                                // Customize what your widget looks like when it's loading.
                                                if (!snapshot.hasData) {
                                                  return Container(
                                                    color:FlutterFlowTheme.of(context).primaryBackground,
                                                    child: Center(
                                                      child: SizedBox(
                                                        width: 50.0,
                                                        height: 50.0,
                                                        child:
                                                        CircularProgressIndicator(
                                                          valueColor:
                                                          AlwaysStoppedAnimation<
                                                              Color>(
                                                            FlutterFlowTheme.of(
                                                                context)
                                                                .primary,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                                final previousTestGetPreviousYearTestsInTestsTabResponse =
                                                snapshot.data!;
                                                return Container(
                                                  width: double.infinity,
                                                  height: 100.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(context).primaryBackground,
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme.of(context).primaryBackground,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0.0,
                                                          6.0,
                                                          0.0,
                                                          0.0),
                                                      child: Builder(
                                                        builder: (context) {
                                                          final previousTestList = TestGroup
                                                              .getPreviousYearTestsInTestsTabCall
                                                              .previousTest(
                                                            previousTestGetPreviousYearTestsInTestsTabResponse
                                                                .jsonBody,
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
                                                            previousTestList
                                                                .length,
                                                            itemBuilder: (context,
                                                                previousTestListIndex) {
                                                              final previousTestListItem =
                                                              previousTestList[
                                                              previousTestListIndex];
                                                              return  (SignupGroup
                                                                  .loggedInUserInformationAndCourseAccessCheckingApiCall
                                                                  .courses(
                                                                createAndPreviewTestPageLoggedInUserInformationAndCourseAccessCheckingApiResponse
                                                                    .jsonBody,
                                                              )
                                                                  .length ==
                                                                  0 && previousTestListIndex==0)?
                                                              Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        16.0,
                                                                        6.0,
                                                                        16.0,
                                                                        6.0),
                                                                    child:
                                                                    Material(
                                                                      color: Colors
                                                                          .transparent,
                                                                      elevation:
                                                                      4.0,
                                                                      shape:
                                                                      RoundedRectangleBorder(
                                                                        borderRadius:
                                                                        BorderRadius.circular(
                                                                            16.0),
                                                                      ),
                                                                      child:
                                                                      Container(
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            10.0,
                                                                            10.0,
                                                                            15.0,
                                                                            10.0),
                                                                        width:
                                                                        100.0,
                                                                        decoration:
                                                                        BoxDecoration(
                                                                          color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              blurRadius:
                                                                              60.0,
                                                                              color:
                                                                              Color(0x04060F0D),
                                                                              offset:
                                                                              Offset(0.0, 4.0),
                                                                            )
                                                                          ],
                                                                          borderRadius:
                                                                          BorderRadius.circular(16.0),
                                                                        ),
                                                                        child:
                                                                        Column(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                          CrossAxisAlignment.stretch,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisSize:
                                                                              MainAxisSize.min,
                                                                              mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                              children: [
                                                                                Flexible(
                                                                                  child:
                                                                                  Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(10.0, 5.0, 10.0, 5.0),
                                                                                    child: Column(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        AutoSizeText(
                                                                                          getJsonField(
                                                                                            previousTestListItem,
                                                                                            r'''$.name''',
                                                                                          ).toString(),
                                                                                          softWrap: true,
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                            color: FlutterFlowTheme.of(context).primaryText,
                                                                                            fontSize: 14.0,
                                                                                            fontWeight: FontWeight.w600,
                                                                                            useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 5,
                                                                                        ),
                                                                                        Text(
                                                                                          'No. of Questions: ${getJsonField(
                                                                                            previousTestListItem,
                                                                                            r'''$.numQuestions''',
                                                                                          ).toString()}',
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                            color: Color(0xFF858585),
                                                                                            fontSize: 12.0,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                          ),
                                                                                        ),

                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                getJsonField(
                                                                                  previousTestListItem,
                                                                                  r'''$.canStart''',
                                                                                )? Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(
                                                                                      0.0,
                                                                                      0.0,
                                                                                      0.0,
                                                                                      0.0),
                                                                                  child:
                                                                                  InkWell(
                                                                                    splashColor: Colors.transparent,
                                                                                    focusColor: Colors.transparent,
                                                                                    hoverColor: Colors.transparent,
                                                                                    highlightColor: Colors.transparent,
                                                                                    onTap: () async {
                                                                                      if (getJsonField(
                                                                                        previousTestListItem,
                                                                                        r'''$.completedAttempt''',
                                                                                      ) !=
                                                                                          null) {
                                                                                        context.pushNamed(
                                                                                          'CreateTestResultPage',
                                                                                          queryParameters: {
                                                                                            'testAttemptId': serializeParam(
                                                                                              getJsonField(
                                                                                                previousTestListItem,
                                                                                                r'''$.completedAttempt.id''',
                                                                                              ).toString(),
                                                                                              ParamType.String,
                                                                                            ),
                                                                                            'courseIdInt': serializeParam(
                                                                                              FFAppState().testCourseIdInt
                                                                                                  .toString(),
                                                                                              ParamType.String,
                                                                                            ),
                                                                                          }.withoutNulls,
                                                                                        );
                                                                                      } else {
                                                                                        context.pushNamed(
                                                                                          'StartTestPage',
                                                                                          queryParameters: {
                                                                                            'testId': serializeParam(
                                                                                              getJsonField(
                                                                                                previousTestListItem,
                                                                                                r'''$.id''',
                                                                                              ).toString(),
                                                                                              ParamType.String,
                                                                                            ),
                                                                                            'courseIdInt': serializeParam(
                                                                                              FFAppState().testCourseIdInt
                                                                                                  .toString(),
                                                                                              ParamType.String,
                                                                                            ),
                                                                                          }.withoutNulls,
                                                                                        );
                                                                                      }
                                                                                    },
                                                                                    child: Container(
                                                                                      width: 94.0,
                                                                                      height: 34.0,
                                                                                      decoration: BoxDecoration(
                                                                                        color: getJsonField(
                                                                                          previousTestListItem,
                                                                                          r'''$.completedAttempt''',
                                                                                        ) !=
                                                                                            null
                                                                                            ? FlutterFlowTheme.of(context).secondaryBackground
                                                                                            : FlutterFlowTheme.of(context).primary,
                                                                                        borderRadius: BorderRadius.circular(10.0),
                                                                                        border: Border.all(
                                                                                          color: FlutterFlowTheme.of(context).primary,
                                                                                          width: 1.0,
                                                                                        ),
                                                                                        // boxShadow: [
                                                                                        //   BoxShadow(
                                                                                        //     color: Colors.grey,
                                                                                        //     offset: Offset(0.0, 1.0),
                                                                                        //     //(x,y)
                                                                                        //     blurRadius: 3.0,
                                                                                        //   ),
                                                                                        // ],
                                                                                      ),
                                                                                      child: Column(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        children: [
                                                                                          Expanded(
                                                                                            child: Align(
                                                                                              alignment: AlignmentDirectional(0.0, 0.05),
                                                                                              child: Text(
                                                                                                getJsonField(
                                                                                                  previousTestListItem,
                                                                                                  r'''$.completedAttempt''',
                                                                                                ) !=
                                                                                                    null
                                                                                                    ? 'View Result'
                                                                                                    : 'Start Test',
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                  color: getJsonField(
                                                                                                    previousTestListItem,
                                                                                                    r'''$.completedAttempt''',
                                                                                                  ) !=
                                                                                                      null
                                                                                                      ? FlutterFlowTheme.of(context).primary
                                                                                                      : Colors.white,
                                                                                                  fontSize: 12.0,
                                                                                                  useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ) :SizedBox(),
                                                                              ],
                                                                            ),
                                                                            Padding(
                                                                              padding:  EdgeInsetsDirectional.fromSTEB(10.0, 5.0, 10.0, 5.0),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  getJsonField(previousTestListItem, r'''$.syllabus''',)!=null && getJsonField(previousTestListItem, r'''$.syllabus''',).toString() != ""
                                                                                      ? InkWell(
                                                                                    onTap: () {
                                                                                      showModalBottomSheet(context: context,
                                                                                          isScrollControlled: true,
                                                                                          shape: const RoundedRectangleBorder( // <-- SEE HERE
                                                                                            borderRadius: BorderRadius.vertical(
                                                                                              top: Radius.circular(25.0),
                                                                                            ),
                                                                                          ),

                                                                                          builder: (BuildContext context){
                                                                                            return Container(
                                                                                              height:MediaQuery.of(context).size.height*0.6,
                                                                                              padding:EdgeInsets.fromLTRB(16, 18, 16, 18),
                                                                                              child: Column(
                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                children:  <Widget>[
                                                                                                  Padding(
                                                                                                    padding: EdgeInsetsDirectional.fromSTEB(
                                                                                                        0.0, 0.0, 0.0, 0.0),
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
                                                                                                  Text(getJsonField(
                                                                                                    previousTestListItem,
                                                                                                    r'''$.name''',
                                                                                                  ).toString(),
                                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                        color: FlutterFlowTheme.of(context).primary,
                                                                                                        fontSize: 18.0,
                                                                                                        fontWeight: FontWeight.w600,
                                                                                                        useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),

                                                                                                      )),
                                                                                                  Html(data:getJsonField(
                                                                                                    previousTestListItem,
                                                                                                    r'''$.syllabus''',
                                                                                                  ),
                                                                                                      style: {"p": Style(
                                                                                                        fontSize: FontSize(
                                                                                                            FlutterFlowTheme.of(context).titleSmall.fontSize!
                                                                                                        ),
                                                                                                        fontFamily: !isWeb ? FlutterFlowTheme.of(context).bodyMediumFamily : 'sans-serif',
                                                                                                        color: FlutterFlowTheme.of(context).primaryText,
                                                                                                        fontWeight: FontWeight.w400,
                                                                                                      ),})
                                                                                                ],
                                                                                              ), );});
                                                                                    },
                                                                                    child: Text(
                                                                                      'SYLLABUS',
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                        color: FlutterFlowTheme.of(context).primary,
                                                                                        fontSize: 14.0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                        //  decoration: TextDecoration.underline,
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                      : SizedBox(),
                                                                                  !getJsonField(previousTestListItem, r'''$.canStart''',)
                                                                                      ? Text(
                                                                                    'LIVE ON ' + getJsonField(previousTestListItem, r'''$.startedAt''',).substring(0,15).toUpperCase(),
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                                      fontSize: 14.0,
                                                                                      fontWeight: FontWeight.normal,
                                                                                      useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                      //  decoration: TextDecoration.underline,
                                                                                    ),
                                                                                  )
                                                                                      : SizedBox(),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ):
                                                              Padding(
                                                                padding: EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    16.0,
                                                                    6.0,
                                                                    16.0,
                                                                    6.0),
                                                                child:
                                                                Material(
                                                                  color: Colors
                                                                      .transparent,
                                                                  elevation:
                                                                  4.0,
                                                                  shape:
                                                                  RoundedRectangleBorder(
                                                                    borderRadius:
                                                                    BorderRadius.circular(
                                                                        16.0),
                                                                  ),
                                                                  child:
                                                                  Container(
                                                                    padding: EdgeInsets.fromLTRB(
                                                                        10.0,
                                                                        10.0,
                                                                        15.0,
                                                                        10.0),
                                                                    width:
                                                                    100.0,
                                                                    decoration:
                                                                    BoxDecoration(
                                                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          blurRadius:
                                                                          60.0,
                                                                          color:
                                                                          Color(0x04060F0D),
                                                                          offset:
                                                                          Offset(0.0, 4.0),
                                                                        )
                                                                      ],
                                                                      borderRadius:
                                                                      BorderRadius.circular(16.0),
                                                                    ),
                                                                    child:
                                                                    Column(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment.start,
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment.stretch,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisSize:
                                                                          MainAxisSize.min,
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment:
                                                                          CrossAxisAlignment.center,
                                                                          children: [
                                                                            Flexible(
                                                                              child:
                                                                              Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(10.0, 5.0, 10.0, 5.0),
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    AutoSizeText(
                                                                                      getJsonField(
                                                                                        previousTestListItem,
                                                                                        r'''$.name''',
                                                                                      ).toString(),
                                                                                      softWrap: true,
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                        color: FlutterFlowTheme.of(context).primaryText,
                                                                                        fontSize: 14.0,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 5,
                                                                                    ),
                                                                                    Text(
                                                                                      'No. of Questions: ${getJsonField(
                                                                                        previousTestListItem,
                                                                                        r'''$.numQuestions''',
                                                                                      ).toString()}',
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                        color: Color(0xFF858585),
                                                                                        fontSize: 12.0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                      ),
                                                                                    ),

                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            getJsonField(
                                                                              previousTestListItem,
                                                                              r'''$.canStart''',
                                                                            )? Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(
                                                                                  0.0,
                                                                                  0.0,
                                                                                  0.0,
                                                                                  0.0),
                                                                              child:
                                                                              InkWell(
                                                                                splashColor: Colors.transparent,
                                                                                focusColor: Colors.transparent,
                                                                                hoverColor: Colors.transparent,
                                                                                highlightColor: Colors.transparent,
                                                                                onTap: () async {
                                                                                  if (getJsonField(
                                                                                    previousTestListItem,
                                                                                    r'''$.completedAttempt''',
                                                                                  ) !=
                                                                                      null) {
                                                                                    context.pushNamed(
                                                                                      'CreateTestResultPage',
                                                                                      queryParameters: {
                                                                                        'testAttemptId': serializeParam(
                                                                                          getJsonField(
                                                                                            previousTestListItem,
                                                                                            r'''$.completedAttempt.id''',
                                                                                          ).toString(),
                                                                                          ParamType.String,
                                                                                        ),
                                                                                        'courseIdInt': serializeParam(
                                                                                          FFAppState().testCourseIdInt
                                                                                              .toString(),
                                                                                          ParamType.String,
                                                                                        ),
                                                                                      }.withoutNulls,
                                                                                    );
                                                                                  } else {
                                                                                    context.pushNamed(
                                                                                      'StartTestPage',
                                                                                      queryParameters: {
                                                                                        'testId': serializeParam(
                                                                                          getJsonField(
                                                                                            previousTestListItem,
                                                                                            r'''$.id''',
                                                                                          ).toString(),
                                                                                          ParamType.String,
                                                                                        ),
                                                                                        'courseIdInt': serializeParam(
                                                                                          FFAppState().testCourseIdInt
                                                                                              .toString(),
                                                                                          ParamType.String,
                                                                                        ),
                                                                                      }.withoutNulls,
                                                                                    );
                                                                                  }
                                                                                },
                                                                                child: Container(
                                                                                  width: 94.0,
                                                                                  height: 34.0,
                                                                                  decoration: BoxDecoration(
                                                                                    color: getJsonField(
                                                                                      previousTestListItem,
                                                                                      r'''$.completedAttempt''',
                                                                                    ) !=
                                                                                        null
                                                                                        ? FlutterFlowTheme.of(context).secondaryBackground
                                                                                        : FlutterFlowTheme.of(context).primary,
                                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                                    border: Border.all(
                                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                                      width: 1.0,
                                                                                    ),
                                                                                    // boxShadow: [
                                                                                    //   BoxShadow(
                                                                                    //     color: Colors.grey,
                                                                                    //     offset: Offset(0.0, 1.0),
                                                                                    //     //(x,y)
                                                                                    //     blurRadius: 3.0,
                                                                                    //   ),
                                                                                    // ],
                                                                                  ),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      Expanded(
                                                                                        child: Align(
                                                                                          alignment: AlignmentDirectional(0.0, 0.05),
                                                                                          child: Text(
                                                                                            getJsonField(
                                                                                              previousTestListItem,
                                                                                              r'''$.completedAttempt''',
                                                                                            ) !=
                                                                                                null
                                                                                                ? 'View Result'
                                                                                                : 'Start Test',
                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                              color: getJsonField(
                                                                                                previousTestListItem,
                                                                                                r'''$.completedAttempt''',
                                                                                              ) !=
                                                                                                  null
                                                                                                  ? FlutterFlowTheme.of(context).primary
                                                                                                  : Colors.white,
                                                                                              fontSize: 12.0,
                                                                                              useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ) :SizedBox(),
                                                                          ],
                                                                        ),
                                                                        Padding(
                                                                          padding:  EdgeInsetsDirectional.fromSTEB(10.0, 5.0, 10.0, 5.0),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              getJsonField(previousTestListItem, r'''$.syllabus''',)!=null && getJsonField(previousTestListItem, r'''$.syllabus''',).toString() != ""
                                                                                  ? InkWell(
                                                                                onTap: () {
                                                                                  showModalBottomSheet(context: context,
                                                                                      isScrollControlled: true,
                                                                                      shape: const RoundedRectangleBorder( // <-- SEE HERE
                                                                                        borderRadius: BorderRadius.vertical(
                                                                                          top: Radius.circular(25.0),
                                                                                        ),
                                                                                      ),

                                                                                      builder: (BuildContext context){
                                                                                        return Container(
                                                                                          height:MediaQuery.of(context).size.height*0.6,
                                                                                          padding:EdgeInsets.fromLTRB(16, 18, 16, 18),
                                                                                          child: Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                            children:  <Widget>[
                                                                                              Padding(
                                                                                                padding: EdgeInsetsDirectional.fromSTEB(
                                                                                                    0.0, 0.0, 0.0, 0.0),
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
                                                                                              Text(getJsonField(
                                                                                                previousTestListItem,
                                                                                                r'''$.name''',
                                                                                              ).toString(),
                                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                    color: FlutterFlowTheme.of(context).primary,
                                                                                                    fontSize: 18.0,
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),

                                                                                                  )),
                                                                                              Html(data:getJsonField(
                                                                                                previousTestListItem,
                                                                                                r'''$.syllabus''',
                                                                                              ),
                                                                                                  style: {"p": Style(
                                                                                                    fontSize: FontSize(
                                                                                                        FlutterFlowTheme.of(context).titleSmall.fontSize!
                                                                                                    ),
                                                                                                    fontFamily: !isWeb ? FlutterFlowTheme.of(context).bodyMediumFamily : 'sans-serif',
                                                                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                                                                    fontWeight: FontWeight.w400,
                                                                                                  ),})
                                                                                            ],
                                                                                          ), );});
                                                                                },
                                                                                child: Text(
                                                                                  'SYLLABUS',
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                    color: FlutterFlowTheme.of(context).primary,
                                                                                    fontSize: 14.0,
                                                                                    fontWeight: FontWeight.normal,
                                                                                    useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                    //  decoration: TextDecoration.underline,
                                                                                  ),
                                                                                ),
                                                                              )
                                                                                  : SizedBox(),
                                                                              !getJsonField(previousTestListItem, r'''$.canStart''',)
                                                                                  ? Text(
                                                                                'LIVE ON ' + getJsonField(previousTestListItem, r'''$.startedAt''',).substring(0,15).toUpperCase(),
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                  color: FlutterFlowTheme.of(context).primary,
                                                                                  fontSize: 14.0,
                                                                                  fontWeight: FontWeight.normal,
                                                                                  useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                  //  decoration: TextDecoration.underline,
                                                                                ),
                                                                              )
                                                                                  : SizedBox(),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
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
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      if ((SignupGroup
                                          .loggedInUserInformationAndCourseAccessCheckingApiCall
                                          .courses(
                                        createAndPreviewTestPageLoggedInUserInformationAndCourseAccessCheckingApiResponse
                                            .jsonBody,
                                      )
                                          .length >
                                          0) &&
                                          FFAppState().isCreatedTest &&
                                          (TestGroup
                                              .listOfCustomCreatedTestsByTheUserOrderedByDateOfCreationDescendingCall
                                              .myCustomTestNodes(
                                            columnListOfCustomCreatedTestsByTheUserOrderedByDateOfCreationDescendingResponse
                                                .jsonBody,
                                          )
                                              .length ==
                                              0))
                                        Expanded(
                                          child: wrapWithModel(
                                            model:
                                            _model.noDataComponentModel,
                                            updateCallback: () =>
                                                setState(() {}),
                                            child: NoDataComponentWidget(),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      if (SignupGroup
                          .loggedInUserInformationAndCourseAccessCheckingApiCall
                          .courses(
                        createAndPreviewTestPageLoggedInUserInformationAndCourseAccessCheckingApiResponse
                            .jsonBody,
                      )
                          .length ==
                          0)
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: 100.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primaryBackground,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (FFAppState().isCreatedTest)
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      height: 100.0,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFEDEDED),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              width: double.infinity,
                                              height: 100.0,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                    16.0, 0.0, 16.0, 0.0),
                                                child: Column(
                                                  mainAxisSize:
                                                  MainAxisSize.max,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/illustration_(1).png',
                                                      width: 120.0,
                                                      height: 100.0,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Padding(
                                                      padding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0.0,
                                                          24.0,
                                                          0.0,
                                                          8.0),
                                                      child: Text(
                                                        'Upgrade to Premium',
                                                        style: FlutterFlowTheme
                                                            .of(context)
                                                            .bodyMedium
                                                            .override(
                                                          fontFamily: FlutterFlowTheme.of(
                                                              context)
                                                              .bodyMediumFamily,
                                                          fontSize: 18.0,
                                                          useGoogleFonts: GoogleFonts
                                                              .asMap()
                                                              .containsKey(
                                                              FlutterFlowTheme.of(context)
                                                                  .bodyMediumFamily),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          22.0,
                                                          0.0,
                                                          22.0,
                                                          0.0),
                                                      child: Text(
                                                        'You need to enroll in a course to access this section.',
                                                        textAlign:
                                                        TextAlign.center,
                                                        style: FlutterFlowTheme
                                                            .of(context)
                                                            .bodyMedium
                                                            .override(
                                                          fontFamily: FlutterFlowTheme.of(
                                                              context)
                                                              .bodyMediumFamily,
                                                          color: Color(
                                                              0xFFB9B9B9),
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                          FontWeight
                                                              .normal,
                                                          useGoogleFonts: GoogleFonts
                                                              .asMap()
                                                              .containsKey(
                                                              FlutterFlowTheme.of(context)
                                                                  .bodyMediumFamily),
                                                          lineHeight: 1.2,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0.0,
                                                          24.0,
                                                          0.0,
                                                          0.0),
                                                      child: InkWell(
                                                        splashColor: Colors
                                                            .transparent,
                                                        focusColor: Colors
                                                            .transparent,
                                                        hoverColor: Colors
                                                            .transparent,
                                                        highlightColor: Colors
                                                            .transparent,
                                                        onTap: () async {
                                                          context.pushNamed(
                                                            'OrderPage',
                                                            queryParameters: {
                                                              'courseId':
                                                              serializeParam(
                                                                FFAppState()
                                                                    .testCourseId,
                                                                ParamType
                                                                    .String,
                                                              ),
                                                              'courseIdInt':
                                                              serializeParam(
                                                                FFAppState()
                                                                    .testCourseIdInt
                                                                    .toString(),
                                                                ParamType
                                                                    .String,
                                                              ),
                                                            }.withoutNulls,
                                                          );
                                                        },
                                                        child: Container(
                                                          width: 110.0,
                                                          height: 44.0,
                                                          decoration:
                                                          BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                .of(context)
                                                                .primary,
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                10.0),
                                                          ),
                                                          alignment:
                                                          AlignmentDirectional(
                                                              0.0, 0.0),
                                                          child: Text(
                                                            'Buy Course',
                                                            style: FlutterFlowTheme
                                                                .of(context)
                                                                .bodyMedium
                                                                .override(
                                                              fontFamily:
                                                              FlutterFlowTheme.of(context)
                                                                  .bodyMediumFamily,
                                                              color: Colors
                                                                  .white,
                                                              fontSize:
                                                              14.0,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w600,
                                                              useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                                  .containsKey(
                                                                  FlutterFlowTheme.of(context).bodyMediumFamily),
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
                                    ).animateOnPageLoad(animationsMap[
                                    'containerOnPageLoadAnimation3']!),
                                  ),
                                if (!FFAppState().isCreatedTest)
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 0.0),
                                      child: FutureBuilder<ApiCallResponse>(
                                        future: TestGroup
                                            .getPreviousYearTestsInTestsTabCall
                                            .call(
                                          authToken:
                                          FFAppState().subjectToken,
                                          courseId: FFAppState().testCourseId,
                                        ),
                                        builder: (context, snapshot) {
                                          // Customize what your widget looks like when it's loading.
                                          if (!snapshot.hasData) {
                                            return Container(
                                              color:FlutterFlowTheme.of(context).primaryBackground,
                                              child: Center(
                                                child: SizedBox(
                                                  width: 50.0,
                                                  height: 50.0,
                                                  child:
                                                  CircularProgressIndicator(
                                                    valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                      FlutterFlowTheme.of(
                                                          context)
                                                          .primary,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                          final previousTestGetPreviousYearTestsInTestsTabResponse =
                                          snapshot.data!;
                                          return Container(
                                            width: double.infinity,
                                            // height: 110.0,
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context).primaryBackground,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                  0.0, 10.0, 0.0, 0.0),
                                              child: Builder(
                                                builder: (context) {
                                                  final previousTestList =
                                                      TestGroup
                                                          .getPreviousYearTestsInTestsTabCall
                                                          .previousTest(
                                                        previousTestGetPreviousYearTestsInTestsTabResponse
                                                            .jsonBody,
                                                      )
                                                          ?.toList() ??
                                                          [];
                                                  return ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    scrollDirection:
                                                    Axis.vertical,
                                                    itemCount:
                                                    previousTestList
                                                        .length,
                                                    itemBuilder: (context,
                                                        previousTestListIndex) {
                                                      final previousTestListItem =
                                                      previousTestList[
                                                      previousTestListIndex];
                                                      return   (SignupGroup
                                                          .loggedInUserInformationAndCourseAccessCheckingApiCall
                                                          .courses(
                                                        createAndPreviewTestPageLoggedInUserInformationAndCourseAccessCheckingApiResponse
                                                            .jsonBody,
                                                      )
                                                          .length ==
                                                          0 && previousTestListIndex==0)?
                                                      Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                16.0,
                                                                6.0,
                                                                16.0,
                                                                6.0),
                                                            child: Material(
                                                              color: Colors
                                                                  .transparent,
                                                              elevation: 4.0,
                                                              shape:
                                                              RoundedRectangleBorder(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    16.0),
                                                              ),
                                                              child: Container(
                                                                padding: EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    10.0,
                                                                    10.0,
                                                                    15.0,
                                                                    10.0),
                                                                width:
                                                                600.0,
                                                                decoration:
                                                                BoxDecoration(
                                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      blurRadius:
                                                                      60.0,
                                                                      color: Color(
                                                                          0x04060F0D),
                                                                      offset:
                                                                      Offset(
                                                                          0.0,
                                                                          4.0),
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
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.stretch,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment.center,
                                                                      children: [
                                                                        Flexible(
                                                                          child:
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                10.0,
                                                                                5.0,
                                                                                10.0,
                                                                                5.0),
                                                                            child:
                                                                            Column(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                AutoSizeText(
                                                                                  getJsonField(
                                                                                    previousTestListItem,
                                                                                    r'''$.name''',
                                                                                  ).toString(),
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                                                    fontSize: 14.0,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                    height: 5),
                                                                                Text(
                                                                                  'No. of Questions: ${getJsonField(
                                                                                    previousTestListItem,
                                                                                    r'''$.numQuestions''',
                                                                                  ).toString()}',
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                    color: Color(0xFF858585),
                                                                                    fontSize: 12.0,
                                                                                    fontWeight: FontWeight.normal,
                                                                                    useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        !getJsonField(
                                                                          previousTestListItem,
                                                                          r'''$.free''',
                                                                        ) ?
                                                                        GestureDetector(
                                                                          onTap:(){
                                                                            // showModalBottomSheet(
                                                                            //   isScrollControlled: true,
                                                                            //   backgroundColor: Colors.transparent,
                                                                            //   context: context,
                                                                            //   builder: (context) {
                                                                            //     return GestureDetector(
                                                                            //       onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
                                                                            //       child: Padding(
                                                                            //         padding: MediaQuery.of(context).viewInsets,
                                                                            //         child: TestLimitPopupWidget(),
                                                                            //       ),
                                                                            //     );
                                                                            //   },
                                                                            // );
                                                                          },
                                                                          child: Padding(
                                                                            padding: EdgeInsets
                                                                                .fromLTRB(
                                                                                0.0,
                                                                                0.0,
                                                                                22.0,
                                                                                0.0),
                                                                            child: Row(
                                                                              mainAxisSize:
                                                                              MainAxisSize
                                                                                  .max,
                                                                              mainAxisAlignment:
                                                                              MainAxisAlignment
                                                                                  .end,
                                                                              children: [
                                                                                ClipRRect(
                                                                                  borderRadius:
                                                                                  BorderRadius.circular(8.0),
                                                                                  child:
                                                                                  Image.asset(
                                                                                    'assets/images/lock.png',
                                                                                    width:
                                                                                    22.0,
                                                                                    height:
                                                                                    22.0,
                                                                                    fit:
                                                                                    BoxFit.cover,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ):  Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0.0,
                                                                              0.0,
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                          InkWell(
                                                                            splashColor: Colors.transparent,
                                                                            focusColor: Colors.transparent,
                                                                            hoverColor: Colors.transparent,
                                                                            highlightColor: Colors.transparent,
                                                                            onTap: () async {
                                                                              if (getJsonField(
                                                                                previousTestListItem,
                                                                                r'''$.completedAttempt''',
                                                                              ) !=
                                                                                  null) {
                                                                                context.pushNamed(
                                                                                  'CreateTestResultPage',
                                                                                  queryParameters: {
                                                                                    'testAttemptId': serializeParam(
                                                                                      getJsonField(
                                                                                        previousTestListItem,
                                                                                        r'''$.completedAttempt.id''',
                                                                                      ).toString(),
                                                                                      ParamType.String,
                                                                                    ),
                                                                                    'courseIdInt': serializeParam(
                                                                                      FFAppState().testCourseIdInt
                                                                                          .toString(),
                                                                                      ParamType.String,
                                                                                    ),
                                                                                  }.withoutNulls,
                                                                                );
                                                                              } else {
                                                                                context.pushNamed(
                                                                                  'StartTestPage',
                                                                                  queryParameters: {
                                                                                    'testId': serializeParam(
                                                                                      getJsonField(
                                                                                        previousTestListItem,
                                                                                        r'''$.id''',
                                                                                      ).toString(),
                                                                                      ParamType.String,
                                                                                    ),
                                                                                    'courseIdInt': serializeParam(
                                                                                      FFAppState().testCourseIdInt
                                                                                          .toString(),
                                                                                      ParamType.String,
                                                                                    ),
                                                                                  }.withoutNulls,
                                                                                );
                                                                              }
                                                                            },
                                                                            child: Container(
                                                                              width: 94.0,
                                                                              height: 34.0,
                                                                              decoration: BoxDecoration(
                                                                                color: getJsonField(
                                                                                  previousTestListItem,
                                                                                  r'''$.completedAttempt''',
                                                                                ) !=
                                                                                    null
                                                                                    ? FlutterFlowTheme.of(context).secondaryBackground
                                                                                    : FlutterFlowTheme.of(context).primary,
                                                                                borderRadius: BorderRadius.circular(10.0),
                                                                                border: Border.all(
                                                                                  color: FlutterFlowTheme.of(context).primary,
                                                                                  width: 1.0,
                                                                                ),
                                                                                // boxShadow: [
                                                                                //   BoxShadow(
                                                                                //     color: Colors.grey,
                                                                                //     offset: Offset(0.0, 1.0),
                                                                                //     //(x,y)
                                                                                //     blurRadius: 3.0,
                                                                                //   ),
                                                                                // ],
                                                                              ),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: Align(
                                                                                      alignment: AlignmentDirectional(0.0, 0.05),
                                                                                      child: Text(
                                                                                        getJsonField(
                                                                                          previousTestListItem,
                                                                                          r'''$.completedAttempt''',
                                                                                        ) !=
                                                                                            null
                                                                                            ? 'View Result'
                                                                                            : 'Start Test',
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                          color: getJsonField(
                                                                                            previousTestListItem,
                                                                                            r'''$.completedAttempt''',
                                                                                          ) !=
                                                                                              null
                                                                                              ? FlutterFlowTheme.of(context).primary
                                                                                              : Colors.white,
                                                                                          fontSize: 12.0,
                                                                                          useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
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
                                                                    Padding(
                                                                      padding:  EdgeInsetsDirectional.fromSTEB(10.0, 5.0, 10.0, 10.0),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          getJsonField(previousTestListItem, r'''$.syllabus''',)!=null && getJsonField(previousTestListItem, r'''$.syllabus''',).toString() != ""
                                                                              ? InkWell(
                                                                            onTap: () {
                                                                              showModalBottomSheet(context: context,
                                                                                  isScrollControlled: true,
                                                                                  shape: const RoundedRectangleBorder( // <-- SEE HERE
                                                                                    borderRadius: BorderRadius.vertical(
                                                                                      top: Radius.circular(25.0),
                                                                                    ),
                                                                                  ),
                                                                                  builder: (BuildContext context){
                                                                                    return Container(
                                                                                      height:MediaQuery.of(context).size.height*0.6,
                                                                                      padding:EdgeInsets.fromLTRB(16, 18, 16, 18),
                                                                                      child: Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        children:  <Widget>[
                                                                                          Padding(
                                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                                0.0, 0.0, 0.0, 0.0),
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
                                                                                          Text(getJsonField(
                                                                                            previousTestListItem,
                                                                                            r'''$.name''',
                                                                                          ).toString(),
                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                color: FlutterFlowTheme.of(context).primary,
                                                                                                fontSize: 18.0,
                                                                                                fontWeight: FontWeight.w600,
                                                                                                useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),

                                                                                              )),
                                                                                          Html(data:getJsonField(
                                                                                            previousTestListItem,
                                                                                            r'''$.syllabus''',
                                                                                          ),
                                                                                              style: {"p": Style(
                                                                                                fontSize: FontSize(
                                                                                                    FlutterFlowTheme.of(context).titleSmall.fontSize!
                                                                                                ),
                                                                                                fontFamily: !isWeb ? FlutterFlowTheme.of(context).bodyMediumFamily : 'sans-serif',
                                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                                                fontWeight: FontWeight.w400,
                                                                                              ),})
                                                                                        ],
                                                                                      ), );});
                                                                            },
                                                                            child: Text(
                                                                              'SYLLABUS',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                color: FlutterFlowTheme.of(context).primary,
                                                                                fontSize: 14.0,
                                                                                fontWeight: FontWeight.normal,
                                                                                useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                //  decoration: TextDecoration.underline,
                                                                              ),
                                                                            ),
                                                                          )
                                                                              : SizedBox(),
                                                                          !getJsonField(previousTestListItem, r'''$.canStart''',)
                                                                              ? Text(
                                                                            'LIVE ON ' + getJsonField(previousTestListItem, r'''$.startedAt''',).substring(0,15).toUpperCase(),
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              color: FlutterFlowTheme.of(context).primary,
                                                                              fontSize: 14.0,
                                                                              fontWeight: FontWeight.normal,
                                                                              useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                              //  decoration: TextDecoration.underline,
                                                                            ),
                                                                          )
                                                                              : SizedBox(),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ):  Padding(
                                                        padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            16.0,
                                                            6.0,
                                                            16.0,
                                                            6.0),
                                                        child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          elevation: 4.0,
                                                          shape:
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                16.0),
                                                          ),
                                                          child: Container(
                                                            padding: EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                10.0,
                                                                10.0,
                                                                15.0,
                                                                10.0),
                                                            width:
                                                            100.0,
                                                            decoration:
                                                            BoxDecoration(
                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  blurRadius:
                                                                  60.0,
                                                                  color: Color(
                                                                      0x04060F0D),
                                                                  offset:
                                                                  Offset(
                                                                      0.0,
                                                                      4.0),
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
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment.stretch,
                                                              children: [
                                                                Row(
                                                                  mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.center,
                                                                  children: [
                                                                    Flexible(
                                                                      child:
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            10.0,
                                                                            5.0,
                                                                            10.0,
                                                                            5.0),
                                                                        child:
                                                                        Column(
                                                                          mainAxisSize: MainAxisSize.max,
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            AutoSizeText(
                                                                              getJsonField(
                                                                                previousTestListItem,
                                                                                r'''$.name''',
                                                                              ).toString(),
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                                fontSize: 14.0,
                                                                                fontWeight: FontWeight.w700,
                                                                                useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                                height: 5),
                                                                            Text(
                                                                              'No. of Questions: ${getJsonField(
                                                                                previousTestListItem,
                                                                                r'''$.numQuestions''',
                                                                              ).toString()}',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                color: Color(0xFF858585),
                                                                                fontSize: 12.0,
                                                                                fontWeight: FontWeight.normal,
                                                                                useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    !getJsonField(
                                                                      previousTestListItem,
                                                                      r'''$.free''',
                                                                    ) ?
                                                                    GestureDetector(
                                                                      onTap:(){
                                                                        // showModalBottomSheet(
                                                                        //   isScrollControlled: true,
                                                                        //   backgroundColor: Colors.transparent,
                                                                        //   context: context,
                                                                        //   builder: (context) {
                                                                        //     return GestureDetector(
                                                                        //       onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
                                                                        //       child: Padding(
                                                                        //         padding: MediaQuery.of(context).viewInsets,
                                                                        //         child: TestLimitPopupWidget(),
                                                                        //       ),
                                                                        //     );
                                                                        //   },
                                                                        // );
                                                                      },
                                                                      child: Padding(
                                                                        padding: EdgeInsets
                                                                            .fromLTRB(
                                                                            0.0,
                                                                            0.0,
                                                                            22.0,
                                                                            0.0),
                                                                        child: Row(
                                                                          mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                          children: [
                                                                            ClipRRect(
                                                                              borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                              child:
                                                                              Image.asset(
                                                                                'assets/images/lock.png',
                                                                                width:
                                                                                22.0,
                                                                                height:
                                                                                22.0,
                                                                                color:FlutterFlowTheme.of(context).primaryText,
                                                                                fit:
                                                                                BoxFit.cover,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ):  Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      child:
                                                                      InkWell(
                                                                        splashColor: Colors.transparent,
                                                                        focusColor: Colors.transparent,
                                                                        hoverColor: Colors.transparent,
                                                                        highlightColor: Colors.transparent,
                                                                        onTap: () async {
                                                                          if (getJsonField(
                                                                            previousTestListItem,
                                                                            r'''$.completedAttempt''',
                                                                          ) !=
                                                                              null) {
                                                                            context.pushNamed(
                                                                              'CreateTestResultPage',
                                                                              queryParameters: {
                                                                                'testAttemptId': serializeParam(
                                                                                  getJsonField(
                                                                                    previousTestListItem,
                                                                                    r'''$.completedAttempt.id''',
                                                                                  ).toString(),
                                                                                  ParamType.String,
                                                                                ),
                                                                                'courseIdInt': serializeParam(
                                                                                  FFAppState().testCourseIdInt
                                                                                      .toString(),
                                                                                  ParamType.String,
                                                                                ),
                                                                              }.withoutNulls,
                                                                            );
                                                                          } else {
                                                                            context.pushNamed(
                                                                              'StartTestPage',
                                                                              queryParameters: {
                                                                                'testId': serializeParam(
                                                                                  getJsonField(
                                                                                    previousTestListItem,
                                                                                    r'''$.id''',
                                                                                  ).toString(),
                                                                                  ParamType.String,
                                                                                ),
                                                                                'courseIdInt': serializeParam(
                                                                                  FFAppState().testCourseIdInt
                                                                                      .toString(),
                                                                                  ParamType.String,
                                                                                ),
                                                                              }.withoutNulls,
                                                                            );
                                                                          }
                                                                        },
                                                                        child: Container(
                                                                          width: 94.0,
                                                                          height: 34.0,
                                                                          decoration: BoxDecoration(
                                                                            color: getJsonField(
                                                                              previousTestListItem,
                                                                              r'''$.completedAttempt''',
                                                                            ) !=
                                                                                null
                                                                                ? FlutterFlowTheme.of(context).secondaryBackground
                                                                                : FlutterFlowTheme.of(context).primary,
                                                                            borderRadius: BorderRadius.circular(10.0),
                                                                            border: Border.all(
                                                                              color: FlutterFlowTheme.of(context).primary,
                                                                              width: 1.0,
                                                                            ),
                                                                            // boxShadow: [
                                                                            //   BoxShadow(
                                                                            //     color: Colors.grey,
                                                                            //     offset: Offset(0.0, 1.0),
                                                                            //     //(x,y)
                                                                            //     blurRadius: 3.0,
                                                                            //   ),
                                                                            // ],
                                                                          ),
                                                                          child: Column(
                                                                            mainAxisSize: MainAxisSize.max,
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              Expanded(
                                                                                child: Align(
                                                                                  alignment: AlignmentDirectional(0.0, 0.05),
                                                                                  child: Text(
                                                                                    getJsonField(
                                                                                      previousTestListItem,
                                                                                      r'''$.completedAttempt''',
                                                                                    ) !=
                                                                                        null
                                                                                        ? 'View Result'
                                                                                        : 'Start Test',
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                      color: getJsonField(
                                                                                        previousTestListItem,
                                                                                        r'''$.completedAttempt''',
                                                                                      ) !=
                                                                                          null
                                                                                          ? FlutterFlowTheme.of(context).primary
                                                                                          : Colors.white,
                                                                                      fontSize: 12.0,
                                                                                      useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
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
                                                                Padding(
                                                                  padding:  EdgeInsetsDirectional.fromSTEB(10.0, 5.0, 10.0, 10.0),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      getJsonField(previousTestListItem, r'''$.syllabus''',)!=null && getJsonField(previousTestListItem, r'''$.syllabus''',).toString() != ""
                                                                          ? InkWell(
                                                                        onTap: () {
                                                                          showModalBottomSheet(context: context,
                                                                              isScrollControlled: true,
                                                                              shape: const RoundedRectangleBorder( // <-- SEE HERE
                                                                                borderRadius: BorderRadius.vertical(
                                                                                  top: Radius.circular(25.0),
                                                                                ),
                                                                              ),
                                                                              builder: (BuildContext context){
                                                                                return Container(
                                                                                  height:MediaQuery.of(context).size.height*0.6,
                                                                                  padding:EdgeInsets.fromLTRB(16, 18, 16, 18),
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    children:  <Widget>[
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                                            0.0, 0.0, 0.0, 0.0),
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
                                                                                      Text(getJsonField(
                                                                                        previousTestListItem,
                                                                                        r'''$.name''',
                                                                                      ).toString(),
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                            color: FlutterFlowTheme.of(context).primary,
                                                                                            fontSize: 18.0,
                                                                                            fontWeight: FontWeight.w600,
                                                                                            useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),

                                                                                          )),
                                                                                      Html(data:getJsonField(
                                                                                        previousTestListItem,
                                                                                        r'''$.syllabus''',
                                                                                      ),
                                                                                          style: {"p": Style(
                                                                                            fontSize: FontSize(
                                                                                                FlutterFlowTheme.of(context).titleSmall.fontSize!
                                                                                            ),
                                                                                            fontFamily: !isWeb ? FlutterFlowTheme.of(context).bodyMediumFamily : 'sans-serif',
                                                                                            color: FlutterFlowTheme.of(context).primaryText,
                                                                                            fontWeight: FontWeight.w400,
                                                                                          ),})
                                                                                    ],
                                                                                  ), );});
                                                                        },
                                                                        child: Text(
                                                                          'SYLLABUS',
                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                            color: FlutterFlowTheme.of(context).primary,
                                                                            fontSize: 14.0,
                                                                            fontWeight: FontWeight.normal,
                                                                            useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                            //  decoration: TextDecoration.underline,
                                                                          ),
                                                                        ),
                                                                      )
                                                                          : SizedBox(),
                                                                      !getJsonField(previousTestListItem, r'''$.canStart''',)
                                                                          ? Text(
                                                                        'LIVE ON ' + getJsonField(previousTestListItem, r'''$.startedAt''',).substring(0,15).toUpperCase(),
                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          color: FlutterFlowTheme.of(context).primary,
                                                                          fontSize: 14.0,
                                                                          fontWeight: FontWeight.normal,
                                                                          useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                          //  decoration: TextDecoration.underline,
                                                                        ),
                                                                      )
                                                                          : SizedBox(),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                if (!FFAppState().isCreatedTest)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    child: FutureBuilder<ApiCallResponse>(
                                      future: PaymentGroup
                                          .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                                          .call(
                                          courseId: FFAppState().testCourseId,
                                          authToken: FFAppState().subjectToken
                                      ),
                                      builder: (context, snapshot) {
                                        // Customize what your widget looks like when it's loading.
                                        if (!snapshot.hasData) {
                                          return Center(
                                            child: LinearProgressIndicator(
                                              color:
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                            ),
                                          );
                                        }
                                        final containerGetCoursePriceAndCourseOffersToSelectFromToStartPaymentResponse =
                                        snapshot.data!;
                                        List priceStrings = PaymentGroup
                                            .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                                            .offerDiscountedFees(containerGetCoursePriceAndCourseOffersToSelectFromToStartPaymentResponse.jsonBody) as List;

// Assuming all elements are numeric values in string format, convert them to double and find the minimum.
                                        double? minPrice = priceStrings
                                            .map<double>((s) => double.parse(s))  // Convert each string to a double
                                            .reduce((a, b) => a < b ? a : b);
                                        return Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFB27A14),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: Image.asset(
                                                'assets/images/Header-Curves.png',
                                              ).image,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(12.0),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsetsDirectional
                                                .fromSTEB(
                                                16.0, 23.0, 16.0, 25.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0,
                                                        0.0,
                                                        10.0,
                                                        0.0),
                                                    child: Wrap(
                                                      spacing: 0.0,
                                                      runSpacing: 0.0,
                                                      alignment:
                                                      WrapAlignment.start,
                                                      crossAxisAlignment:
                                                      WrapCrossAlignment
                                                          .start,
                                                      direction:
                                                      Axis.horizontal,
                                                      runAlignment:
                                                      WrapAlignment.start,
                                                      verticalDirection:
                                                      VerticalDirection
                                                          .down,
                                                      clipBehavior: Clip.none,
                                                      children: [
                                                        Text(
                                                          'Pay only ',
                                                          style: FlutterFlowTheme
                                                              .of(context)
                                                              .bodyMedium
                                                              .override(
                                                            fontFamily: FlutterFlowTheme.of(
                                                                context)
                                                                .bodyMediumFamily,
                                                            color: Colors
                                                                .white,
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
                                                        Text(
                                                          '₹ ${(String var1) {
                                                            return var1
                                                                .split('.')
                                                                .first;
                                                          }(minPrice.toString())}'
                                                          ,
                                                          style: FlutterFlowTheme
                                                              .of(context)
                                                              .bodyMedium
                                                              .override(
                                                            fontFamily: FlutterFlowTheme.of(
                                                                context)
                                                                .bodyMediumFamily,
                                                            color: Colors
                                                                .white,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            useGoogleFonts: GoogleFonts
                                                                .asMap()
                                                                .containsKey(
                                                                FlutterFlowTheme.of(context)
                                                                    .bodyMediumFamily),
                                                          ),
                                                        ),
                                                        Text(
                                                          ' & ',
                                                          style: FlutterFlowTheme
                                                              .of(context)
                                                              .bodyMedium
                                                              .override(
                                                            fontFamily: FlutterFlowTheme.of(
                                                                context)
                                                                .bodyMediumFamily,
                                                            color: Colors
                                                                .white,
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
                                                        Text(
                                                          'get ',
                                                          style: FlutterFlowTheme
                                                              .of(context)
                                                              .bodyMedium
                                                              .override(
                                                            fontFamily: FlutterFlowTheme.of(
                                                                context)
                                                                .bodyMediumFamily,
                                                            color: Colors
                                                                .white,
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
                                                        Text(
                                                          'access ',
                                                          style: FlutterFlowTheme
                                                              .of(context)
                                                              .bodyMedium
                                                              .override(
                                                            fontFamily: FlutterFlowTheme.of(
                                                                context)
                                                                .bodyMediumFamily,
                                                            color: Colors
                                                                .white,
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
                                                        Text(
                                                          'to ',
                                                          style: FlutterFlowTheme
                                                              .of(context)
                                                              .bodyMedium
                                                              .override(
                                                            fontFamily: FlutterFlowTheme.of(
                                                                context)
                                                                .bodyMediumFamily,
                                                            color: Colors
                                                                .white,
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
                                                        Text(
                                                          'the ',
                                                          style: FlutterFlowTheme
                                                              .of(context)
                                                              .bodyMedium
                                                              .override(
                                                            fontFamily: FlutterFlowTheme.of(
                                                                context)
                                                                .bodyMediumFamily,
                                                            color: Colors
                                                                .white,
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
                                                        Text(
                                                          'Tests.',
                                                          style: FlutterFlowTheme
                                                              .of(context)
                                                              .bodyMedium
                                                              .override(
                                                            fontFamily: FlutterFlowTheme.of(
                                                                context)
                                                                .bodyMediumFamily,
                                                            color: Colors
                                                                .white,
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
                                                      ],
                                                    ),
                                                  ),
                                                ),
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
                                                    CleverTapService.recordEvent(
                                                      'Buy Now Clicked',
                                                      {"courseId":serializeParam(
                                                        FFAppState().testCourseId,
                                                        ParamType.String,
                                                      )
                                                      },
                                                    );
                                                    context.pushNamed(
                                                      'OrderPage',
                                                      queryParameters: {
                                                        'courseId':
                                                        serializeParam(
                                                          FFAppState()
                                                              .testCourseId,
                                                          ParamType.String,
                                                        ),
                                                        'courseIdInt':
                                                        serializeParam(
                                                          FFAppState()
                                                              .testCourseIdInt
                                                              .toString(),
                                                          ParamType.String,
                                                        ),
                                                      }.withoutNulls,
                                                    );
                                                  },
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    elevation: 2.0,
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(10.0),
                                                    ),
                                                    child: Container(
                                                      decoration:
                                                      BoxDecoration(
                                                        color: FlutterFlowTheme
                                                            .of(context)
                                                            .secondaryBackground,
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            10.0),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            29.0,
                                                            13.0,
                                                            29.0,
                                                            13.0),
                                                        child: Text(
                                                          'Buy Now',
                                                          style: FlutterFlowTheme
                                                              .of(context)
                                                              .bodyMedium
                                                              .override(
                                                            fontFamily: FlutterFlowTheme.of(
                                                                context)
                                                                .bodyMediumFamily,
                                                            color: Color(
                                                                0xFFB27A14),
                                                            fontSize:
                                                            16.0,
                                                            useGoogleFonts: GoogleFonts
                                                                .asMap()
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
                                        );
                                      },
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
            ));
      },
    );
  }


}
