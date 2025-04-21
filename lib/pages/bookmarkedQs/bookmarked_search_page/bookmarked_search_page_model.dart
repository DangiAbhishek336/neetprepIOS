import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class BookmarkedSearchPageModel extends FlutterFlowModel {
  ///  Local state fields for this page.

  bool showSearchRes = false;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for TextField widget.
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  List<dynamic> simpleSearchResults = [];
  List<List<dynamic>> searchResRev= [];
  // Stores action output result for [Custom Action - getTabs] action in Container widget.
  List<int>? numTabs;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
    textController?.dispose();
  }

/// Action blocks are added here.

/// Additional helper methods are added here.
}
