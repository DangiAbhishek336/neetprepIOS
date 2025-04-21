import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:neetprep_essential/flutter_flow/flutter_flow_util.dart';
import 'package:neetprep_essential/index.dart';
import 'package:neetprep_essential/pages/practice/assertion_chapter_wise_page/assertion_chapter_wise_page_widget.dart';
import 'package:neetprep_essential/pages/practice/hardestqs_chapter_wise_page/hardestqs_chapter_page_widget.dart';
import 'package:neetprep_essential/pages/user_info_form/user_form/user_info_form_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../backend/api_requests/api_calls.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../practice/practice_chapter_wise_page/practice_chapter_page_widget.dart';
import 'form_completion_handler_model.dart';

class FormCompletionHandler extends StatefulWidget {
  const FormCompletionHandler({super.key});

  @override
  State<FormCompletionHandler> createState() => _FormCompletionHandlerState();
}

class _FormCompletionHandlerState extends State<FormCompletionHandler> {

  late FormCompletionHandlerModel _model;
   bool showAnnouncement = true;
  bool isFormCompleted  = false;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FormCompletionHandlerModel());
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        isLoading = true;
      });
      await isFormCompletedFunc();
      setState(() {
        isLoading = false;
      });
    });

  }


  Future<bool> isFormCompletedFunc() async {
    setState(() {
      isLoading = true;
    });

    _model.response= await SignupGroup
        .getUserInformationApiCall
        .call(
      authToken: FFAppState().subjectToken,
    );
    bool isPhonePresent  = false, isCityPresent  = false,isStatePresent  = false, isBoardExamYearPresent  = false, isNeetExamYearPresent=false, isFirstNamePresent = false, isLastNamePresent = false;
     print(SignupGroup.getUserInformationApiCall.me( _model.response?.jsonBody).toString());
    if(SignupGroup.getUserInformationApiCall.me( _model.response?.jsonBody)!=null) {
      isPhonePresent = SignupGroup.getUserInformationApiCall.parentPhone(
          _model.response?.jsonBody) != null
          && SignupGroup.getUserInformationApiCall
              .parentPhone( _model.response?.jsonBody)
              .isNotEmpty;

      isCityPresent = SignupGroup.getUserInformationApiCall.city(
          _model.response?.jsonBody) != null
          && SignupGroup.getUserInformationApiCall
              .city( _model.response?.jsonBody)
              .isNotEmpty;

      isStatePresent = SignupGroup.getUserInformationApiCall.state(
          _model.response?.jsonBody) != null
          && SignupGroup.getUserInformationApiCall
              .state( _model.response?.jsonBody)
              .isNotEmpty;

      isBoardExamYearPresent = SignupGroup.getUserInformationApiCall
          .boardExamYear( _model.response?.jsonBody) != null
          && SignupGroup.getUserInformationApiCall
              .boardExamYear( _model.response?.jsonBody).toString()
              .isNotEmpty;

      isNeetExamYearPresent = SignupGroup.getUserInformationApiCall
          .neetExamYear( _model.response?.jsonBody) != null
          && SignupGroup.getUserInformationApiCall
              .neetExamYear( _model.response?.jsonBody).toString()
              .isNotEmpty;

      isFirstNamePresent = SignupGroup.getUserInformationApiCall.firstName(
          _model.response?.jsonBody) != null
          && SignupGroup.getUserInformationApiCall
              .firstName( _model.response?.jsonBody)
              .isNotEmpty;

      isLastNamePresent = SignupGroup.getUserInformationApiCall.lastName(
          _model.response?.jsonBody) != null
          && SignupGroup.getUserInformationApiCall
              .lastName( _model.response?.jsonBody)
              .isNotEmpty;
    }


    isFormCompleted  = isPhonePresent && isCityPresent && isNeetExamYearPresent && isStatePresent ;
        // && isBoardExamYearPresent  && isFirstNamePresent && isLastNamePresent;
    FFAppState().isFormCompleted = isFormCompleted ;

    setState(() {
      isLoading = false;
      isFormCompleted  = isPhonePresent && isCityPresent && isNeetExamYearPresent && isStatePresent ;
    });

    return Future.value(isFormCompleted)  ;

  }



  @override
  Widget build(BuildContext context) {
    return
         Scaffold(
          body:
          isLoading?  Center(
               child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
                           ),
             ): isFormCompleted?  HardestQsChapterPageWidget():
    UserInfoForm()
        );
  }

}
