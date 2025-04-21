import '/backend/api_requests/api_calls.dart';
import '/components/test_count_down_timer/test_count_down_timer_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import 'package:flutter/material.dart';

class TestPageModel extends FlutterFlowModel {
  ///  Local state fields for this page.

  bool isLoading = false;

  int secondsPerQuestion = 0;

  int? minutes;

  int? seconds;

  int questionLoadedTime = 0;

  int? selectedPageNumber;

  int? startTimeInSec;


  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Backend Call - API (Get completed test attempt data with test result for a test attempt)] action in TestPage widget.
  ApiCallResponse? questionsList;
  InstantTimer? instantTimer1;
  // Stores action output result for [Backend Call - API (update test attempt for a test by a user based on questions attempted and time spend etc )] action in Icon widget.
  ApiCallResponse? submitRes1;
  // Model for TestCountDownTimer component.
  late TestCountDownTimerModel testCountDownTimerModel;
  // Stores action output result for [Bottom Sheet - ConfirmPop] action in Text widget.
  bool? selRes;
  // Stores action output result for [Backend Call - API (update test attempt for a test by a user based on questions attempted and time spend etc )] action in Text widget.
  ApiCallResponse? submitRes;
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // Stores action output result for [Backend Call - API (update test attempt for a test by a user based on questions attempted and time spend etc )] action in Container widget.
  ApiCallResponse? updateTestAttempt;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    testCountDownTimerModel =
        createModel(context, () => TestCountDownTimerModel());
  }

  void dispose() {
    unfocusNode.dispose();
    instantTimer1?.cancel();
    testCountDownTimerModel.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
