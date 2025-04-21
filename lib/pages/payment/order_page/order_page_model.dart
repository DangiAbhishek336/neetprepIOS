import 'dart:convert';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../../clevertap/clevertap_service.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/form_field_controller.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';


class OrderPageModel extends FlutterFlowModel {
  ///  Local state fields for this page.

  bool is6MonthChecked = true;
  FormFieldController<String>? dropDownValueController;
  TextEditingController couponCodeController = new TextEditingController();
  String? dropDownValue;
  String couponButtonText = "Apply";
  int? couponId =null;

  bool is1YearChecked = false;


  bool isCouponValidated = false;
 bool enableCouponButton = false;
 String? couponValidityError = "";
  String? discountAfterCouponIsApplied = null;

  String amount = '';

  String title = '';

  String fee = '';

  String cc = '216413';

  bool? isloading = true;

    bool? isOptionSel =true; 


    bool hasShipment = false;

  late YoutubePlayerController _ytControllerFlashcards;
  late YoutubePlayerController _ytControllerAbhyas;
  late YoutubePlayerController _ytControllerHTS;
  late YoutubePlayerController _ytControllerEssentialBooks;
  late YoutubePlayerController _ytControllerEssential;
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Backend Call - API (Get course price and course offers to select from to start payment)] action in OrderPage widget.
  ApiCallResponse? courseInfo;
  // Stores action output result for [Bottom Sheet - BottomPopup] action in Container widget.
  dynamic bottomPop;
  // Stores action output result for [Backend Call - API (Create payment for a user for a course and course offer and get checksum)] action in Button widget.
  ApiCallResponse? paymentDetails1;
  // Stores action output result for [Custom Action - paytmIntegration] action in Button widget.
  String? paymentStatus1;
  // Stores action output result for [Backend Call - API (Payment Success Backend Processing call to enable course)] action in Button widget.
  ApiCallResponse? paymentResponse1;

  dynamic addOnCourseList= [];
  dynamic complimentaryAddOnList = [];
  List<int>? selectedAddOnCoursesList= [];
  List<bool> addOnCheckBoxList = [];
  List<bool> complimentaryAddOnCheckBoxList = [];
  List<bool> hasShipmentInSelectedAddOnCoursesList = [];
  List<bool> hasShipmentInComplimentaryCourseList = [];


  /// Initialization and disposal methods.

  Future<Map<String, dynamic>?> checkCouponValidity(Map<String, String> body) async {
    var url = Uri.parse('${FFAppState().baseUrl}/coupon_wo_payment');
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer ' + FFAppState().subjectToken,
    };

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // Parse the JSON response
        var jsonResponse = jsonDecode(response.body);
        String? amount;
        String? errorMessage;

        if (jsonResponse != null) {
          amount = jsonResponse['payment']['amount'].toString();
          couponId = jsonResponse['payment']['couponId'];
          errorMessage = jsonResponse['error'];
          print(jsonResponse.toString());
        }

        return {'amount': amount, 'error': errorMessage};
      } else {
        // Handle error
        var jsonResponse = jsonDecode(response.body);
        String? errorMessage = jsonResponse['error'];

        print('Coupon eligibility check failed with status ${response.statusCode}');
        print(response.body);
        setState(){
          enableCouponButton = true;
        }
        return {'amount': null, 'error': errorMessage};
      }
    } catch (e) {
      // Handle exceptions
      setState(){
        enableCouponButton = true;
      }
      print('Error occurred while checking coupon validity: $e');
      return {'amount': null, 'error': e.toString()};
    }
  }

  String base64DecodeString(String base64EncodedString) {
    List<int> bytes = base64.decode(base64EncodedString);
    String decodedString = utf8.decode(bytes);
    print(decodedString);
    String issueNum  = decodedString.split(":")[1];
    return issueNum;
  }

  List<int> addComplimentaryCourses(List<dynamic> addOnCourseList,) {
    List<int> filteredList = [];
    int index  = 0;

    addOnCourseList.forEach((item) {
      if (item!['complimentaryCourseOffer'] == null) {
        filteredList.add(int.parse(base64DecodeString(item['complimentaryCourse']['id'])));
        hasShipmentInComplimentaryCourseList[index] = item['complimentaryCourse']['hasShipment'];

      } else {
        filteredList.add(int.parse(base64DecodeString(item['complimentaryCourse']['id'])));
        hasShipmentInComplimentaryCourseList[index] = item['complimentaryCourseOffer']['hasShipment'];

      }
      index++;
    });
    return filteredList;
  }


  List<int> filterAddOnCourses(List<dynamic> addOnCourseList,) {
    List<int> filteredList = [];
    int index  = 0;

    addOnCourseList.forEach((item) {
      Map<String, dynamic>? addonCourseOffer = item!['addonCourseOffer'];
      Map<String, dynamic> addonCourse = item['addonCourse'];

      // Check if addonCourseOffer is null
      if (addonCourseOffer == null) {
        // Check discountedFee within addonCourse
        print("1"+ addonCourse['discountedFee']);
      //  if (addonCourse['discountedFee'].toString() == "0.00") {
          filteredList.add(item['addonCourseId']);
          amount = (double.parse(amount) + double.parse(item['addonCourse']['discountedFee'])).toString();
          fee = (double.parse(fee) +double.parse(item['addonCourse']['fee'])).toString();
          addOnCheckBoxList[index]  = true;
        hasShipmentInSelectedAddOnCoursesList[index] = item['addonCourse']['hasShipment'];

      //  }
      } else {
        // Check if discountedFee within addonCourseOffer is 0.0
        print("22"+ addonCourseOffer['discountedFee']);
       // if (addonCourseOffer['discountedFee'].toString() == "0.00") {
          print("33"+ addonCourseOffer['discountedFee']);
          filteredList.add(item['addonCourseId']);
          amount = (double.parse(amount) + double.parse(item['addonCourseOffer']['discountedFee'])).toString();
          fee = (double.parse(fee) +double.parse(item['addonCourseOffer']['fee'])).toString();
          addOnCheckBoxList[index]  = true;
        hasShipmentInSelectedAddOnCoursesList[index] = item['addonCourseOffer']['hasShipment'];
      //  }
      }
      index++;
    });

    return filteredList;
  }

  List<int> filterComplimentaryAddOnCourses(List<dynamic> addOnCourseList,) {
    List<int> filteredList = [];
    int index  = 0;

    addOnCourseList.forEach((item) {
      if (item!['complimentaryCourseOffer'] == null) {
          filteredList.add(int.parse(base64DecodeString(item['complimentaryCourse']['id'])));
          amount = (double.parse(amount) + 0.0).toString();
          fee = (double.parse(fee) +double.parse(item['complimentaryCourse']['discountedFee'])).toString();
          hasShipmentInComplimentaryCourseList[index] = item['complimentaryCourse']['hasShipment'];

      } else {
          filteredList.add(int.parse(base64DecodeString(item['complimentaryCourse']['id'])));
          amount = (double.parse(amount) + 0.0).toString();
          fee = (double.parse(fee) +double.parse(item['complimentaryCourseOffer']['discountedFee'])).toString();
          hasShipmentInComplimentaryCourseList[index] = item['complimentaryCourseOffer']['hasShipment'];

      }
      index++;
    });
    return filteredList;
  }

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
  }


  void purchaseFlashcardBottomSheet(context) {
    _ytControllerFlashcards = YoutubePlayerController.fromVideoId(
      videoId: "C72UyHhqrx4",
      autoPlay: false,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    );
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      context: context,
      builder: (context) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40.0, right: 16),
                          child: SvgPicture.asset(
                            'assets/images/close_circle.svg',
                            fit: BoxFit.none,
                            color:FlutterFlowTheme.of(context).primaryText
                          ),
                        ),
                      )
                    ]),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: SvgPicture.asset("assets/images/gift.svg", height: 60,),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                              'Pagewise Flashcards',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                fontWeight: FontWeight.w700,
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 20.0,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                          ],
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ),
                    ),
                    Padding(
                      padding:const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: YoutubePlayer(
                              controller: _ytControllerFlashcards,
                              aspectRatio: 16 / 9,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: RichText(
                        text: TextSpan(
                          text:
                          'FlashCards are a Unique Way to REVISE NCERT based on ',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                            fontSize: 13,
                            fontFamily: FlutterFlowTheme.of(context)
                                .bodyMediumFamily,
                            color: FlutterFlowTheme.of(context).accent1,
                            fontWeight: FontWeight.w400,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context)
                                    .bodyMediumFamily),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "ACTIVE RECALL & SPACED REPETITION ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "- scientifically proven methods for retaining longer.\n\nThere are ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "10,000+ PageWise Flashcards ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "for P+C+B with Both NEW & OLD NCERT Page Filter.\n\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text: "For ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Physics and Physical Chemistry, ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "each Flashcard is ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "linked to ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "a relevant calculation based ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Q ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "based on the formula/concept tested in the flashcard. Almost all questions have detailed ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "audio/video explanations, ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "apart from the ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "hints, steps of calculation ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "& detailed text explanations .\n\nActively Recall NCERT in a PageWise manner & Rapidly Revise the Most Forgettable Words & Concepts on an NCERT Page using PageWise FlashCards.",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),



                  ]),
            ),
          ),
          bottomNavigationBar: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
            child: ElevatedButton(
                onPressed: () async {

                  FirebaseAnalytics.instance.logEvent(
                    name: 'buy_now_button_click',
                    parameters: {
                      "courseId": FFAppState().flashcardCourseIdInt.toString(),
                    },
                  );
                  CleverTapService.recordEvent(
                    'Buy Now Clicked',
                    {"courseId":
                    FFAppState().flashcardCourseIdInt.toString(),

                    },
                  );
                  context.pop();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  elevation: 5,
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Go Buy Now',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily:
                      FlutterFlowTheme.of(context).bodyMediumFamily,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 14.0,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context).bodyMediumFamily),
                    ))),
          ),
        );
      },
    );
  }


  void purchaseAbhyas2BottomSheet(context) {

    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      context: context,
      builder: (context) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40.0, right: 16),
                          child: SvgPicture.asset(
                              'assets/images/close_circle.svg',
                              fit: BoxFit.none,
                              color:FlutterFlowTheme.of(context).primaryText
                          ),
                        ),
                      )
                    ]),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: SvgPicture.asset("assets/images/gift.svg", height: 60,),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                              'Custom Abhyas',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                fontWeight: FontWeight.w700,
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 20.0,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                          ],
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        child: ImageSlideshow(
                          width: double.infinity,
                          height: 300,
                          initialPage: 0,
                          indicatorColor: FlutterFlowTheme.of(context).primary,
                          indicatorBackgroundColor: Colors.grey,
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                            //   child: AspectRatio(
                            //     aspectRatio: 16 / 9,
                            //     child: YoutubePlayer(
                            //       controller: _ytControllerHTS,
                            //       aspectRatio: 16 / 9,
                            //     ),
                            //   ),
                            // ),
                            Image.asset(
                              'assets/images/abs1.png',
                              fit: BoxFit.cover,
                            ),
                            Image.asset(
                              'assets/images/abs2.png',
                              fit: BoxFit.cover,
                            ),
                            Image.asset(
                              'assets/images/abs3.png',
                              fit: BoxFit.cover,
                            ),
                            Image.asset(
                              'assets/images/abs4.png',
                              fit: BoxFit.cover,
                            ),
                            Image.asset(
                              'assets/images/abs5.png',
                              fit: BoxFit.cover,
                            ),
                            Image.asset(
                              'assets/images/abs6.png',
                              fit: BoxFit.cover,
                            ),
                          ],
                          autoPlayInterval: null,
                          isLoop: false,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: RichText(
                        text: TextSpan(
                          text: 'Introducing ',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontSize: 13,
                            fontFamily:
                            FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: FlutterFlowTheme.of(context).accent1,
                            fontWeight: FontWeight.w400,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).bodyMediumFamily),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Custom Abhyas – ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Your ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text: "Personalized ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "NEET Practice Companion! 📝\n\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text: "With Custom Abhyas, experience session-based question practice tailored just for NEET prep. Choose subjects, apply filters, and receive detailed performance analytics—all in one platform to target your weaknesses and track your progress. 📊✨\n\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text: "Select Subject\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text: "Begin by picking the subject—Physics, Chemistry, or Biology. A simple start to focus your practice. ⚛️🧬\n\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text: "Choose Chapter & Sub-Topics\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text: "Next, select the chapter and dive deeper by choosing specific sub-topics. This helps you cover exactly what you need, one focused step at a time. 🔍\n\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text: "Apply Filters for a Tailored Experience\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text: "Refine your session by filtering questions based on difficulty level, bookmarked questions, or past mistakes. Choose from sets like NCERT-based, PYQs, or Recommended Sets for an authentic NEET-like experience. 🏆\n\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Set the Number of Questions\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text: "Customize each session with the exact number of questions you want. Perfect for both quick revisions and extensive practice sessions. ⏳\n\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Create Session & Start Practicing\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text: "Click \"Create Session\" and begin your tailored practice! Get instant explanations and solutions as you go, enhancing learning in real-time. 💡\n\nEnd with Detailed Analytics Wrap up with Session Analytics that show your performance—correct vs. incorrect questions, improvement areas, and overall progress. Track your streak and keep improving with every session! 📈🔥",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),


                  ]),
            ),
          ),
          bottomNavigationBar: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
            child: ElevatedButton(
                onPressed: () async {
                  FirebaseAnalytics.instance.logEvent(
                    name: 'buy_now_button_click',
                    parameters: {
                      "courseId": FFAppState().abhyas2CourseIdInt.toString(),
                    },
                  );
                  CleverTapService.recordEvent(
                    'Buy Now Clicked',
                    {"courseId":
                    FFAppState().abhyas2CourseIdInt.toString(),

                    },
                  );
                  context.pop();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  elevation: 5,
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Go Buy Now',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily:
                      FlutterFlowTheme.of(context).bodyMediumFamily,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 14.0,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context).bodyMediumFamily),
                    ))),
          ),
        );
      },
    );
  }

  void purchaseAbhyasBottomSheet(context) {
    _ytControllerFlashcards = YoutubePlayerController.fromVideoId(
      videoId: "Zd-yMyML9hc",
      autoPlay: false,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    );
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      context: context,
      builder: (context) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40.0, right: 16),
                          child: SvgPicture.asset(
                              'assets/images/close_circle.svg',
                              fit: BoxFit.none,
                              color:FlutterFlowTheme.of(context).primaryText
                          ),
                        ),
                      )
                    ]),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: SvgPicture.asset("assets/images/gift.svg", height: 60,),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                              'NCERT Padne k Alawa NCERT Based Q Practice bhi Krni hai Zaroori !',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                fontWeight: FontWeight.w700,
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 20.0,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                          ],
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ),
                    ),
                    Padding(
                      padding:const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: YoutubePlayer(
                              controller: _ytControllerFlashcards,
                              aspectRatio: 16 / 9,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: RichText(
                        text: TextSpan(
                          text:
                          "FIRST TIME EVER , Solve Q's exactly from pages of NCERT you are reading daily using the Page Filter (both available for New & Old NCERT) in Abhyas Batch!\n",
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                            fontSize: 13,
                            fontFamily: FlutterFlowTheme.of(context)
                                .bodyMediumFamily,
                            color: FlutterFlowTheme.of(context).accent1,
                            fontWeight: FontWeight.w400,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context)
                                    .bodyMediumFamily),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "NCERT Abhyas Batch is a One Stop Solution for Complete NCERT Based Q Practice Practice for NEET Preparation. Not only you can do Question Practice Pagewise from both old and newer NCERT's, with PYQ Marked NCERT, you can also attempt 25 yrs NEET, AIIMS & AIPMT PYQ's for all the three subjects PAGEWISE itself as you read through NCERT. On top of this, it all comes with detailed audio and video solutions, apart from text explanations to almost all the Q's, has NCERT Forming Line from Which Q is asked, hints & steps of solving Calculation based Q & PYQ Marking too to Q's! The Bookmark feature allows you to revisit the difficult Q's later!\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "For iOS Users / Logging in Laptop, Just Download Google Chrome and search  essential.neetprep.com ( don't put www or http, just type this as such & press enter) \n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Abhyas Batch comes with a 3 day No Q Asked 100% refund policy, so what are you guys waiting for?",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Padhai Karo Kahin se Lekin\nQ Practice karo Yahi se",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),



                  ]),
            ),
          ),
          bottomNavigationBar: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
            child: ElevatedButton(
                onPressed: () async {
                  FirebaseAnalytics.instance.logEvent(
                    name: 'buy_now_button_click',
                    parameters: {
                      "courseId": FFAppState().courseIdInt.toString(),
                    },
                  );
                  CleverTapService.recordEvent(
                    'Buy Now Clicked',
                    {"courseId":
                    FFAppState().courseIdInt.toString(),

                    },
                  );
                  context.pop();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  elevation: 5,
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Go Buy Now',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily:
                      FlutterFlowTheme.of(context).bodyMediumFamily,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 14.0,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context).bodyMediumFamily),
                    ))),
          ),
        );
      },
    );
  }

  void purchaseEssentialBottomSheet(context) {
    _ytControllerEssential = YoutubePlayerController.fromVideoId(
      videoId: "E2n8SuDDnc8",
      autoPlay: false,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    );
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      context: context,
      builder: (context) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40.0, right: 16),
                          child: SvgPicture.asset(
                            'assets/images/close_circle.svg',
                            fit: BoxFit.none,
                            color:FlutterFlowTheme.of(context).primaryText
                          ),
                        ),
                      )
                    ]),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: SvgPicture.asset("assets/images/gift.svg", height: 60,),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                              'Abhyas Essential',
                              style: FlutterFlowTheme.of(context)
                                  .titleMedium,
                            ),
                          ],
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: YoutubePlayer(
                          controller: _ytControllerEssential,
                          aspectRatio: 16 / 9,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: RichText(
                        text: TextSpan(
                          text:
                          'Abhyas Essential Course includes ',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                            fontSize: 13,
                            fontFamily: FlutterFlowTheme.of(context)
                                .bodyMediumFamily,
                            color: FlutterFlowTheme.of(context).accent1,
                            fontWeight: FontWeight.w400,
                            useGoogleFonts: GoogleFonts.asMap()
                                .containsKey(
                                FlutterFlowTheme.of(context)
                                    .bodyMediumFamily),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Handpicked HIGHEST YIELD PAGEWISE NCERT Based Q's ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "(75-100 Q's per chapter). ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Dr Aman Tilak ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "has himself personally ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text: "contributed ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "in the Q's Selection process so that this course has nothing but the BEST & the ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "MOST EXPECTED Q's for NEET",
                              style: FlutterFlowTheme.of(context).bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              ", covering all the topics according to ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Updated Syllabus.\n\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "As you go on solving Q's in an NCERT PageWise manner from Abhyas Essential, you will seamlessly cover all the Important ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "NCERT In-Text Q's, ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Solved ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Examples ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "and Back ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Exercise ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "based Q's which are all converted into MCQ format, maximally aiding your NEET preparation. We have gone a step ahead to include All Important ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Exemplar ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Based Q's, which are also converted into MCQ format, all with detailed ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Audio/Video Explanations.\n\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "To make this ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "LEGENDARY",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              ", we have included ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "ALL Previous Year Q's ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "from the past 6 Years ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "since NTA is conducting NEET, ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "from ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "2019-2024",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              ", including all updated syllabus based Q's from 2024 Jhajjar Paper, 2019 Odisha, 2020 COVID, 2022 Ganganagar, 2022 Abroad & 2023 Manipur paper, all with Detailed Video solutions. All of this ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),

                            TextSpan(
                              text:
                              "will get covered SEAMLESSLY ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "as you ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),

                            TextSpan(
                              text:
                              "go on solving the Q's ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),

                            TextSpan(
                              text:
                              "from Abhyas Essential.\n\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "As a ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "LIMITED TIME DEAL ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              ", Abhyas Essential course is being included under the bigger ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),

                            TextSpan(
                              text:
                              "NCERT Abhyas Batch ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),

                            TextSpan(
                              text:
                              "which has",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),

                            TextSpan(
                              text:
                              " additional 150-200 Q's per chapter ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),

                            TextSpan(
                              text:
                              "apart from these for rigorous Q Practice. Abhyas Essential is meant to be used for ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),


                            TextSpan(
                              text:
                              "ACTIVE RECALL & REVISION ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "and is ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "NOT a SUBSTITUTE ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),


                            TextSpan(
                              text:
                              "of NCERT Abhyas Batch. For ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "mastering ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "our NEET preparation, it's highly recommended that after you are complete practicing Q's from ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Abhyas Essential ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "course, do ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "In-Depth ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Q Practice from ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),

                            TextSpan(
                              text:
                              "NCERT Abhyas Batch",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              ", which has ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "3 times ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                                text:
                                "as many ",
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                  fontSize: 13,
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  color: FlutterFlowTheme.of(context).accent1,
                                  fontWeight: FontWeight.w400,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(
                                      FlutterFlowTheme.of(context)
                                          .bodyMediumFamily),
                                )),
                            TextSpan(
                              text:
                              "Q's ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "as ABHYAS ESSENTIAL course, covering in depth & detail everything and thus ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "making NCERT ABHYAS BATCH ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "as a ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "ONE STOP SOLUTION FOR Q PRACTICE ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "for NEET preparation.",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
          bottomNavigationBar: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
            child: ElevatedButton(
                onPressed: () async {
                  FirebaseAnalytics.instance.logEvent(
                    name: 'buy_now_button_click',
                    parameters: {
                      "courseId": FFAppState().essentialCourseIdInt.toString(),
                    },
                  );
                  CleverTapService.recordEvent(
                    'Buy Now Clicked',
                    {"courseId":
                    FFAppState().essentialCourseIdInt.toString(),

                    },
                  );
                  context.pop();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  elevation: 5,
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Go Buy Now',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily:
                      FlutterFlowTheme.of(context).bodyMediumFamily,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 14.0,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context).bodyMediumFamily),
                    ))),
          ),
        );
      },
    );
  }

  void purchaseAbhyasBooksBottomSheet(context) {
    _ytControllerAbhyas = YoutubePlayerController.fromVideoId(
      videoId: "CET0flp5Wzw",
      autoPlay: false,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    );
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      context: context,
      builder: (context) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40.0, right: 16),
                          child: SvgPicture.asset(
                            'assets/images/close_circle.svg',
                            fit: BoxFit.none,
                            color: FlutterFlowTheme.of(context).primaryText,
                          ),
                        ),
                      )
                    ]),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: SvgPicture.asset("assets/images/gift.svg", height: 60,),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                              'NCERT Abhyas + 8 Books (Phy & Chem Pagewise MCQs)',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                fontWeight: FontWeight.w700,
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 20.0,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                          ],
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                    //   child: Container(
                    //     child: Image.asset(
                    //       'assets/images/abhyasBooks.png',
                    //       fit: BoxFit.cover,
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: YoutubePlayer(
                          controller: _ytControllerAbhyas,
                          aspectRatio: 16 / 9,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: RichText(
                        text: TextSpan(
                          text:
                          'NCERT Abhyas Batch Class 11+12th Offline Books Package contains ',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                            fontSize: 13,
                            fontFamily: FlutterFlowTheme.of(context)
                                .bodyMediumFamily,
                            color: FlutterFlowTheme.of(context).accent1,
                            fontWeight: FontWeight.w400,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context)
                                    .bodyMediumFamily),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "total 8 books",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              " (2 Physics Class 11th + 2 Physics Class 12th + 2 Chemistry Class 11th + 2 Chemistry Class 12th) & 50 NEET like ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "OMR Sheets for Bubbling Practice. All these are Based on Updated NEET Syllabus ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "and have to be used in conjunction with NCERT Abhyas Batch of NEET Essential App (to be enrolled separately). It contains NCERT (both OLD + NEW) ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text: "Pagewise arranged Q's ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "of all varieties (including Assertion Reason, Statements Type, Sequencing Type, Matching Type, Diagram Based, Calculations Based, Previous Year Questions Based etc) for dedicated Offline Pen & Paper based Q Practice for NEET Aspirants.Answer key is available at the end of every chapter. ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Detailed Text, Audio and Video explanations",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              " are also available and can be accessed from Online NCERT Abhyas Batch. ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
          bottomNavigationBar: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
            child: ElevatedButton(
                onPressed: () async {
                  FirebaseAnalytics.instance.logEvent(
                    name: 'buy_now_button_click',
                    parameters: {
                      "courseId": FFAppState().offlineBookCourseIdInt.toString(),
                    },
                  );
                  CleverTapService.recordEvent(
                    'Buy Now Clicked',
                    {"courseId":
                    FFAppState().offlineBookCourseIdInt.toString(),

                    },
                  );
                  context.pop();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  elevation: 5,
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Go Buy Now',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily:
                      FlutterFlowTheme.of(context).bodyMediumFamily,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 14.0,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context).bodyMediumFamily),
                    ))),
          ),
        );
      },
    );
  }

  void purchaseHTSBottomSheet(context) {
    _ytControllerHTS = YoutubePlayerController.fromVideoId(
      videoId: "m3mW0N31vdE",
      autoPlay: false,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    );
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      context: context,
      builder: (context) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40.0, right: 16),
                          child: SvgPicture.asset(
                            'assets/images/close_circle.svg',
                            fit: BoxFit.none,
                              color:FlutterFlowTheme.of(context).primaryText
                          ),
                        ),
                      )
                    ]),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: Image.asset(
                        "assets/images/info.png",
                        height: 60,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                              'Home Test Series',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                fontWeight: FontWeight.w700,
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 20.0,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                          ],
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ),
                    ),
                    Padding(
                      padding:const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: ImageSlideshow(
                          width: double.infinity,

                          initialPage: 0,
                          indicatorColor: FlutterFlowTheme.of(context).primary,
                          indicatorBackgroundColor: Colors.grey,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: YoutubePlayer(
                                  controller: _ytControllerHTS,
                                  aspectRatio: 16 / 9,
                                ),
                              ),
                            ),
                            // Image.asset(
                            //   'assets/images/hts1.jpg',
                            //   fit: BoxFit.cover,
                            // ),
                            // Image.asset(
                            //   'assets/images/hts2.jpg',
                            //   fit: BoxFit.cover,
                            // ),
                            // Image.asset(
                            //   'assets/images/hts3.jpg',
                            //   fit: BoxFit.cover,
                            // ),
                            // Image.asset(
                            //   'assets/images/hts4.jpg',
                            //   fit: BoxFit.cover,
                            // ),
                            // Image.asset(
                            //   'assets/images/hts5.jpg',
                            //   fit: BoxFit.cover,
                            // ),

                          ],
                          autoPlayInterval: null,
                          isLoop: false,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: RichText(
                        text: TextSpan(
                          text:
                          "Home Test Series for NEET 2025/26 includes ",
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                            fontSize: 13,
                            fontFamily: FlutterFlowTheme.of(context)
                                .bodyMediumFamily,
                            color: FlutterFlowTheme.of(context).accent1,
                            fontWeight: FontWeight.w400,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context)
                                    .bodyMediumFamily),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "New 180 Q's NEET Pattern 20 Full-Length ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "(720 marks each) based on the latest NTA NEET (UG) pattern alongwith ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "25 OMR Sheets ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "for Bubbling Practice which you can give at the ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text: "ease of your home. ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Expect ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Delivery within 4-5 days ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "of ordering. \n\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Dr. Aman Tilak ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "has ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "himself contributed ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "and supervised the Q's of this Home Test series jisse tumhe ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "different types ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "k dher saare Q's practice krne ko mile in a 720 marks test based format, just like your actual NEET Exam!\n\nA",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              " Unique Feature, ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "which you won't find anywhere else is that this test series is designed in such a way that ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "ek baar saare tests lagaa liye toh saara syllabus bhi ek baar revise🔥ho jaye ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "+ tumhe apne weak areas k baare mein bhi pataa lag jayega because questions are made encompassing all the topics of NCERT of all 3 subjects!\n\nThe test series book includes:\n10 Level I Test Booklets\n10 Level II Test Booklets\n25 OMRs\nVideo/audio solutions for in-depth\nunderstanding for all questions via Telegram bot @HYTSBOT.",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),



                  ]),
            ),
          ),
          bottomNavigationBar: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
            child: ElevatedButton(
                onPressed: () async {
                  FirebaseAnalytics.instance.logEvent(
                    name: 'buy_now_button_click',
                    parameters: {
                      "courseId": FFAppState().homeTestSeriesBookCourseIdInt.toString(),
                    },
                  );
                  CleverTapService.recordEvent(
                    'Buy Now Clicked',
                    {"courseId":
                    FFAppState().homeTestSeriesBookCourseIdInt.toString(),

                    },
                  );
                  context.pop();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  elevation: 5,
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Go Buy Now',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily:
                      FlutterFlowTheme.of(context).bodyMediumFamily,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 14.0,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context).bodyMediumFamily),
                    ))),
          ),
        );
      },
    );
  }


  void purchasePyqBottomSheet(context) {
    _ytControllerHTS = YoutubePlayerController.fromVideoId(
      videoId: "wc4x6WGIKeI",
      autoPlay: false,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    );
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      context: context,
      builder: (context) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40.0, right: 16),
                          child: SvgPicture.asset(
                              'assets/images/close_circle.svg',
                              fit: BoxFit.none,
                              color:FlutterFlowTheme.of(context).primaryText
                          ),
                        ),
                      )
                    ]),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: Image.asset(
                        "assets/images/info.png",
                        height: 60,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                              'PYQ Marked NCERT (P+C+B) with Q Attempting Feature ',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                fontWeight: FontWeight.w700,
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 20.0,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                          ],
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ),
                    ),
                    Padding(
                      padding:const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: ImageSlideshow(
                          width: double.infinity,

                          initialPage: 0,
                          indicatorColor: FlutterFlowTheme.of(context).primary,
                          indicatorBackgroundColor: Colors.grey,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: YoutubePlayer(
                                  controller: _ytControllerHTS,
                                  aspectRatio: 16 / 9,
                                ),
                              ),
                            ),
                          ],
                          autoPlayInterval: null,
                          isLoop: false,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: RichText(
                        text: TextSpan(
                          text:
                          "With ",
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                            fontSize: 13,
                            fontFamily: FlutterFlowTheme.of(context)
                                .bodyMediumFamily,
                            color: FlutterFlowTheme.of(context).accent1,
                            fontWeight: FontWeight.w400,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context)
                                    .bodyMediumFamily),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "PYQ Marked NCERT",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              ", you can attempt 25 yrs NEET, AIIMS & AIPMT PYQ's for all the three subjects PAGEWISE itself as you read through NCERT. On top of this, it all comes with ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "detailed audio and video solutions, apart from text explanations to almost all the Q's, has NCERT Forming Line ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "from Which Q is asked, ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text: "hints ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "& steps of solving Calculation based Q \n \n Get 25 Yrs PYQ Marked Phy + Chem + Bio NCERT with Q Attempting Feature & Video Solutions complementary with the Abhyas Essential Course."
                            ,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),



                  ]),
            ),
          ),
          bottomNavigationBar: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
            child: ElevatedButton(
                onPressed: () async {
                  FirebaseAnalytics.instance.logEvent(
                    name: 'buy_now_button_click',
                    parameters: {
                      "courseId": FFAppState().pyqMarkedNcertCourseIdInt.toString(),
                    },
                  );
                  CleverTapService.recordEvent(
                    'Buy Now Clicked',
                    {"courseId":
                    FFAppState().pyqMarkedNcertCourseIdInt.toString(),

                    },
                  );
                  context.pop();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  elevation: 5,
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Go Buy Now',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily:
                      FlutterFlowTheme.of(context).bodyMediumFamily,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 14.0,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context).bodyMediumFamily),
                    ))),
          ),
        );
      },
    );
  }

  void purchaseIncorrectMarkedBottomSheet(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      context: context,
      builder: (context) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40.0, right: 16),
                          child: SvgPicture.asset(
                              'assets/images/close_circle.svg',
                              fit: BoxFit.none,
                              color:FlutterFlowTheme.of(context).primaryText
                          ),
                        ),
                      )
                    ]),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: Image.asset(
                        "assets/images/info.png",
                        height: 60,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                              "Incorrect Q's Marked NCERT",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                fontWeight: FontWeight.w700,
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 20.0,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                          ],
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ),
                    ),
                    Padding(
                      padding:const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: Container(
                        height:300,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: ImageSlideshow(
                          width: double.infinity,

                          initialPage: 0,
                          indicatorColor: FlutterFlowTheme.of(context).primary,
                          indicatorBackgroundColor: Colors.grey,
                          children: [
                            Image.asset(
                              'assets/images/1.jpg',
                              fit: BoxFit.contain,
                            ),
                            Image.asset(
                              'assets/images/2.jpg',
                              fit: BoxFit.contain,
                            ),
                            Image.asset(
                              'assets/images/3.jpg',
                              fit: BoxFit.contain,
                            ),
                            Image.asset(
                              'assets/images/4.jpg',
                              fit: BoxFit.contain,
                            ),
                          ],
                          autoPlayInterval: null,
                          isLoop: false,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: RichText(
                        text: TextSpan(
                          text:
                          "All the questions that you make mistakes in get ",
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                            fontSize: 13,
                            fontFamily: FlutterFlowTheme.of(context)
                                .bodyMediumFamily,
                            color: FlutterFlowTheme.of(context).accent1,
                            fontWeight: FontWeight.w400,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context)
                                    .bodyMediumFamily),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "highlighted automatically ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "with red color inside Incorrect Q's Marked NCERT.\n\nDuring your last minute revision, you can go through these highlights to ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "rapidly go through your weak areas of NCERT. ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Moreover, you can click on the highlights and attempt the questions again, all of which have detailed audio/video and text explanations.",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),



                  ]),
            ),
          ),
          bottomNavigationBar: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
            child: ElevatedButton(
                onPressed: () async {
                  FirebaseAnalytics.instance.logEvent(
                    name: 'buy_now_button_click',
                    parameters: {
                      "courseId": FFAppState().incorrectMarkedNcertCourseIdInt.toString(),
                    },
                  );
                  CleverTapService.recordEvent(
                    'Buy Now Clicked',
                    {"courseId":
                    FFAppState().incorrectMarkedNcertCourseIdInt.toString(),

                    },
                  );
                  context.pop();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  elevation: 5,
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Go Buy Now',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily:
                      FlutterFlowTheme.of(context).bodyMediumFamily,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 14.0,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context).bodyMediumFamily),
                    ))),
          ),
        );
      },
    );
  }



  void purchaseARBottomSheet(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      context: context,
      builder: (context) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40.0, right: 16),
                          child: SvgPicture.asset(
                            'assets/images/close_circle.svg',
                            fit: BoxFit.none,
                            color: FlutterFlowTheme.of(context).primaryText
                          ),
                        ),
                      )
                    ]),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: SvgPicture.asset("assets/images/gift.svg", height: 60,),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                              'A/R Power Up',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                fontWeight: FontWeight.w700,
                                color: FlutterFlowTheme.of(context).primaryText ,
                                fontSize: 20.0,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                          ],
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: Container(
                        child:
                        ImageSlideshow(
                          width: double.infinity,
                          height: 300,
                          initialPage: 0,
                          indicatorColor: FlutterFlowTheme.of(context).primary,
                          indicatorBackgroundColor: Colors.grey,
                          children: [
                            Image.asset(
                              'assets/images/ar_1.jpg',
                              fit: BoxFit.contain,
                            ),
                            Image.asset(
                              'assets/images/ar_2.jpg',
                              fit: BoxFit.contain,
                            ),
                            Image.asset(
                              'assets/images/ar_3.jpg',
                              fit: BoxFit.contain,
                            ),
                            Image.asset(
                              'assets/images/ar_4.jpg',
                              fit: BoxFit.contain,
                            ),
                            Image.asset(
                              'assets/images/ar_5.jpg',
                              fit: BoxFit.contain,
                            ),
                          ],
                          autoPlayInterval: null,
                          isLoop: false,
                        ),

                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: RichText(
                        text: TextSpan(
                          text:
                          'A/R PowerUp Course is a ',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                            fontSize: 13,
                            fontFamily: FlutterFlowTheme.of(context)
                                .bodyMediumFamily,
                            color: FlutterFlowTheme.of(context).accent1,
                            fontWeight: FontWeight.w400,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context)
                                    .bodyMediumFamily),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "BLESSING ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "for all those students who face ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "difficulty ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "in solving the NEWER QUESTION TYPES introduced in recent years of NEET like ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text: "ASSERTION REASON, STATEMENTS, SEQUENCING, MATCHING & GRAPH Based Q's. ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "You get to solve a total of 2500+ such Q's at one single place with A/R PowerUp Course!\n\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "On top of this, it all comes with detailed audio and ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "video solutions, ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w700,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "apart from text explanations to almost all the Q's, has NCERT Forming Line ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "NCERT Forming Line ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "from Which Q is asked, ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Hints & Steps ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "of solving for Calculation based Q's & PYQ Marking too to Q's! You can Bookmark the Q's you wish to revisit later as well!",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
          bottomNavigationBar: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
            child: ElevatedButton(
                onPressed: () async {
                  FirebaseAnalytics.instance.logEvent(
                    name: 'buy_now_button_click',
                    parameters: {
                      "courseId": FFAppState().assertionCourseIdInt.toString(),
                    },
                  );
                  CleverTapService.recordEvent(
                    'Buy Now Clicked',
                    {"courseId":
                    FFAppState().assertionCourseIdInt.toString(),

                    },
                  );
                  context.pop();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  elevation: 5,
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Go Buy Now',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily:
                      FlutterFlowTheme.of(context).bodyMediumFamily,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 14.0,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context).bodyMediumFamily),
                    ))),
          ),
        );
      },
    );
  }

  void purchaseAbhyasEssentialBooksBottomSheet(context) {
    _ytControllerEssentialBooks = YoutubePlayerController.fromVideoId(
      videoId: "rbcvB9w1MYw",
      autoPlay: false,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    );
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      context: context,
      builder: (context) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40.0, right: 16),
                          child: SvgPicture.asset(
                              'assets/images/close_circle.svg',
                              fit: BoxFit.none,
                              color: FlutterFlowTheme.of(context).primaryText
                          ),
                        ),
                      )
                    ]),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: SvgPicture.asset("assets/images/gift.svg", height: 60,),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                              'Abhyas Essential Books Package (P+C) + 30 OMR',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                fontWeight: FontWeight.w700,
                                color: FlutterFlowTheme.of(context).primaryText ,
                                fontSize: 20.0,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                          ],
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: Container(
                        child:
                        ImageSlideshow(
                          width: double.infinity,

                          initialPage: 0,
                          indicatorColor: FlutterFlowTheme.of(context).primary,
                          indicatorBackgroundColor: Colors.grey,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: YoutubePlayer(
                                  controller: _ytControllerEssentialBooks,
                                  aspectRatio: 16 / 9,
                                ),
                              ),
                            ),
                            Image.asset(
                              'assets/images/essential_book1.jpg',
                              fit: BoxFit.contain,
                            ),
                            Image.asset(
                              'assets/images/essential_book2.jpg',
                              fit: BoxFit.contain,
                            ),
                            Image.asset(
                              'assets/images/essential_book3.jpg',
                              fit: BoxFit.contain,
                            ),
                            Image.asset(
                              'assets/images/essential_book4.jpg',
                              fit: BoxFit.contain,
                            ),
                            Image.asset(
                              'assets/images/essential_book5.jpg',
                              fit: BoxFit.contain,
                            ),
                          ],
                          autoPlayInterval: null,
                          isLoop: false,
                        ),

                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: RichText(
                        text: TextSpan(
                          text:
                          'Abhyas Essential Book includes ',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                            fontSize: 13,
                            fontFamily: FlutterFlowTheme.of(context)
                                .bodyMediumFamily,
                            color: FlutterFlowTheme.of(context).accent1,
                            fontWeight: FontWeight.w400,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context)
                                    .bodyMediumFamily),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Handpicked HIGHEST YIELD PAGEWISE NCERT Based Q's ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "(75-100 Q's per chapter). ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text: "Dr Aman Tilak ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "has himself personally contributed in the Q's ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Selection ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "process so that these books have nothing but the BEST & the ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "MOST EXPECTED Q's for NEET ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              ", covering all the topics according to ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Updated Syllabus.\n\nNOTE-\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "1. Online Abhyas Essential Course is NOT a part of this Books Package & is to be enrolled separately with NCERT Abhyas Batch.\n\n2. Abhyas Essential Course Books Package is NOT the same as NCERT Abhyas Batch Books Package. Please check the product description before purchasing.\n\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "BOOK HIGHLIGHTS\n\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "1. High-Yield Questions: ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Includes 75-100 Most Expected Q's per chapter for NEET, selected by Dr. Aman Tilak's team.\n\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "2. NCERT Coverage: ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "FIRST PRODUCT EVER to include NCERT In-Text Q's, Solved Examples and Back Exercise Q's converted into MCQ format & arranged in a PageWise format with video solutions.\n\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),

                            TextSpan(
                              text:
                              "3. Exemplar Questions: ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Includes all important NCERT Exemplar based questions with detailed audio/video explanations.\n\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "4. NEET 2019-2024 All Q's: ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "All Updated Syllabus based Q's from a total of 12 NEET Papers from past 6 years, including Q's from additionally conducted papers like 2024 Jhajjar, 2020 COVID & 2019 Odisha are included with video solutions.\n\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "5. NCERT PAGEWISE Question Filter: ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "As you go on practicing Q's arranged in an NCERT PageWise format, all NCERT In-Text Q's, Back-Exercise, Exemplar & Previous 6 Years Q's will seamlessly be covered.\n\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),

                            TextSpan(
                              text:
                              "6. Video Explanations: ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Detailed Audio, Video & Text explanations including Hints & Steps of calculation can be accessed from NEET Essential App from Playstore/App store (Note - App subscription is to be taken separately & is not included with the books.\n\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "IMPORTANT NOTE: ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Abhyas Essential is for Active Recall and Revision & is NOT a SUBSTITUTE for in depth Q practice from the NCERT Abhyas Batch, which has almost 3X more Q's than Abhyas Essential.\n\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Dr Aman Tilak's Recommendation for You: ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Use Abhyas Essential first, then practice extensively with the NCERT Abhyas Batch. You can also use Abhyas Essential to know the areas you are weak in & then strengthen them with NCERT reading & in-depth Q Practice from NCERT Abhyas Batch!",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),


                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
          bottomNavigationBar: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
            child: ElevatedButton(
                onPressed: () async {
                  FirebaseAnalytics.instance.logEvent(
                    name: 'buy_now_button_click',
                    parameters: {
                      "courseId": FFAppState().abhyasEssentialBookCourseIdInt.toString(),
                    },
                  );
                  CleverTapService.recordEvent(
                    'Buy Now Clicked',
                    {"courseId":
                    FFAppState().abhyasEssentialBookCourseIdInt.toString(),

                    },
                  );
                  context.pop();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  elevation: 5,
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Go Buy Now',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily:
                      FlutterFlowTheme.of(context).bodyMediumFamily,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 14.0,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context).bodyMediumFamily),
                    ))),
          ),
        );
      },
    );
  }

  void purchaseAbhyasEssentialBottomSheet(context) {
    _ytControllerEssentialBooks = YoutubePlayerController.fromVideoId(
      videoId: "dbcoHFz3ujA",
      autoPlay: false,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    );
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      context: context,
      builder: (context) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40.0, right: 16),
                          child: SvgPicture.asset(
                              'assets/images/close_circle.svg',
                              fit: BoxFit.none,
                              color: FlutterFlowTheme.of(context).primaryText
                          ),
                        ),
                      )
                    ]),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: SvgPicture.asset("assets/images/gift.svg", height: 60,),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                              'NEET  Abhyas Essential Course (P+C+B) + Books Package (P+C+30 OMRs) ',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                fontWeight: FontWeight.w700,
                                color: FlutterFlowTheme.of(context).primaryText ,
                                fontSize: 20.0,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                          ],
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: Container(
                        child:
                        ImageSlideshow(
                          width: double.infinity,
                        //  height: 300,
                          initialPage: 0,
                          indicatorColor: FlutterFlowTheme.of(context).primary,
                          indicatorBackgroundColor: Colors.grey,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: YoutubePlayer(
                                  controller: _ytControllerEssentialBooks,
                                  aspectRatio: 16 / 9,
                                ),
                              ),
                            ),
                            Image.asset(
                              'assets/images/abhyas_essential_banner.jpg',
                              fit: BoxFit.contain,
                            ),
                            Image.asset(
                              'assets/images/essential_book1.jpg',
                              fit: BoxFit.contain,
                            ),
                            Image.asset(
                              'assets/images/essential_book2.jpg',
                              fit: BoxFit.contain,
                            ),
                            Image.asset(
                              'assets/images/essential_book3.jpg',
                              fit: BoxFit.contain,
                            ),
                            Image.asset(
                              'assets/images/essential_book4.jpg',
                              fit: BoxFit.contain,
                            ),
                            Image.asset(
                              'assets/images/essential_book5.jpg',
                              fit: BoxFit.contain,
                            ),
                          ],
                          autoPlayInterval: null,
                          isLoop: false,
                        ),

                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: RichText(
                        text: TextSpan(
                          text:
                          'NEET Abhyas Essential Course (P+C+B) + Books Package (P+C) includes ',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                            fontSize: 13,
                            fontFamily: FlutterFlowTheme.of(context)
                                .bodyMediumFamily,
                            color: FlutterFlowTheme.of(context).accent1,
                            fontWeight: FontWeight.w400,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context)
                                    .bodyMediumFamily),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Handpicked HIGHEST YIELD PAGEWISE NCERT Based Q's ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "(75-100 Q's per chapter). ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text: "Dr Aman Tilak ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "has himself personally contributed in the Q's ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Selection ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "process so that these books have nothing but the BEST & the ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "MOST EXPECTED Q's for NEET ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              ", covering all the topics according to ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Updated Syllabus.\n\nLIMITED TIME OFFER - Get the following additionally upon enrolling now -\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "\n\u2022 30 OMR sheets ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "according to NEET new 180 Q's pattern\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "\u2022 Unlimited ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Custom Test ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Generator - generate tests using the NCERT Page filter & on selective topics\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "\u2022 25 Yr's ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "PYQ Marked NCERT ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),

                            TextSpan(
                              text:
                              "(P+C+B) ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "\n\n COURSE & BOOK HIGHLIGHTS\n\n1. High-Yield Questions:"
                            ,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Includes 75-100 Most Expected Q's per chapter for NEET, selected by Dr. Aman Tilak's team\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "2. NCERT Coverage: ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "FIRST PRODUCT EVER to include NCERT In-Text Q's, Solved Examples and Back Exercise Q's converted into MCQ format & arranged in a PageWise format with video solutions\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "3. Exemplar Questions: ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Includes all important NCERT Exemplar based questions with detailed audio/video explanations\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "4. NEET 2019-2024 All Q's: ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "All Updated Syllabus based Q's from a total of 12 NEET Papers from past 6 years, including all Q's from NEET 2024 paper & Q's from additionally conducted papers like 2024 Jhajjar, Re-NEET 2024, 2020 COVID & 2019 Odisha are included with video solutions\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "5. NCERT PAGEWISE Question Filter:",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "As you go on practicing Q's arranged in an NCERT PageWise format, all NCERT In-Text Q's, Back-Exercise, Exemplar & Previous 6 Years Q's will seamlessly be covered\n",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "6. Video Explanations: ",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),
                            TextSpan(
                              text:
                              "Detailed Audio, Video & Text explanations including Hints & Steps of calculation can be accessed from NEET Essential App from Playstore/App store",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontSize: 13,
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).accent1,
                                fontWeight: FontWeight.w400,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                            ),



                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
          bottomNavigationBar: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
            child: ElevatedButton(
                onPressed: () async {
                  FirebaseAnalytics.instance.logEvent(
                    name: 'buy_now_button_click',
                    parameters: {
                      "courseId": FFAppState().abhyasEssentialBookCourseIdInt.toString(),
                    },
                  );
                  CleverTapService.recordEvent(
                    'Buy Now Clicked',
                    {"courseId":
                    FFAppState().abhyasEssentialBookCourseIdInt.toString(),

                    },
                  );
                  context.pop();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  elevation: 5,
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Go Buy Now',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily:
                      FlutterFlowTheme.of(context).bodyMediumFamily,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 14.0,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context).bodyMediumFamily),
                    ))),
          ),
        );
      },
    );
  }




}