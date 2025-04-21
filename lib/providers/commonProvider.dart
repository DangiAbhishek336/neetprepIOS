import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neetprep_essential/backend/api_requests/api_calls.dart';
import 'package:provider/provider.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:http/http.dart' as http;
import '../app_state.dart';
import '../auth/firebase_auth/auth_util.dart';
import '../flutter_flow/flutter_flow_theme.dart';

class CommonProvider extends ChangeNotifier {
  TextEditingController feedbackTextController = new TextEditingController();
  bool isFilePresent = false;
  String? fileName;
  String? filePath;
  Uint8List? fileBytes;
  bool isFeedbackSubmitted = false;
  final GlobalKey feedbackSubmitToolTipKey = GlobalKey();
  double _sizeKbs = 0;
  final int maxSizeKbs = 10000;

  Future<void> showEnableScreenshotCaptureBottomSheet(context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext builder) {
        return StatefulBuilder(builder: (context, setState) {
          return Consumer<CommonProvider>(
              builder: (context, commonProvider, child) {
            return Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          FFAppState().isScreenshotCaptureDisabled = true;
                          notifyListeners();
                        },
                        child: SvgPicture.asset(
                            'assets/images/close_circle.svg',
                            fit: BoxFit.none,
                            color: FlutterFlowTheme.of(context).primaryText),
                      )
                    ]),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8, top: 8.0),
                      child: SvgPicture.asset("assets/images/message.svg"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8, top: 8.0),
                      child: Text(
                        "Feedback | Support",
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w700,
                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                  FlutterFlowTheme.of(context)
                                      .bodyMediumFamily),
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 0.0),
                      child: Text(
                        "Encountered an issue?",
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              fontSize: 14.0,
                              color: FlutterFlowTheme.of(context).accent1,
                              fontWeight: FontWeight.w400,
                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                  FlutterFlowTheme.of(context)
                                      .bodyMediumFamily),
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 20),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Simply click ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    fontWeight: FontWeight.w400,
                                    color: FlutterFlowTheme.of(context).accent1,
                                    fontSize: 14.0,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily),
                                  ),
                            ),
                            TextSpan(
                              text: "'Okay' ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    fontWeight: FontWeight.w700,
                                    color: FlutterFlowTheme.of(context).accent1,
                                    fontSize: 14.0,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily),
                                  ),
                            ),
                            TextSpan(
                              text:
                                  "to capture a screen recording or screenshot, then submit your feedback directly in the app or email us at supportabhyas@neetprep.com.\n\nWe'll tackle and resolve your issue swiftly!",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    fontWeight: FontWeight.w400,
                                    color: FlutterFlowTheme.of(context).accent1,
                                    fontSize: 14.0,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily),
                                  ),
                            ),
                          ],
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            onPressed: () async {
                              FFAppState().isScreenshotCaptureDisabled = false;
                              print(FFAppState().isScreenshotCaptureDisabled);
                              commonProvider.notifyListeners();
                              Navigator.of(context).pop();
                              await ScreenProtector.preventScreenshotOff();
                              isFeedbackSubmitted = false;
                              Timer(Duration(minutes: 10), () {
                                FFAppState().isScreenshotCaptureDisabled = true;
                                FFAppState().showFeedbackSubmitTooltip = true;
                                ScreenProtector.preventScreenshotOn();
                                commonProvider.notifyListeners();
                              });

                              commonProvider.notifyListeners();
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              elevation: 5,
                              backgroundColor:
                                  FlutterFlowTheme.of(context).primary,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Border radius
                              ),
                            ),
                            child: Text('Okay',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily),
                                    ))),
                      ),
                    ),
                  ],
                ));
          });
        });
      },
    );
  }

  void showFeedBackFormBottomSheet(context) async {
    filePath = "";
    fileName = "";
    fileBytes = null;
    feedbackTextController.clear();
    notifyListeners();
    await showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: false,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Consumer<CommonProvider>(
              builder: (context, commonProvider, child) {
            return SingleChildScrollView(
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 20),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: SvgPicture.asset(
                                  'assets/images/close_circle.svg',
                                  fit: BoxFit.none,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText),
                            ),
                          ],
                        ),
                        SvgPicture.asset(
                          'assets/images/message.svg',
                          fit: BoxFit.none,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Feedback | Support",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w700,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                ),
                              ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 20),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "We wish you to be a part of improving the NEET Essential experience. Please tell us in a brief about the bugs would might have faced with the app and the website version. Also mention areas of ",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        fontWeight: FontWeight.w400,
                                        color: FlutterFlowTheme.of(context)
                                            .accent1,
                                        fontSize: 14.0,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                ),
                                TextSpan(
                                  text: " improvements",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        fontWeight: FontWeight.w700,
                                        color: FlutterFlowTheme.of(context)
                                            .accent1,
                                        fontSize: 14.0,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                ),
                                TextSpan(
                                  text: " you wish to see in future?\n\n",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        fontWeight: FontWeight.w400,
                                        color: FlutterFlowTheme.of(context)
                                            .accent1,
                                        fontSize: 14.0,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                ),
                                TextSpan(
                                  text: "Note: ",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        fontWeight: FontWeight.w700,
                                        color: FlutterFlowTheme.of(context)
                                            .accent1,
                                        fontSize: 14.0,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                ),
                                TextSpan(
                                  text:
                                      "For refund requests, please email us directly at ",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        fontWeight: FontWeight.w400,
                                        color: FlutterFlowTheme.of(context)
                                            .accent1,
                                        fontSize: 14.0,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                ),
                                TextSpan(
                                  text: "supportabhyas@neetprep.com",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        fontWeight: FontWeight.w700,
                                        color: FlutterFlowTheme.of(context)
                                            .accent1,
                                        fontSize: 14.0,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                ),
                                TextSpan(
                                  text:
                                      ". Use the feedback flow for submitting feedback only.",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        fontWeight: FontWeight.w400,
                                        color: FlutterFlowTheme.of(context)
                                            .accent1,
                                        fontSize: 14.0,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                ),
                              ],
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: feedbackTextController,
                          autofocus: false,
                          obscureText: false,
                          onEditingComplete: () {},
                          onTapOutside: (_) {},
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                            labelStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  color: FlutterFlowTheme.of(context).accent1,
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  fontWeight: FontWeight.normal,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .bodyMediumFamily),
                                ),
                            hintText: 'Write your Feedback | Support here ...',
                            hintStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  color: FlutterFlowTheme.of(context).accent1,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .bodyMediumFamily),
                                ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).accent1,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                          maxLines: 10,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value != null && value.trim().isEmpty) {
                              return 'Please write your feedback here';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15),
                        isFilePresent &&
                                ((!kIsWeb && filePath != "") ||
                                    (kIsWeb && fileBytes != null))
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.file_copy_outlined,
                                        color: FlutterFlowTheme.of(context)
                                            .accent1,
                                        size: 20,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        fileName!,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontSize: 14,
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .accent1,
                                              fontWeight: FontWeight.w400,
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
                                  InkWell(
                                    onTap: () {
                                      if (filePath!.isEmpty) {
                                        isFilePresent = false;
                                      }
                                      fileName = "";
                                      filePath = "";
                                      setState(() {});
                                    },
                                    child: Icon(
                                      Icons.close,
                                      size: 20,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                    ),
                                  )
                                ],
                              )
                            : GestureDetector(
                                onTap: () async {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles(
                                          type: FileType.custom,
                                          allowMultiple: false,
                                          allowedExtensions: [
                                        'bmp',
                                        'gif',
                                        'jpeg',
                                        'jpg',
                                        'png',
                                        'heic',
                                        'avi',
                                        'flv',
                                        'mkv',
                                        'mov',
                                        'mp4',
                                        'mpeg',
                                        'webm',
                                        'wmv'
                                      ]);

                                  if (result != null) {
                                    if (!kIsWeb) {
                                      PlatformFile file = result.files.first;
                                      if (file.path!.isNotEmpty) {
                                        final size = result.files.first.size;
                                        _sizeKbs = size / 1024;
                                        print(_sizeKbs.toString() + "_sizeKbs");
                                        print(maxSizeKbs.toString() +
                                            "maxSizeKbs");
                                        if (_sizeKbs > maxSizeKbs) {
                                          print(
                                              'size should be less than $maxSizeKbs Kb');
                                          Fluttertoast.showToast(
                                              msg:
                                                  " File size should be less than 10 MB");
                                        } else {
                                          filePath = file.path!;
                                          fileName = file.name;
                                          isFilePresent = true;
                                        }
                                      } else {
                                        isFilePresent = false;
                                      }
                                    } else {
                                      final size = result.files.first.size;
                                      _sizeKbs = size / 1024;
                                      print(_sizeKbs.toString() + "_sizeKbs");
                                      print(
                                          maxSizeKbs.toString() + "maxSizeKbs");
                                      if (_sizeKbs > maxSizeKbs) {
                                        print(
                                            'size should be less than $maxSizeKbs Kb');
                                        Fluttertoast.showToast(
                                            msg:
                                                " File size should be less than 10 MB");
                                        notifyListeners();
                                      } else {
                                        fileBytes = result.files.first.bytes;
                                        fileName = result.files.first.name;
                                      }

                                      if (fileName!.isNotEmpty) {
                                        isFilePresent = true;
                                      } else {
                                        isFilePresent = false;
                                      }
                                    }
                                  }
                                  notifyListeners();
                                  setState(() {});
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Color(0xffe9e9e9)),
                                    // Border styling
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: TextFormField(
                                    autofocus: false,
                                    obscureText: false,
                                    onEditingComplete: () {},
                                    onTapOutside: (_) {},
                                    enabled: false,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily),
                                          ),
                                      hintText: 'Upload Documents | Images',
                                      suffixIcon: Icon(Icons.upload_file_sharp),
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            color: FlutterFlowTheme.of(context)
                                                .accent1,
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily),
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .accent1,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: FlutterFlowTheme.of(context)
                                              .accent1,
                                          fontWeight: FontWeight.normal,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                        ),
                                    validator: (value) {
                                      if (value != null &&
                                          value.trim().isEmpty) {
                                        return 'Please enter your feedback here';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                                onPressed: () async {
                                  if (feedbackTextController.text.isNotEmpty) {
                                    bool result = await feedbackSupportApi(
                                        content: feedbackTextController.text
                                            .toString(),
                                        phone: FFAppState().phoneNum,
                                        issueType: "ESSENTIAL_FEEDBACK",
                                        email: currentUserEmail,
                                        userData: FFAppState().deviceData,
                                        imageUrlPath: filePath!,
                                        bytes: fileBytes,
                                        token: FFAppState().subjectToken,
                                        fileName: fileName!);
                                    if (result == true) {
                                      Navigator.pop(context);
                                      isFeedbackSubmitted = true;
                                      await ScreenProtector
                                          .preventScreenshotOn();
                                      showThankYouBottomSheet(context);
                                      FFAppState().isScreenshotCaptureDisabled =
                                          true;
                                      notifyListeners();
                                    } else {
                                      Navigator.pop(context);
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Please write your feedback");
                                  }

                                  return;
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  backgroundColor:
                                      FlutterFlowTheme.of(context).primary,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Border radius
                                  ),
                                ),
                                child: Text('Submit',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          fontWeight: FontWeight.w700,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 14.0,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                        ))),
                          ),
                        ),
                      ]),
                ),
              ),
            );
          });
        });
      },
    );
  }

  void showThankYouBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext builder) {
        return Consumer<CommonProvider>(
            builder: (context, commonProvider, child) {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset('assets/images/close_circle.svg',
                        fit: BoxFit.none,
                        color: FlutterFlowTheme.of(context).primaryText),
                  )
                ]),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, top: 8.0),
                  child: Image.asset("assets/images/hands_join.png"),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, top: 8.0),
                  child: Text(
                    "Thank you for the Feedback !!!",
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          fontSize: 22.0,
                          color: FlutterFlowTheme.of(context).accent1,
                          fontWeight: FontWeight.w700,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).bodyMediumFamily),
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, top: 8.0),
                  child: Text(
                    "Feedback received! Gratitude for your valuable insights shaping our progress.",
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          fontSize: 14.0,
                          color: FlutterFlowTheme.of(context).accent1,
                          fontWeight: FontWeight.w400,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).bodyMediumFamily),
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          return;
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          elevation: 5,
                          backgroundColor: FlutterFlowTheme.of(context).primary,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10.0), // Border radius
                          ),
                        ),
                        child: Text('Okay',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .bodyMediumFamily),
                                ))),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Future<bool> feedbackSupportApi(
      {required String content,
      required String phone,
      required String issueType,
      required String email,
      required String userData,
      required Uint8List? bytes,
      required var imageUrlPath,
      required String token,
      required String fileName}) async {
    File imageFile = File(imageUrlPath);

    var request = Dio();
    request.options.headers['Authorization'] = 'Bearer $token';

    var formData = kIsWeb
        ? FormData.fromMap({
            'content': content,
            'phone': phone ?? "",
            'issueType': issueType,
            'email': email,
            'userData': userData,
            'imageUrl': fileName.isEmpty
                ? null
                : MultipartFile.fromBytes(
                    bytes!,
                    filename: fileName,
                  ),
          })
        : FormData.fromMap({
            'content': content,
            'phone': phone,
            'issueType': issueType,
            'email': email,
            'userData': userData,
            'imageUrl': imageUrlPath.toString().isEmpty
                ? null
                : await MultipartFile.fromFile(imageUrlPath,
                    filename: imageFile.path.split('/').last),
          });

    formData.fields.removeWhere((entry) => entry.value == null);
    print(formData.toString());

    var response = await request.post(
      '${FFAppState().baseUrl}/support/create',
      data: formData,
    );
    var responseString = await response.toString();
    print(responseString);
    Map<String, dynamic> responseData = json.decode(responseString);
    String status = responseData['status'];
    if (status.toUpperCase() == "OK")
      return Future.value(true);
    else
      return Future.value(false);
  }
}
