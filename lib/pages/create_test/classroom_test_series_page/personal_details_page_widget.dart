import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neetprep_essential/flutter_flow/flutter_flow_util.dart';
import 'package:neetprep_essential/pages/create_test/classroom_test_series_page/personal_details_page_model.dart';
import 'package:provider/provider.dart';
import '../../../flutter_flow/flutter_flow_drop_down.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/form_field_controller.dart';

class PersonalDetailsPageWidget extends StatefulWidget {
  const PersonalDetailsPageWidget({
    Key? key,
    required this.isFromBuyNow
  }) : super(key: key);

  final bool isFromBuyNow;

  @override
  _PersonalDetailsPageWidgetState createState() => _PersonalDetailsPageWidgetState();
}

class _PersonalDetailsPageWidgetState extends State<PersonalDetailsPageWidget> {


  @override
  void initState() {
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "PersonalDetailsFormWidget");
    var personalDetailsModel = Provider.of<PersonalDetailsPageModel>(context,listen:false);
    personalDetailsModel.initializeControllers();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
              0.0, 0.0, 0.0, 0.0),
          child: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
             context.pop();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 29.0,
            ),
          ),
        ),
        title: Text(
          'Personal Details',
          textAlign: TextAlign.center,
          style: FlutterFlowTheme.of(context)
              .headlineMedium
              .override(
            fontFamily: FlutterFlowTheme.of(context)
                .headlineMediumFamily,
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            useGoogleFonts: GoogleFonts.asMap().containsKey(
                FlutterFlowTheme.of(context)
                    .headlineMediumFamily),
          ),
        ),
        elevation: 1.0,
      ),
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body:  WillPopScope(
             onWillPop: () async{
             context.pop();
             return true;
      },
              child: SafeArea(
                child:SingleChildScrollView(
                  child: Consumer<PersonalDetailsPageModel>(
                      builder: (context,personalDetails,child)  {
                        return Container(
                          height: MediaQuery.of(context).size.height,
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 10.0, 0.0, 5.0),
                                  child: TextFormField(
                                    controller: personalDetails.nameController,
                                    autofocus: false,
                                    obscureText: false,
                                    onEditingComplete: () {
                                     // personalDetails.formKey.currentState?.validate();
                                      personalDetails.notifyListeners();
                                      FocusScope.of(context).unfocus();
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal:20),
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                        fontFamily:
                                        FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        fontWeight: FontWeight.normal,
                                        useGoogleFonts: GoogleFonts
                                            .asMap()
                                            .containsKey(
                                            FlutterFlowTheme.of(
                                                context)
                                                .bodyMediumFamily),
                                      ),
                                      labelText: 'Name',
                                      hintText:"Name",
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .labelMedium,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFC9C9C9),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                      fontFamily:
                                      FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color: Color(0xFF252525),
                                      fontWeight: FontWeight.normal,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                          FlutterFlowTheme.of(context)
                                              .bodyMediumFamily),
                                    ),
                                    validator: (value) {
                                      if (value != null &&
                                          value.trim().isEmpty) {
                                        return 'Please enter your Name';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 5.0, 0.0, 5.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    FlutterFlowDropDown<String>(
                                      controller: FormFieldController<String>(
                                        '+91',
                                      ),
                                      options: ['+91'],

                                      width: 70.0,
                                      height: 50.0,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                        fontFamily:
                                        FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        fontWeight: FontWeight.normal,
                                        useGoogleFonts: GoogleFonts
                                            .asMap()
                                            .containsKey(
                                            FlutterFlowTheme.of(
                                                context)
                                                .bodyMediumFamily),
                                      ),

                                      icon: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 24.0,
                                      ),
                                      fillColor: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      elevation: 2.0,
                                      borderColor: Color(0xFFC9C9C9),
                                      borderWidth: 1.0,
                                      borderRadius: 10.0,
                                      margin: EdgeInsetsDirectional.fromSTEB(
                                          10.0, 11.0, 8.0, 12.0),
                                      hidesUnderline: true,
                                      isSearchable: false,
                                      isMultiSelect: false,
                                      hintText: 'Phone Number',
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: TextFormField(
                                        controller: personalDetails.phoneController,
                                        autovalidateMode: AutovalidateMode
                                            .onUserInteraction,
                                        autofocus: false,
                                        obscureText: false,
                                        onEditingComplete: () {
                                       //   personalDetails.formKey.currentState?.validate();
                                          personalDetails.notifyListeners();
                                          FocusScope.of(context).unfocus();
                                          },
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal:20),
                                           labelText: 'Phone Number',
                                          labelStyle:
                                          FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                            fontFamily:
                                            FlutterFlowTheme.of(
                                                context)
                                                .bodyMediumFamily,
                                            fontWeight:
                                            FontWeight.normal,
                                            useGoogleFonts: GoogleFonts
                                                .asMap()
                                                .containsKey(
                                                FlutterFlowTheme.of(
                                                    context)
                                                    .bodyMediumFamily),
                                          ),
                                          hintStyle:
                                          FlutterFlowTheme.of(context)
                                              .labelMedium,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFC9C9C9),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(10.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(10.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                              FlutterFlowTheme.of(context)
                                                  .error,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(10.0),
                                          ),
                                          focusedErrorBorder:
                                          OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                              FlutterFlowTheme.of(context)
                                                  .error,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                          fontFamily:
                                          FlutterFlowTheme.of(context)
                                              .bodyMediumFamily,
                                          color: Color(0xFF252525),
                                          fontWeight: FontWeight.normal,
                                          useGoogleFonts: GoogleFonts
                                              .asMap()
                                              .containsKey(
                                              FlutterFlowTheme.of(
                                                  context)
                                                  .bodyMediumFamily),
                                        ),
                                        keyboardType: TextInputType.phone,
                                        validator: (value) {
                                          if (value != null &&
                                              value.isEmpty) {
                                            return 'Please enter your phone number';
                                          } else if (value
                                              .toString()
                                              .length !=
                                              10) {
                                            return 'Please enter valid phone number';
                                          }
                                          return null;
                                        },
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp('[0-9]')),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 5.0, 0.0, 5.0),
                                  child: TextFormField(
                                    enabled: false,
                                    controller: personalDetails.emailController,
                                    autofocus: false,
                                    obscureText: false,
                                  onEditingComplete: () {
                               // personalDetails.formKey.currentState?.validate();
                                personalDetails.notifyListeners();
                                FocusScope.of(context).unfocus();
                                },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal:20),
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                        fontFamily:
                                        FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        fontWeight: FontWeight.normal,
                                        useGoogleFonts: GoogleFonts
                                            .asMap()
                                            .containsKey(
                                            FlutterFlowTheme.of(
                                                context)
                                                .bodyMediumFamily),
                                      ),
                                      //  labelText: 'Email ID',
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .labelMedium,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFC9C9C9),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFC9C9C9),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                      fontFamily:
                                      FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color: Color(0xFF252525),
                                      fontWeight: FontWeight.normal,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                          FlutterFlowTheme.of(context)
                                              .bodyMediumFamily),
                                    ),
                                    validator: (value) {
                                      if (value != null &&
                                          value.trim().isEmpty) {
                                        return 'Please enter your Email ID';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async{
                                  await personalDetails.getStates().then((_){
                                    personalDetails.showBottomSheet(context,"state",personalDetails.listOfStates);
                                  });

                                },
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 5.0, 0.0, 5.0),
                                    child: AbsorbPointer(
                                      child: TextFormField(
                                        controller: personalDetails.stateController,
                                        autofocus: false,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.chevron_right_sharp),
                                          contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal:20),
                                          labelStyle: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                            fontFamily:
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily,
                                            fontWeight: FontWeight.normal,
                                            useGoogleFonts: GoogleFonts
                                                .asMap()
                                                .containsKey(
                                                FlutterFlowTheme.of(
                                                    context)
                                                    .bodyMediumFamily),
                                          ),
                                          hintText: 'Choose Your State',
                                          hintStyle: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                            fontFamily:
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily,
                                            fontWeight: FontWeight.normal,
                                            useGoogleFonts: GoogleFonts
                                                .asMap()
                                                .containsKey(
                                                FlutterFlowTheme.of(
                                                    context)
                                                    .bodyMediumFamily),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFC9C9C9),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(10.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context)
                                                  .primary,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(10.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context)
                                                  .error,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(10.0),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context)
                                                  .error,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                          fontFamily:
                                          FlutterFlowTheme.of(context)
                                              .bodyMediumFamily,
                                          color: Color(0xFF252525),
                                          fontWeight: FontWeight.normal,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily),
                                        ),

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                                  personalDetails.stateController.text.isNotEmpty ?
                                  personalDetails.stateController.text=="Request a Center"?
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 5.0, 0.0, 5.0),
                                      child: TextFormField(
                                        controller: personalDetails.requestedCenterController,
                                        autofocus: false,
                                        obscureText: false,
                                        onEditingComplete: () {
                                          // personalDetails.formKey.currentState?.validate();
                                          personalDetails.notifyListeners();
                                          FocusScope.of(context).unfocus();
                                        },
                                        onTapOutside: (_){
                                          personalDetails.notifyListeners();
                                          FocusScope.of(context).unfocus();
                                        },
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal:20),
                                          labelStyle: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                            fontFamily:
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily,
                                            fontWeight: FontWeight.normal,
                                            useGoogleFonts: GoogleFonts
                                                .asMap()
                                                .containsKey(
                                                FlutterFlowTheme.of(
                                                    context)
                                                    .bodyMediumFamily),
                                          ),
                                          hintText: 'Enter state, city & locality',
                                          hintStyle: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                            fontFamily:
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily,
                                            fontWeight: FontWeight.normal,
                                            useGoogleFonts: GoogleFonts
                                                .asMap()
                                                .containsKey(
                                                FlutterFlowTheme.of(
                                                    context)
                                                    .bodyMediumFamily),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFC9C9C9),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(10.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context)
                                                  .primary,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(10.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context)
                                                  .error,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(10.0),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context)
                                                  .error,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                          fontFamily:
                                          FlutterFlowTheme.of(context)
                                              .bodyMediumFamily,
                                          color: Color(0xFF252525),
                                          fontWeight: FontWeight.normal,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily),
                                        ),
                                        validator: (value) {
                                          if (value != null &&
                                              value.trim().isEmpty) {
                                            return 'Please enter your Email ID';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ):
                                  GestureDetector(
                                    onTap: (){
                                      personalDetails.showBottomSheet(context,"city",personalDetails.listOfCities);
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 5.0, 0.0, 5.0),
                                        child: AbsorbPointer(
                                          child: TextFormField(
                                            controller: personalDetails.cityController,
                                            autofocus: false,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              suffixIcon: Icon(Icons.chevron_right_sharp),
                                              contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal:20),
                                              labelStyle: FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .override(
                                                fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                                fontWeight: FontWeight.normal,
                                                useGoogleFonts: GoogleFonts
                                                    .asMap()
                                                    .containsKey(
                                                    FlutterFlowTheme.of(
                                                        context)
                                                        .bodyMediumFamily),
                                              ),
                                              hintText: 'Choose Your City',
                                              hintStyle: FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .override(
                                                fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                                fontWeight: FontWeight.normal,
                                                useGoogleFonts: GoogleFonts
                                                    .asMap()
                                                    .containsKey(
                                                    FlutterFlowTheme.of(
                                                        context)
                                                        .bodyMediumFamily),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0xFFC9C9C9),
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                BorderRadius.circular(10.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(context)
                                                      .primary,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                BorderRadius.circular(10.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(context)
                                                      .error,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                BorderRadius.circular(10.0),
                                              ),
                                              focusedErrorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(context)
                                                      .error,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                BorderRadius.circular(10.0),
                                              ),
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                              fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                              color: Color(0xFF252525),
                                              fontWeight: FontWeight.normal,
                                              useGoogleFonts: GoogleFonts.asMap()
                                                  .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                            ),
                                            validator: (value) {
                                              if (value != null &&
                                                  value.trim().isEmpty) {
                                                return 'Please enter your Email ID';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ):SizedBox(),
                                  personalDetails.cityController.text.isNotEmpty?
                                  personalDetails.cityController.text=="Request a Center"?
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 5.0, 0.0, 5.0),
                                      child: TextFormField(
                                        controller: personalDetails.requestedCenterController,
                                        autofocus: false,
                                        obscureText: false,
                                        onEditingComplete: () {
                                          // personalDetails.formKey.currentState?.validate();
                                          personalDetails.notifyListeners();
                                          FocusScope.of(context).unfocus();
                                        },
                                        onTapOutside: (_){
                                          personalDetails.notifyListeners();
                                          FocusScope.of(context).unfocus();
                                        },
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal:20),
                                          labelStyle: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                            fontFamily:
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily,
                                            fontWeight: FontWeight.normal,
                                            useGoogleFonts: GoogleFonts
                                                .asMap()
                                                .containsKey(
                                                FlutterFlowTheme.of(
                                                    context)
                                                    .bodyMediumFamily),
                                          ),
                                          hintText: 'Enter state, city & locality',
                                          hintStyle:FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                            fontFamily:
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily,
                                            fontWeight: FontWeight.normal,
                                            useGoogleFonts: GoogleFonts
                                                .asMap()
                                                .containsKey(
                                                FlutterFlowTheme.of(
                                                    context)
                                                    .bodyMediumFamily),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFC9C9C9),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(10.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context)
                                                  .primary,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(10.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context)
                                                  .error,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(10.0),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context)
                                                  .error,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                          fontFamily:
                                          FlutterFlowTheme.of(context)
                                              .bodyMediumFamily,
                                          color: Color(0xFF252525),
                                          fontWeight: FontWeight.normal,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily),
                                        ),
                                        validator: (value) {
                                          if (value != null &&
                                              value.trim().isEmpty) {
                                            return 'Please enter your Email ID';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ):
                                  personalDetails.centerNameController.text.isEmpty||(personalDetails.centerNameController.text.isNotEmpty&&  personalDetails.centerNameController.text=="Request a Center")?GestureDetector(
                                    onTap: (){
                                      personalDetails.showBottomSheet(context,"center",personalDetails.listOfCenters);
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 5.0, 0.0, 5.0),
                                        child: AbsorbPointer(
                                          child: TextFormField(
                                            controller: personalDetails.centerNameController,
                                            autofocus: false,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              suffixIcon: Icon(Icons.chevron_right_sharp),
                                              contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal:20),
                                              labelStyle: FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .override(
                                                fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                                fontWeight: FontWeight.normal,
                                                useGoogleFonts: GoogleFonts
                                                    .asMap()
                                                    .containsKey(
                                                    FlutterFlowTheme.of(
                                                        context)
                                                        .bodyMediumFamily),
                                              ),
                                              hintText: 'Choose Your Center',
                                              hintStyle: FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .override(
                                                fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                                fontWeight: FontWeight.normal,
                                                useGoogleFonts: GoogleFonts
                                                    .asMap()
                                                    .containsKey(
                                                    FlutterFlowTheme.of(
                                                        context)
                                                        .bodyMediumFamily),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0xFFC9C9C9),
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                BorderRadius.circular(10.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(context)
                                                      .primary,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                BorderRadius.circular(10.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(context)
                                                      .error,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                BorderRadius.circular(10.0),
                                              ),
                                              focusedErrorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(context)
                                                      .error,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                BorderRadius.circular(10.0),
                                              ),
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                              fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                              color: Color(0xFF252525),
                                              fontWeight: FontWeight.normal,
                                              useGoogleFonts: GoogleFonts.asMap()
                                                  .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ):SizedBox():SizedBox(),
                              personalDetails.centerNameController.text.isNotEmpty?
                              personalDetails.centerNameController.text=="Request a Center"?
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 5.0, 0.0, 5.0),
                                  child: TextFormField(
                                    controller: personalDetails.requestedCenterController,
                                    autofocus: false,
                                    obscureText: false,
                                    onEditingComplete: () {
                                      // personalDetails.formKey.currentState?.validate();
                                      personalDetails.notifyListeners();
                                      FocusScope.of(context).unfocus();
                                    },
                                    onTapOutside: (_){
                                      personalDetails.notifyListeners();
                                      FocusScope.of(context).unfocus();
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal:20),
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                        fontFamily:
                                        FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        fontWeight: FontWeight.normal,
                                        useGoogleFonts: GoogleFonts
                                            .asMap()
                                            .containsKey(
                                            FlutterFlowTheme.of(
                                                context)
                                                .bodyMediumFamily),
                                      ),
                                      hintText: 'Enter state, city & locality',
                                      hintStyle:FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                        fontFamily:
                                        FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        fontWeight: FontWeight.normal,
                                        useGoogleFonts: GoogleFonts
                                            .asMap()
                                            .containsKey(
                                            FlutterFlowTheme.of(
                                                context)
                                                .bodyMediumFamily),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFC9C9C9),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                      fontFamily:
                                      FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color: Color(0xFF252525),
                                      fontWeight: FontWeight.normal,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                          FlutterFlowTheme.of(context)
                                              .bodyMediumFamily),
                                    ),
                                    validator: (value) {
                                      if (value != null &&
                                          value.trim().isEmpty) {
                                        return 'Please enter your state, city & locality';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ):
                              Padding(
                                padding: const EdgeInsets.only(top:5.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 1,
                                        color: Color(0xffC9C9C9),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(10,5,10,5),
                                      child: Column(
                                        children: [
                                          TextField(
                                            enabled: false,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal:0),
                                              labelStyle: FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .override(
                                                fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                                fontWeight: FontWeight.normal,
                                                useGoogleFonts: GoogleFonts
                                                    .asMap()
                                                    .containsKey(
                                                    FlutterFlowTheme.of(
                                                        context)
                                                        .bodyMediumFamily),
                                              ),
                                              // labelText: 'Name',
                                              hintStyle: FlutterFlowTheme.of(context)
                                                  .labelMedium,

                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                              fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                              color: Color(0xFF252525),
                                              fontWeight: FontWeight.normal,
                                              useGoogleFonts: GoogleFonts.asMap()
                                                  .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                            ),
                                            maxLines: 4,
                                            controller: personalDetails.centerNameController,
                                          ),
                                          Align(
                                              alignment:Alignment.bottomRight,
                                              child:OutlinedButton(
                                                  onPressed: (){

                                                    personalDetails.showBottomSheet(context, 'center', personalDetails.listOfCenters);

                                                  },
                                                  style: OutlinedButton.styleFrom(
                                                    shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                                                    side: BorderSide(width: 1.0, color: FlutterFlowTheme.of(context).primary),
                                                  ),
                                                  child:Text("Change",style:FlutterFlowTheme.of(context).bodyMedium.override(
                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                    fontSize: 14.0,
                                                    color: FlutterFlowTheme.of(context).primary,
                                                    fontWeight: FontWeight.w400,
                                                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                                                        FlutterFlowTheme.of(context).bodyMediumFamily),
                                                  ))
                                              )
                                          )
                                        ],
                                      ),
                                    )
                                ),
                              ):
                              SizedBox(),

                                   Visibility(
                                visible:   personalDetails.nameController.text.isNotEmpty
                                    && personalDetails.phoneController.text.isNotEmpty
                                    && personalDetails.emailController.text.isNotEmpty
                                    &&(
                                        (personalDetails.centerNameController.text!="" && personalDetails.centerNameController.text!="Request a Center" && personalDetails.requestedCenterController.text.isEmpty ) || (personalDetails.centerNameController.text=="Request a Center" && personalDetails.requestedCenterController.text.isNotEmpty)||(personalDetails.centerNameController.text.isEmpty && personalDetails.requestedCenterController.text.isNotEmpty)
                                    ),
                                    child: Padding(
                                padding: const EdgeInsets.only(top:12.0),
                                child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:[
                                        Checkbox(
                                          checkColor: Colors.white,
                                          activeColor:  Color(0xffE6A123),
                                          // focusColor: Color(0xffE6A123),
                                          value: personalDetails.termsAccepted,
                                          onChanged: (value) {
                                            personalDetails.termsAccepted = value!;
                                            personalDetails.notifyListeners();
                                          },
                                        ),
                                        Flexible(child:
                                        Text('I have read and agreed to the Terms of Use. By submitting my details I override my NDNC registration & authorize NEETPrep representatives to contact me through Call, SMS, Email, WhatsApp or any other. I also authorise to send me new promotional offers and services from time to time.',
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                            fontSize: 12.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                                FlutterFlowTheme.of(context).bodyMediumFamily),
                                          ),

                                        )),
                                      ]
                                ),
                              ),
                                  )


                            ],
                          ),
                        );
                      }
                  ),
                ),
              ),
            ),


        bottomNavigationBar: Consumer<PersonalDetailsPageModel>(
          builder: (context,personalDetails,child) {
            return Padding(
              padding: EdgeInsets.only(top: 20.0, left: 16, right: 16, bottom: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(40), backgroundColor: Color(0xFFE6A123),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      // side: BorderSide(width: 3, color: Colors.black),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    textStyle:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                onPressed:personalDetails.nameController.text.isNotEmpty
                    && personalDetails.phoneController.text.isNotEmpty
                    && personalDetails.emailController.text.isNotEmpty
                && personalDetails.termsAccepted
                    &&(
                        (personalDetails.centerNameController.text!="" && personalDetails.centerNameController.text!="Request a Center" && personalDetails.requestedCenterController.text.isEmpty ) || (personalDetails.centerNameController.text=="Request a Center" && personalDetails.requestedCenterController.text.isNotEmpty)||(personalDetails.centerNameController.text.isEmpty && personalDetails.requestedCenterController.text.isNotEmpty)
                    )? () async {

                    if(!widget.isFromBuyNow) {
                      await personalDetails.submitDetailsToHubspot(false).then(
                              (_) {
                            context.pop();
                            if (personalDetails.requestedCenterController.text
                                .isEmpty) {
                              context.pushNamed(
                                  'ThankYouPageWithCenterAvailable');
                            }
                            else {
                              context.pushNamed('ThankYouPage');
                            }
                          }
                      );

                    }
                    else {
                      if (personalDetails.requestedCenterController.text == "") {
                        context.pushNamed('OrderPage', queryParameters: {
                          'courseId': serializeParam(
                            FFAppState().classroomTestCourseId,
                            ParamType.String,
                          ),
                          'courseIdInt': serializeParam(
                            FFAppState().classroomTestCourseIdInt.toString(),
                            ParamType.String,
                          ),
                          'state': serializeParam(
                            personalDetails.stateController.text,
                            ParamType.String,
                          ),
                          'city': serializeParam(
                            personalDetails.cityController.text,
                            ParamType.String,
                          ),
                          'centerAddress': serializeParam(
                            personalDetails.centerNameController.text!=""&& personalDetails.centerNameController.text!="Request a Center" ? personalDetails.centerNameController.text: personalDetails.requestedCenterController.text,
                            ParamType.String,
                          ),
                        }.withoutNulls,);
                      }
                      else{
                        await personalDetails.submitDetailsToHubspot(false).then(
                                (_) {
                              context.pop();
                                context.pushNamed('ThankYouPage');

                            }
                        );
                      }
                    }




                }:null,
                child: Text(
                  widget.isFromBuyNow? 'Confirm Personal Details':'Submit Request',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                        FlutterFlowTheme.of(context).bodyMediumFamily),
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }




}
