import '/components/locked_content/locked_content_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class LockPageModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for LockedContent component.
  late LockedContentModel lockedContentModel;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    lockedContentModel = createModel(context, () => LockedContentModel());
  }

  void dispose() {
    unfocusNode.dispose();
    lockedContentModel.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
