import 'dart:async';
import 'dart:convert';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../flutter_flow/flutter_flow_icon_button.dart';
import '/backend/api_requests/api_calls.dart';
import '/components/custom_html_view/custom_html_view_widget.dart';
import '/flutter_flow/instant_timer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class FlashcardPageModel extends FlutterFlowModel {
  ///  Local state fields for this page.

  bool isLoading = false;

  int quesTitleNumber = 0;

  bool? sectionCompleted = false;

  String subTopicName = '';

  int sectionNumber = 0;
  FlipCardController flipController = FlipCardController();
   String selectedIssue = "";
   String selectedIssueId = "";
  var issueSubmittedResponse;
  List issueDisplayNameList = [];
  List issueList = [];
  PageController swipeController = PageController(initialPage: 0);
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Backend Call - API (Get Status of all Practice Questions for a test for a given user)] action in PracticeQuetionsPage widget.
  ApiCallResponse? statusList;
  ApiCallResponse? userAccessJson;
  // Stores action output result for [Custom Action - chkJson] action in PracticeQuetionsPage widget.
  List<dynamic>? newStatusList;
  // Stores action output result for [Bottom Sheet - BubbleQuestions] action in Image widget.
  int? selectedPageNumber;
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
      pageViewController!.hasClients &&
      pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // Stores action output result for [Backend Call - API (Create or delete bookmark for a practice question by a user)] action in Icon widget.
  ApiCallResponse? apiResultdn0;
  // Stores action output result for [Backend Call - API (Create or delete bookmark for a practice question by a user)] action in Icon widget.
  ApiCallResponse? apiResultdn1;
  // Stores action output result for [Backend Call - API (Create answer for a practice question by a user with specific marked option )] action in Container widget.
  ApiCallResponse? apiResultixv;
  InstantTimer? instantTimer;
  // Models for CustomHtmlView dynamic component.
  late FlutterFlowDynamicModels<CustomHtmlViewModel> customHtmlViewModels1;
  // Models for CustomHtmlView dynamic component.
  late FlutterFlowDynamicModels<CustomHtmlViewModel> customHtmlViewModels2;

  TextEditingController issueDescriptionController = new TextEditingController();
   Map<String,String> displayIssueAndIdMap = {};
  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    customHtmlViewModels1 =
        FlutterFlowDynamicModels(() => CustomHtmlViewModel());
    customHtmlViewModels2 =
        FlutterFlowDynamicModels(() => CustomHtmlViewModel());
  }

  void dispose() {
    unfocusNode.dispose();
    instantTimer?.cancel();
    // customHtmlViewModels1.dispose();
    // customHtmlViewModels2.dispose();
  }

  Future<void> getQuestionIssueList()async {
   var response = await  PracticeGroup
        .getQuestionIssueListForIssueReportingCall
        .call();
    issueList =  PracticeGroup.getQuestionIssueListForIssueReportingCall.questionIssueTypes(response.jsonBody);
   issueDisplayNameList = [];
   displayIssueAndIdMap={};
   for(var item in issueList){
     issueDisplayNameList.add(item['displayName']);
     displayIssueAndIdMap[item['displayName']] = item['id'];

   }

  }

  String getBase64forQuestion(String courseId) {
    String courseIdStr = "Question:" + courseId;
    Codec<String, String> stringToBase64Url = utf8.fuse(base64Url);
    String encoded = stringToBase64Url.encode(courseIdStr);

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


  Future<void> postIssue(
      String flashCardId, String issueId, String content) async {
    try {
      Map<String, dynamic> requestBody = {
        'flashCardId': flashCardId,
        'issueId': issueId,
        'content': content,
      };

      String requestBodyJson = jsonEncode(requestBody);
      String apiUrl = '${FFAppState().baseUrl}/api/v1/report_flashcard';

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
          msg: "Your request is successfully submitted!",
        );
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Response: ${response.body}');
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        String message = jsonResponse['message'];
        Fluttertoast.showToast(
          msg: "Oops! One issue at a time, please. We're fixing the flashcard problem. Thanks!",
        );
      }
    } catch (error) {
      print('Error making the request: $error');
      Fluttertoast.showToast(msg: "Some Error Occurred");
    }
  }

  Future<void> showIssueTypeBottomSheet(context, deckId, cardId) async {
    GlobalKey<FormState> formFieldKey = GlobalKey<FormState>();
    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color.fromARGB(113, 0, 0, 0),
      context: context,
      builder: (context) {
        return Form(
          key:formFieldKey,
          child: Padding(
            padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: AlignmentDirectional(0.0, 1.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Material(
                          color: Colors.transparent,
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(0.0),
                              bottomRight: Radius.circular(0.0),
                              topLeft: Radius.circular(16.0),
                              topRight: Radius.circular(16.0),
                            ),
                          ),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(0.0),
                                bottomRight: Radius.circular(0.0),
                                topLeft: Radius.circular(16.0),
                                topRight: Radius.circular(16.0),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Issue Type",
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
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
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          size: 24.0,
                                        ),
                                        onPressed: () async {
                                          issueDescriptionController.clear();
                                          selectedIssueId = "";
                                          Navigator.pop(context);
                                        },
                                      )
                                    ]),
                                SizedBox(height: 16),
                                DropdownButtonFormField2<String>(
                                  autovalidateMode:AutovalidateMode.onUserInteraction ,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    contentPadding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                    border: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Color(0xffe9e9e9)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    // Add more decoration..
                                  ),
                                  hint: const Text(
                                    'Select Your Issue',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      color: Color(0xFFA3A5A7),
                                    ),
                                  ),
                                  items: issueDisplayNameList
                                      .map((item) => DropdownMenuItem<String>(
                                    value: item.toString(),
                                    child: Text(
                                      item.toString(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        color: Color(0xFFA3A5A7),
                                      ),
                                    ),
                                  ))
                                      .toList(),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select your issue.';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    //Do something when selected item is changed.
                                    if (displayIssueAndIdMap.containsKey(value)) {
                                      selectedIssue = value.toString();
                                      selectedIssueId =
                                      displayIssueAndIdMap[value]!;
                                    }
                                    print(selectedIssue);
                                    print(selectedIssueId);
                                  },
                                  onSaved: (value) {
                                    selectedIssue = value.toString();
                                  },
                                  buttonStyleData: const ButtonStyleData(
                                    padding: EdgeInsets.only(right: 8),
                                  ),
                                  iconStyleData: const IconStyleData(
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.black45,
                                    ),
                                    iconSize: 24,
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    decoration: BoxDecoration(
                                      border:
                                      Border.all(color: Color(0xffe9e9e9)),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                  ),
                                ),
                                SizedBox(height: 16),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: TextFormField(
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    controller: issueDescriptionController,
                                    // autofocus: true,
                                    //   obscureText: false,
                                    decoration: InputDecoration(
                                      hintText:
                                      'Please share your concerns here.. ',
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                        fontFamily:
                                        FlutterFlowTheme.of(context)
                                            .bodySmallFamily,
                                        color: Color(0xFFA3A5A7),
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.normal,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .bodySmallFamily),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xffe9e9e9),
                                          width: 1.0,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xffe9e9e9),
                                          width: 1.0,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(4.0),
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xffe9e9e9),
                                          width: 1.0,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(4.0),
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xffe9e9e9),
                                          width: 1.0,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(4.0),
                                        ),
                                      ),
                                      contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          10.0, 20.0, 0.0, 0.0),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w400,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                          FlutterFlowTheme.of(context)
                                              .bodyMediumFamily),
                                    ),
                                    maxLines: 6,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'Please share your concern here';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(height: 16),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: Size.fromHeight(20),
                                        backgroundColor:
                                        FlutterFlowTheme.of(context)
                                            .primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10.0),
                                          // side: BorderSide(width: 3, color: Colors.black),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 14),
                                        textStyle: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    onPressed: () async {
                                      final isValid = formFieldKey.currentState?.validate();
                                      if(isValid!=null && isValid) {
                                        String num = base64DecodeString(
                                            selectedIssueId);
                                        await postIssue(
                                            cardId, num,
                                            issueDescriptionController.text)
                                            .then((_) {
                                          issueDescriptionController
                                              .clear();
                                          selectedIssueId = "";
                                          Navigator.pop(context);
                                        });
                                      }
                                    },
                                    child: Text(
                                      'Submit',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                        fontFamily:
                                        FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        fontSize: 15.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily),
                                      ),
                                    ),
                                  ),
                                )
                              ],
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
        );
      },
    ).then((value) => null);
  }


/// Action blocks are added here.

/// Additional helper methods are added here.
}
