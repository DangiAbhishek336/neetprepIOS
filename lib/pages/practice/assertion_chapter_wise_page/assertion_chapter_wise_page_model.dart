import '/backend/api_requests/api_calls.dart';
import '/components/nav_bar/nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class AssertionChapterWisePageModel extends FlutterFlowModel {
  ///  Local state fields for this page.

  ///  State fields for stateful widgets in this page.
  bool showSearchList = false;
  bool  prefsShowAssertionQs = false;
  bool prefsShowAssertionCongratsQs = false;
  bool prefsShowAssertionAskForReview = false;
  final unfocusNode = FocusNode();
  // Stores action output result for [Backend Call - API (Logged in user information and course access checking api )] action in PracticeChapterWisePage widget.
  ApiCallResponse? memberShip;
  // Stores action output result for [Backend Call - API (Get Practice Tests to show chapter wise)] action in PracticeChapterWisePage widget.
  ApiCallResponse? apiResultdwy;
  // Stores action output result for [Bottom Sheet - selectBook] action in Row widget.
  int? selectedCourseIndex;
  // Stores action output result for [Backend Call - API (Get Courses for switching)] action in Row widget.
  ApiCallResponse? selectCourses;
  // Model for navBar component.
  late NavBarModel navBarModel;


  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    navBarModel = createModel(context, () => NavBarModel());
  }

  void dispose() {
    unfocusNode.dispose();
    // textController?.dispose();
    navBarModel.dispose();
  }

/// Action blocks are added here.

/// Additional helper methods are added here.
}
