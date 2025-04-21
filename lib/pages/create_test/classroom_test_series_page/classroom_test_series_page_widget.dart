import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:neetprep_essential/components/drawer/darwer_widget.dart';
import 'package:neetprep_essential/utlis/text.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../flutter_flow/flutter_flow_icon_button.dart';
import '/backend/api_requests/api_calls.dart';
import '/components/no_data_component/no_data_component_widget.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'classroom_test_series_page_model.dart';


class ClassroomTestSeriesPageWidget extends StatefulWidget {
  const ClassroomTestSeriesPageWidget({Key? key}) : super(key: key);

  @override
  _ClassroomTestSeriesPageWidgetState createState() =>
      _ClassroomTestSeriesPageWidgetState();
}

class _ClassroomTestSeriesPageWidgetState
    extends State<ClassroomTestSeriesPageWidget>
    with TickerProviderStateMixin {
  late ClassroomTestSeriesPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isCallbackSubmitted = false;

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

  Future<bool?> getCallbackRequestedValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key)?prefs.getBool(key):false;

  }
  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "ClassroomTestSeriesPageWidget",);
    _model = createModel(context, () => ClassroomTestSeriesPageModel());
    FFAppState().isCreatedTest = false;
     // isCallbackSubmitted =   getCallbackRequestedValue("isCallbackSubmitted") as bool;
      getCallbackRequestedValue('isCallbackSubmitted').then((value){isCallbackSubmitted = value!;});
    print(isCallbackSubmitted);
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
      future:  SignupGroup
          .loggedInUserInformationAndCourseAccessCheckingApiCall
          .call(
        authToken: FFAppState().subjectToken,
        courseIdInt: FFAppState().classroomTestCourseIdInt,
        altCourseIds: FFAppState().classroomTestCourseIdInts,
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
                backgroundColor:FlutterFlowTheme.of(context).primaryBackground,
                drawer: DrawerWidget(DrawerStrings.classroomTestSeries),
                appBar: AppBar(
                  iconTheme: IconThemeData(color:FlutterFlowTheme.of(context).accent1),
                  elevation: 1.2,
                  backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                  title: Text('Classroom Test Series',
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
                body: SafeArea(
                  top: true,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [

                      if(false)
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 8.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),

                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  15.0, 10.0, 15.0, 10.0),
                              child: Row(
                                // mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        context.pushNamed('PracticeChapterWisePage');
                                      },
                                      child: Icon(Icons.arrow_back)),
                                  if(false)
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 2.0, 0.0),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            setState(() {
                                              FFAppState().isCreatedTest = true;
                                            });
                                          },
                                          child: Material(
                                            color: Colors.transparent,
                                            elevation: 4.0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(12.0),
                                            ),
                                            child: Container(
                                              height: 38.0,
                                              decoration: BoxDecoration(
                                                color: FFAppState().isCreatedTest
                                                    ? Color(0xFF121212)
                                                    : Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 10.0,
                                                    color:
                                                    FFAppState().isCreatedTest
                                                        ? Color(0x0000001A)
                                                        : Colors.white,
                                                    offset: Offset(0.0, 5.0),
                                                  )
                                                ],
                                                borderRadius:
                                                BorderRadius.circular(12.0),
                                              ),
                                              alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                              child: Text(
                                                'Create Your Test',
                                                style:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                  fontFamily:
                                                  FlutterFlowTheme.of(
                                                      context)
                                                      .bodyMediumFamily,
                                                  color: FFAppState()
                                                      .isCreatedTest
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 11.0,
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
                                      ),
                                    ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          2.0, 0.0, 0.0, 0.0),
                                      child: Container(
                                        height: 38.0,
                                        alignment:
                                        AlignmentDirectional(0.0, 0.0),
                                        child: Text(
                                          'Tests',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                            fontFamily:
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily,
                                            color: Colors.black,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w500,
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
                                ],
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
                          .length >
                          0)
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
                                        color: FlutterFlowTheme.of(context).primaryBackground
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
                                                      (_) => Container(
                                                        decoration:BoxDecoration(
                                                        color:FlutterFlowTheme.of(context).primaryBackground
                                                        ),
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
                                                      ),
                                                  // Customize what your widget looks like when it's loading another page.
                                                  newPageProgressIndicatorBuilder:
                                                      (_) => Container(
                                                        decoration:BoxDecoration(
                                                            color:FlutterFlowTheme.of(context).primaryBackground
                                                        ),
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
                                                           FlutterFlowTheme.of(context).primaryBackground,
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
                                                                            FFAppState().classroomTestCourseIdInt
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
                                                                            FFAppState().classroomTestCourseIdInt
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
                                                                          ? Colors.white
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
                                                  color: FlutterFlowTheme.of(context).primaryText,
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
                                                FFAppState().classroomTestCourseId,
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
                                                                  Padding(padding:EdgeInsets.fromLTRB(12, 12, 12, 12),
                                                                      child:Container(

                                                                          padding:EdgeInsets.fromLTRB(12,4,12,4),
                                                                          decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(8),
                                                                            border: Border.all(
                                                                              color:FlutterFlowTheme.of(context).primary,
                                                                            ),
                                                                          ),
                                                                          child:Text("Hurry up, only a few seats left", style: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .override(
                                                                            fontFamily:
                                                                            FlutterFlowTheme.of(context).titleSmallFamily,
                                                                            color: FlutterFlowTheme.of(context).primary,
                                                                            fontSize: 14.0,
                                                                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                                                                FlutterFlowTheme.of(context)
                                                                                    .titleSmallFamily),
                                                                          ),)
                                                                      )
                                                                  ),
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
                                                                          color: FlutterFlowTheme.of(context).primaryBackground,
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
                                                                                              FFAppState().classroomTestCourseIdInt
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
                                                                                              FFAppState().classroomTestCourseIdInt
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
                                                                                            ? Colors.white
                                                                                            : FlutterFlowTheme.of(context).primary,
                                                                                        borderRadius: BorderRadius.circular(10.0),
                                                                                        border: Border.all(
                                                                                          color: FlutterFlowTheme.of(context).primary,
                                                                                          width: 1.0,
                                                                                        ),
                                                                                        boxShadow: [
                                                                                          BoxShadow(
                                                                                            color: Colors.grey,
                                                                                            offset: Offset(0.0, 1.0),
                                                                                            //(x,y)
                                                                                            blurRadius: 3.0,
                                                                                          ),
                                                                                        ],
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
                                                                      color: FlutterFlowTheme.of(context).primaryBackground,
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
                                                                                          FFAppState().classroomTestCourseIdInt
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
                                                                                       FFAppState().classroomTestCourseIdInt
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
                                                                                        ? Colors.white
                                                                                        : FlutterFlowTheme.of(context).primary,
                                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                                    border: Border.all(
                                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                                      width: 1.0,
                                                                                    ),
                                                                                    boxShadow: [
                                                                                      BoxShadow(
                                                                                        color: Colors.grey,
                                                                                        offset: Offset(0.0, 1.0),
                                                                                        //(x,y)
                                                                                        blurRadius: 3.0,
                                                                                      ),
                                                                                    ],
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
                              color: Color(0xFFEDEDED),
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
                                                color:FlutterFlowTheme.of(context).primaryBackground,
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
                                                                    .classroomTestCourseId,
                                                                ParamType
                                                                    .String,
                                                              ),
                                                              'courseIdInt':
                                                              serializeParam(
                                                                FFAppState()
                                                                    .classroomTestCourseIdInt
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
                                          courseId: FFAppState().classroomTestCourseId,
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
                                                            Padding(padding:EdgeInsets.fromLTRB(12, 12, 12, 12),
                                                                child:Container(

                                                                    padding:EdgeInsets.fromLTRB(12,4,12,4),
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(8),
                                                                      border: Border.all(
                                                                        color:FlutterFlowTheme.of(context).primary,
                                                                      ),
                                                                    ),
                                                                    child:Text("Hurry up, only a few seats left", style: FlutterFlowTheme.of(context)
                                                                        .titleSmall
                                                                        .override(
                                                                      fontFamily:
                                                                      FlutterFlowTheme.of(context).titleSmallFamily,
                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                      fontSize: 14.0,
                                                                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .titleSmallFamily),
                                                                    ),)
                                                                )
                                                            ),
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
                                                                                      color:FlutterFlowTheme.of(context).primaryText
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
                                                                                      FFAppState().classroomTestCourseIdInt
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
                                                                                      FFAppState().classroomTestCourseIdInt
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
                                                                                    ? Colors.white
                                                                                    : FlutterFlowTheme.of(context).primary,
                                                                                borderRadius: BorderRadius.circular(10.0),
                                                                                border: Border.all(
                                                                                  color: FlutterFlowTheme.of(context).primary,
                                                                                  width: 1.0,
                                                                                ),
                                                                                boxShadow: [
                                                                                  BoxShadow(
                                                                                    color: Colors.grey,
                                                                                    offset: Offset(0.0, 1.0),
                                                                                    //(x,y)
                                                                                    blurRadius: 3.0,
                                                                                  ),
                                                                                ],
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
                                                              color: FlutterFlowTheme.of(context).primaryBackground,
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
                                                                                color:FlutterFlowTheme.of(context).primaryText
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
                                                                                  FFAppState().classroomTestCourseIdInt
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
                                                                                  FFAppState().classroomTestCourseIdInt
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
                                                                                ? Colors.white
                                                                                : FlutterFlowTheme.of(context).primary,
                                                                            borderRadius: BorderRadius.circular(10.0),
                                                                            border: Border.all(
                                                                              color: FlutterFlowTheme.of(context).primary,
                                                                              width: 1.0,
                                                                            ),
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                color: Colors.grey,
                                                                                offset: Offset(0.0, 1.0),
                                                                                //(x,y)
                                                                                blurRadius: 3.0,
                                                                              ),
                                                                            ],
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
                              ],
                            ),
                          ),
                        ),
                      // wrapWithModel(
                      //   model: _model.navBarModel,
                      //   updateCallback: () => setState(() {}),
                      //   child: NavBarWidget(),
                      // ),
                    ],
                  ),
                ),
                bottomNavigationBar:
                SignupGroup
                    .loggedInUserInformationAndCourseAccessCheckingApiCall
                    .courses(
                  createAndPreviewTestPageLoggedInUserInformationAndCourseAccessCheckingApiResponse
                      .jsonBody,
                )
                    .length >
                    0 ? SizedBox():
                Container(
                  padding:EdgeInsets.fromLTRB(16,12,16,12),
                  height:130,
                  width:double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.0),
                        topRight: Radius.circular(24.0),
                      ),
                      color:Color(0xffffaecd3),
                      image: DecorationImage(
                          image: AssetImage(
                              "assets/images/Sticky-Footer.jpg"
                          ),
                          fit: BoxFit.cover
                      )
                  ),
                  child: Stack(
                      children:[
                      // SvgPicture.asset("assets/images/Sticky-Footer-M.svg",fit: BoxFit.cover,),
                        Column(
                            children:[
                              Flexible(
                                child: Center(
                                  child: Text("Enroll Now: Be Part of Our Successful Classroom Test Series!",textAlign:TextAlign.center,style:FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                    color: Colors.black,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                    //  decoration: TextDecoration.underline,
                                  ),),
                                ),
                              ),
                              SizedBox(height:10),
                              Flexible(
                                  child:Padding(
                                    padding:EdgeInsets.fromLTRB(15,0,15,0),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children:[
                                          Flexible(
                                            flex:1,
                                            child: OutlinedButton(
                                                onPressed: (){
                                                  context.pushNamed(
                                                    'PersonalDetailsPageWidget',
                                                    queryParameters: {
                                                      'isFromBuyNow':
                                                      serializeParam(
                                                        false,
                                                        ParamType.bool,
                                                      ),
                                                    }.withoutNulls,
                                                  );
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  elevation: 1,
                                                  foregroundColor: Color(0xffE6A123), side: BorderSide(color: Colors.white),
                                                  backgroundColor: Colors.white,
                                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10.0), // Border radius
                                                  ),
                                                ),
                                                child: FittedBox(
                                                  fit:BoxFit.fitWidth,
                                                  child: Text('Request a Callback',style:FlutterFlowTheme.of(
                                                      context)
                                                      .bodyMedium
                                                      .override(
                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                    fontWeight: FontWeight.w500,
                                                    color:FlutterFlowTheme.of(context).primary,
                                                    fontSize: 16.0,
                                                    useGoogleFonts:
                                                    GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                  )),
                                                )),
                                          ),
                                          SizedBox(width:5),
                                          Flexible(
                                            flex:1,
                                            child: FittedBox(
                                              fit:BoxFit.fitWidth,
                                              child: ElevatedButton(
                                                  onPressed: (){
                                                    context.pushNamed(
                                                      'PersonalDetailsPageWidget',
                                                      queryParameters: {
                                                        'isFromBuyNow':
                                                        serializeParam(
                                                          true,
                                                          ParamType.bool,
                                                        ),
                                                      }.withoutNulls,
                                                    );
                                                  },

                                                  style: OutlinedButton.styleFrom(
                                                    foregroundColor: Colors.white, elevation:1,
                                                  //  side: BorderSide(color: Colors.white),
                                                    backgroundColor: FlutterFlowTheme.of(context).primary,
                                                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10.0), // Border radius
                                                    ),
                                                  ),
                                                  child: Text('Buy now',style:FlutterFlowTheme.of(
                                                      context)
                                                      .bodyMedium
                                                      .override(
                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                    fontWeight: FontWeight.w500,
                                                    color:Colors.white,
                                                    fontSize: 15.0,
                                                    useGoogleFonts:
                                                    GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                  ))),
                                            ),
                                          )
                                        ]
                                    ),
                                  )
                              ),
                              SizedBox(height:10),
                            ]
                        )
                      ]
                  ),
                )

              ),
            ));
      },
    );
  }
}
