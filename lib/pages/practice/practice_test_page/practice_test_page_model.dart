import '/components/custom_html_view/custom_html_view_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class PracticeTestPageModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // Stores action output result for [Custom Action - getOffset] action in Container widget.
  int? offSetN1;
  // Stores action output result for [Custom Action - getOffset] action in Container widget.
  int? offSetN;
  // Stores action output result for [Custom Action - getOffset] action in Container widget.
  int? offSetN1Copy;
  // Stores action output result for [Custom Action - getOffset] action in Container widget.
  int? offSetNCopy;
  // Models for CustomHtmlView dynamic component.
  late FlutterFlowDynamicModels<CustomHtmlViewModel> customHtmlViewModels;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    customHtmlViewModels =
        FlutterFlowDynamicModels(() => CustomHtmlViewModel());
  }

  void dispose() {
    unfocusNode.dispose();
    tabBarController?.dispose();
    customHtmlViewModels.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
