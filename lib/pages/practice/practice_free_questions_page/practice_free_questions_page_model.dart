import '/backend/api_requests/api_calls.dart';
import '/components/custom_html_view/custom_html_view_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import 'package:flutter/material.dart';

class PracticeFreeQuestionsPageModel extends FlutterFlowModel {
  ///  Local state fields for this page.

  bool isLoading = false;

  int chkAnswer = 0;

  bool showConfetti = false;

  int confettiParticleCount = 20;

  double confettiGravity = 0.8;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Backend Call - API (Get Status of all Practice Questions for a test for a given user)] action in PracticeFreeQuestionsPage widget.
  ApiCallResponse? statusList;
  // Stores action output result for [Custom Action - chkJson] action in PracticeFreeQuestionsPage widget.
  List<dynamic>? newStatusList;
  // Stores action output result for [Bottom Sheet - BubbleQuestions] action in Icon widget.
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
  late FlutterFlowDynamicModels<CustomHtmlViewModel> customHtmlViewModels;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    customHtmlViewModels =
        FlutterFlowDynamicModels(() => CustomHtmlViewModel());
  }

  void dispose() {
    unfocusNode.dispose();
    instantTimer?.cancel();
    customHtmlViewModels.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
