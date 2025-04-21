import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../backend/api_requests/api_calls.dart';
import '../../../flutter_flow/flutter_flow_icon_button.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';


class UserInfoFormModel extends ChangeNotifier {
  /// Initialization and disposal methods.
  final formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController neetYearController = TextEditingController();
  final TextEditingController boardExamYearController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController registrationNoController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  String? selectedBoardExamYear = null;
  String? selectedNeetExamYear = null;
  String? selectedState= null;
  /// To Do : Make both neetExamYears and boardExamYears list dynamic.
  List<String> neetExamYears = ["2025","2026","2027"];
  List<String> boardExamYears = ["2020","2021","2022","2023","2024","2025","2026","2027","2028"];
  List<String> stateList = [
    "Andhra Pradesh",
    "Andaman and Nicobar Islands",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chandigarh",
    "Chhattisgarh",
    "Dadar and Nagar Haveli",
    "Daman and Diu",
    "Delhi",
    "Lakshadweep",
    "Puducherry",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jammu and Kashmir",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttar Pradesh",
    "Uttarakhand",
    "West Bengal",
  ];
  bool isLoading = false;
  ApiCallResponse? data;


  void initState(BuildContext context) {
    firstNameController.clear();
    lastNameController.clear();
    phoneController.clear();
    neetYearController.clear();
    boardExamYearController.clear();
    cityController.clear();
    stateController.clear();
    pincodeController.clear();

  }

  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    neetYearController.dispose();
    boardExamYearController.dispose();
    cityController.dispose();
    stateController.dispose();
    pincodeController.dispose();

  }

  void showNeetExamYearSheet(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(
            top: Radius.circular(
                16.0)),
      ),
      builder: (BuildContext builder) {
        return Consumer<UserInfoFormModel>(
          builder: (context,userInfoForm,child) {
            return Container(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              padding: EdgeInsets.fromLTRB(16.0,27.0,16.0,13),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  mainAxisSize:
                  MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Choose your NEET Exam Year',
                          style: FlutterFlowTheme
                              .of(context)
                              .bodyMedium,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SvgPicture.asset(
                              'assets/images/close_circle.svg',
                              fit: BoxFit.none,
                              color:FlutterFlowTheme.of(context).primaryText
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(height:10),
                    for (int index = 0; index < neetExamYears.length; index++)
                      RadioListTile(
                        activeColor: FlutterFlowTheme
                            .of(context)
                            .primary,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        value: neetExamYears[index],
                        title: Text(
                          neetExamYears[index].toString(), style: FlutterFlowTheme
                            .of(context)
                            .bodyMedium
                            .override(
                          fontFamily:
                          FlutterFlowTheme
                              .of(context)
                              .bodyMediumFamily,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                          useGoogleFonts: GoogleFonts.asMap()
                              .containsKey(
                              FlutterFlowTheme
                                  .of(context)
                                  .bodyMediumFamily),
                        ),),
                        groupValue: selectedNeetExamYear,
                        onChanged: (value) {
                          selectedNeetExamYear = value!;
                          notifyListeners();
                        },
                      ),
                    SizedBox(height:10),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromHeight(20),
                            backgroundColor:
                            FlutterFlowTheme.of(context).primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              // side: BorderSide(width: 3, color: Colors.black),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 14),
                            textStyle: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        onPressed: () async {
                          if(selectedNeetExamYear!=null && selectedNeetExamYear!.isNotEmpty)
                          neetYearController.text =  selectedNeetExamYear.toString();

                          if(selectedNeetExamYear.toString()!="2024"){
                             registrationNoController.clear();
                          }
                          notifyListeners();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Confirm',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                            fontFamily: FlutterFlowTheme.of(context)
                                .bodyMediumFamily,
                            fontSize: 15.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            useGoogleFonts: GoogleFonts.asMap()
                                .containsKey(FlutterFlowTheme.of(context)
                                .bodyMediumFamily),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }

  void showBoardExamYearSheet(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(
            top: Radius.circular(
                16.0)),
      ),
      builder: (BuildContext builder) {
        return Consumer<UserInfoFormModel>(
            builder: (context,userInfoForm,child) {
              return Container(
                padding: EdgeInsets.fromLTRB(16.0,27.0,16.0,13),
                decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    mainAxisSize:
                    MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Choose your 12th Board Exam Year',
                            style: FlutterFlowTheme
                                .of(context)
                                .bodyMedium
                                .override(
                              fontFamily: FlutterFlowTheme
                                  .of(context)
                                  .bodyMediumFamily,
                              fontSize: 18.0,
                              useGoogleFonts: GoogleFonts.asMap()
                                  .containsKey(
                                  FlutterFlowTheme
                                      .of(context)
                                      .bodyMediumFamily),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 30.0, right: 16),
                              child: SvgPicture.asset(
                                  'assets/images/close_circle.svg',
                                  fit: BoxFit.none,
                                  color:FlutterFlowTheme.of(context).primaryText
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      SizedBox(height:10),
                      for (int index = 0; index < boardExamYears.length; index++)
                        RadioListTile(
                          activeColor: FlutterFlowTheme
                              .of(context)
                              .primary,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 0, vertical: 0),
                          value: boardExamYears[index],
                          title: Text(
                            boardExamYears[index].toString(), style: FlutterFlowTheme
                              .of(context)
                              .bodyMedium),
                          groupValue: selectedBoardExamYear,
                          onChanged: (value) {
                            selectedBoardExamYear = value!;
                            notifyListeners();
                          },
                        ),
                      SizedBox(height:10),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size.fromHeight(20),
                              backgroundColor:
                              FlutterFlowTheme.of(context).primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                // side: BorderSide(width: 3, color: Colors.black),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 14),
                              textStyle: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                          onPressed: () async {
                            if(selectedBoardExamYear!=null && selectedBoardExamYear!.isNotEmpty)
                              boardExamYearController.text =  selectedBoardExamYear.toString();
                            notifyListeners();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Confirm',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium,
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              );
            }
        );
      },
    );
  }

  void showStateListSheet(context){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(
            top: Radius.circular(
                16.0)),
      ),
      builder: (BuildContext builder) {
        return Consumer<UserInfoFormModel>(
            builder: (context,userInfoForm,child) {
              return Container(
                height:MediaQuery.of(context).size.height*0.6,
                decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                child: Scaffold(
                  backgroundColor: FlutterFlowTheme.of(context).secondaryBackground ,
                  appBar: AppBar(
                    backgroundColor: FlutterFlowTheme.of(context).secondaryBackground ,
                    leadingWidth: 20,
                    centerTitle: false,
                    automaticallyImplyLeading: false,
                    title: Padding(
                      padding: EdgeInsets.only(top:50,bottom:50,left:16,right:16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center  ,
                        children: [
                          Text(
                            'Choose your State',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium

                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: SvgPicture.asset(
                                'assets/images/close_circle.svg',
                                fit: BoxFit.none,
                                color:FlutterFlowTheme.of(context).primaryText
                            ),
                          ),
                        ],
                      ),
                    ),
                    titleSpacing: 0,
                    leading:SizedBox(),
                    elevation: 0,
                  ),
                  body: Container(
                    padding: EdgeInsets.fromLTRB(16.0,0.0,16.0,13),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        mainAxisSize:
                        MainAxisSize.min,
                        children: [
                          for (int index = 0; index < stateList.length; index++)
                            RadioListTile(
                              activeColor: FlutterFlowTheme
                                  .of(context)
                                  .primary,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              value: stateList[index],
                              title: Text(
                                stateList[index].toString(), style: FlutterFlowTheme
                                  .of(context)
                                  .bodyMedium),
                              groupValue: selectedState,
                              onChanged: (value) {
                                selectedState = value!;
                                notifyListeners();
                              },
                            ),
                          SizedBox(height:10)

                        ],
                      ),
                    ),
                  ),
                  bottomNavigationBar: Container(
                    padding: EdgeInsets.fromLTRB(16.0,16.0,16.0,13),
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(20),
                          backgroundColor:
                          FlutterFlowTheme.of(context).primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            // side: BorderSide(width: 3, color: Colors.black),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 0, vertical: 14),
                          textStyle: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      onPressed: () async {
                        if(selectedState!=null && selectedState!.isNotEmpty)
                          stateController.text =  selectedState.toString();

                        notifyListeners();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Confirm',
                        style: FlutterFlowTheme.of(context)
                            .bodyMedium
                            .override(
                          fontFamily: FlutterFlowTheme.of(context)
                              .bodyMediumFamily,
                          fontSize: 15.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          useGoogleFonts: GoogleFonts.asMap()
                              .containsKey(FlutterFlowTheme.of(context)
                              .bodyMediumFamily),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
        );
      },
    );

  }



/// Action blocks are added here.

/// Additional helper methods are added here.
}
