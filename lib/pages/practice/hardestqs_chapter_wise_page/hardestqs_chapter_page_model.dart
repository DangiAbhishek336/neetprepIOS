import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:neetprep_essential/flutter_flow/flutter_flow_theme.dart';

import '../../../app_state.dart';
import '../../../auth/firebase_auth/auth_util.dart';
import '../../../backend/api_requests/api_calls.dart';
import '../../../custom_code/widgets/custom_banner.dart';
import '../../../firebase/firebase_push_notification.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../auth/login_page/login_page_widget.dart';

class HardestQsChapterPageModel extends ChangeNotifier {


  bool hasCourseAccess = false;
  bool isPaidUser = false;
  bool trial = false;
  bool phoneConfirmed = false;
  String phone  = "";
  bool phoneConfirmedModalSheet = false;
  var userCourses = null;
  var userExpiryAt = null;
  var userData = null;
  List<dynamic>? freeChapters = [];
  List<String>? excludeIds = [];
  String? courseStatus  = null;
  String? testSeriesCourseStatus  = null;
  String? altCourseStatus  = null;
  bool isLoading = true;
  bool isTopicsLoading = true;
  bool isLoggedIn = false;
  int? daysLeft = null;
  bool showAbhyasBanner = false;
  bool showTestSeriesBanner = false;
  bool showFreeTrialBanner = false;
  int eleigibleBannersCt = 0;

  List<CustomBanner> filteredBannersList = [];
  Map<String,dynamic> courseStatusResponse = {};

  Map<String, List<dynamic>>? topicsData;



  void callNotify(){
    notifyListeners();
  }




  OverlayEntry? _overlayEntry;

  void setLoadingOverlay(bool isLoading,context) {
    if (isLoading) {
      _showOverlay(context);
    } else {
      _removeOverlay();
    }
  }

  void _showOverlay(BuildContext context) {
    _overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.black.withOpacity(0.5), // Semi-transparent background
        child: Center(
          child: CircularProgressIndicator(color:FlutterFlowTheme.of(context).primary), // Loader in the center
        ),
      ),
    );
    Overlay.of(context)?.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }


  Future<bool> isFormCompletedFunc() async {

      isLoading = true;
    notifyListeners();

    var response= await SignupGroup
        .getUserInformationApiCall
        .call(
      authToken: FFAppState().subjectToken,
    );
    bool isPhonePresent  = false, isCityPresent  = false,isStatePresent  = false, isBoardExamYearPresent  = false, isNeetExamYearPresent=false, isFirstNamePresent = false, isLastNamePresent = false;
    print(SignupGroup.getUserInformationApiCall.me( response.jsonBody).toString());
    if(SignupGroup.getUserInformationApiCall.me( response.jsonBody)!=null) {
      isPhonePresent = SignupGroup.getUserInformationApiCall.phone(
          response.jsonBody) != null
          && SignupGroup.getUserInformationApiCall
              .phone(response.jsonBody)
              .isNotEmpty;

      isCityPresent = SignupGroup.getUserInformationApiCall.city(
          response.jsonBody) != null
          && SignupGroup.getUserInformationApiCall
              .city( response.jsonBody)
              .isNotEmpty;

      isStatePresent = SignupGroup.getUserInformationApiCall.state(
          response.jsonBody) != null
          && SignupGroup.getUserInformationApiCall
              .state( response.jsonBody)
              .isNotEmpty;

      isBoardExamYearPresent = SignupGroup.getUserInformationApiCall
          .boardExamYear( response.jsonBody) != null
          && SignupGroup.getUserInformationApiCall
              .boardExamYear( response.jsonBody).toString()
              .isNotEmpty;

      isNeetExamYearPresent = SignupGroup.getUserInformationApiCall
          .neetExamYear(response.jsonBody) != null
          && SignupGroup.getUserInformationApiCall
              .neetExamYear( response.jsonBody).toString()
              .isNotEmpty;

      isFirstNamePresent = SignupGroup.getUserInformationApiCall.firstName(
          response.jsonBody) != null
          && SignupGroup.getUserInformationApiCall
              .firstName( response.jsonBody)
              .isNotEmpty;

      isLastNamePresent = SignupGroup.getUserInformationApiCall.lastName(
          response.jsonBody) != null
          && SignupGroup.getUserInformationApiCall
              .lastName( response.jsonBody)
              .isNotEmpty;
    }


    bool isFormCompleted  = isPhonePresent && isCityPresent && isNeetExamYearPresent && isStatePresent ;
    // && isBoardExamYearPresent  && isFirstNamePresent && isLastNamePresent;
    FFAppState().isFormCompleted = isFormCompleted ;


      isLoading = false;
      isFormCompleted  = isPhonePresent && isCityPresent && isNeetExamYearPresent && isStatePresent ;
     notifyListeners();

    return Future.value(isFormCompleted && false)  ;

  }


  Future<bool> getTrialCourse(BuildContext context) async {
    setLoadingOverlay(true,context);
    final url = Uri.parse('${FFAppState().baseUrl}/get-trial-course');

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      "email": currentUserEmail.toString(),
      "phone": "0000000000",
      "course": FFAppState().hardestQsCourseIdInt,
      "name": currentUserDisplayName,
    });

    print(body);
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print('Response data: ${response.body}');
        setLoadingOverlay(false,context);
        await callLoginApi(context);
        await fetchTopics();
        Fluttertoast.showToast(
          msg: "Congrats, your Course is activated!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0
        );
        return true; // Return true on success
      } else {
        print(response.body);
        print('Failed to get trial course. Status code: ${response.statusCode}');
        setLoadingOverlay(false,context);
        return false; // Return false on failure
      }
    } catch (e) {
      print('Error occurred: $e');
      setLoadingOverlay(false,context);
      return false; // Return false if an exception occurs
    }
  }


  Future<List<String>> encodeTopics(List<dynamic> ids) async{
    return ids.map((id) => base64Encode(utf8.encode('Test:$id'))).toList();
  }

  Future<void> callLoginApi(context) async {
    try {
      setLoading(true);  // Start loading
      String authToken = FFAppState().subjectToken;
      int courseIdInt = FFAppState().hardestQsCourseIdInt;
      String altCourseIds = FFAppState().hardestQsCourseIdInts;

      final apiResponse = await LoggedInUserInformationAndCourseAccessCheckingApiCall().call(
        authToken: authToken,
        courseIdInt: courseIdInt,
        altCourseIds: altCourseIds,
      );
      print(apiResponse.jsonBody.toString());
      if (apiResponse.statusCode == 200) {
        // Parse the user data from the response
         userData = LoggedInUserInformationAndCourseAccessCheckingApiCall().me(apiResponse.jsonBody);
        if(userData==null){
          isLoggedIn = false;
          setLoading(false);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPageWidget()),
          );
          return;
        }
         isLoggedIn = true;
        userCourses = LoggedInUserInformationAndCourseAccessCheckingApiCall().courses(apiResponse.jsonBody);
        userExpiryAt  = LoggedInUserInformationAndCourseAccessCheckingApiCall().expiryDate(apiResponse.jsonBody);
          courseStatusResponse  = getJsonField(
           (apiResponse.jsonBody ?? ''),
           r'''$.data.me.profile.courseStatus''',
         ) ;
         courseStatus =  courseStatusResponse[FFAppState().hardestQsCourseIdInt.toString()]?.toString().toUpperCase();
         testSeriesCourseStatus=  courseStatusResponse[FFAppState().testCourseIdInt.toString()]?.toString().toUpperCase();

        print(userCourses.toString());
        print(courseStatus.toString());

        if(userCourses!=null && userCourses.isNotEmpty && courseStatus!='PAID') {
          print(userExpiryAt.toString());
          DateTime expiryDate = DateFormat("EEE MMM dd yyyy HH:mm:ss").parse(
              userExpiryAt);
          DateTime currentDate = DateTime.now();
          DateTime expiryDateOnly = DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
          DateTime currentDateOnly = DateTime(currentDate.year, currentDate.month, currentDate.day);

           daysLeft = expiryDateOnly.difference(currentDateOnly).inDays;
          print(daysLeft.toString());
        }
        freeChapters = LoggedInUserInformationAndCourseAccessCheckingApiCall().freeChapters(apiResponse.jsonBody);
        if(freeChapters!=null && freeChapters!.isNotEmpty &&  courseStatus!='PAID'){
          excludeIds  = await encodeTopics(freeChapters!);

        }
        else{
          excludeIds =[];
        }

         if(courseStatus=="TRIAL"|| courseStatus =="PAID"){
           hasCourseAccess = true;
           trial = courseStatus=="TRIAL";
           isPaidUser = courseStatus=="PAID"?true:false;
         }
         else{
           getTrialCourse(context);
           notifyListeners();
         }
         if(courseStatus==null){
           courseStatus = "FREE";
         }
         if(altCourseStatus==null){
           altCourseStatus = "FREE";
         }
         notifyListeners();
          print("userCourses"+userCourses.toString());
          print("freeChapters"+freeChapters.toString());
         print("courseStatus"+courseStatus.toString());
         print("isPaidUser"+isPaidUser.toString());
         print("hasCourseAccess"+hasCourseAccess.toString());
         setLoading(false);
      } else {

        debugPrint('Failed to fetch user details.');
      }
    } catch (e) {
      setLoading(false);
      debugPrint('Error in callLoginApi: $e');
    } finally {
      setLoading(false);  // Stop loading after the API call
    }
  }

  Future<Map<String, List<dynamic>>?> fetchTopics() async {
    try {
      setLoadingForFetchingTopics(true);
      String authToken = FFAppState().subjectToken;
      String courseId = FFAppState().hardestQsCourseId;

      List<String>? excludeIdsList = excludeIds;
      print(excludeIdsList);


      final apiCall = GetPracticeTestsToShowOpenAndLockedTopicsCall();


      final response = await apiCall.call(
        authToken: authToken,
        courseId: courseId,
        excludeIds: excludeIdsList,
      );


      final openTopics = apiCall.openTopicNodes(response.jsonBody)??[];
      final lockedTopics = apiCall.lockedTopicNodes(response.jsonBody)??[];
      //FFAppState().allSearchItems = apiCall.openTopicsQuestionSetsId(response.jsonBody),...apiCall.lockedTopicsQuestionSetsId(response.jsonBody)].cast<dynamic>();
     // FFAppState().allSearchItems = apiCall.openTopicsQuestionSetsId(response.jsonBody??'')??[].toList().cast<dynamic>()+apiCall.lockedTopicsQuestionSetsId(response.jsonBody??'')??[].toList().cast<dynamic>();
    // ,...apiCall.lockedTopicsQuestionSetsId(response.jsonBody)].cast<dynamic>();
    //   FFAppState().allSearchItems =
    //       PracticeGroup.getPracticeTestsToShowChapterWiseCall
    //           .allChapterWithId(
    //         (_model.apiResultdwy?.jsonBody ?? ''),
    //       )!
    //           .toList()
    //           .cast<dynamic>();
      //print( "FFAppState().allSearchItems.toString()"+FFAppState().allSearchItems.toString());
    //log("openTopics in model"+ openTopics.length.toString());
    //log("lockedTopics in model"+ lockedTopics.length.toString());

      // Fetch the accessible and restricted topics separately
      List<dynamic> accessibleTopics = apiCall.openTopicsQuestionSetsId(response.jsonBody ?? '')?.toList().cast<dynamic>() ?? [];
      List<dynamic> restrictedTopics = apiCall.lockedTopicsQuestionSetsId(response.jsonBody ?? '')?.toList().cast<dynamic>() ?? [];



      print(accessibleTopics.toString());
      print(restrictedTopics.toString());

// Combine both lists into allSearchItems
      FFAppState().allSearchItems = accessibleTopics + restrictedTopics;


      log( FFAppState().allSearchItems.toString());
      topicsData =  {
        'openTopics': openTopics,
        'lockedTopics': lockedTopics,
      };

    setLoadingForFetchingTopics(false);
      return {
        'openTopics': openTopics,
        'lockedTopics': lockedTopics,
      };
    } catch (e) {
      // Handle exceptions and return null
      setLoadingForFetchingTopics(false);
      print('Error fetching topics: $e');
      return null;
    }
  }

  Future<void> getBannersVersion2() async {
    setLoading(true);
    final db = FirebaseFirestore.instance;
    if(FFAppState().bannersByCourseId.isNotEmpty){
      return;
    }

    Map<String, CustomBanner> bannersByCourseId = {};

    try {
      // Fetch the banners collection from Firestore
      QuerySnapshot querySnapshot = await db.collection("Banners").get();

      print("Successfully completed");
      print(querySnapshot.toString());

      for (var docSnapshot in querySnapshot.docs) {

        var bannerData = docSnapshot.data() as Map<String, dynamic>;



          if (bannerData != null) {
            var banner = CustomBanner(
              title: bannerData['title'] ?? '',  // Default to empty string if null
              content: bannerData['content'] ?? '',  // Default to empty string if null
              imageUrl: bannerData['imageUrl'] ?? '',  // Default to empty string if null
              isVisible: bannerData['isVisible'] ?? false,  // Default to false if null
              courseIdForAccessCheck: bannerData['courseIdForAccessCheck'] ?? '',  // Default to empty string if null
              courseIdForOrderPage: bannerData['courseIdForOrderPage'] ?? '',  // Default to empty string if null
              seqId: bannerData['seqId'] ,  // Default to empty string if null
              ctaText: bannerData['ctaText'] ,  // Default to empty string if null
              webPageUrl: bannerData['webPageUrl'] ,  // Default to empty string if null
              webPageTitle: bannerData['webPageTitle'] ,  // Default to empty string if null
            );

            // Add to the map, using courseIdForAccessCheck as the key
            bannersByCourseId[banner.courseIdForAccessCheck.toString()+docSnapshot.id.toString()] = banner;
            print(bannersByCourseId.toString());
          } else {
    log('No banner data found for document ${docSnapshot.id}');
    }
      }
      FFAppState().bannersByCourseId = bannersByCourseId;

      // At this point, bannerMap contains courseIdForAccessCheck as keys and CustomBanner as values
      // You can now use this map wherever needed

    } catch (e) {
      print("Error fetching banners: $e");
    } finally {
      setLoading(false);  // Set loading to false after the operation is complete
    }
  }

  Future<void> filterBanners() async {

   filteredBannersList = [];

   FFAppState().bannersByCourseId.forEach((key, banner) {

      String courseStatus = courseStatusResponse[banner.courseIdForAccessCheck.toString()]?.toString()?.toUpperCase() ?? '';
      String? altCourseStatus = null;
      if(banner.courseIdForAccessCheck.toString()==FFAppState().courseIdInt.toString()){
        altCourseStatus =  courseStatusResponse[FFAppState().altCourseIdInt.toString()]?.toString()?.toUpperCase() ?? '';
      }
        if (!(altCourseStatus=="PAID" || courseStatus == 'PAID') && banner.isVisible) {
          filteredBannersList.add(banner);
        }
    });
   filteredBannersList.sort((a, b) {
     int aSeqId = a.seqId ?? double.infinity.toInt(); // Set default to infinity if seqId is null
     int bSeqId = b.seqId ?? double.infinity.toInt(); // Set default to infinity if seqId is null
     return aSeqId.compareTo(bSeqId);
   });



   return ;
  }






  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setLoadingForFetchingTopics(bool value) {
    isTopicsLoading = value;
    notifyListeners();
  }
}