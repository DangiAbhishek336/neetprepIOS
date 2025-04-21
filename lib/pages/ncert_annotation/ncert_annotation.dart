import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neetprep_essential/backend/api_requests/api_calls.dart';
import 'package:neetprep_essential/components/custom_html_view/custom_html_view_widget.dart';
import 'package:neetprep_essential/components/html_question/html_question_widget.dart';
import 'package:neetprep_essential/flutter_flow/flutter_flow_icon_button.dart';
import 'package:neetprep_essential/flutter_flow/flutter_flow_theme.dart';
import 'package:neetprep_essential/flutter_flow/flutter_flow_util.dart';
import 'package:neetprep_essential/index.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../../clevertap/clevertap_service.dart';
import '../../components/drawer/darwer_widget.dart';
import '../../custom_code/widgets/android_web_view.dart';
import '../../utlis/text.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart' show Factory, kIsWeb;
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart'
    as Android;
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;

import 'package:universal_html/html.dart' as html;


// #enddocregion platform_imports

class NcertAnnotation extends StatefulWidget {

  final String webUrl;
  final String title;
  const NcertAnnotation({super.key,required this.webUrl, required this.title});

  @override
  State<NcertAnnotation> createState() => _NcertAnnotationState();
}

class _NcertAnnotationState extends State<NcertAnnotation> {
  ///web

  final GlobalKey webViewKey = GlobalKey();
  // final cookieManager = WebviewCookieManager();
  String idToken = FFAppState().subjectToken; // Your id_token value here

  ///

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      userAgent:   kIsWeb? "essential/web-221":Platform.isIOS?"essential/ios-221" :"essential/android-221",
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: true);

  late ContextMenu contextMenu;
  String url = "";
  bool isAttemptResetApiSucceeded = false;
  final urlController = TextEditingController();
  bool haveAccess = false;
  bool kisweb = false;
  bool show = false;
  String questionStr = "";
  bool optionSelected = false;
  bool isBookmarked = false;


  String getBase64OfQuestion(int userIdInt) {
    String userIdStr = "Question:" + userIdInt.toString();
    Codec<String, String> stringToBase64Url = utf8.fuse(base64Url);
    String encoded = stringToBase64Url.encode(userIdStr);

    /// print(encoded);
    return encoded;
  }


  void showCustomDialog(BuildContext context, String qid) async {
    print("i am called");

    String questionID = extractNumberFromUrlAndGetBase64(qid);
    log(questionID);
    http.Response apiResponce = await fetchDataFromGraphQL(questionID);
    Map<String, dynamic> data = json.decode(apiResponce.body);
    // for (var entry in data.entries) {
    //   print('${entry.key}: ${entry.value}');
    // }
    log("i am called twice");

    // print(data['questionDetails']['edges'][0]['exam'][])
    haveAccess
        ? showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              List<Color> colorList = [
                Colors.black,
                Colors.black,
                Colors.black,
                Colors.black,
              ];
              bool showExplanation = false;
              optionSelected = false;
              isAttemptResetApiSucceeded = false;
              isBookmarked =  data['data']['question']['bookmarkQuestion']!=null?true:false;
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return PointerInterceptor(
                    child: Dialog(
                      insetPadding: EdgeInsets.symmetric(horizontal: 10),
                      backgroundColor: Colors.white,
                      child: Container(
                        padding: EdgeInsets.zero,
                        margin: EdgeInsets.zero,
                        width: MediaQuery.of(context).size.width *
                            0.8, // Set the desired width
                        height: 700, // Set the desired height
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          show = false;
                                          setState(
                                            () {
                                              show = false;
                                              questionStr = "";
                                            },
                                          );
                                          Navigator.of(context).pop();
                                        },
                                        child: Icon(
                                          Icons.cancel,
                                          size: 25,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                    height:
                                        16),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(0, 242, 242, 242),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(16.0, 5.0, 16.0, 16.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            width: 100.0,
                                            height: 26.0,
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(0, 242, 242, 242),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                data['data']['question']['questionDetails']!=null &&  data['data']['question']['questionDetails']['edges']!=null && data['data']['question']['questionDetails']['edges'].isNotEmpty?
                                                Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
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
                                                            data['data']["question"]["questionDetails"]["edges"][0]["node"]["exam"]??"",
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
                                                            data['data']["question"]["questionDetails"]["edges"][0]["node"]["year"]
                                                                ?.toString() ??
                                                                "PYQ",
                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                              color: Colors.white,
                                                              fontSize: 12.0,
                                                              useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ):SizedBox(),
                                              ],
                                            ),
                                          ),
                                        ),
                                        (data['data']['question']['userAnswer'] !=
                                            null || optionSelected ) ?
                                        OutlinedButton(
                                          onPressed: () async{
                                            await resetUserSingleQuestionAttempt(questionID);
                                            setState((){
                                              optionSelected = false;
                                              showExplanation = false;
                                              isAttemptResetApiSucceeded = true;
                                              colorList = [
                                                Colors.black,
                                                Colors.black,
                                                Colors.black,
                                                Colors.black,
                                              ];
                                            });
                                            http.Response apiResponce = await fetchDataFromGraphQL(questionID);
                                            setState(()=> data = json.decode(apiResponce.body));

                                          },
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Color(0xffE6A123), side: BorderSide(color: Color(0xffE6A123)), // Border color
                                          ),
                                          child: Text('Reset Attempt'),
                                        ):Container(),
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                  borderRadius: BorderRadius.circular(8.0),
                                                  border: Border.all(
                                                    color: Color(0xFFF0F1F3),
                                                    width: 1.0,
                                                  ),
                                                ),
                                                child: Visibility(
                                                  visible: isBookmarked,
                                                  child: Padding(
                                                    padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
                                                    child: InkWell(
                                                      splashColor: Colors.transparent,
                                                      focusColor: Colors.transparent,
                                                      hoverColor: Colors.transparent,
                                                      highlightColor: Colors.transparent,
                                                      onTap: () async {
                                                        setState(() {
                                                          isBookmarked = false;
                                                        });
                                                        await PracticeGroup.createOrDeleteBookmarkForAPracticeQuestionByAUserCall.call(
                                                          questionId: questionID,
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
                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                  borderRadius: BorderRadius.circular(8.0),
                                                  border: Border.all(
                                                    color: Color(0xFFF0F1F3),
                                                    width: 1.0,
                                                  ),
                                                ),
                                                child: Visibility(
                                                  visible: !isBookmarked,
                                                  child: Padding(
                                                    padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
                                                    child: InkWell(
                                                      splashColor: Colors.transparent,
                                                      focusColor: Colors.transparent,
                                                      hoverColor: Colors.transparent,
                                                      highlightColor: Colors.transparent,
                                                      onTap: () async {
                                                        setState(() {
                                                          isBookmarked = true;

                                                        });
                                                        await PracticeGroup.createOrDeleteBookmarkForAPracticeQuestionByAUserCall.call(
                                                          questionId: questionID,
                                                          userId: functions.getBase64OfUserId(FFAppState().userIdInt),
                                                          authToken: FFAppState().subjectToken,
                                                        );
                                                        setState(() {});
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
                                        )



                                      ],
                                    ),
                                  ),
                                ),
                                Material(
                                  color: Colors.transparent,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                        color: Color(0xFFF0F1F3),
                                        width: 1.0,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 15.0,
                                          color: Color.fromARGB(16, 0, 0, 0),
                                          offset: Offset(0.0, 10.0),
                                        )
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: kIsWeb || Platform.isIOS ?HtmlQuestionWidget(
                                            questionHtmlStr: data['data']
                                                    ['question']['question'] +
                                                questionStr,
                                          ):Container(
                                            height: 350,
                                            child: AndroidWebView(
                                                html: data['data']
                                                ['question']['question']
                                            ),
                                          ),
                                        ),
                                        kIsWeb||Platform.isIOS?Positioned(
                                          right: 5,
                                          top: 5,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              border: Border.all(
                                                color: Color(0xFFF0F1F3),
                                                width: 1.0,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(5.0, 5.0, 5.0, 5.0),
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  print(data['ncert']);
                                                  questionStr =
                                                      "<span class=\"display_webview\"></span>";
                                                  setState(() {});
                                                },
                                                child: Icon(
                                                  Icons.refresh,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  size: 24.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ):SizedBox(),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10.0, 20.0, 11.0, 20.0),
                                  child: Builder(
                                    builder: (context) {
                                      return Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: List.generate(4,
                                            (optionNumbersIndex) {
                                          final options = data['data']
                                                  ['question']['options']
                                              [optionNumbersIndex];
                                          return Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(5.0, 0.0, 5.0, 0.0),
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  if (optionNumbersIndex ==
                                                      data['data']['question'][
                                                          'correctOptionIndex']) {
                                                    colorList[
                                                            optionNumbersIndex] =
                                                        Colors.green;
                                                    setState(() {});
                                                  } else {
                                                    colorList[data['data']
                                                                ['question'][
                                                            'correctOptionIndex']] =
                                                        Colors.green;

                                                    colorList[
                                                            optionNumbersIndex] =
                                                        Colors.red;
                                                    setState(() {});
                                                  }

                                                  log(colorList.toString());
                                                  setState((){
                                                    optionSelected = true;
                                                  });
                                                  await PracticeGroup
                                                      .createAnswerForAPracticeQuestionByAUserWithSpecificMarkedOptionCall
                                                      .call(
                                                    questionId: questionID,
                                                    userId: getBase64OfUserId(
                                                        FFAppState().userIdInt),
                                                    userAnswer:
                                                        optionNumbersIndex,
                                                    authToken: FFAppState()
                                                        .subjectToken,
                                                  );
                                                },
                                                child: Material(
                                                  color: Colors.transparent,
                                                  elevation: 2.0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  child: Container(
                                                    height: 50.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFFFfffff),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          blurRadius: 15.0,
                                                          color: Color.fromARGB(
                                                              14, 0, 0, 0),
                                                          offset:
                                                              Offset(0.0, 10.0),
                                                        )
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                      border: Border.all(
                                                        color: valueOrDefault<
                                                            Color>(
                                                          data['data']['question'][
                                                                      'userAnswer'] !=
                                                                  null
                                                              ? data['data']['question']
                                                                              ['userAnswer'][
                                                                          'userAnswer'] ==
                                                                      data['data']
                                                                              ['question'][
                                                                          'correctOptionIndex']
                                                                  ? data['data']['question']['userAnswer']['userAnswer'] ==
                                                                          optionNumbersIndex
                                                                      ? Colors
                                                                          .green
                                                                      : Colors
                                                                          .black
                                                                  : data['data']['question']['userAnswer']
                                                                              ['userAnswer'] ==
                                                                          optionNumbersIndex
                                                                      ? Colors.red
                                                                      : data['data']['question']['correctOptionIndex'] == optionNumbersIndex
                                                                          ? Colors.green
                                                                          : Colors.black
                                                              : colorList[optionNumbersIndex],
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .lineColor,
                                                        ),
                                                        width: 2.0,
                                                      ),
                                                    ),
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          options.toString(),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
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
                                              ),
                                            ),
                                          );
                                        }),
                                      );
                                    },
                                  ),
                                ),

                                (data['data']['question']['userAnswer'] !=
                                    null||optionSelected)?  Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 16.0, 0.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      setState(() {
                                        showExplanation = !showExplanation;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        border: Border.all(
                                          color: Color(0xFF252525),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            12.0, 8.0, 12.0, 8.0),
                                        child: Text(
                                          showExplanation
                                              ? 'Hide Explanation'
                                              : 'Show Explanation',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                fontSize: 12.0,
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
                                ):Container(),

                                ///
                                if (showExplanation)
                                  SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 16.0, 16.0, 16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              if ((String var1) {
                                                return !RegExp(
                                                        r'<(audio|iframe|table)\b[^>]*>')
                                                    .hasMatch(var1);
                                              }(data['data']['question']
                                                      ['explanation']
                                                  .toString()))
                                                Material(
                                                  color: Colors.transparent,
                                                  elevation: 0.0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      border: Border.all(
                                                        color:
                                                            Color(0xFFF0F1F3),
                                                        width: 1.0,
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          blurRadius: 15.0,
                                                          color: Color.fromARGB(
                                                              16, 0, 0, 0),
                                                          offset:
                                                              Offset(0.0, 10.0),
                                                        )
                                                      ],
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child:
                                                          CustomHtmlViewWidget(
                                                        questionStr: data[
                                                                        'data']
                                                                    ['question']
                                                                ['explanation']
                                                            .toString(),
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
                                              }(data['data']['question']
                                                      ['explanation']
                                                  .toString()))
                                                Material(
                                                  color: Colors.transparent,
                                                  elevation: 0.0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      border: Border.all(
                                                        color:
                                                            Color(0xFFF0F1F3),
                                                        width: 1.0,
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          blurRadius: 15.0,
                                                          color: Color.fromARGB(
                                                              16, 0, 0, 0),
                                                          offset:
                                                              Offset(0.0, 10.0),
                                                        )
                                                      ],
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 0, 0, 0),
                                                      child: custom_widgets
                                                          .CustomWebView(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                        height: 400,
                                                        src: data['data']
                                                                    ['question']
                                                                ['explanation']
                                                            .toString(),
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

                                ///
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          )
        : showDialog(
            context: context,
            builder: (BuildContext context) {
              return PointerInterceptor(
                child: AlertDialog(
                  actions: <Widget>[
                    SizedBox(
                      width: 340,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/lock_copy.png',
                              width: 130.0,
                              height: 130.0,
                              fit: BoxFit.cover,
                            ),
                            Text(
                              'You need to be enrolled in a course to access this section.',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color: Color(0xFF999999),
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily),
                                    lineHeight: 1.2,
                                  ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  context.pushNamed(
                                    'OrderPage',
                                    queryParameters: {
                                      'courseId': serializeParam(
                                        FFAppState().courseId,
                                        ParamType.String,
                                      ),
                                      'courseIdInt': serializeParam(
                                        FFAppState().courseIdInt.toString(),
                                        ParamType.String,
                                      ),
                                    }.withoutNulls,
                                  );
                                },
                                child: Container(
                                  width: 110.0,
                                  height: 35.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  alignment: AlignmentDirectional(0.00, 0.00),
                                  child: Text(
                                    'Buy Course',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: Colors.white,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.normal,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
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
                  ],
                ),
              );
            });
  }

  ///

  ///Android

  late final WebViewController _controller;

  //
  Future<void> initilize() async {
    ApiCallResponse response = await SignupGroup
        .loggedInUserInformationAndCourseAccessCheckingApiCall
        .call(
      authToken: FFAppState().subjectToken,
      courseIdInt: FFAppState().courseIdInt,
      altCourseIds: FFAppState().courseIdInts,
    );

      var courseStatusResponse =  SignupGroup.loggedInUserInformationAndCourseAccessCheckingApiCall.courseStatus(response.jsonBody);
      String? courseStatus =  courseStatusResponse[FFAppState().courseIdInt.toString()]?.toString().toUpperCase();
      String? altCourseStatus =  courseStatusResponse[FFAppState().altCourseIdInt.toString()]?.toString().toUpperCase();
      String? pyqMarkedNcertCourseStatus =  courseStatusResponse[FFAppState().pyqMarkedNcertCourseIdInt.toString()]?.toString().toUpperCase();
      String? incorrectMarkedNcertCourseStatus =  courseStatusResponse[FFAppState().incorrectMarkedNcertCourseIdInt.toString()]?.toString().toUpperCase();
      log(courseStatus.toString());
      if(courseStatus=="PAID"|| altCourseStatus=="PAID"||pyqMarkedNcertCourseStatus=="PAID"||incorrectMarkedNcertCourseStatus=="PAID") {
        haveAccess = true;
        log("true");
        setState(() {});
      }
    
    log(response.bodyText.toString());

    setState(() {});
  }

  Future<dynamic> fetchDataFromGraphQL(String questionId) async {
    final String apiUrl = '${FFAppState().baseUrl}/graphql';
    final String query = '''
    {
      question(id: "$questionId") {
        question
        correctOptionIndex
        explanation
        options
        userAnswer {
          userAnswer
        }
        bookmarkQuestion {
          userId
        }
        ncert
        questionDetails(last: 1) {
          edges { 
            node { 
               year 
               exam
             }
            }
          }
      }
    }
  ''';

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${FFAppState().subjectToken}',
    };

    final Map<String, String> queryParams = {
      'query': query,
    };

    final Uri uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);

    final http.Response response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      // Parse the response data
      final Map<String, dynamic> data = json.decode(response.body);
      data.forEach((key, value) {
        log('$key: $value');
      });

      // Log the parsed data

      // You can access specific fields like this:
      final String question = data['data']['question']['question'];
      final int correctOptionIndex =
          data['data']['question']['correctOptionIndex'];

      return response;

      // Use the data as needed
    } else {
      // Handle API error here
      log("API Error: ${response.statusCode}");
    }
  }

  Future<void> resetUserSingleQuestionAttempt(
      String questionId) async {
    try {
      Map<String, dynamic> requestBody = {
       'questionId':  base64DecodeString(questionId)
      };

      String requestBodyJson = jsonEncode(requestBody);
      String apiUrl = '${FFAppState().baseUrl}/api/v1/user/deleteUserSingleQuestionAttempt';

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + FFAppState().subjectToken,
      };

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: requestBodyJson,
      );



      if (response.statusCode == 200) {
        print('Request successful');
        print('Response: ${response.body}');
        Fluttertoast.showToast(
          msg: "Your attempt is reset successfully!",
        );
        isAttemptResetApiSucceeded = true;
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Response: ${response.body}');
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        String message = jsonResponse['message'];
        Fluttertoast.showToast(
          msg: message,
        );
      }
    } catch (error) {
      print('Error making the request: $error');
      Fluttertoast.showToast(msg: "Some Error Occurred");
    }
  }

  String getBase64forQuestion(String courseId) {
    String courseIdStr = "Question:" + courseId;
    Codec<String, String> stringToBase64Url = utf8.fuse(base64Url);
    String encoded = stringToBase64Url.encode(courseIdStr);

    /// print(encoded);
    return encoded;
  }

  String? getBase64OfUserId(int userIdInt) {
    String userIdStr = "User:" + userIdInt.toString();
    Codec<String, String> stringToBase64Url = utf8.fuse(base64Url);
    String encoded = stringToBase64Url.encode(userIdStr);

    /// print(encoded);
    return encoded;
  }

  String base64DecodeString(String base64EncodedString) {
    List<int> bytes = base64.decode(base64EncodedString);
    String decodedString = utf8.decode(bytes);
    print(decodedString);
    String issueNum  = decodedString.split(":")[1];
    return issueNum;
  }


  String extractNumberFromUrlAndGetBase64(String url) {
    // Split the URL by '/'
    final List<String> urlParts = url.split('/');

    // Get the last part of the URL, which should be the number
    final String lastPart = urlParts.last;

    log("last numbers are $lastPart");

    // Try to parse the last part as an integer
    try {
      log("base 64 is ${getBase64forQuestion(lastPart)}");

      return getBase64forQuestion(lastPart);
    } catch (e) {
      // Handle parsing errors here
      log("error whil converting the number to base 64");
      return "ERROR"; // Return a default value or handle the error accordingly
    }
  }

  Future<void> setTokenCookie() async {
    final cookieManager = CookieManager.instance();

    await cookieManager.setCookie(
      url: WebUri(widget.webUrl), // Set cookie for this URL
      name: "id_token", // Cookie name
      value: FFAppState().subjectToken, // The token to set
      domain: "www.neetprep.com", // The domain for the cookie
      isSecure: true, // Use secure if the domain is https
      isHttpOnly: true, // Cookie is only accessible via HTTP
    );
  }


  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "NCERTAnnotation",);
    CleverTapService.recordPageView("NCERTAnnotation Opened");
    initilize();
if(kIsWeb){
  setTokenCookie();
}
    if (!kIsWeb) {
      WebViewCookieManager().clearCookies();
      WebViewCookieManager().setCookie(
        WebViewCookie(
          name: 'id_token',
          value: '${FFAppState().subjectToken}',
          domain: 'www.neetprep.com',
        ),
      );
      late final PlatformWebViewControllerCreationParams params;
      if (WebViewPlatform.instance is WebKitWebViewPlatform) {
        params = WebKitWebViewControllerCreationParams(
          allowsInlineMediaPlayback: true,
          mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
        );
      } else {
        params = const PlatformWebViewControllerCreationParams();
      }

      final WebViewController controller =
      WebViewController.fromPlatformCreationParams(params);
      // #enddocregion platform_features

      controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              debugPrint('WebView is loading (progress : $progress%)');
            },
            onPageStarted: (String url) {
              debugPrint('Page started loading: $url');
            },
            onPageFinished: (String url) {
              debugPrint('Page finished loading: $url');
            },
            onWebResourceError: (Android.WebResourceError error) {
              debugPrint('''
            Page resource error:
            code: ${error.errorCode}
            description: ${error.description}s
            errorType: ${error.errorType}
            isForMainFrame: ${error.isForMainFrame}
          ''');
            },
            onNavigationRequest: (NavigationRequest request) async {
              if (request.url.contains('/epubQuestion')) {
                String questionID =
                extractNumberFromUrlAndGetBase64(request.url);
                log(questionID);
                http.Response apiResponce =
                await fetchDataFromGraphQL(questionID);
                Map<String, dynamic> data = json.decode(apiResponce.body);
                haveAccess
                    ? showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    List<Color> colorList = [
                      Colors.black,
                      Colors.black,
                      Colors.black,
                      Colors.black,
                    ];

                    bool showExplanation = false;
                    optionSelected = false;
                    isAttemptResetApiSucceeded = false;
                    isBookmarked =  data['data']['question']['bookmarkQuestion']!=null?true:false;
                    return StatefulBuilder(
                      builder:
                          (BuildContext context, StateSetter setState) {
                        return Dialog(
                          insetPadding:
                          EdgeInsets.symmetric(horizontal: 10),
                          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                          child: Container(
                            padding: EdgeInsets.zero,
                            margin: EdgeInsets.zero,
                            width: 360, // Set the desired width
                            height: 700, // Set the desired height
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                          const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Icon(
                                              Icons.cancel,
                                              size: 25,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                        16),
                                    Container(
                                      decoration: BoxDecoration(
                                        color:  FlutterFlowTheme.of(context).secondaryBackground,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(16.0, 5.0, 16.0, 16.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                width: 100.0,
                                                height: 26.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    data['data']['question']['questionDetails']!=null &&  data['data']['question']['questionDetails']['edges']!=null && data['data']['question']['questionDetails']['edges'].isNotEmpty?
                                                    Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
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
                                                                data['data']["question"]["questionDetails"]["edges"][0]["node"]["exam"]??"",
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
                                                                data['data']["question"]["questionDetails"]["edges"][0]["node"]["year"]
                                                                    ?.toString() ??
                                                                    "PYQ",
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
                                                    ):SizedBox()
                                                  ],
                                                ),
                                              ),
                                            ),
                                             (data['data']['question']['userAnswer'] !=
                                                null || optionSelected ) ?
                                            OutlinedButton(
                                              onPressed: () async{
                                                await resetUserSingleQuestionAttempt(questionID);
                                                setState((){
                                                  optionSelected = false;
                                                  showExplanation = false;
                                                  isAttemptResetApiSucceeded = true;
                                                  colorList = [
                                                    Colors.black,
                                                    Colors.black,
                                                    Colors.black,
                                                    Colors.black,
                                                  ];
                                                });
                                                http.Response apiResponce = await fetchDataFromGraphQL(questionID);
                                                setState(()=> data = json.decode(apiResponce.body));

                                              },
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: Color(0xffE6A123), side: BorderSide(color: Color(0xffE6A123)), // Border color
                                              ),
                                              child: Text('Reset Attempt'),
                                            ):Container(),
                                            Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                                      borderRadius: BorderRadius.circular(8.0),
                                                      border: Border.all(
                                                        color: Color(0xFFF0F1F3),
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                    child: Visibility(
                                                      visible: isBookmarked,
                                                      child: Padding(
                                                        padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
                                                        child: InkWell(
                                                          splashColor: Colors.transparent,
                                                          focusColor: Colors.transparent,
                                                          hoverColor: Colors.transparent,
                                                          highlightColor: Colors.transparent,
                                                          onTap: () async {
                                                            setState(() {
                                                              isBookmarked = false;
                                                            });
                                                            await PracticeGroup.createOrDeleteBookmarkForAPracticeQuestionByAUserCall.call(
                                                              questionId: questionID,
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
                                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                                      borderRadius: BorderRadius.circular(8.0),
                                                      border: Border.all(
                                                        color: Color(0xFFF0F1F3),
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                    child: Visibility(
                                                      visible: !isBookmarked,
                                                      child: Padding(
                                                        padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
                                                        child: InkWell(
                                                          splashColor: Colors.transparent,
                                                          focusColor: Colors.transparent,
                                                          hoverColor: Colors.transparent,
                                                          highlightColor: Colors.transparent,
                                                          onTap: () async {
                                                            setState(() {
                                                              isBookmarked = true;

                                                            });
                                                            await PracticeGroup.createOrDeleteBookmarkForAPracticeQuestionByAUserCall.call(
                                                              questionId: questionID,
                                                              userId: functions.getBase64OfUserId(FFAppState().userIdInt),
                                                              authToken: FFAppState().subjectToken,
                                                            );
                                                            setState(() {});
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
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Material(
                                      color: Colors.transparent,
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(12.0),
                                      ),
                                      child: Container(
                                        width: 350,
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color:
                                          FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          borderRadius:
                                          BorderRadius.circular(8.0),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                            width: 1.0,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 15.0,
                                              color: Color.fromARGB(
                                                  16, 0, 0, 0),
                                              offset: Offset(0.0, 10.0),
                                            )
                                          ],
                                        ),
                                        child: Stack(
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(5),
                                              child:  kIsWeb || Platform.isIOS ?HtmlQuestionWidget(
                                                questionHtmlStr: data['data']
                                                ['question']['question'] +
                                                    questionStr,
                                              ):Container(
                                                height: 350,
                                                child: AndroidWebView(
                                                    html: data['data']
                                                    ['question']['question']
                                                ),
                                              )
                                            ),
                                            kIsWeb||Platform.isIOS?
                                           Positioned(
                                              right: 5,
                                              top: 5,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme
                                                      .of(context)
                                                      .secondaryBackground,
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(8.0),
                                                  border: Border.all(
                                                    color:
                                                    Color(0xFFF0F1F3),
                                                    width: 1.0,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      5.0,
                                                      5.0,
                                                      5.0,
                                                      5.0),
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
                                                      questionStr =
                                                      "<span class=\"display_webview\"></span>";
                                                      setState(() {});
                                                    },
                                                    child: Icon(
                                                      Icons.refresh,
                                                      color: FlutterFlowTheme
                                                          .of(context)
                                                          .primaryText,
                                                      size: 24.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ):SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          10.0, 20.0, 11.0, 20.0),
                                      child: Builder(
                                        builder: (context) {
                                          return Row(
                                            mainAxisSize:
                                            MainAxisSize.max,
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceEvenly,
                                            children: List.generate(4,
                                                    (optionNumbersIndex) {
                                                  final options = data['data']
                                                  ['question']
                                                  ['options']
                                                  [optionNumbersIndex];
                                                  return Expanded(
                                                    child: Padding(
                                                      padding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          5.0,
                                                          0.0,
                                                          5.0,
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
                                                          if (optionNumbersIndex ==
                                                              data['data'][
                                                              'question']
                                                              [
                                                              'correctOptionIndex']) {
                                                            colorList[
                                                            optionNumbersIndex] =
                                                                Colors.green;
                                                            setState(() {});
                                                          } else {
                                                            colorList[data['data']
                                                            [
                                                            'question']
                                                            [
                                                            'correctOptionIndex']] =
                                                                Colors.green;

                                                            colorList[
                                                            optionNumbersIndex] =
                                                                Colors.red;
                                                            setState(() {});
                                                          }

                                                          log(colorList
                                                              .toString());
                                                          print(data.toString());
                                                          setState((){
                                                            optionSelected = true;
                                                          });

                                                          await PracticeGroup
                                                              .createAnswerForAPracticeQuestionByAUserWithSpecificMarkedOptionCall
                                                              .call(
                                                            questionId:
                                                            questionID,
                                                            userId: getBase64OfUserId(
                                                                FFAppState()
                                                                    .userIdInt),
                                                            userAnswer:
                                                            optionNumbersIndex,
                                                            authToken:
                                                            FFAppState()
                                                                .subjectToken,
                                                          );
                                                        },
                                                        child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          elevation: 2.0,
                                                          shape:
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                12.0),
                                                          ),
                                                          child: Container(
                                                            height: 50.0,
                                                            decoration:
                                                            BoxDecoration(
                                                              color: FlutterFlowTheme.of(context).tertiaryBackground,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  blurRadius:
                                                                  15.0,
                                                                  color: Color
                                                                      .fromARGB(
                                                                      14,
                                                                      0,
                                                                      0,
                                                                      0),
                                                                  offset:
                                                                  Offset(
                                                                      0.0,
                                                                      10.0),
                                                                )
                                                              ],
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  12.0),
                                                              border:
                                                              Border.all(
                                                                color:
                                                                valueOrDefault<
                                                                    Color>(
                                                                  data['data']['question']['userAnswer'] !=
                                                                      null
                                                                      ? data['data']['question']['userAnswer']['userAnswer'] ==
                                                                      data['data']['question']['correctOptionIndex']
                                                                      ? data['data']['question']['userAnswer']['userAnswer'] == optionNumbersIndex
                                                                      ? Colors.green
                                                                      : Colors.black
                                                                      : data['data']['question']['userAnswer']['userAnswer'] == optionNumbersIndex
                                                                      ? Colors.red
                                                                      : data['data']['question']['correctOptionIndex'] == optionNumbersIndex
                                                                      ? Colors.green
                                                                      : Colors.black
                                                                      : colorList[optionNumbersIndex],
                                                                  FlutterFlowTheme.of(
                                                                      context)
                                                                      .lineColor,
                                                                ),
                                                                width: 2.0,
                                                              ),
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
                                                                  .center,
                                                              children: [
                                                                Text(
                                                                  options
                                                                      .toString(),
                                                                  style: FlutterFlowTheme.of(
                                                                      context)
                                                                      .bodyMedium
                                                                      .override(
                                                                    fontFamily:
                                                                    FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                    color:
                                                                    FlutterFlowTheme.of(context).primaryText,
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
                                                    ),
                                                  );
                                                }),
                                          );
                                        },
                                      ),
                                    )
                                    ,
                                    (data['data']['question']['userAnswer'] !=
                                        null||optionSelected) ? Padding(
                                      padding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 16.0, 0.0),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor:
                                        Colors.transparent,
                                        onTap: () async {
                                          setState(() {
                                            showExplanation =
                                            !showExplanation;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(
                                                context)
                                                .tertiaryBackground,
                                            borderRadius:
                                            BorderRadius.circular(
                                                10.0),
                                            border: Border.all(
                                              color: Color(0xFF252525),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsetsDirectional
                                                .fromSTEB(
                                                12.0, 8.0, 12.0, 8.0),
                                            child: Text(
                                              showExplanation
                                                  ? 'Hide Explanation'
                                                  : 'Show Explanation',
                                              style: FlutterFlowTheme.of(
                                                  context)
                                                  .bodyMedium
                                                  .override(
                                                fontFamily:
                                                FlutterFlowTheme.of(
                                                    context)
                                                    .bodyMediumFamily,
                                                fontSize: 12.0,
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
                                    ):Container(),
                                    if (showExplanation)
                                      Padding(
                                        padding: EdgeInsetsDirectional
                                            .fromSTEB(
                                            16.0, 16.0, 16.0, 16.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            if ((String var1) {
                                              return !RegExp(
                                                  r'<(audio|iframe|table)\b[^>]*>')
                                                  .hasMatch(var1);
                                            }(data['data']['question']
                                            ['explanation']
                                                .toString()))
                                              Material(
                                                color: Colors.transparent,
                                                elevation: 0.0,
                                                shape:
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(12.0),
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
                                                        8.0),
                                                    border: Border.all(
                                                      color:FlutterFlowTheme
                                                          .of(context)
                                                          .secondaryBackground ,
                                                      width: 1.0,
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        blurRadius: 15.0,
                                                        color: Color
                                                            .fromARGB(16,
                                                            0, 0, 0),
                                                        offset: Offset(
                                                            0.0, 10.0),
                                                      )
                                                    ],
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .all(8.0),
                                                    child:
                                                    CustomHtmlViewWidget(
                                                      questionStr: data[
                                                      'data']
                                                      [
                                                      'question']
                                                      [
                                                      'explanation']
                                                          .toString(),
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
                                            }(data['data']['question']
                                            ['explanation']
                                                .toString()))
                                              Material(
                                                color: Colors.transparent,
                                                elevation: 0.0,
                                                shape:
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(12.0),
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
                                                        8.0),
                                                    border: Border.all(
                                                      color: FlutterFlowTheme
                                                          .of(context)
                                                          .secondaryBackground,
                                                      width: 1.0,
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        blurRadius: 15.0,
                                                        color: Color
                                                            .fromARGB(16,
                                                            0, 0, 0),
                                                        offset: Offset(
                                                            0.0, 10.0),
                                                      )
                                                    ],
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(0,
                                                        0, 0, 0),
                                                    child: custom_widgets
                                                        .CustomWebView(
                                                      width: MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width *
                                                          0.9,
                                                      height: 400,
                                                      src: data['data'][
                                                      'question']
                                                      [
                                                      'explanation']
                                                          .toString(),
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
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
                    : showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      actions: <Widget>[
                        SizedBox(
                          width: 340,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/lock_copy.png',
                                  width: 130.0,
                                  height: 130.0,
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  'You need to be enrolled in a course to access this section.',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                    fontFamily:
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color: Color(0xFF999999),
                                    useGoogleFonts: GoogleFonts
                                        .asMap()
                                        .containsKey(
                                        FlutterFlowTheme.of(
                                            context)
                                            .bodyMediumFamily),
                                    lineHeight: 1.2,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      context.pushNamed(
                                        'OrderPage',
                                        queryParameters: {
                                          'courseId': serializeParam(
                                            FFAppState().courseId,
                                            ParamType.String,
                                          ),
                                          'courseIdInt': serializeParam(
                                            FFAppState()
                                                .courseIdInt
                                                .toString(),
                                            ParamType.String,
                                          ),
                                        }.withoutNulls,
                                      );
                                    },
                                    child: Container(
                                      width: 110.0,
                                      height: 35.0,
                                      decoration: BoxDecoration(
                                        color:
                                        FlutterFlowTheme.of(context)
                                            .primary,
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      alignment: AlignmentDirectional(
                                          0.00, 0.00),
                                      child: Text(
                                        'Buy Course',
                                        style:
                                        FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                          fontFamily:
                                          FlutterFlowTheme.of(
                                              context)
                                              .bodyMediumFamily,
                                          color: Colors.white,
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
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
                log('blocking navigation to ${request.url}');
                return NavigationDecision.prevent;
              }
              debugPrint('allowing navigation to ${request.url}');
              return NavigationDecision.navigate;
            },
            onUrlChange: (UrlChange change) {
              if (change.url!.contains('/epubQuestion')) {
                controller.setNavigationDelegate(NavigationDelegate(
                  onNavigationRequest: (request) {
                    if (request.url.contains('/epubQuestion')) {
                      return NavigationDecision.prevent;
                    }
                    debugPrint('allowing navigation to ${request.url}');
                    return NavigationDecision.navigate;
                  },
                ));
              }
              debugPrint('url change to ${change.url}');
            },
          ),
        )
        ..addJavaScriptChannel(
          'Toaster',
          onMessageReceived: (JavaScriptMessage message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message.message)),
            );
          },
        )
        ..setUserAgent(kIsWeb? "WebView/web/Essential/342":Platform.isIOS?"WebView/ios/Essential/342" :"WebView/android/Essential/123")
        ..loadRequest(
          Uri.parse(
              '${widget.webUrl}&id_token=${Uri.encodeComponent(FFAppState().subjectToken)}&android=${kIsWeb ? 0 : 1}&embed=1'),
           // '  FFAppState().baseUrl/ncert-book?embed=1&id_token=${Uri.encodeComponent(FFAppState().subjectToken)}&android=${kIsWeb ? 0 : 1}'),
        );



      // #docregion platform_features
      if (controller.platform is AndroidWebViewController) {
        AndroidWebViewController.enableDebugging(true);
        (controller.platform as AndroidWebViewController)
            .setMediaPlaybackRequiresUserGesture(false);
      }
      // #enddocregion platform_features

      _controller = controller;
    } else {
      print("making context");
      contextMenu = ContextMenu(
          menuItems: [
            ContextMenuItem(
                id: 1,
                title: "Special",
                action: () async {
                  print("Menu item Special clicked!");
                  print(await webViewController?.getSelectedText());
                  await webViewController?.clearFocus();
                })
          ],
          settings:
          ContextMenuSettings(hideDefaultSystemContextMenuItems: false),
          onCreateContextMenu: (hitTestResult) async {
            print("onCreateContextMenu");
            print(hitTestResult.extra);
            print(await webViewController?.getSelectedText());
          },
          onHideContextMenu: () {
            print("onHideContextMenu");
          },
          onContextMenuActionItemClicked: (contextMenuItemClicked) async {
            var id = contextMenuItemClicked.id;
            print("onContextMenuActionItemClicked: " +
                id.toString() +
                " " +
                contextMenuItemClicked.title);
          });

      if (kIsWeb) {

        html.window.onMessage.listen((event) async {
          try {
            var datum = event.data;
            print("Received snapshot.data: $datum");

            // Assuming that snapshot.data is already in JSON format
            final Map<String, dynamic> maps = jsonDecode(datum);

            maps.forEach((key, value) async {
              print('$key: $value');
              if (!show) {

                showCustomDialog(context, value.toString());
                show = true;
                setState(() {});
              }
            });
          } catch (e) {
            print("Error processing snapshot.data: $e");
          }
        });



        html.window.onMessage.listen((event) {
          // Process the data sent from JavaScript
          final data = event.data;

          // Check if the data matches the expected value for navigation
          if (data == 'navigateToNewScreen') {
            // Navigate to the new Flutter screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PracticeChapterPageWidget()),
            );
          }
        });

      }
    }

  }

  bool _isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        drawer: DrawerWidget(DrawerStrings.ncertAnnotation),
        onDrawerChanged: (isOpen) {
          setState(() {
            _isDrawerOpen = isOpen; // Update drawer state
          });
        },
        appBar: AppBar(
          iconTheme: IconThemeData(color: FlutterFlowTheme.of(context).accent1),
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          // automaticallyImplyLeading: false,
          // leading: FlutterFlowIconButton(
          //   borderColor: Colors.transparent,
          //   borderRadius: 30.0,
          //   borderWidth: 1.0,
          //   buttonSize: 60.0,
          //   icon: Icon(
          //     Icons.arrow_back_rounded,
          //     color: FlutterFlowTheme.of(context).primaryText,
          //     size: 24.0,
          //   ),
          //   onPressed: () async {
          //     if (!kIsWeb) {
          //       if (await _controller.canGoBack()) {
          //         await _controller.goBack();
          //       } else {
          //         // FFAppState().annotationVisibility = false;
          //         context.goNamed('PracticeChapterWisePage');
          //       }
          //     } else {
          //
          //       // context.pop();
          //       // if (await webViewController?.canGoBack() ?? false) {
          //       //   webViewController?.goBack();
          //       // } else {
          //       //   context.pop();
          //       // }
          //       if (await webViewController?.canGoBack() ?? false) {
          //         print("1111");
          //         webViewController?.goBack();
          //       } else {
          //         print("2222");
          //         // context.pop();
          //         //Navigator.pop(context);
          //         context.goNamed('PracticeChapterWisePage');
          //       }
          //       print("working");
          //     }
          //   },
          // ),
          title: Align(
            alignment: AlignmentDirectional(-0.35, 0.2),
            child: Text(
              widget.title=="P+C+B"? 'PYQ Marked NCERT':widget.title,
              textAlign: TextAlign.start,
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily:
                        FlutterFlowTheme.of(context).headlineMediumFamily,
                    color:FlutterFlowTheme.of(context).primaryText,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700,
                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                        FlutterFlowTheme.of(context).headlineMediumFamily),
                  ),
            ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: kIsWeb
            ? InAppWebView(
                key: webViewKey,
                initialUrlRequest: URLRequest(
                    url: WebUri(
                        '${widget.webUrl}&id_token=${Uri.encodeComponent(FFAppState().subjectToken)}&android=${kIsWeb ? 0 : 1}')),
                initialUserScripts: UnmodifiableListView<UserScript>([]),
                initialSettings: settings,
                contextMenu: contextMenu,
                onWebViewCreated: (controller) async {
                  webViewController = controller;
                },
                onLoadStart: (controller, url) async {
                  setState(() {
                    this.url = url.toString();
                    urlController.text = this.url;
                  });
                },
                onPermissionRequest: (controller, request) async {
                  return PermissionResponse(
                      resources: request.resources,
                      action: PermissionResponseAction.GRANT);
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  var uri = navigationAction.request.url!;

                  return NavigationActionPolicy.ALLOW;
                },
                onLoadStop: (controller, url) async {
                  setState(() {
                    this.url = url.toString();
                    urlController.text = this.url;
                  });
                },
                onReceivedError: (controller, request, error) {},
                onProgressChanged: (controller, progress) {
                  if (progress == 100) {}
                  setState(() {
                    urlController.text = this.url;
                  });
                },
                onUpdateVisitedHistory: (controller, url, isReload) {
                  setState(() {
                    this.url = url.toString();
                    urlController.text = this.url;
                  });
                },
                onConsoleMessage: (controller, consoleMessage) {
                  print(consoleMessage);
                },
              )
            : WebViewWidget(controller: _controller,));
  }
}
