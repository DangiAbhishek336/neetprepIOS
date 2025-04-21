import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';

class BottomPopupModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  TextEditingController? textController1;
  TextEditingController? address1Controller;
  TextEditingController? address2Controller;
  TextEditingController? pincodeController;
  TextEditingController? stateController;
  TextEditingController? cityController;
  TextEditingController? mobileNum2Controller;
  TextEditingController? landmarkController;
  String? Function(BuildContext, String?)? textController1Validator;
  String? Function(BuildContext, String?)? address1Validator;
  String? Function(BuildContext, String?)? address2Validator;
  String? Function(BuildContext, String?)? pincodeValidator;
  String? Function(BuildContext, String?)? stateValidator;
  String? Function(BuildContext, String?)? cityValidator;
  String? Function(BuildContext, String?)? mobileNum2Validator;

  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // State field(s) for TextField widget.
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for TextField widget.
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;

  bool submitted = false;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    textController1?.dispose();
    textController2?.dispose();
    textController3?.dispose();
  }

  String? get errorTextForPhoneNumber {
    final text = textController2.text;

    if (text.isEmpty) {
      return 'Please enter your Phone Number';
    }
    if (text.length !=10) {
      return 'Please enter a 10-digit mobile number';
    }

    return null;
  }

  String? get errorTextForUserName {
    final text = textController1.text;

    if (text.isEmpty) {
      return 'Please enter your Name';
    }

    return null;
    }



  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
