import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

import '../../../clevertap/clevertap_service.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'start_test_page_model.dart';
export 'start_test_page_model.dart';

class StartTestPageWidget extends StatefulWidget {
  const StartTestPageWidget({
    Key? key,
    this.testId,
    this.courseIdInt
  }) : super(key: key);

  final String? testId;
  final String? courseIdInt;

  @override
  _StartTestPageWidgetState createState() => _StartTestPageWidgetState();
}

class _StartTestPageWidgetState extends State<StartTestPageWidget> {
  late StartTestPageModel _model;
  late String _localPath;
  late TargetPlatform? platform;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "StartTestPage");
    CleverTapService.recordEvent("Start Test Page Opened",{"testId":widget.testId});
    if(!kIsWeb) {
      if (Platform.isAndroid) {
        platform = TargetPlatform.android;
      } else {
        platform = TargetPlatform.iOS;
      }
    }
    _model = createModel(context, () => StartTestPageModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }


  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    if (platform == TargetPlatform.android) {
      return "/sdcard/download/";
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return directory.path + Platform.pathSeparator + 'Download';
    }
  }

  void showToastMsg(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor:  FlutterFlowTheme.of(context).primary,
        fontSize: 16.0
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return FutureBuilder<ApiCallResponse>(
      future: TestGroup.getTestDetailsForSingleTestForTheStartTestPageCall.call(
        testId: widget.testId,
        authToken: FFAppState().subjectToken,
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
        final startTestPageGetTestDetailsForSingleTestForTheStartTestPageResponse =
            snapshot.data!;
        return Title(
            title: 'StartTestPage',
            color: FlutterFlowTheme.of(context).primaryBackground,
            child: GestureDetector(
              onTap: () =>
                  FocusScope.of(context).requestFocus(_model.unfocusNode),
              child: WillPopScope(
                onWillPop: ()async{
                  context.safePopForTests(widget.courseIdInt);
                  return false;
                },
                child: Scaffold(
                  key: scaffoldKey,
                  backgroundColor:
                      FlutterFlowTheme.of(context).primaryBackground,
                  appBar: AppBar(
                    backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                    automaticallyImplyLeading: false,
                    title: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context.safePopForTests(widget.courseIdInt);
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 29.0,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 20.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                            TestGroup
                                .getTestDetailsForSingleTestForTheStartTestPageCall
                                .testName(
                            startTestPageGetTestDetailsForSingleTestForTheStartTestPageResponse
                              .jsonBody,
                            )
                                .toString().length>=25?
                                  TestGroup
                                      .getTestDetailsForSingleTestForTheStartTestPageCall
                                      .testName(
                                        startTestPageGetTestDetailsForSingleTestForTheStartTestPageResponse
                                            .jsonBody,
                                      )
                                      .toString().substring(0,25)+"...": TestGroup
                                .getTestDetailsForSingleTestForTheStartTestPageCall
                                .testName(
                              startTestPageGetTestDetailsForSingleTestForTheStartTestPageResponse
                                  .jsonBody,
                            )
                                .toString(),
                                  style: FlutterFlowTheme.of(context)
                                      .headlineMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .headlineMediumFamily,
                                        color: FlutterFlowTheme.of(context).primaryText ,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .headlineMediumFamily),
                                      ),
                                ),
                              ],
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
                    top: true,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                  16.0, 18.0, 16.0, 16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Material(
                                    color: Colors.transparent,
                                    elevation: 4.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF121212),
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 16.0, 16.0, 16.0),
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Color(0xFF121212),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    TestGroup
                                                        .getTestDetailsForSingleTestForTheStartTestPageCall
                                                        .testName(
                                                          startTestPageGetTestDetailsForSingleTestForTheStartTestPageResponse
                                                              .jsonBody,
                                                        )
                                                        .toString(),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color: Colors.white,
                                                          fontSize: 18.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily),
                                                        ),
                                                  ),
                                                  Text(
                                                    'PYQs',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color:
                                                              Color(0xFFFAFAFA),
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
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 24.0,
                                                                0.0, 0.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          width: 92.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xFF121212),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            border: Border.all(
                                                              color: Color(
                                                                  0xFF252525),
                                                              width: 0.5,
                                                            ),
                                                          ),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            10.0,
                                                                            0.0,
                                                                            6.0),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              0.0),
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/images/marks.png',
                                                                    width: 25.0,
                                                                    height:
                                                                        25.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            10.0),
                                                                child: Text(
                                                                  '${getJsonField( startTestPageGetTestDetailsForSingleTestForTheStartTestPageResponse
                                                                      .jsonBody,
                                                                      r'''$.data.test.maxMarks''')} Marks',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            12.0,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        useGoogleFonts:
                                                                            GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                      ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Flexible(
                                                          child: Container(
                                                            width: 92.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0xFF121212),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              border:
                                                                  Border.all(
                                                                color: Color(
                                                                    0xFF252525),
                                                                width: 0.5,
                                                              ),
                                                            ),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          10.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            0.0),
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/images/timer.png',
                                                                      width:
                                                                          25.0,
                                                                      height:
                                                                          25.0,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          6.0,
                                                                          0.0,
                                                                          10.0),
                                                                  child: Text(
                                                                    '${TestGroup.getTestDetailsForSingleTestForTheStartTestPageCall.durationInMin(
                                                                          startTestPageGetTestDetailsForSingleTestForTheStartTestPageResponse
                                                                              .jsonBody,
                                                                        ).toString()} Minutes',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              12.0,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          useGoogleFonts:
                                                                              GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                        ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 92.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xFF121212),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            border: Border.all(
                                                              color: Color(
                                                                  0xFF252525),
                                                              width: 0.5,
                                                            ),
                                                          ),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            10.0,
                                                                            0.0,
                                                                            6.0),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              0.0),
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/images/Questions.png',
                                                                    width: 25.0,
                                                                    height:
                                                                        25.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            10.0),
                                                                child: Text(
                                                                  '${TestGroup.getTestDetailsForSingleTestForTheStartTestPageCall.numQuestions(
                                                                        startTestPageGetTestDetailsForSingleTestForTheStartTestPageResponse
                                                                            .jsonBody,
                                                                      ).toString()} Qs',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            12.0,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        useGoogleFonts:
                                                                            GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
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
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 20.0, 0.0, 0.0),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        border: Border.all(
                                          color: Color(0xFFE9E9E9),
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20.0, 16.0, 20.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 0.0, 10.0, 0.0),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0.0),
                                                    child: Image.asset(
                                                      'assets/images/Vector_(2).png',
                                                      width: 25.0,
                                                      height: 25.0,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  valueOrDefault<String>(
                                                    '${(int.tryParse(valueOrDefault<String>(
                                                          TestGroup
                                                              .getTestDetailsForSingleTestForTheStartTestPageCall
                                                              .positiveMarksPerQ(
                                                                startTestPageGetTestDetailsForSingleTestForTheStartTestPageResponse
                                                                    .jsonBody,
                                                              )
                                                              .toString(),
                                                          '4',
                                                        )) ?? 4).toString()} marks for correct answer',
                                                    '4 marks for correct answer',
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily,
                                                        color:
                                                            Color(0xFF6E6E6E),
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
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20.0, 8.0, 20.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 0.0, 10.0, 0.0),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0.0),
                                                    child: Image.asset(
                                                      'assets/images/Vector.png',
                                                      width: 25.0,
                                                      height: 25.0,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  valueOrDefault<String>(
                                                    '${(int.tryParse(valueOrDefault<String>(
                                                          TestGroup
                                                              .getTestDetailsForSingleTestForTheStartTestPageCall
                                                              .positiveMarksPerQ(
                                                                startTestPageGetTestDetailsForSingleTestForTheStartTestPageResponse
                                                                    .jsonBody,
                                                              )
                                                              .toString(),
                                                          '4',
                                                        )) ?? 4).toString()} negative mark for incorrect answer',
                                                    '1 negative mark for incorrect answer',
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily,
                                                        color:
                                                            Color(0xFF6E6E6E),
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
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20.0, 8.0, 20.0, 16.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 0.0, 10.0, 0.0),
                                                  child: Container(
                                                    width: 25.0,
                                                    height: 25.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  valueOrDefault<String>(
                                                    'No negative marks for skipped questions',
                                                    'No negative marks for skipped questions',
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily,
                                                        color:
                                                            Color(0xFF6E6E6E),
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
                          ),
                        ),
                        TestGroup
                            .getTestDetailsForSingleTestForTheStartTestPageCall
                            .pdfURL(
                          startTestPageGetTestDetailsForSingleTestForTheStartTestPageResponse
                              .jsonBody,
                        )!=null? Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 20.0, 16.0, 0.0),
                          child: InkWell(
                            onTap: () async{

                              String pdfURL  = TestGroup.getTestDetailsForSingleTestForTheStartTestPageCall.pdfURL(startTestPageGetTestDetailsForSingleTestForTheStartTestPageResponse.jsonBody,).toString();
                              //if(kIsWeb){
                                await launchURL(pdfURL);
                              // }
                              // else {
                              //   await _prepareSaveDir();
                              //   showToastMsg(
                              //       "Downloading");
                              //   try {
                              //     String formattedDate = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
                              //     String fileName = TestGroup.getTestDetailsForSingleTestForTheStartTestPageCall.testName(startTestPageGetTestDetailsForSingleTestForTheStartTestPageResponse.jsonBody,).toString() + formattedDate;
                              //     await Dio()
                              //         .download(
                              //         pdfURL,
                              //         _localPath +
                              //             "/" +
                              //             fileName +
                              //             ".pdf");
                              //     showToastMsg(
                              //         "Download Completed");
                              //   } catch (e) {
                              //     showToastMsg(
                              //         "Download Failed.");
                              //   }
                              // }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 48.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).primary,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              alignment: AlignmentDirectional(0.0, 0.0),

                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.download,color:Colors.white), // Download icon
                                    SizedBox(width: 10), // Add spacing between icon and text
                                    Text("Download Test as PDF",style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                          FlutterFlowTheme.of(context)
                                              .bodyMediumFamily),)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ):SizedBox(),
                  (getJsonField(
                    startTestPageGetTestDetailsForSingleTestForTheStartTestPageResponse
                        .jsonBody,
                    r'''$.data.test.completedAttempt.id''',
                  ) ==
                      null) &&(getJsonField(
                              startTestPageGetTestDetailsForSingleTestForTheStartTestPageResponse
                                  .jsonBody,
                              r'''$.data.test.resumeAttempt.id''',
                            ) !=
                            null)?
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 20.0, 16.0, 0.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed(
                                  'TestPage',
                                  queryParameters: {
                                    'testId': serializeParam(
                                      TestGroup
                                          .getTestDetailsForSingleTestForTheStartTestPageCall
                                          .testId(
                                            startTestPageGetTestDetailsForSingleTestForTheStartTestPageResponse
                                                .jsonBody,
                                          )
                                          .toString(),
                                      ParamType.String,
                                    ),
                                    'testAttemptId': serializeParam(
                                      getJsonField(
                                        startTestPageGetTestDetailsForSingleTestForTheStartTestPageResponse
                                            .jsonBody,
                                        r'''$.data.test.resumeAttempt.id''',
                                      ).toString(),
                                      ParamType.String,
                                    ),
                                    'courseIdInt': serializeParam(
                                   widget.courseIdInt.toString()
                                          .toString(),
                                      ParamType.String,
                                    ),
                                  }.withoutNulls,
                                );
                              },
                              child:Padding(
                                padding:EdgeInsets.only(bottom:20),
                                child: Container(
                                width: double.infinity,
                                height: 48.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).primaryBackground,
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 2.0,
                                  ),
                                ),
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Text(
                                  'Resume Test',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        fontWeight: FontWeight.w500,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                ),
                              ),),
                            ),
                          )
                      :
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 20.0, 16.0, 20.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                var _shouldSetState = false;
                                if (TestGroup
                                    .getTestDetailsForSingleTestForTheStartTestPageCall
                                    .canStart(
                                  startTestPageGetTestDetailsForSingleTestForTheStartTestPageResponse
                                      .jsonBody,
                                )) {
                                  _model.testJson = await TestGroup
                                      .getTestDetailsForSingleTestForTheStartTestPageCall
                                      .call(
                                    testId: widget.testId,
                                    authToken: FFAppState().subjectToken,
                                  );
                                  _shouldSetState = true;
                                  if (getJsonField(
                                        (_model.testJson?.jsonBody ?? ''),
                                        r'''$.data.test.resumeAttempt.id''',
                                      ) !=
                                      null) {
                                    context.pushNamed(
                                      'TestPage',
                                      queryParameters: {
                                        'testId': serializeParam(
                                          TestGroup
                                              .getTestDetailsForSingleTestForTheStartTestPageCall
                                              .testId(
                                                startTestPageGetTestDetailsForSingleTestForTheStartTestPageResponse
                                                    .jsonBody,
                                              )
                                              .toString(),
                                          ParamType.String,
                                        ),
                                        'testAttemptId': serializeParam(
                                          getJsonField(
                                            (_model.testJson?.jsonBody ?? ''),
                                            r'''$.data.test.resumeAttempt.id''',
                                          ).toString(),
                                          ParamType.String,
                                        ),
                                        'courseIdInt': serializeParam(
                                          widget.courseIdInt
                                              .toString(),
                                          ParamType.String,
                                        ),
                                      }.withoutNulls,
                                    );

                                    if (_shouldSetState) setState(() {});
                                    return;
                                  } else {
                                    _model.newTestAttempt = await TestGroup
                                        .createTestAttemptForATestByAUserCall
                                        .call(
                                      testId: TestGroup
                                          .getTestDetailsForSingleTestForTheStartTestPageCall
                                          .testId(
                                            startTestPageGetTestDetailsForSingleTestForTheStartTestPageResponse
                                                .jsonBody,
                                          )
                                          .toString(),
                                      userId: functions.getBase64OfUserId(
                                          FFAppState().userIdInt),
                                      authToken: FFAppState().subjectToken,
                                    );
                                    _shouldSetState = true;

                                    context.pushNamed(
                                      'TestPage',
                                      queryParameters: {
                                        'testId': serializeParam(
                                          TestGroup
                                              .getTestDetailsForSingleTestForTheStartTestPageCall
                                              .testId(
                                                startTestPageGetTestDetailsForSingleTestForTheStartTestPageResponse
                                                    .jsonBody,
                                              )
                                              .toString(),
                                          ParamType.String,
                                        ),
                                        'testAttemptId': serializeParam(
                                          TestGroup
                                              .createTestAttemptForATestByAUserCall
                                              .testAttemptId(
                                                (_model.newTestAttempt
                                                        ?.jsonBody ??
                                                    ''),
                                              )
                                              .toString(),
                                          ParamType.String,
                                        ),
                                        'courseIdInt': serializeParam(
                                         widget.courseIdInt
                                              .toString(),
                                          ParamType.String,
                                        ),
                                      }.withoutNulls,
                                    );

                                    if (_shouldSetState) setState(() {});
                                    return;
                                  }
                                } else {
                                  await showDialog(
                                    context: context,
                                    builder: (alertDialogContext) {
                                      return AlertDialog(
                                        title: Text('Test is not live yet'),
                                        content: Text(
                                            'Test will be live at ${TestGroup.getTestDetailsForSingleTestForTheStartTestPageCall.startedAt(
                                                  startTestPageGetTestDetailsForSingleTestForTheStartTestPageResponse
                                                      .jsonBody,
                                                ).toString()}'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                alertDialogContext),
                                            child: Text('Ok'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  if (_shouldSetState) setState(() {});
                                  return;
                                }

                                if (_shouldSetState) setState(() {});
                              },
                              child: Container(
                                width: double.infinity,
                                height: 48.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).primary,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Text(
                                  'Start Test',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ));
      },
    );
  }
}
