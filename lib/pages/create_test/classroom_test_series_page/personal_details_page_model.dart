

import 'dart:convert';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../auth/firebase_auth/auth_util.dart';
import '../../../backend/api_requests/api_calls.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class PersonalDetailsPageModel extends ChangeNotifier {
  /// Initialization and disposal methods.
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController centerNameController = TextEditingController();
  final TextEditingController requestedCenterController = TextEditingController();
  bool termsAccepted = false;
  List listOfStates = [
  ];
  List listOfCities = [

  ];
  List listOfCenters = [

  ];
  String selectedState = "Request a Center", selectedCity = "Request a Center", selectedCenter = "Request a Center";

  ApiCallResponse? data;

  void initState(BuildContext context) {
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    cityController.clear();
    stateController.clear();
    centerNameController.clear();
  }

  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    cityController.dispose();
    stateController.dispose();
    centerNameController.dispose();
  }

  void showBottomSheet(BuildContext context, name, list) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return Consumer<PersonalDetailsPageModel>(
            builder: (context, personalDetails, child) {
          return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,

              child: Scaffold(
                appBar: AppBar(
                  leadingWidth: 20,
                  centerTitle: false,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  title: Padding(
                    padding: EdgeInsets.only(top:40,bottom:30,left:16,right:16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Choose your ' + name,
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                            fontFamily: FlutterFlowTheme.of(context)
                                .bodyMediumFamily,
                            fontSize: 18.0,
                            useGoogleFonts: GoogleFonts.asMap()
                                .containsKey(
                                FlutterFlowTheme.of(context)
                                    .bodyMediumFamily),
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              child: Icon(Icons.close,color: Colors.black,),
                            ))
                      ],
                    ),
                  ),
                  titleSpacing: 0,
                  leading:SizedBox(),
                  elevation: 0,
                ),
               body:SingleChildScrollView(
                 child: Container(
                   color: Colors.white,
                   child: Column(
                     children: [
                       RadioListTile(
                         activeColor: FlutterFlowTheme.of(context).primary,
                         contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                         value: 'Request a Center',
                         title: Text('Request a Center',style:  FlutterFlowTheme.of(context)
                             .bodyMedium
                             .override(
                           fontFamily:
                           FlutterFlowTheme.of(context)
                               .bodyMediumFamily,
                           fontSize: 16.0,
                           fontWeight: FontWeight.normal,
                           useGoogleFonts: GoogleFonts.asMap()
                               .containsKey(
                               FlutterFlowTheme.of(context)
                                   .bodyMediumFamily),
                         ),),
                         groupValue: name.toUpperCase() == "STATE"
                             ? selectedState
                             : name.toUpperCase() == "CITY"
                             ? selectedCity
                             : selectedCenter,
                         onChanged: (value) {
                           print(name.toUpperCase());
                           if (name.toUpperCase() == "STATE") {
                             selectedState = value.toString();
                           }
                           else if (name.toUpperCase() == "CITY") {
                             selectedCity = value.toString();

                           }
                           else{
                             selectedCenter = value.toString();

                           }

                           notifyListeners();
                           print(selectedState);
                         },
                       ),
                       Divider(),
                       for (int index = 0; index < list.length; index++)
                         RadioListTile(
                           activeColor: FlutterFlowTheme.of(context).primary,
                           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                           value: list[index],
                           title: Text(list[index],style:  FlutterFlowTheme.of(context)
                               .bodyMedium
                               .override(
                             fontFamily:
                             FlutterFlowTheme.of(context)
                                 .bodyMediumFamily,
                             fontSize: 16.0,
                             fontWeight: FontWeight.normal,
                             useGoogleFonts: GoogleFonts.asMap()
                                 .containsKey(
                                 FlutterFlowTheme.of(context)
                                     .bodyMediumFamily),
                           ),),
                           groupValue: name.toUpperCase() == "STATE"
                               ? selectedState
                               : name.toUpperCase() == "CITY"
                               ? selectedCity
                               : selectedCenter,
                           onChanged: (value) {
                             print(name.toUpperCase());
                             if (name.toUpperCase() == "STATE") {
                               selectedState = value.toString();
                             }
                             else if (name.toUpperCase() == "CITY") {
                               selectedCity = value.toString();

                             }
                             else{
                               selectedCenter = value.toString();

                             }

                             notifyListeners();
                             print(selectedState);
                           },
                         ),
                     ],
                   ),
                 ),
               ),
                bottomNavigationBar:  Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Container(
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
                        if (name.toUpperCase() == "STATE") {
                          stateController.text = selectedState;
                          cityController.text = "";
                          selectedCity = "Request a Center";
                          centerNameController.text ="";
                          requestedCenterController.text="";
                          selectedCenter = "Request a Center";
                          await getCities();

                        }
                        else if (name.toUpperCase() == "CITY") {
                          cityController.text = selectedCity;
                          centerNameController.text ="";
                          requestedCenterController.text="";
                          selectedCenter = "Request a Center";
                          await getCenters();
                        }
                        else{
                            centerNameController.text = selectedCenter;
                          requestedCenterController.text="";
                        }
                        notifyListeners();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Confirm Center',
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
              )
          );
        });
      },
    );
  }

  Future<void> initializeControllers() async {

    emailController.text = currentUserEmail;
    phoneController.text = FFAppState().userPhoneNumber;
    String firstName = FFAppState().firstName.toString() ?? "";
    String lastName = FFAppState().lastName.toString() ?? "";
    nameController.text = currentUserDisplayName;
    stateController.clear();
    cityController.clear();
    centerNameController.clear();
    requestedCenterController.clear();
    selectedState = "Request a Center";
    selectedCity = "Request a Center";
    selectedCenter = "Request a Center";
     termsAccepted = false;
  }


  Future<void> submitDetailsToHubspot(bool hasUserPaid) async {
    String apiUrl = '${FFAppState().baseUrl}/api/v1/leadinsert';
    String bearerToken = FFAppState().subjectToken;

    Map<String, String> queryParams = {
      'phone': phoneController.text,
      'name': nameController.text,
      'city': cityController.text,
      'state': stateController.text,
      'course': 'offline test series',
      'lifecyclestage': hasUserPaid ? 'customer':'Lead',
      'utm_source': 'Essential App',
      'email':emailController.text,
      'classroom_test_centre': (centerNameController.text=="Request a Center"|| centerNameController.text=="")?requestedCenterController.text:centerNameController.text
    };

    queryParams.removeWhere((key, value) => value == 'Request a Center'||value=='Lead');

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: Uri(queryParameters: queryParams).query,
    );

    if (response.statusCode == 200) {
      print('API call successful');
      print('Response body: ${response.body}');
    } else {
      print('API call failed with status code: ${response.statusCode}');
    }
  }




  Future<void> getStates() async {
    listOfStates =[];
    final response = await http.post(
      Uri.parse('${FFAppState().baseUrl}/graphql'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'query': '''
          {
            centres {
              state
            }
          }
        '''
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> centres = data['data']['centres'];

      for (var center in centres) {
        if (!listOfStates.contains(center['state'])) {
            listOfStates.add(center['state']);
        }
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> getCities() async {
    listOfCities=[];
    final response = await http.post(
      Uri.parse('${FFAppState().baseUrl}/graphql'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'query': '''
          {
            centres(state:"${stateController.text.toString()}") {
              city
            }
          }
        '''
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> centres = data['data']['centres'];

      for (var center in centres) {
        if (!listOfCities.contains(center['city'])) {
          listOfCities.add(center['city']);
        }
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> getCenters() async {
    listOfCenters=[];
    final response = await http.post(
      Uri.parse('${FFAppState().baseUrl}/graphql'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'query': '''
          {
            centres(state:"${stateController.text.toString()}", city:"${cityController.text.toString()}") {
              address
            }
          }
        '''
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> centres = data['data']['centres'];

      for (var center in centres) {
        if (!listOfCenters.contains(center['address'])) {
          listOfCenters.add(center['address']);
        }
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
    print("kkkk"+ prefs.getBool(key).toString());
  }
}


