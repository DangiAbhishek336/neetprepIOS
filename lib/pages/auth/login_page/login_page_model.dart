import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class LoginPageModel extends FlutterFlowModel {
  ///  Local state fields for this page.

  bool isLoading = false;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Custom Action - gmailLogin] action in Container widget.
  dynamic userJson;

  dynamic appleUserJson;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
