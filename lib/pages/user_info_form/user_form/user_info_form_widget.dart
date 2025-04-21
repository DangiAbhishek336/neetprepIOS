import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neetprep_essential/backend/api_requests/api_calls.dart';
import 'package:neetprep_essential/flutter_flow/flutter_flow_util.dart';
import 'package:neetprep_essential/pages/user_info_form/user_form/user_info_form_model.dart';
import 'package:provider/provider.dart';

import '../../../flutter_flow/flutter_flow_drop_down.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/form_field_controller.dart';
import '/flutter_flow/custom_functions.dart' as functions;

class UserInfoForm extends StatefulWidget {
  const UserInfoForm({
    Key? key,
  }) : super(key: key);

  @override
  _UserInfoFormState createState() => _UserInfoFormState();
}

class _UserInfoFormState extends State<UserInfoForm> {
  String buttonText = "Submit";

  @override
  void initState() {
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "UserInfoForm");

    checkIfAuthTokenIsNotExpired();
    setValues();
    super.initState();
  }

  Future<void> setValues() async{
    var userInfoModel = Provider.of<UserInfoFormModel>(context, listen: false);
    var response = await SignupGroup.getUserInformationApiCall.call(
      authToken: FFAppState().subjectToken,
    );
    var data = response.jsonBody;
    if(SignupGroup.getUserInformationApiCall.me(data)!=null) {
      userInfoModel.firstNameController.text = SignupGroup.getUserInformationApiCall.firstName(data)!=null && SignupGroup.getUserInformationApiCall.firstName(data).isNotEmpty ?SignupGroup.getUserInformationApiCall.firstName(data).toString():"" ;
      userInfoModel.lastNameController.text = SignupGroup.getUserInformationApiCall.lastName(data)!=null && SignupGroup.getUserInformationApiCall.lastName(data).isNotEmpty ?SignupGroup.getUserInformationApiCall.lastName(data).toString():"" ;
      userInfoModel.phoneController.text = SignupGroup.getUserInformationApiCall.parentPhone(data)!=null && SignupGroup.getUserInformationApiCall.parentPhone(data).isNotEmpty ?SignupGroup.getUserInformationApiCall.parentPhone(data).toString():"" ;
      userInfoModel.neetYearController.text = SignupGroup.getUserInformationApiCall.neetExamYear(data)!=null && SignupGroup.getUserInformationApiCall.neetExamYear(data).toString().isNotEmpty ?SignupGroup.getUserInformationApiCall.neetExamYear(data).toString():""  ;
      userInfoModel.boardExamYearController.text = SignupGroup.getUserInformationApiCall.boardExamYear(data)!=null && SignupGroup.getUserInformationApiCall.boardExamYear(data).toString().isNotEmpty ?SignupGroup.getUserInformationApiCall.boardExamYear(data).toString():""  ;
      userInfoModel.registrationNoController.text = SignupGroup.getUserInformationApiCall.registrationNo(data)!=null && SignupGroup.getUserInformationApiCall.registrationNo(data).isNotEmpty ?SignupGroup.getUserInformationApiCall.registrationNo(data).toString():""  ;
      userInfoModel.dobController.text = SignupGroup.getUserInformationApiCall.dob(data)!=null && SignupGroup.getUserInformationApiCall.dob(data).isNotEmpty ?SignupGroup.getUserInformationApiCall.dob(data).toString():""  ;
      userInfoModel.stateController.text = SignupGroup.getUserInformationApiCall.state(data)!=null && SignupGroup.getUserInformationApiCall.state(data).isNotEmpty ?SignupGroup.getUserInformationApiCall.state(data).toString():""  ;
      userInfoModel.cityController.text =  SignupGroup.getUserInformationApiCall.city(data)!=null && SignupGroup.getUserInformationApiCall.city(data).isNotEmpty ?SignupGroup.getUserInformationApiCall.city(data).toString():""  ;
      userInfoModel.pincodeController.text =  SignupGroup.getUserInformationApiCall.pincode(data)!=null && SignupGroup.getUserInformationApiCall.pincode(data).isNotEmpty ? SignupGroup.getUserInformationApiCall.pincode(data).toString():""  ;
   if( userInfoModel.boardExamYearController.text.isNotEmpty){
      userInfoModel.selectedBoardExamYear =userInfoModel.boardExamYearController.text;
   }

      if( userInfoModel.neetYearController.text.isNotEmpty){
         userInfoModel.selectedNeetExamYear =userInfoModel.neetYearController.text;
      }
      if(userInfoModel.phoneController.text.length>10){
        userInfoModel.phoneController.text = userInfoModel.phoneController.text.substring(userInfoModel.phoneController.text.length- 10);
      }
     if(userInfoModel.firstNameController.text.isNotEmpty || userInfoModel.lastNameController.text.isNotEmpty || userInfoModel.phoneController.text.isNotEmpty || userInfoModel.neetYearController.text.isNotEmpty|| userInfoModel.boardExamYearController.text.isNotEmpty ||   userInfoModel.registrationNoController.text.isNotEmpty ||userInfoModel.dobController.text.isNotEmpty|| userInfoModel.stateController.text.isNotEmpty||userInfoModel.cityController.text.isNotEmpty||userInfoModel.pincodeController.text.isNotEmpty)
       buttonText = "Update";
     }
    setState(() {
    });
  }


  Future<void> checkIfAuthTokenIsNotExpired() async{
    var response = await SignupGroup.getUserInformationApiCall.call(
      authToken: FFAppState().subjectToken,
    );
    var data = response.jsonBody;
    print("I am coming here ");
    print(SignupGroup.getUserInformationApiCall.me(data).toString());
    print(FFAppState().subjectToken);
    if(SignupGroup.getUserInformationApiCall.me(data)==null) {
       context.goNamed('LoginPage');
    }

    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          child:formWidget(),
        ),
        bottomNavigationBar: Consumer<UserInfoFormModel>(
          builder: (context,userInfoModel,_) {
            return WillPopScope(
              onWillPop: () async {
                context.pushNamed("PracticeChapterWisePage");
                return Future.value(false);
              },
              child: Padding(
                padding: EdgeInsets.only(top: 8.0, left: 16, right: 16, bottom: 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE6A123),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        // side: BorderSide(width: 3, color: Colors.black),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      textStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                  onPressed: () async {
                    if (userInfoModel.formKey.currentState != null &&
                        userInfoModel.formKey.currentState!.validate()) {
                      String firstName = userInfoModel.firstNameController.text;
                      String phone = userInfoModel.phoneController.text;
                      String neetYear = userInfoModel.neetYearController.text;
                      String city = userInfoModel.cityController.text;
                      String state = userInfoModel.stateController.text;
                      var response = await SignupGroup.createOrUpdateUserProfile2
                          .call(
                          authToken: FFAppState().subjectToken,
                          city: city,
                          neetExamYear: neetYear,
                          state: state,
                          firstName: firstName,
                          parentPhone:"+91"+phone,
                          userId: functions.getBase64OfUserId(FFAppState().userIdInt),
                      ).then((value) {
                            if(kIsWeb)
                             context.pushReplacement('hardestQsChapterPageWidget');
                            else
                              context.goNamed('HardestQsChapterPageWidget');
                      });
                      print(response.toString());
                      FirebaseAnalytics.instance.logEvent(
                        name: 'onboarding_submit_button_clicked',
                      );

                    }
                  },
                  child: Text(
                    buttonText,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context).bodyMediumFamily),
                    ),
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  Widget formWidget(){
    return Consumer<UserInfoFormModel>(
      builder: (context,userInfoModel,child) {
        return SingleChildScrollView(
          child: Form(
            autovalidateMode: AutovalidateMode.disabled,
            key: userInfoModel.formKey,
            child: Container(
              height: MediaQuery.of(context).size.height*1.2,
              padding: EdgeInsets.fromLTRB(16.0,0,16.0,0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                    EdgeInsets.only(bottom: 10.0, top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: ()  {context.pushNamed("PracticeChapterWisePage");},
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              color: FlutterFlowTheme.of(context)
                                  .primaryText,
                              size: 24.0,
                            )),
                        SizedBox(width: 10.0),
                        Flexible(
                          child: Text(
                            'Help us know you better & tackle the toughest questions!',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                              fontFamily:
                              FlutterFlowTheme.of(context)
                                  .bodyMediumFamily,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              useGoogleFonts: GoogleFonts
                                  .asMap()
                                  .containsKey(
                                  FlutterFlowTheme.of(
                                      context)
                                      .bodyMediumFamily),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height:12),
                        headingSection("assets/images/personalcard.svg","Personal Details",true,true),
                        personalDetailsSection(),
                        SizedBox(height:12),
                        headingSection("assets/images/note-2.svg","Exam Details",true,true),
                        examDetailsSection(),
                        SizedBox(height:12),
                        headingSection("assets/images/location.svg","Address Details",true,true),
                        addressDetailSection()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Widget headingSection(imagePath,title,isOpened,isBottomBorderEnabled){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        SvgPicture.asset(
               imagePath,
          color:Color(0xff6e6e6e),
               fit: BoxFit.contain,
             ),
    SizedBox(width:10),
    Text(title,style:FlutterFlowTheme.of(context)
            .bodyMedium
            .override(
          fontSize: 14,
          color:Color(0xff6e6e6e),
          fontFamily:
          FlutterFlowTheme.of(context)
              .bodyMediumFamily,
          fontWeight: FontWeight.w500,
          useGoogleFonts: GoogleFonts
              .asMap()
              .containsKey(
              FlutterFlowTheme.of(
                  context)
                  .bodyMediumFamily),
        )),

      ]


    );

    //   Container(
    //     child:ListTile(
    //      leading: SvgPicture.asset(
    //        imagePath,
    //        color:isOpened? FlutterFlowTheme.of(context).primary:Colors.black,
    //        fit: BoxFit.contain,
    //      ),
    //     title: Text(title,style:FlutterFlowTheme.of(context)
    //         .bodyMedium
    //         .override(
    //       fontSize: 14,
    //       color: isOpened? FlutterFlowTheme.of(context).primary:Colors.black,
    //       fontFamily:
    //       FlutterFlowTheme.of(context)
    //           .bodyMediumFamily,
    //       fontWeight: FontWeight.w500,
    //       useGoogleFonts: GoogleFonts
    //           .asMap()
    //           .containsKey(
    //           FlutterFlowTheme.of(
    //               context)
    //               .bodyMediumFamily),
    //     )),
    //     trailing: isOpened?SvgPicture.asset("assets/images/arrow-up.svg", color: FlutterFlowTheme.of(context).primary):SvgPicture.asset("assets/images/arrow-down.svg", color: Colors.black)  ,
    //   )
    //
    // );
  }

  Widget personalDetailsSection(){
    return Consumer<UserInfoFormModel>(
      builder: (context,userInfoModel,_) {
        return Container(
            child:Column(
              children:[
                SizedBox(height:12),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context)
                        .secondaryBackground,
                  ),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: userInfoModel.firstNameController,
                    autofocus: false,
                    obscureText: false,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
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
                      labelText: 'First Name',
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
                    style: FlutterFlowTheme.of(context).bodyMedium,
                    validator: (value) {
                      if (value != null &&
                          value.trim().isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                    ],
                  ),
                ),
                SizedBox(height:12),
                // Container(
                //   width: double.infinity,
                //   decoration: BoxDecoration(
                //     color: FlutterFlowTheme.of(context)
                //         .secondaryBackground,
                //   ),
                //   child: TextFormField(
                //     autovalidateMode: AutovalidateMode.onUserInteraction,
                //     controller: userInfoModel.lastNameController,
                //     autofocus: false,
                //     obscureText: false,
                //     decoration: InputDecoration(
                //       contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                //       labelStyle: FlutterFlowTheme.of(context)
                //           .bodyMedium
                //           .override(
                //         fontFamily:
                //         FlutterFlowTheme.of(context)
                //             .bodyMediumFamily,
                //         fontWeight: FontWeight.normal,
                //         useGoogleFonts: GoogleFonts
                //             .asMap()
                //             .containsKey(
                //             FlutterFlowTheme.of(
                //                 context)
                //                 .bodyMediumFamily),
                //       ),
                //       labelText: 'Last Name',
                //       hintStyle: FlutterFlowTheme.of(context)
                //           .labelMedium,
                //       enabledBorder: OutlineInputBorder(
                //         borderSide: BorderSide(
                //           color: Color(0xFFC9C9C9),
                //           width: 1.0,
                //         ),
                //         borderRadius:
                //         BorderRadius.circular(10.0),
                //       ),
                //       focusedBorder: OutlineInputBorder(
                //         borderSide: BorderSide(
                //           color: FlutterFlowTheme.of(context)
                //               .primary,
                //           width: 1.0,
                //         ),
                //         borderRadius:
                //         BorderRadius.circular(10.0),
                //       ),
                //       errorBorder: OutlineInputBorder(
                //         borderSide: BorderSide(
                //           color: FlutterFlowTheme.of(context)
                //               .error,
                //           width: 1.0,
                //         ),
                //         borderRadius:
                //         BorderRadius.circular(10.0),
                //       ),
                //       focusedErrorBorder: OutlineInputBorder(
                //         borderSide: BorderSide(
                //           color: FlutterFlowTheme.of(context)
                //               .error,
                //           width: 1.0,
                //         ),
                //         borderRadius:
                //         BorderRadius.circular(10.0),
                //       ),
                //     ),
                //     style: FlutterFlowTheme.of(context)
                //         .bodyMedium
                //         .override(
                //       fontFamily:
                //       FlutterFlowTheme.of(context)
                //           .bodyMediumFamily,
                //       color: Color(0xFF252525),
                //       fontWeight: FontWeight.normal,
                //       useGoogleFonts: GoogleFonts.asMap()
                //           .containsKey(
                //           FlutterFlowTheme.of(context)
                //               .bodyMediumFamily),
                //     ),
                //     validator: (value) {
                //       if (value != null &&
                //           value.trim().isEmpty) {
                //         return 'Please enter your last name';
                //       }
                //       return null;
                //     },
                //     inputFormatters: [
                //       FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                //     ],
                //   ),
                // ),
                // SizedBox(height:12),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      FlutterFlowDropDown<String>(
                        controller: FormFieldController<String>(
                          '+91',
                        ),
                        options: ['+91'],

                        width: 70.0,
                        height: 45.0,
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
                            8.0, 0.0, 8.0, 0.0),
                        hidesUnderline: true,
                        isSearchable: false,
                        isMultiSelect: false,
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: TextFormField(
                          controller: userInfoModel.phoneController,
                          autovalidateMode: AutovalidateMode
                              .onUserInteraction,
                          autofocus: false,
                          obscureText: false,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            labelText: "Parent Phone Number",
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
                          style: FlutterFlowTheme.of(context).bodyMedium,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value != null &&
                                value.isEmpty) {
                              return "Please enter your Parent's phone number";
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
                SizedBox(height:12),
                // GestureDetector(
                //   onTap: () async{
                //     print("I am clicked");
                //     FocusScope.of(context).requestFocus(new FocusNode());
                //     DateTime? pickedDate = await showDatePicker(
                //         context: context,
                //         builder: (context, child) {
                //           return Theme(
                //             data: Theme.of(context).copyWith(
                //               colorScheme: ColorScheme.light(
                //                 primary: FlutterFlowTheme.of(context).primary,
                //               ),
                //               textButtonTheme: TextButtonThemeData(
                //                 style: TextButton.styleFrom(
                //                   foregroundColor: FlutterFlowTheme.of(context).primary,
                //                 ),
                //               ),
                //             ),
                //             child: child!,
                //           );
                //         },
                //         initialDate: DateTime.now(),
                //         firstDate:DateTime(1990),
                //         lastDate: DateTime(2101)
                //     );
                //     if(pickedDate != null ){
                //       print(pickedDate);
                //       String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                //       print(formattedDate);
                //       setState(() {
                //         userInfoModel.dobController.text = formattedDate;
                //       });
                //     }
                //     else{
                //      Fluttertoast.showToast(msg: "Date is not selected");
                //     }
                //
                //   },
                //   child: Container(
                //     width: double.infinity,
                //     decoration: BoxDecoration(
                //       color: FlutterFlowTheme.of(context)
                //           .secondaryBackground,
                //     ),
                //     child: AbsorbPointer(
                //       child: TextFormField(
                //         autovalidateMode: AutovalidateMode.onUserInteraction,
                //         readOnly: true,
                //         controller: userInfoModel.dobController,
                //         autofocus: false,
                //         obscureText: false,
                //         decoration: InputDecoration(
                //           contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                //           labelStyle: FlutterFlowTheme.of(context)
                //               .bodyMedium
                //               .override(
                //             fontFamily:
                //             FlutterFlowTheme.of(context)
                //                 .bodyMediumFamily,
                //             fontWeight: FontWeight.normal,
                //             useGoogleFonts: GoogleFonts
                //                 .asMap()
                //                 .containsKey(
                //                 FlutterFlowTheme.of(
                //                     context)
                //                     .bodyMediumFamily),
                //           ),
                //           labelText: 'Date Of Birth',
                //           hintStyle: FlutterFlowTheme.of(context)
                //               .labelMedium,
                //           enabledBorder: OutlineInputBorder(
                //             borderSide: BorderSide(
                //               color: Color(0xFFC9C9C9),
                //               width: 1.0,
                //             ),
                //             borderRadius:
                //             BorderRadius.circular(10.0),
                //           ),
                //           focusedBorder: OutlineInputBorder(
                //             borderSide: BorderSide(
                //               color: FlutterFlowTheme.of(context)
                //                   .primary,
                //               width: 1.0,
                //             ),
                //             borderRadius:
                //             BorderRadius.circular(10.0),
                //           ),
                //           errorBorder: OutlineInputBorder(
                //             borderSide: BorderSide(
                //               color: FlutterFlowTheme.of(context)
                //                   .error,
                //               width: 1.0,
                //             ),
                //             borderRadius:
                //             BorderRadius.circular(10.0),
                //           ),
                //           focusedErrorBorder: OutlineInputBorder(
                //             borderSide: BorderSide(
                //               color: FlutterFlowTheme.of(context)
                //                   .error,
                //               width: 1.0,
                //             ),
                //             borderRadius:
                //             BorderRadius.circular(10.0),
                //           ),
                //         ),
                //         style: FlutterFlowTheme.of(context)
                //             .bodyMedium
                //             .override(
                //           fontFamily:
                //           FlutterFlowTheme.of(context)
                //               .bodyMediumFamily,
                //           color: Color(0xFF252525),
                //           fontWeight: FontWeight.normal,
                //           useGoogleFonts: GoogleFonts.asMap()
                //               .containsKey(
                //               FlutterFlowTheme.of(context)
                //                   .bodyMediumFamily),
                //         ),
                //         validator: (value) {
                //           if (value != null &&
                //               value.trim().isEmpty) {
                //             return 'Please enter your Date of birth';
                //           }
                //           return null;
                //         },
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(height:12),
              ]
            )

        );
      }
    );
  }

  Widget examDetailsSection(){
    return Consumer<UserInfoFormModel>(
      builder: (context,userInfoModel,_) {
        return Container(
            child:Column(
                children:[
                  SizedBox(height:12),
                  GestureDetector(
                    onTap: () async{

                      userInfoModel.showNeetExamYearSheet(context);

                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context)
                            .secondaryBackground,
                      ),
                      child: AbsorbPointer(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: userInfoModel.neetYearController,
                          autofocus: false,
                          obscureText: false,
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.chevron_right_sharp),
                            contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
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
                            labelText: 'Choose Your Neet Exam Year',
                            hintText: 'Choose Your Neet Exam Year',
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
                          style: FlutterFlowTheme.of(context).bodyMedium,
                          validator: (value) {
                            if (value == null|| value.trim().isEmpty) {
                              return 'Please select your NEET exam year';
                            }
                            return null;
                          },

                        ),
                      ),
                    ),
                  ),
                  SizedBox(height:12),
                  // GestureDetector(
                  //   onTap: () async{
                  //     userInfoModel.showBoardExamYearSheet(context);
                  //
                  //   },
                  //   child: Container(
                  //     width: double.infinity,
                  //     decoration: BoxDecoration(
                  //       color: FlutterFlowTheme.of(context)
                  //           .secondaryBackground,
                  //     ),
                  //     child: AbsorbPointer(
                  //       child: TextFormField(
                  //         autovalidateMode: AutovalidateMode.onUserInteraction,
                  //         controller: userInfoModel.boardExamYearController,
                  //         autofocus: false,
                  //         obscureText: false,
                  //         decoration: InputDecoration(
                  //           suffixIcon: Icon(Icons.chevron_right_sharp),
                  //           contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  //           labelStyle: FlutterFlowTheme.of(context)
                  //               .bodyMedium
                  //               .override(
                  //             fontFamily:
                  //             FlutterFlowTheme.of(context)
                  //                 .bodyMediumFamily,
                  //             fontWeight: FontWeight.normal,
                  //             useGoogleFonts: GoogleFonts
                  //                 .asMap()
                  //                 .containsKey(
                  //                 FlutterFlowTheme.of(
                  //                     context)
                  //                     .bodyMediumFamily),
                  //           ),
                  //           labelText: 'Choose Your Board Exam Year',
                  //           hintText: 'Choose Your Board Exam Year',
                  //           hintStyle: FlutterFlowTheme.of(context)
                  //               .bodyMedium
                  //               .override(
                  //             fontFamily:
                  //             FlutterFlowTheme.of(context)
                  //                 .bodyMediumFamily,
                  //             fontWeight: FontWeight.normal,
                  //             useGoogleFonts: GoogleFonts
                  //                 .asMap()
                  //                 .containsKey(
                  //                 FlutterFlowTheme.of(
                  //                     context)
                  //                     .bodyMediumFamily),
                  //           ),
                  //           enabledBorder: OutlineInputBorder(
                  //             borderSide: BorderSide(
                  //               color: Color(0xFFC9C9C9),
                  //               width: 1.0,
                  //             ),
                  //             borderRadius:
                  //             BorderRadius.circular(10.0),
                  //           ),
                  //           focusedBorder: OutlineInputBorder(
                  //             borderSide: BorderSide(
                  //               color: FlutterFlowTheme.of(context)
                  //                   .primary,
                  //               width: 1.0,
                  //             ),
                  //             borderRadius:
                  //             BorderRadius.circular(10.0),
                  //           ),
                  //           errorBorder: OutlineInputBorder(
                  //             borderSide: BorderSide(
                  //               color: FlutterFlowTheme.of(context)
                  //                   .error,
                  //               width: 1.0,
                  //             ),
                  //             borderRadius:
                  //             BorderRadius.circular(10.0),
                  //           ),
                  //           focusedErrorBorder: OutlineInputBorder(
                  //             borderSide: BorderSide(
                  //               color: FlutterFlowTheme.of(context)
                  //                   .error,
                  //               width: 1.0,
                  //             ),
                  //             borderRadius:
                  //             BorderRadius.circular(10.0),
                  //           ),
                  //         ),
                  //         style: FlutterFlowTheme.of(context)
                  //             .bodyMedium
                  //             .override(
                  //           fontFamily:
                  //           FlutterFlowTheme.of(context)
                  //               .bodyMediumFamily,
                  //           color: Color(0xFF252525),
                  //           fontWeight: FontWeight.normal,
                  //           useGoogleFonts: GoogleFonts.asMap()
                  //               .containsKey(
                  //               FlutterFlowTheme.of(context)
                  //                   .bodyMediumFamily),
                  //         ),
                  //         validator: (value) {
                  //           if (value == null|| value.trim().isEmpty) {
                  //             return 'Please select your Board exam year';
                  //           }
                  //           return null;
                  //         },
                  //
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height:12),

                ]
            )

        );
      }
    );
  }

  Widget addressDetailSection(){
    return Consumer<UserInfoFormModel>(
      builder: (context,userInfoModel,_) {
        return Container(
            child:Column(
                children:[
                  SizedBox(height:12),
                  // Container(
                  //   width: double.infinity,
                  //   decoration: BoxDecoration(
                  //     color: FlutterFlowTheme.of(context)
                  //         .secondaryBackground,
                  //   ),
                  //   child: TextFormField(
                  //     controller: userInfoModel.pincodeController,
                  //     autofocus: false,
                  //     autovalidateMode:
                  //     AutovalidateMode.onUserInteraction,
                  //     obscureText: false,
                  //     keyboardType: TextInputType.phone,
                  //     decoration: InputDecoration(
                  //       contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  //       labelStyle: FlutterFlowTheme.of(context)
                  //           .bodyMedium
                  //           .override(
                  //         fontFamily:
                  //         FlutterFlowTheme.of(context)
                  //             .bodyMediumFamily,
                  //         fontWeight: FontWeight.normal,
                  //         useGoogleFonts: GoogleFonts
                  //             .asMap()
                  //             .containsKey(
                  //             FlutterFlowTheme.of(
                  //                 context)
                  //                 .bodyMediumFamily),
                  //       ),
                  //       labelText: 'PIN Code',
                  //       hintStyle: FlutterFlowTheme.of(context)
                  //           .labelMedium,
                  //       enabledBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(
                  //           color: Color(0xFFC9C9C9),
                  //           width: 1.0,
                  //         ),
                  //         borderRadius:
                  //         BorderRadius.circular(10.0),
                  //       ),
                  //       focusedBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(
                  //           color: FlutterFlowTheme.of(context)
                  //               .primary,
                  //           width: 1.0,
                  //         ),
                  //         borderRadius:
                  //         BorderRadius.circular(10.0),
                  //       ),
                  //       errorBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(
                  //           color: FlutterFlowTheme.of(context)
                  //               .error,
                  //           width: 1.0,
                  //         ),
                  //         borderRadius:
                  //         BorderRadius.circular(10.0),
                  //       ),
                  //       focusedErrorBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(
                  //           color: FlutterFlowTheme.of(context)
                  //               .error,
                  //           width: 1.0,
                  //         ),
                  //         borderRadius:
                  //         BorderRadius.circular(10.0),
                  //       ),
                  //     ),
                  //     style: FlutterFlowTheme.of(context)
                  //         .bodyMedium
                  //         .override(
                  //       fontFamily:
                  //       FlutterFlowTheme.of(context)
                  //           .bodyMediumFamily,
                  //       color: Color(0xFF252525),
                  //       fontWeight: FontWeight.normal,
                  //       useGoogleFonts: GoogleFonts.asMap()
                  //           .containsKey(
                  //           FlutterFlowTheme.of(context)
                  //               .bodyMediumFamily),
                  //     ),
                  //     inputFormatters: [
                  //       FilteringTextInputFormatter.allow(
                  //           RegExp('[0-9]'))
                  //     ],
                  //     validator: (value) {
                  //       if (value != null &&
                  //           value.trim().isNotEmpty && value.length!=6) {
                  //         return 'Please enter a valid PIN Code';
                  //       }
                  //       return null;
                  //     },
                  //   ),
                  // ),
                  // SizedBox(height:12),
                  GestureDetector(
                    onTap: () async{
                      userInfoModel.showStateListSheet(context);
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context)
                            .secondaryBackground,
                      ),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: userInfoModel.stateController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          autofocus: false,
                          obscureText: false,
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.chevron_right_sharp),
                            contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
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
                            labelText: 'State',
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
                              .bodyMedium,
                          validator: (value) {
                            if (value != null &&
                                value.trim().isEmpty) {
                              return 'Please enter your state';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height:12),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context)
                          .secondaryBackground,
                    ),
                    child: TextFormField(
                      controller: userInfoModel.cityController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      autofocus: false,
                      obscureText: false,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
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
                        labelText: 'City',
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
                      style: FlutterFlowTheme.of(context).bodyMedium,
                      validator: (value) {
                        if (value != null &&
                            value.trim().isEmpty) {
                          return 'Please enter your city';
                        }
                        return null;
                      },
                    ),
                  ),

                ]
            )

        );
      }
    );

  }



}
