import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class TestListModel extends FlutterFlowModel {
  ///  Local state fields for this page.

  List<int> intList = [];
  void addToIntList(int item) => intList.add(item);
  void removeFromIntList(int item) => intList.remove(item);
  void removeAtIndexFromIntList(int index) => intList.removeAt(index);
  void updateIntListAtIndex(int index, Function(int) updateFn) =>
      intList[index] = updateFn(intList[index]);

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
