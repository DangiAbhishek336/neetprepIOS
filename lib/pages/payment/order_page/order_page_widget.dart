import 'dart:convert';
import 'dart:developer';

import 'package:buttons_tabbar/buttons_tabbar.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../clevertap/clevertap_service.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/payment/bottom_popup/bottom_popup_widget.dart';
import 'order_page_model.dart';

export 'order_page_model.dart';

class OrderPageWidget extends StatefulWidget {
  final String courseId;
  final String courseIdInt;
  final String? state;
  final String? city;
  final String? centerAddress;

  const OrderPageWidget(
      {Key? key, required this.courseId, required this.courseIdInt, this.state, this.city, this.centerAddress})
      : super(key: key);

  @override
  _OrderPageWidgetState createState() => _OrderPageWidgetState();
}

class _OrderPageWidgetState extends State<OrderPageWidget>
    with SingleTickerProviderStateMixin {
  late OrderPageModel _model;
  int ct = 0;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController pageController = PageController();
  late TabController _controller;
  int selectedIndex = -1;
  bool _isVisible = true;


  String encodeToBase64(dynamic input) {
    String inputString = "CourseOffer:" + input.toString();
    List<int> bytes = utf8.encode(inputString);
    String encoded = base64.encode(bytes);
    return encoded;
  }

  String encodeToBase64PaymentId(dynamic input) {
    String inputString = "Payment:" + input.toString();
    List<int> bytes = utf8.encode(inputString);
    String encoded = base64.encode(bytes);
    return encoded;
  }


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OrderPageModel());
    ct = 0;
    _model.couponButtonText = "Apply";
    final targetDate = DateTime(2025, 4, 30);

    // Compare with current date
    if (DateTime.now().isAfter(targetDate)) {
      _isVisible = false;
    }

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      CleverTapService.recordEvent("Order Page Opened",{"courseIdInt":widget.courseIdInt} );
      _model.courseInfo = await PaymentGroup
          .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall.call(
          courseId: widget.courseId, authToken: FFAppState().subjectToken);
      await Future.delayed(const Duration(milliseconds: 900));
      await FirebaseAnalytics.instance.logEvent(name: 'order_page_screen_view',
        parameters: {"courseId": widget.courseIdInt},);
      print(_model.courseInfo?.jsonBody.toString());
      if ((_model.courseInfo?.succeeded ?? true) && ((getJsonField(
        _model.courseInfo?.jsonBody, r'''$.data.course.discountedFee''',)
          .toString()) != '')) {
        if (widget.courseIdInt == FFAppState().courseIdInt.toString()) {
          setState(() {
            _model.amount = (PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .neet26OfferDiscountedFees(
              (_model.courseInfo?.jsonBody ?? ''),) as List)
                .map<String>((s) => s.toString())
                .toList()
                .first;
            _model.title = (PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .neet26OfferTitles(
              (_model.courseInfo?.jsonBody ?? ''),) as List)
                .map<String>((s) => s.toString())
                .toList()
                .first;
            _model.fee = (PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .neet26OfferFees((_model.courseInfo?.jsonBody ?? ''),) as List)
                .map<String>((s) => s.toString())
                .toList()
                .first;
            _model.cc = functions.getIntFromBase64((PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .neet26courseOffersId(
              (_model.courseInfo?.jsonBody ?? ''),) as List)
                .map<String>((s) => s.toString())
                .toList()
                .first).toString();
            _model.hasShipment = (PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .neet26HasShipment(
              (_model.courseInfo?.jsonBody ?? ''),) as List)
                .map<String>((s) => s.toString())
                .toList()
                .first == "true" ? true : false;
            selectedIndex = 0;
            _model.addOnCourseList = PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .getAllAddOnCoursesForFirstCourseOfferOfNEET26(
                (_model.courseInfo?.jsonBody ?? '')) ?? [];
            _model.complimentaryAddOnList = PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .getAllcomplimentaryCourseOffersForFirstCourseOfferOfNEET26(
                (_model.courseInfo?.jsonBody ?? '')) ?? [];
            print("  _model.complimentaryAddOnList"+  _model.complimentaryAddOnList.toString());
            _model.addOnCheckBoxList =
                List.generate(_model.addOnCourseList.length, (index) => true);
            _model.complimentaryAddOnCheckBoxList = List.generate(
                _model.complimentaryAddOnList.length, (index) => true);
            _model.selectedAddOnCoursesList = [];
            _model.isCouponValidated = false;
            _model.discountAfterCouponIsApplied = null;
            _model.couponCodeController.text = "";
            _model.couponId = null;
            _model.hasShipmentInComplimentaryCourseList = List.generate(
                _model.complimentaryAddOnList.length, (index) => false);
            _model.hasShipmentInSelectedAddOnCoursesList =
                List.generate(_model.addOnCourseList.length, (index) => false);
            _model.selectedAddOnCoursesList =
                _model.filterAddOnCourses(_model.addOnCourseList);
            _model.filterComplimentaryAddOnCourses(
                _model.complimentaryAddOnList);
          });
        } else {
          setState(() {
            _model.amount = (PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .offerDiscountedFees(
              (_model.courseInfo?.jsonBody ?? ''),) as List)
                .map<String>((s) => s.toString())
                .toList()
                .first;
            _model.title = (PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .offerTitles((_model.courseInfo?.jsonBody ?? ''),) as List)
                .map<String>((s) => s.toString())
                .toList()
                .first;
            _model.fee = (PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .offerFees((_model.courseInfo?.jsonBody ?? ''),) as List)
                .map<String>((s) => s.toString())
                .toList()
                .first;
            _model.cc = functions.getIntFromBase64(getJsonField(
              (_model.courseInfo?.jsonBody ?? ''),
              r'''$.data.course.offers.edges[0].node.id''',).toString())
                .toString();
            _model.hasShipment = (PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .hasShipment((_model.courseInfo?.jsonBody ?? ''),) as List)
                .map<String>((s) => s.toString())
                .toList()
                .first == "true" ? true : false;
            _model.isOptionSel = false;
            selectedIndex = 0;
         _model.addOnCourseList = PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .getAllAddonsCourseOffers(
                (_model.courseInfo?.jsonBody ?? '')) ?? [];

            _model.complimentaryAddOnList = PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .getAllComplimentaryCourseOffers(
                (_model.courseInfo?.jsonBody ?? '')) ?? [];
            print("  _model.complimentaryAddOnList"+  _model.complimentaryAddOnList.toString());
            print("  _model.title"+  _model.title.toString());
            _model.addOnCheckBoxList =
                List.generate(_model.addOnCourseList.length, (index) => false);
            _model.complimentaryAddOnCheckBoxList = List.generate(
                _model.complimentaryAddOnList.length, (index) => true);
            _model.selectedAddOnCoursesList = [];
            _model.isCouponValidated = false;
            _model.discountAfterCouponIsApplied = null;
            _model.couponCodeController.text = "";
            _model.couponId = null;
            _model.hasShipmentInComplimentaryCourseList = List.generate(
                _model.complimentaryAddOnList.length, (index) => false);
            _model.hasShipmentInSelectedAddOnCoursesList =
                List.generate(_model.addOnCourseList.length, (index) => false);
            _model.selectedAddOnCoursesList =
                _model.filterAddOnCourses(_model.addOnCourseList);
            _model.filterComplimentaryAddOnCourses(
                _model.complimentaryAddOnList);
          });
        }


        _controller.addListener(() {
          setState(() {});
          log(_model.courseInfo!.jsonBody.toString());
          if (_isVisible && _controller.index.toString() == "2" ) {
            _model.amount = (PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .neet25OfferDiscountedFees(
              (_model.courseInfo?.jsonBody ?? ''),) as List)
                .map<String>((s) => s.toString())
                .toList()
                .first;
            _model.title = (PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .neet25OfferTitles(
              (_model.courseInfo?.jsonBody ?? ''),) as List)
                .map<String>((s) => s.toString())
                .toList()
                .first;
            _model.fee = (PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .neet25OfferFees((_model.courseInfo?.jsonBody ?? ''),) as List)
                .map<String>((s) => s.toString())
                .toList()
                .first;
            _model.cc = functions.getIntFromBase64((PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .neet25courseOffersId(
              (_model.courseInfo?.jsonBody ?? ''),) as List)
                .map<String>((s) => s.toString())
                .toList()
                .first).toString();
            _model.hasShipment = (PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .neet25HasShipment(
              (_model.courseInfo?.jsonBody ?? ''),) as List)
                .map<String>((s) => s.toString())
                .toList()
                .first == "true" ? true : false;
            selectedIndex = 0;
            _model.addOnCourseList = PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .getAllAddOnCoursesForFirstCourseOfferOfNEET25(
                (_model.courseInfo?.jsonBody ?? '')) ?? [];
            _model.addOnCheckBoxList =
                List.generate(_model.addOnCourseList.length, (index) => false);
            _model.complimentaryAddOnList = PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .getAllcomplimentaryCourseOffersForFirstCourseOfferOfNEET25(
                (_model.courseInfo?.jsonBody ?? '')) ?? [];
            _model.complimentaryAddOnCheckBoxList = List.generate(
                _model.complimentaryAddOnList.length, (index) => true);
            _model.hasShipmentInSelectedAddOnCoursesList =
                List.generate(_model.addOnCourseList.length, (index) => false);
            _model.hasShipmentInComplimentaryCourseList = List.generate(
                _model.complimentaryAddOnList.length, (index) => false);
            _model.isCouponValidated = false;
            _model.couponButtonText = "Apply";
            _model.discountAfterCouponIsApplied = null;
            _model.couponCodeController.text = "";
            _model.couponId = null;
            _model.selectedAddOnCoursesList =
                _model.filterAddOnCourses(_model.addOnCourseList);
            _model.filterComplimentaryAddOnCourses(
                _model.complimentaryAddOnList);
          } else if (_controller.index.toString() == "0") {
            _model.amount = (PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .neet26OfferDiscountedFees(
              (_model.courseInfo?.jsonBody ?? ''),) as List)
                .map<String>((s) => s.toString())
                .toList()
                .first;
            _model.title = (PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .neet26OfferTitles(
              (_model.courseInfo?.jsonBody ?? ''),) as List)
                .map<String>((s) => s.toString())
                .toList()
                .first;
            _model.fee = (PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .neet26OfferFees((_model.courseInfo?.jsonBody ?? ''),) as List)
                .map<String>((s) => s.toString())
                .toList()
                .first;
            _model.cc = functions.getIntFromBase64((PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .neet26courseOffersId(
              (_model.courseInfo?.jsonBody ?? ''),) as List)
                .map<String>((s) => s.toString())
                .toList()
                .first).toString();
            _model.hasShipment = (PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .neet26HasShipment(
              (_model.courseInfo?.jsonBody ?? ''),) as List)
                .map<String>((s) => s.toString())
                .toList()
                .first == "true" ? true : false;
            selectedIndex = 0;
            _model.addOnCourseList = PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .getAllAddOnCoursesForFirstCourseOfferOfNEET26(
                (_model.courseInfo?.jsonBody ?? '')) ?? [];
            _model.addOnCheckBoxList =
                List.generate(_model.addOnCourseList.length, (index) => false);
            _model.complimentaryAddOnList = PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .getAllcomplimentaryCourseOffersForFirstCourseOfferOfNEET26(
                (_model.courseInfo?.jsonBody ?? '')) ?? [];
            _model.complimentaryAddOnCheckBoxList = List.generate(
                _model.complimentaryAddOnList.length, (index) => true);
            _model.hasShipmentInSelectedAddOnCoursesList =
                List.generate(_model.addOnCourseList.length, (index) => false);
            _model.hasShipmentInComplimentaryCourseList = List.generate(
                _model.complimentaryAddOnList.length, (index) => false);
            _model.isCouponValidated = false;
            _model.couponButtonText = "Apply";
            _model.discountAfterCouponIsApplied = null;
            _model.couponCodeController.text = "";
            _model.couponId = null;
            _model.selectedAddOnCoursesList =
                _model.filterAddOnCourses(_model.addOnCourseList);
            _model.filterComplimentaryAddOnCourses(
                _model.complimentaryAddOnList);
          }
          else if (_controller.index.toString() == "1") {
            _model.amount = (PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .neet27OfferDiscountedFees(
              (_model.courseInfo?.jsonBody ?? ''),) as List)
                .map<String>((s) => s.toString())
                .toList()
                .first;
            _model.title = (PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .neet27OfferTitles(
              (_model.courseInfo?.jsonBody ?? ''),) as List)
                .map<String>((s) => s.toString())
                .toList()
                .first;
            _model.fee = (PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .neet27OfferFees((_model.courseInfo?.jsonBody ?? ''),) as List)
                .map<String>((s) => s.toString())
                .toList()
                .first;
            _model.cc = functions.getIntFromBase64((PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .neet27courseOffersId(
              (_model.courseInfo?.jsonBody ?? ''),) as List)
                .map<String>((s) => s.toString())
                .toList()
                .first).toString();
            _model.hasShipment = (PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .neet27HasShipment(
              (_model.courseInfo?.jsonBody ?? ''),) as List)
                .map<String>((s) => s.toString())
                .toList()
                .first == "true" ? true : false;
            selectedIndex = 0;
            _model.addOnCourseList = PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .getAllAddOnCoursesForFirstCourseOfferOfNEET27(
                (_model.courseInfo?.jsonBody ?? '')) ?? [];
            _model.addOnCheckBoxList =
                List.generate(_model.addOnCourseList.length, (index) => false);
            _model.complimentaryAddOnList = PaymentGroup
                .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                .getAllcomplimentaryCourseOffersForFirstCourseOfferOfNEET27(
                (_model.courseInfo?.jsonBody ?? '')) ?? [];
            _model.complimentaryAddOnCheckBoxList = List.generate(
                _model.complimentaryAddOnList.length, (index) => true);
            _model.hasShipmentInSelectedAddOnCoursesList =
                List.generate(_model.addOnCourseList.length, (index) => false);
            _model.hasShipmentInComplimentaryCourseList = List.generate(
                _model.complimentaryAddOnList.length, (index) => false);
            _model.isCouponValidated = false;
            _model.couponButtonText = "Apply";
            _model.discountAfterCouponIsApplied = null;
            _model.couponCodeController.text = "";
            _model.couponId = null;
            _model.selectedAddOnCoursesList =
                _model.filterAddOnCourses(_model.addOnCourseList);
            _model.filterComplimentaryAddOnCourses(
                _model.complimentaryAddOnList);
          }
        });

        return;
      } else {
        await showDialog(context: context, builder: (alertDialogContext) {
          return AlertDialog(title: Text('Error'),
            content: Text(
                'The page couldn\'t be loaded. Please try again later.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(alertDialogContext),
                child: Text('Ok'),),
            ],);
        },);
        context.safePop();
        return;
      }
    });
    _controller = TabController(length: _isVisible?3:2, vsync: this);
    _model.couponCodeController.addListener(() {
      setState(() {
        _model.couponCodeController.value =
            _model.couponCodeController.value.copyWith(
              text: _model.couponCodeController.text.toUpperCase(),
              selection: _model.couponCodeController.selection,);

        _model.enableCouponButton =
        _model.couponCodeController.text.isEmpty ? false : true;
      });
    });


    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void showBottomSheet() {
    showModalBottomSheet(shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
      context: context,
      builder: (context) {
        return SingleChildScrollView(child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                child: Align(
                  alignment: Alignment.topRight, child: InkWell(onTap: () {
                  Navigator.pop(context);
                }, child: Icon(Icons.close)),),),
              Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                child: Image.asset("assets/images/info.png", height: 60),),
              Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                child: RichText(text: TextSpan(children: [
                  TextSpan(text: 'Would you like to learn more\n',
                    style: FlutterFlowTheme
                        .of(context)
                        .bodyMedium
                        .override(
                      fontFamily: FlutterFlowTheme
                          .of(context)
                          .bodyMediumFamily,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontSize: 20.0,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme
                              .of(context)
                              .bodyMediumFamily),),),
                  TextSpan(text: 'before you make a decision ?',
                    style: FlutterFlowTheme
                        .of(context)
                        .bodyMedium
                        .override(
                      fontFamily: FlutterFlowTheme
                          .of(context)
                          .bodyMediumFamily,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff252525),
                      fontSize: 20.0,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme
                              .of(context)
                              .bodyMediumFamily),),),
                ], style: FlutterFlowTheme
                    .of(context)
                    .bodyMedium,),),),
              Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: Text('Get a call from our counsellors for quick help',
                    style: FlutterFlowTheme
                        .of(context)
                        .bodyMedium
                        .override(
                      fontFamily: FlutterFlowTheme
                          .of(context)
                          .bodyMediumFamily,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff4a4a4a),
                      fontSize: 12.0,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme
                              .of(context)
                              .bodyMediumFamily),)),),
              Container(width: MediaQuery
                  .of(context)
                  .size
                  .width,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 5),
                child: ElevatedButton(onPressed: () async {
                  await submitDetailsToHubspot(false).then((_) {
                    context.pushNamed('ClassroomTestSeriesPage');
                  });
                },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      elevation: 0,
                      side: BorderSide(color: Colors.white),
                      backgroundColor: FlutterFlowTheme
                          .of(context)
                          .primary,
                      padding: EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),),),
                    child: Text('Request a Callback', style: FlutterFlowTheme
                        .of(context)
                        .bodyMedium
                        .override(fontFamily: FlutterFlowTheme
                        .of(context)
                        .bodyMediumFamily,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 14.0,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme
                              .of(context)
                              .bodyMediumFamily),))),),
              Container(width: MediaQuery
                  .of(context)
                  .size
                  .width,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 25),
                child: OutlinedButton(onPressed: () {
                  Navigator.pop(context);
                  context.pushNamed('PromotionPage');
                },
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0)),
                        side: BorderSide(width: 1.0, color: FlutterFlowTheme
                            .of(context)
                            .primary),
                        padding: EdgeInsets.symmetric(vertical: 15)),
                    child: Text("Let's Make It Happen Together!",
                        style: FlutterFlowTheme
                            .of(context)
                            .bodyMedium
                            .override(fontFamily: FlutterFlowTheme
                            .of(context)
                            .bodyMediumFamily,
                          fontSize: 14.0,
                          color: FlutterFlowTheme
                              .of(context)
                              .primary,
                          fontWeight: FontWeight.w400,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme
                                  .of(context)
                                  .bodyMediumFamily),))),)
            ]),);
      },);
  }

  Future<void> submitDetailsToHubspot(bool hasUserPaid) async {
    String apiUrl = '${FFAppState().baseUrl}/api/v1/leadinsert';
    String bearerToken = FFAppState().subjectToken;

    Map<String, String> queryParams = {
      'phone': FFAppState().userPhoneNumber,
      'name': currentUserDisplayName,
      'city': widget.city ?? "",
      'state': widget.state ?? "",
      'course': 'offline test series',
      'lifecyclestage': hasUserPaid ? 'customer' : 'Lead',
      'utm_source': 'Essential App',
      'email': currentUserEmail,
      'classroom_test_centre': widget.centerAddress ?? ""
    };

    queryParams.removeWhere((key, value) =>
    value == 'Request a Center' || value == 'Lead');

    final response = await http.post(Uri.parse(apiUrl), headers: {
      'Authorization': 'Bearer $bearerToken',
      'Content-Type': 'application/x-www-form-urlencoded',
    }, body: Uri(queryParameters: queryParams).query,);

    if (response.statusCode == 200) {
      print('API call successful');
      print('Response body: ${response.body}');
    } else {
      print('API call failed with status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    return FutureBuilder<ApiCallResponse>(future: PaymentGroup
        .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall.call(
        courseId: widget.courseId, authToken: FFAppState().subjectToken),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(backgroundColor: FlutterFlowTheme
              .of(context)
              .primaryBackground,
            body: Center(child: SizedBox(width: 40.0,
              height: 40.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(FlutterFlowTheme
                    .of(context)
                    .primary,),),),),);
        }
        final orderPageGetCoursePriceAndCourseOffersToSelectFromToStartPaymentResponse = snapshot
            .data!;
        return Title(title: 'OrderPage',
            color: FlutterFlowTheme
                .of(context)
                .secondaryBackground,
            child: GestureDetector(//   onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
              child: Scaffold(key: scaffoldKey,
                backgroundColor: FlutterFlowTheme
                    .of(context)
                    .primaryBackground,
                appBar: AppBar(backgroundColor: FlutterFlowTheme
                    .of(context)
                    .secondaryBackground,
                  automaticallyImplyLeading: false,
                  leading: FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 30.0,
                    borderWidth: 1.0,
                    buttonSize: 60.0,
                    icon: Icon(Icons.arrow_back_rounded, color: FlutterFlowTheme
                        .of(context)
                        .primaryText, size: 24.0,),
                    onPressed: () async {
                      if (widget.courseIdInt ==
                          FFAppState().courseIdInt.toString() ||
                          widget.courseIdInt ==
                              FFAppState().offlineBookCourseIdInt.toString() ||
                          widget.courseIdInt ==
                              FFAppState().homeTestSeriesBookCourseIdInt
                                  .toString()) {
                        context.safePop();
                      } else {
                        context.safePopForTests(widget.courseIdInt);
                      }
                    },),
                  title: Align(alignment: AlignmentDirectional(-0.35, 0.2),
                    child: Text('Order Summary', textAlign: TextAlign.start,
                      style: FlutterFlowTheme
                          .of(context)
                          .headlineMedium
                          .override(fontFamily: FlutterFlowTheme
                          .of(context)
                          .headlineMediumFamily,
                        color: FlutterFlowTheme
                            .of(context)
                            .primaryText,
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme
                                .of(context)
                                .headlineMediumFamily),),),),
                  actions: [],
                  centerTitle: false,
                  elevation: 0.0,),
                body: WillPopScope(onWillPop: () async {
                  if (widget.courseIdInt ==
                      FFAppState().courseIdInt.toString() ||
                      widget.courseIdInt ==
                          FFAppState().offlineBookCourseIdInt.toString() ||
                      widget.courseIdInt ==
                          FFAppState().homeTestSeriesBookCourseIdInt
                              .toString()) {
                    context.safePop();
                  } else {
                    context.safePopForTests(widget.courseIdInt);
                  }
                  return false;
                },
                  child: SafeArea(top: true,
                    child: FutureBuilder<ApiCallResponse>(future: PaymentGroup
                        .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                        .call(courseId: widget.courseId,
                        authToken: FFAppState().subjectToken),
                      builder: (context, snapshot) {
                        // Customize what your widget looks like when it's loading.
                        if (!snapshot.hasData) {
                          return Center(child: SizedBox(width: 40.0,
                            height: 40.0,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                FlutterFlowTheme
                                    .of(context)
                                    .primary,),),),);
                        }
                        final containerGetCoursePriceAndCourseOffersToSelectFromToStartPaymentResponse = snapshot
                            .data!;
                        return Container(width: double.infinity, height: double
                            .infinity, decoration: BoxDecoration(
                          color: FlutterFlowTheme
                              .of(context)
                              .primaryBackground,), child: Visibility(
                          visible: (_model.courseInfo?.succeeded ?? true) &&
                              (getJsonField(
                                orderPageGetCoursePriceAndCourseOffersToSelectFromToStartPaymentResponse
                                    .jsonBody,
                                r'''$.data.course.discountedFee''',) != null),
                          child: Column(mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    widget.courseIdInt ==
                                        FFAppState().courseIdInt.toString()
                                        ? 
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              16.0, 8.0, 16.0, 5.0),
                                          child: Text("Select your Exam Year",
                                            style: FlutterFlowTheme
                                                .of(context)
                                                .bodyMedium
                                                .override(
                                              fontFamily: FlutterFlowTheme
                                                  .of(context)
                                                  .bodyMediumFamily,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w500,
                                              useGoogleFonts: GoogleFonts
                                                  .asMap().containsKey(
                                                  FlutterFlowTheme
                                                      .of(context)
                                                      .bodyMediumFamily),),),),
                                        Container(height: MediaQuery
                                            .of(context)
                                            .size
                                            .height * 2.3,
                                          child: DefaultTabController(length: 2,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment
                                                  .start,
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      16.0, 10.0, 16.0, 0.0),
                                                  child: ButtonsTabBar(
                                                    controller: _controller,
                                                    center: false,
                                                    contentPadding: EdgeInsets
                                                        .fromLTRB(
                                                        10, 10, 10, 10),
                                                    backgroundColor: FlutterFlowTheme
                                                        .of(context)
                                                        .primary,
                                                    unselectedBackgroundColor: FlutterFlowTheme
                                                        .of(context)
                                                        .accent8,
                                                    unselectedLabelStyle: TextStyle(
                                                        color: !FFAppState()
                                                            .isDarkMode
                                                            ? FlutterFlowTheme
                                                            .of(context)
                                                            .primary
                                                            : Colors.white),
                                                    labelStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight
                                                            .bold,
                                                        fontFamily: 'Poppins'),
                                                    tabs: _isVisible?[
                                                      Tab(text: "NEET 2026 ",),
                                                      Tab(text: "NEET 2027 ",),
                                                      Tab(text: "NEET 2025 ",)
                                                    ]:[ Tab(text: "NEET 2026 ",),
                                                      Tab(text: "NEET 2027 ",),],),),
                                                Expanded(child: TabBarView(
                                                  controller: _controller,
                                                  children: <Widget>[

                                                    (getJsonField(
                                                      _model.courseInfo
                                                          ?.jsonBody,
                                                      r'''$.data.course.neet26Offers.edges''',) !=
                                                        [] && getJsonField(
                                                      _model.courseInfo
                                                          ?.jsonBody,
                                                      r'''$.data.course.neet26Offers.edges''',) !=
                                                        null && getJsonField(
                                                      _model.courseInfo
                                                          ?.jsonBody,
                                                      r'''$.data.course.neet26Offers.edges''',) !=
                                                        '')
                                                        ? offersTab(
                                                        orderPageGetCoursePriceAndCourseOffersToSelectFromToStartPaymentResponse
                                                            .jsonBody,
                                                        PaymentGroup
                                                            .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                                                            .neet26CourseOffers(
                                                            orderPageGetCoursePriceAndCourseOffersToSelectFromToStartPaymentResponse
                                                                .jsonBody)
                                                            ?.toList() ?? [])
                                                        : SizedBox(),
                                                    (getJsonField(
                                                      _model.courseInfo
                                                          ?.jsonBody,
                                                      r'''$.data.course.neet27Offers.edges''',) !=
                                                        [] && getJsonField(
                                                      _model.courseInfo
                                                          ?.jsonBody,
                                                      r'''$.data.course.neet27Offers.edges''',) !=
                                                        null && getJsonField(
                                                      _model.courseInfo
                                                          ?.jsonBody,
                                                      r'''$.data.course.neet27Offers.edges''',) !=
                                                        '')
                                                        ? offersTab(
                                                        orderPageGetCoursePriceAndCourseOffersToSelectFromToStartPaymentResponse
                                                            .jsonBody,
                                                        PaymentGroup
                                                            .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                                                            .neet27CourseOffers(
                                                            orderPageGetCoursePriceAndCourseOffersToSelectFromToStartPaymentResponse
                                                                .jsonBody)
                                                            ?.toList() ?? [])
                                                        : SizedBox(),
                                                    if(_isVisible)
                                                    ( getJsonField(
                                                      _model.courseInfo
                                                          ?.jsonBody,
                                                      r'''$.data.course.neet25Offers.edges''',) !=
                                                        [] && getJsonField(
                                                      _model.courseInfo
                                                          ?.jsonBody,
                                                      r'''$.data.course.neet25Offers.edges''',) !=
                                                        null && getJsonField(
                                                      _model.courseInfo
                                                          ?.jsonBody,
                                                      r'''$.data.course.neet25Offers.edges''',) !=
                                                        '')
                                                        ? offersTab(
                                                        orderPageGetCoursePriceAndCourseOffersToSelectFromToStartPaymentResponse
                                                            .jsonBody,
                                                        PaymentGroup
                                                            .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                                                            .neet25CourseOffers(
                                                            orderPageGetCoursePriceAndCourseOffersToSelectFromToStartPaymentResponse
                                                                .jsonBody)
                                                            ?.toList() ?? [])
                                                        : SizedBox()
                                                  ],),),
                                              ],),),),
                                      ],)
                                        : SizedBox(),

                                    if (widget.courseIdInt !=
                                        FFAppState().courseIdInt.toString() &&
                                        getJsonField(
                                          _model.courseInfo?.jsonBody,
                                          r'''$.data.course.offers.edges''',) !=
                                            [] && getJsonField(
                                      _model.courseInfo?.jsonBody,
                                      r'''$.data.course.offers.edges''',) !=
                                        null && getJsonField(
                                      _model.courseInfo?.jsonBody,
                                      r'''$.data.course.offers.edges''',) != '')
                                    // if (false)
                                      offersTab(
                                          orderPageGetCoursePriceAndCourseOffersToSelectFromToStartPaymentResponse
                                              .jsonBody,
                                          PaymentGroup
                                              .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                                              .courseOffers(
                                              orderPageGetCoursePriceAndCourseOffersToSelectFromToStartPaymentResponse
                                                  .jsonBody)
                                              ?.toList() ?? []),
                                  ],),),),
                              Container(width: double.infinity,
                                height: 72.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme
                                      .of(context)
                                      .primaryBackground,),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 12.0, 16.0, 12.0),
                                  child: FFButtonWidget(onPressed: () async {
                                    var _shouldSetState = false;
                                    bool hasShipmentInAddOnCourse = _model
                                        .hasShipmentInSelectedAddOnCoursesList
                                        .contains(true) || _model
                                        .hasShipmentInComplimentaryCourseList
                                        .contains(true);

                                    !_model.hasShipment &&
                                        !hasShipmentInAddOnCourse
                                        ? await showModalBottomSheet(
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      builder: (context) {
                                        return GestureDetector(onTap: () =>
                                            FocusScope.of(context).requestFocus(
                                                _model.unfocusNode),
                                          child: Padding(
                                            padding: MediaQuery.viewInsetsOf(
                                                context),
                                            child: BottomPopupWidget(mrp: '₹ ${(
                                                String var1, String var2) {
                                              return var1.isEmpty ? var2 : var1;
                                            }(functions.getIntegerAmount(
                                                _model.fee).toString(),
                                                (PaymentGroup
                                                    .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                                                    .offerFees(
                                                  (_model.courseInfo
                                                      ?.jsonBody ?? ''),) ?? '')
                                                    .toString())}',
                                              currPrice: '₹ ${(String var1,
                                                  String var2) {
                                                return var1.isEmpty
                                                    ? var2
                                                    : var1;
                                              }(functions.getIntegerAmount(
                                                  _model.amount).toString(),
                                                  (PaymentGroup
                                                      .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                                                      .offerDiscountedFees(
                                                    (_model.courseInfo
                                                        ?.jsonBody ?? ''),) ??
                                                      '').toString())}',
                                              phoneNum: FFAppState().phoneNum,
                                              name: currentUserDisplayName,
                                              email: currentUserEmail,
                                              hasShipment: _model
                                                  .hasShipment,),),);
                                      },).then((value) => setState(() =>
                                    _model.bottomPop = value))
                                        : await context.pushNamed(
                                        "BookPurchaseForm").then((value) =>
                                        setState(() =>
                                        _model.bottomPop = value));

                                    setState(() {});
                                    if (getJsonField(
                                      _model.bottomPop, r'''$.phone''',) !=
                                        null) {
                                      setState(() {});
                                      Set<int> selectedAddOnCoursesSet = Set
                                          .from(
                                          _model.selectedAddOnCoursesList ??
                                              []);
                                      _model.paymentDetails1 =
                                      await PaymentGroup
                                          .createPaymentForAUserForACourseAndCourseOfferAndGetChecksumCall
                                          .call(
                                          txnAmount: functions.getIntegerAmount(
                                              _model.amount),
                                          email: currentUserEmail,
                                          mobile: getJsonField(
                                            _model.bottomPop, r'''$.phone''',)
                                              .toString(),
                                          authToken: FFAppState().subjectToken,
                                          userid: FFAppState().userIdInt,
                                          course: widget.courseIdInt.toString(),
                                          courseOfferId: _model.cc,
                                          hasShipment: _model.hasShipment ||
                                              _model
                                                  .hasShipmentInSelectedAddOnCoursesList
                                                  .contains(true) || _model
                                              .hasShipmentInComplimentaryCourseList
                                              .contains(true),
                                          addOns: selectedAddOnCoursesSet,
                                          couponId: _model.isCouponValidated
                                              ? _model.couponId.toString() ?? ""
                                              : "");
                                      _shouldSetState = true;

                                      await actions.getJson(
                                        (_model.paymentDetails1 ?? ''),);
                                      print("txnAmount"+functions.getIntegerAmount(
                                          _model.amount).toString());
                                      print("mobile"+getJsonField(
                                        _model.bottomPop, r'''$.phone''',)
                                          .toString());
                                      print("courseOffferId"+ _model.cc.toString());
                                      print("addons"+selectedAddOnCoursesSet.toString());
                                      print("course"+widget.courseIdInt.toString());
                                      print("hasShipment"+ _model.hasShipment.toString());


                                      print("_model.paymentDetails1!.jsonBody.toString()"+_model.paymentDetails1!.jsonBody.toString());


                                      if (_model.hasShipment || _model
                                          .hasShipmentInSelectedAddOnCoursesList
                                          .contains(true) || _model
                                          .hasShipmentInComplimentaryCourseList
                                          .contains(true)) {
                                        print(getJsonField(
                                          (_model.paymentDetails1?.jsonBody ??
                                              ''), r'''$.payment_id''',));


                                        var response;
                                        response = await PaymentGroup
                                            .createPaymentForBookOrderCall(
                                            response: "",
                                            address1: getJsonField(
                                              _model.bottomPop,
                                              r'''$.address1''',),
                                            userName: getJsonField(
                                              _model.bottomPop, r'''$.name''',),
                                            address2: getJsonField(
                                              _model.bottomPop,
                                              r'''$.address2''',),
                                            pincode: getJsonField(
                                              _model.bottomPop,
                                              r'''$.pincode''',),
                                            amount: serializeParam(PaymentGroup
                                                .createPaymentForAUserForACourseAndCourseOfferAndGetChecksumCall
                                                .amount((_model.paymentDetails1
                                                ?.jsonBody ?? ''),).toString(),
                                              ParamType.String,) ?? "",
                                            userState: getJsonField(
                                              _model.bottomPop,
                                              r'''$.state''',),
                                            userCity: getJsonField(
                                              _model.bottomPop, r'''$.city''',),
                                            userEmail: currentUserEmail,
                                            landmark: getJsonField(
                                              _model.bottomPop,
                                              r'''$.landmark''',),
                                            userId: functions.getBase64OfUserId(
                                                FFAppState().userIdInt),
                                            userPhone: getJsonField(
                                              _model.bottomPop,
                                              r'''$.phone''',),
                                            mobileNum2: getJsonField(
                                              _model.bottomPop,
                                              r'''$.mobileNum2''',),
                                            paymentForId: FFAppState()
                                                .courseIdInt,
                                            paymentForType: "Course",
                                            orderId: getJsonField(
                                              (_model.paymentDetails1
                                                  ?.jsonBody ?? ''),
                                              r'''$.order_id''',).toString(),
                                            paymentId: encodeToBase64PaymentId(
                                                getJsonField(
                                                  (_model.paymentDetails1
                                                      ?.jsonBody ?? ''),
                                                  r'''$.payment_id''',)
                                                    .toString()),
                                            courseOfferId: encodeToBase64(
                                                _model.cc));

                                        await actions.getJson(
                                          (response?.jsonBody ?? ''),);
                                      }
                                      _model.paymentStatus1 =
                                      await actions.paytmIntegration(
                                        getJsonField(
                                          (_model.paymentDetails1?.jsonBody ??
                                              ''), r'''$.order_id''',)
                                            .toString(), getJsonField(
                                        (_model.paymentDetails1?.jsonBody ??
                                            ''), r'''$.amount''',).toString(),
                                        getJsonField(
                                          (_model.paymentDetails1?.jsonBody ??
                                              ''), r'''$.txnToken''',)
                                            .toString(), PaymentGroup
                                          .createPaymentForAUserForACourseAndCourseOfferAndGetChecksumCall
                                          .paymentId(
                                        (_model.paymentDetails1?.jsonBody ??
                                            ''),), PaymentGroup
                                          .createPaymentForAUserForACourseAndCourseOfferAndGetChecksumCall
                                          .mid(
                                        (_model.paymentDetails1?.jsonBody ??
                                            ''),).toString(), PaymentGroup
                                          .createPaymentForAUserForACourseAndCourseOfferAndGetChecksumCall
                                          .callbackUrl(
                                        (_model.paymentDetails1?.jsonBody ??
                                            ''),).toString(),);
                                      _shouldSetState = true;


                                      await actions.getJson(
                                        (_model.paymentStatus1 ?? ''),);


                                      _model.paymentResponse1 =
                                      await PaymentGroup
                                          .paymentSuccessBackendProcessingCallToEnableCourseCall
                                          .call(orderId: PaymentGroup
                                          .createPaymentForAUserForACourseAndCourseOfferAndGetChecksumCall
                                          .orderId(
                                        (_model.paymentDetails1?.jsonBody ??
                                            ''),).toString(),
                                        paymentId: PaymentGroup
                                            .createPaymentForAUserForACourseAndCourseOfferAndGetChecksumCall
                                            .paymentId(
                                          (_model.paymentDetails1?.jsonBody ??
                                              ''),),);
                                      _shouldSetState = true;
                                      setState(() {});

                                      await actions.getJson(
                                        (_model.paymentResponse1 ?? ''),);


                                      if (PaymentGroup
                                          .paymentSuccessBackendProcessingCallToEnableCourseCall
                                          .paymentResponseStatus(
                                        (_model.paymentResponse1?.jsonBody ??
                                            ''),).toString() == 'TXN_FAILURE') {
                                        await showDialog(context: context,
                                          builder: (alertDialogContext) {
                                            return AlertDialog(
                                              title: Text('Retry Payment'),
                                              content: Text(
                                                  'Your payment was not completed. Please try again later. If your payment is deducted, your course access will be setup in a few minutes. Please close the app and check later. Please reach out to us if you are facing any issues.'),
                                              actions: [
                                                TextButton(onPressed: () =>
                                                    Navigator.pop(
                                                        alertDialogContext),
                                                  child: Text('Ok'),),
                                              ],);
                                          },);

                                        context.pushNamed('PostTransaction',
                                          queryParameters: {
                                            'success': serializeParam(
                                              false, ParamType.bool,),
                                            'id': serializeParam(PaymentGroup
                                                .createPaymentForAUserForACourseAndCourseOfferAndGetChecksumCall
                                                .orderId((_model.paymentDetails1
                                                ?.jsonBody ?? ''),).toString(),
                                              ParamType.String,),
                                            'amount': serializeParam(
                                              PaymentGroup
                                                  .createPaymentForAUserForACourseAndCourseOfferAndGetChecksumCall
                                                  .amount((_model
                                                  .paymentDetails1?.jsonBody ??
                                                  ''),).toString(),
                                              ParamType.String,),
                                          }.withoutNulls,);

                                        if (_shouldSetState) setState(() {});
                                        return;
                                      } else {
                                        if (PaymentGroup
                                            .paymentSuccessBackendProcessingCallToEnableCourseCall
                                            .paymentResponseStatus(
                                          (_model.paymentResponse1?.jsonBody ??
                                              ''),).toString() ==
                                            'TXN_SUCCESS') {
                                          FFAppState()
                                              .clearUserInfoQueryCacheKey(
                                              FFAppState().userIdInt
                                                  .toString());
                                          context.pushNamed('PostTransaction',
                                            queryParameters: {
                                              'success': serializeParam(
                                                true, ParamType.bool,),
                                              'id': serializeParam(PaymentGroup
                                                  .createPaymentForAUserForACourseAndCourseOfferAndGetChecksumCall
                                                  .orderId((_model
                                                  .paymentDetails1?.jsonBody ??
                                                  ''),).toString(),
                                                ParamType.String,),
                                              'amount': serializeParam(
                                                PaymentGroup
                                                    .createPaymentForAUserForACourseAndCourseOfferAndGetChecksumCall
                                                    .amount((_model
                                                    .paymentDetails1
                                                    ?.jsonBody ?? ''),)
                                                    .toString(),
                                                ParamType.String,),
                                              'course': widget.courseIdInt
                                                  .toString()
                                            }.withoutNulls,);

                                          if (widget.courseIdInt ==
                                              FFAppState().courseIdInt
                                                  .toString()) {
                                            context.pushNamed(
                                                'PracticeChapterWisePage');
                                          } else if (widget.courseIdInt ==
                                              FFAppState().testCourseIdInt
                                                  .toString()) {
                                            print("I went here");
                                            context.pushNamed(
                                                'CreateAndPreviewTestPage');
                                          } else if (widget.courseIdInt ==
                                              FFAppState()
                                                  .classroomTestCourseIdInt
                                                  .toString()) {
                                            await submitDetailsToHubspot(true)
                                                .then((_) {
                                              context.pushNamed(
                                                  'ClassroomTestSeriesPage');
                                            });
                                          } else if (widget.courseIdInt ==
                                              FFAppState().flashcardCourseIdInt
                                                  .toString()) {
                                            context.pushNamed(
                                                'FlashcardChapterWisePage');
                                          } else if (widget.courseIdInt ==
                                              FFAppState().assertionCourseIdInt
                                                  .toString()) {
                                            context.pushNamed(
                                                'AssertionChapterWisePage');
                                          }
                                          else if (widget.courseIdInt ==
                                              FFAppState().abhyas2CourseIdInt
                                                  .toString()) {
                                            context.pushNamed('abhyasBatch2');
                                          }

                                          await FirebaseAnalytics.instance
                                              .logEvent(
                                            name: 'course_purchased',
                                            parameters: {
                                              "courseId": widget.courseIdInt
                                                  .toString(),
                                            },);
                                          CleverTapService.recordEvent("Course Purchased Event", {
                                            "courseId": widget.courseIdInt,
                                            "amount":serializeParam(
                                              PaymentGroup
                                                  .createPaymentForAUserForACourseAndCourseOfferAndGetChecksumCall
                                                  .amount((_model
                                                  .paymentDetails1
                                                  ?.jsonBody ?? ''),)
                                                  .toString(),
                                              ParamType.String,)
                                          });

                                          if (_shouldSetState) setState(() {});
                                          return;
                                        } else {
                                          await showDialog(context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(title: Text(
                                                  'Please wait'),
                                                content: Text(
                                                    'Your payment is yet to be confirmed. If your money is deducted, please wait for a few minutes for getting course access. Please close the app and check later. Please reach out to us if you are facing any issues.'),
                                                actions: [TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          alertDialogContext),
                                                  child: Text('Ok'),),
                                                ],);
                                            },);

                                          context.pushNamed('PostTransaction',
                                            queryParameters: {
                                              'success': serializeParam(
                                                false, ParamType.bool,),
                                              'id': serializeParam(PaymentGroup
                                                  .createPaymentForAUserForACourseAndCourseOfferAndGetChecksumCall
                                                  .orderId((_model
                                                  .paymentDetails1?.jsonBody ??
                                                  ''),).toString(),
                                                ParamType.String,),
                                              'amount': serializeParam(
                                                PaymentGroup
                                                    .createPaymentForAUserForACourseAndCourseOfferAndGetChecksumCall
                                                    .amount((_model
                                                    .paymentDetails1
                                                    ?.jsonBody ?? ''),)
                                                    .toString(),
                                                ParamType.String,),
                                            }.withoutNulls,);


                                          if (_shouldSetState) setState(() {});
                                          return;
                                        }
                                      }
                                    } else {
                                      if (_model.hasShipment) {
                                        return;
                                      }
                                      await showDialog(context: context,
                                        builder: (alertDialogContext) {
                                          return AlertDialog(
                                            title: Text('Mobile Number'),
                                            content: Text(
                                                'Please enter the mobile number'),
                                            actions: [
                                              TextButton(onPressed: () =>
                                                  Navigator.pop(
                                                      alertDialogContext),
                                                child: Text('Ok'),),
                                            ],);
                                        },);
                                      if (_shouldSetState) setState(() {});
                                      return;
                                    }
                                  },
                                    text: 'Pay ₹ ${(String var1, String var2) {
                                      return var1.isEmpty ? var2 : var1;
                                    }(_model.amount, (PaymentGroup
                                        .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                                        .offerDiscountedFees(
                                      (_model.courseInfo?.jsonBody ??
                                          ''),) as List)
                                        .map<String>((s) => s.toString())
                                        .toList()
                                        .first)}',
                                    options: FFButtonOptions(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24.0, 0.0, 24.0, 0.0),
                                      iconPadding: EdgeInsetsDirectional
                                          .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                      color: FlutterFlowTheme
                                          .of(context)
                                          .primary,
                                      textStyle: FlutterFlowTheme
                                          .of(context)
                                          .titleSmall
                                          .override(fontFamily: FlutterFlowTheme
                                          .of(context)
                                          .titleSmallFamily,
                                        color: Colors.white,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(FlutterFlowTheme
                                            .of(context)
                                            .titleSmallFamily),),
                                      elevation: 3.0,
                                      borderSide: BorderSide(
                                        color: Colors.transparent, width: 1.0,),
                                      borderRadius: BorderRadius.circular(8.0),
                                      hoverElevation: 6.0,),),),),
                              widget.courseIdInt ==
                                  FFAppState().courseIdInt.toString() ? InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    backgroundColor: FlutterFlowTheme
                                        .of(context)
                                        .secondaryBackground,
                                    context: context,
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16.0)),),
                                    builder: (BuildContext builder) {
                                      return Container(

                                        padding: EdgeInsets.all(16.0),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                    0.0, 10.0, 0.0, 0.0),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize
                                                      .max,
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .end,
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .end,
                                                  children: [
                                                    FlutterFlowIconButton(
                                                      borderRadius: 20.0,
                                                      borderWidth: 0.0,
                                                      buttonSize: 40.0,
                                                      fillColor: FlutterFlowTheme
                                                          .of(context)
                                                          .primaryBackground,
                                                      icon: FaIcon(
                                                        FontAwesomeIcons
                                                            .timesCircle,
                                                        color: FlutterFlowTheme
                                                            .of(context)
                                                            .primaryText,
                                                        size: 24.0,),
                                                      onPressed: () async {
                                                        Navigator.pop(context);
                                                      },),
                                                  ],),),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 12.0),
                                                child: SvgPicture.asset(
                                                    "assets/images/chat.svg"),),
                                              Text(
                                                  "Already Paid, \nbut can't access?",
                                                  style: FlutterFlowTheme
                                                      .of(context)
                                                      .bodyMedium
                                                      .override(
                                                    fontFamily: FlutterFlowTheme
                                                        .of(context)
                                                        .bodyMediumFamily,
                                                    fontSize: 26.0,
                                                    fontWeight: FontWeight.w700,
                                                    useGoogleFonts: GoogleFonts
                                                        .asMap().containsKey(
                                                        FlutterFlowTheme
                                                            .of(context)
                                                            .bodyMediumFamily),)),
                                              Padding(padding: const EdgeInsets
                                                  .fromLTRB(0, 20, 10, 20),
                                                child: RichText(text: TextSpan(
                                                  text: "Apologies for the inconvenience.\n\n",
                                                  style: FlutterFlowTheme
                                                      .of(context)
                                                      .bodyMedium
                                                      .override(fontSize: 12,
                                                    fontFamily: FlutterFlowTheme
                                                        .of(context)
                                                        .bodyMediumFamily,
                                                    color: FlutterFlowTheme
                                                        .of(context)
                                                        .accent1,
                                                    fontWeight: FontWeight.w400,
                                                    useGoogleFonts: GoogleFonts
                                                        .asMap().containsKey(
                                                        FlutterFlowTheme
                                                            .of(context)
                                                            .bodyMediumFamily),),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: "Just try reinstalling the app and logging back with the EMAIL you had purchased the course. If it's still not working, shoot us your number at ",
                                                      style: FlutterFlowTheme
                                                          .of(context)
                                                          .bodyMedium
                                                          .override(
                                                        fontSize: 12,
                                                        fontFamily: FlutterFlowTheme
                                                            .of(context)
                                                            .bodyMediumFamily,
                                                        color: FlutterFlowTheme
                                                            .of(context)
                                                            .accent1,
                                                        fontWeight: FontWeight
                                                            .w400,
                                                        useGoogleFonts: GoogleFonts
                                                            .asMap()
                                                            .containsKey(
                                                            FlutterFlowTheme
                                                                .of(context)
                                                                .bodyMediumFamily),),),
                                                    TextSpan(
                                                      text: "supportabhyas@neetprep.com ",
                                                      style: FlutterFlowTheme
                                                          .of(context)
                                                          .bodyMedium
                                                          .override(
                                                        fontSize: 12,
                                                        fontFamily: FlutterFlowTheme
                                                            .of(context)
                                                            .bodyMediumFamily,
                                                        color: FlutterFlowTheme
                                                            .of(context)
                                                            .accent1,
                                                        fontWeight: FontWeight
                                                            .w700,
                                                        useGoogleFonts: GoogleFonts
                                                            .asMap()
                                                            .containsKey(
                                                            FlutterFlowTheme
                                                                .of(context)
                                                                .bodyMediumFamily),),),
                                                    TextSpan(
                                                      text: ", and we'll get right on it to help you out. \n\nThank you for your understanding.",
                                                      style: FlutterFlowTheme
                                                          .of(context)
                                                          .bodyMedium
                                                          .override(
                                                        fontSize: 12,
                                                        fontFamily: FlutterFlowTheme
                                                            .of(context)
                                                            .bodyMediumFamily,
                                                        color: FlutterFlowTheme
                                                            .of(context)
                                                            .accent1,
                                                        fontWeight: FontWeight
                                                            .w400,
                                                        useGoogleFonts: GoogleFonts
                                                            .asMap()
                                                            .containsKey(
                                                            FlutterFlowTheme
                                                                .of(context)
                                                                .bodyMediumFamily),),),
                                                  ],),),),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: FlutterFlowTheme
                                                      .of(context)
                                                      .primary,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(8.0),),
                                                  padding: EdgeInsets.fromLTRB(
                                                      20.0, 14.0, 20.0, 14.0),),
                                                child: Container(
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.9,
                                                  child: Center(child: Text(
                                                      'Okay',
                                                      style: FlutterFlowTheme
                                                          .of(context)
                                                          .bodyMedium
                                                          .override(
                                                        fontFamily: FlutterFlowTheme
                                                            .of(context)
                                                            .bodyMediumFamily,
                                                        fontWeight: FontWeight
                                                            .w500,
                                                        color: Colors.white,
                                                        fontSize: 16.0,
                                                        useGoogleFonts: GoogleFonts
                                                            .asMap()
                                                            .containsKey(
                                                            FlutterFlowTheme
                                                                .of(context)
                                                                .bodyMediumFamily),)),),),),
                                            ],),),);
                                    },);
                                },
                                child: Align(alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 16.0),
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          children: [
                                            SvgPicture.asset(
                                                "assets/images/information.svg",
                                                color: FlutterFlowTheme
                                                    .of(context)
                                                    .primary),
                                            SizedBox(width: 5),
                                            Text(
                                                "Already Paid but can't access?",
                                                style: FlutterFlowTheme
                                                    .of(context)
                                                    .bodyMedium
                                                    .override(
                                                    fontFamily: FlutterFlowTheme
                                                        .of(context)
                                                        .bodyMediumFamily,
                                                    color: FlutterFlowTheme
                                                        .of(context)
                                                        .primary,
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight
                                                        .normal,
                                                    useGoogleFonts: GoogleFonts
                                                        .asMap().containsKey(
                                                        FlutterFlowTheme
                                                            .of(context)
                                                            .bodyMediumFamily)))
                                          ]),)),) : SizedBox(),
                            ],),),);
                      },),),),),));
      },);
  }

  Widget offersTab(jsonBody, offersList) {
    return Padding(padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
      child: Container(width: double.infinity,
        decoration: BoxDecoration(color: FlutterFlowTheme
            .of(context)
            .primaryBackground,),
        child: Builder(builder: (context) {
          final planList = offersList;
          return Column(mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                    children: List.generate(planList.length, (planListIndex) {
                      final planListItem = planList[planListIndex];
                        return Padding(padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 7.0, 16.0, 7.0),
                          child: InkWell(splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              setState(() {
                                _model.hasShipment = getJsonField(
                                  planListItem, r'''$.hasShipment''',);
                                selectedIndex = planListIndex;
                                _model.amount = getJsonField(
                                  planListItem, r'''$.discountedFee''',)
                                    .toString();
                                _model.title =
                                    getJsonField(planListItem, r'''$.title''',)
                                        .toString();
                                _model.fee =
                                    getJsonField(planListItem, r'''$.fee''',)
                                        .toString();
                                _model.cc = functions.getIntFromBase64(
                                    getJsonField(planListItem, r'''$.id''',)
                                        .toString()).toString();
                                _model.isOptionSel = true;
                                _model.addOnCourseList = ((getJsonField(
                                  planListItem, r'''$.addons.edges[:].node''',
                                  true,) as List?)?.cast<
                                    Map<String, dynamic>?>() ?? []);
                                _model.addOnCheckBoxList = List.generate(
                                    _model.addOnCourseList.length, (
                                    index) => false);
                                _model.complimentaryAddOnList = ((getJsonField(
                                  planListItem,
                                  r'''$.complimentaryAddons.edges[:].node''',
                                  true,) as List?)?.cast<
                                    Map<String, dynamic>?>() ?? []);
                                print(" _model.complimentaryAddOnList"+ _model.complimentaryAddOnList.length.toString());
                                _model.complimentaryAddOnCheckBoxList =
                                    List.generate(
                                        _model.complimentaryAddOnList.length, (
                                        index) => true);
                                _model.selectedAddOnCoursesList = [];
                                _model.addOnCheckBoxList = List.generate(
                                    _model.addOnCourseList.length, (
                                    index) => false);
                                _model.hasShipmentInSelectedAddOnCoursesList =
                                    List.generate(
                                        _model.addOnCourseList.length, (
                                        index) => false);
                                _model.hasShipmentInComplimentaryCourseList =
                                    List.generate(
                                        _model.complimentaryAddOnList.length, (
                                        index) => false);
                                _model.selectedAddOnCoursesList =
                                    _model.filterAddOnCourses(
                                        _model.addOnCourseList);
                                _model.filterComplimentaryAddOnCourses(
                                    _model.complimentaryAddOnList);
                                _model.couponCodeController.clear();
                                _model.enableCouponButton = false;
                                _model.couponValidityError = "";
                                _model.couponButtonText = "Apply";
                                _model.isCouponValidated = false;
                                _model.discountAfterCouponIsApplied = null;
                              });
                            },
                            child: Material(color: Colors.transparent,
                              elevation: selectedIndex == planListIndex ? 3 : 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),),
                              child: Container(width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme
                                      .of(context)
                                      .secondaryBackground,
                                  boxShadow: [
                                    BoxShadow(blurRadius: 15.0,
                                      color: Color(0x04060F0D),
                                      offset: Offset(0.0, 10.0),)
                                  ],
                                  borderRadius: BorderRadius.circular(16.0),
                                  border: Border.all(
                                    color: valueOrDefault<Color>(
                                      selectedIndex == planListIndex
                                          ? FlutterFlowTheme
                                          .of(context)
                                          .primary
                                          : FlutterFlowTheme
                                          .of(context)
                                          .secondaryText, FlutterFlowTheme
                                        .of(context)
                                        .primary,),
                                    width: selectedIndex == planListIndex
                                        ? 2
                                        : 1,),),
                                child: Column(mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 14.0, 0.0, 14.0),
                                      child: Row(mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Expanded(child: Padding(
                                            padding: EdgeInsetsDirectional
                                                .fromSTEB(20.0, 0.0, 0.0, 0.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: FlutterFlowTheme
                                                    .of(context)
                                                    .secondaryBackground,),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Text(getJsonField(
                                                    planListItem,
                                                    r'''$.title''',)
                                                      .toString(),
                                                      style: FlutterFlowTheme
                                                          .of(context)
                                                          .bodyMedium),
                                                  getJsonField(planListItem,
                                                    r'''$.expiryAt''',) ==
                                                      null ||getJsonField(
                                                    planListItem, r'''$.hasShipment''',)||
                                                      widget.courseId
                                                          .toString() ==
                                                          FFAppState()
                                                              .offlineBookCourseId
                                                              .toString() ||
                                                      widget.courseId
                                                          .toString() ==
                                                          FFAppState()
                                                              .homeTestSeriesBookCourseId
                                                              .toString()
                                                      ? SizedBox()
                                                      : Padding(
                                                    padding: EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 4.0, 0.0, 0.0),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize
                                                          .max,
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .start,
                                                      children: [
                                                        Text('Valid Till:',
                                                          style: FlutterFlowTheme
                                                              .of(context)
                                                              .bodyMedium
                                                              .override(
                                                            fontFamily: FlutterFlowTheme
                                                                .of(context)
                                                                .bodyMediumFamily,
                                                            color: Color(
                                                                0xFFB9B9B9),
                                                            fontSize: 12.0,
                                                            fontWeight: FontWeight
                                                                .normal,
                                                            useGoogleFonts: GoogleFonts
                                                                .asMap()
                                                                .containsKey(
                                                                FlutterFlowTheme
                                                                    .of(context)
                                                                    .bodyMediumFamily),),),
                                                        Padding(
                                                          padding: EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              2.0, 0.0, 11.0,
                                                              0.0),
                                                          child: Text(
                                                            functions
                                                                .formatDate(
                                                                (getJsonField(
                                                                  planListItem,
                                                                  r'''$.expiryAt''',)
                                                                    .toString()),
                                                                'yMMMd'),
                                                            style: FlutterFlowTheme
                                                                .of(context)
                                                                .bodyMedium
                                                                .override(
                                                              fontFamily: FlutterFlowTheme
                                                                  .of(context)
                                                                  .bodyMediumFamily,
                                                              color: Color(
                                                                  0xFF858585),
                                                              fontSize: 12.0,
                                                              useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                                  .containsKey(
                                                                  FlutterFlowTheme
                                                                      .of(
                                                                      context)
                                                                      .bodyMediumFamily),),),),
                                                      ],),),
                                                  SizedBox(height: 10),
                                                  getJsonField(planListItem,
                                                    r'''$.hasShipment''',)
                                                      ? InkWell(onTap: () {
                                                    if (widget.courseIdInt ==
                                                        FFAppState().offlineBookCourseIdInt
                                                            .toString()||widget.courseIdInt ==
                                                        FFAppState().courseIdInt
                                                            .toString()) {
                                                      _model
                                                          .purchaseAbhyasBooksBottomSheet(
                                                          context);
                                                    }
                                                    else if (widget.courseIdInt ==
                                                        FFAppState()
                                                            .homeTestSeriesBookCourseIdInt
                                                            .toString()) {
                                                      _model
                                                          .purchaseHTSBottomSheet(
                                                          context);
                                                    }
                                                    else if (widget.courseIdInt ==
                                                        FFAppState()
                                                            .incorrectMarkedNcertCourseIdInt
                                                            .toString()) {
                                                      _model
                                                          .purchaseIncorrectMarkedBottomSheet(
                                                          context);
                                                    }
                                                    else if (widget.courseIdInt ==
                                                        FFAppState()
                                                            .pyqMarkedNcertCourseIdInt
                                                            .toString()) {
                                                      _model
                                                          .purchasePyqBottomSheet(
                                                          context);
                                                    }
                                                   else  if (widget.courseIdInt ==
                                                        FFAppState()
                                                            .abhyasEssentialBookCourseIdInt
                                                            .toString()) {
                                                      _model
                                                          .purchaseAbhyasEssentialBooksBottomSheet(
                                                          context);
                                                    }
                                                    else  if (widget.courseIdInt ==
                                                        FFAppState()
                                                            .essentialCourseIdInt
                                                            .toString()) {
                                                      _model
                                                          .purchaseAbhyasEssentialBottomSheet(
                                                          context);
                                                    }
                                                  },
                                                    child: Container(
                                                      width: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width * 0.32,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme
                                                            .of(context)
                                                            .accent8,
                                                        // Set the background color
                                                        borderRadius: BorderRadius
                                                            .circular(
                                                            10), // Set the border radius
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            10.0, 6.0, 10.0,
                                                            6.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .center,
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .center,
                                                          children: [
                                                            Icon(Icons
                                                                .info_outline,
                                                                color: FlutterFlowTheme
                                                                    .of(context)
                                                                    .primary,
                                                                size: 18),
                                                            Padding(
                                                              padding: EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  2.0, 0.0,
                                                                  11.0,
                                                                  0.0),
                                                              child: FittedBox(
                                                                child: Text(
                                                                  widget.courseIdInt ==
                                                                      FFAppState()
                                                                          .essentialCourseIdInt
                                                                          .toString()? "Info": 'Book Info',
                                                                  style: FlutterFlowTheme
                                                                      .of(
                                                                      context)
                                                                      .bodyMedium
                                                                      .override(
                                                                    fontFamily: FlutterFlowTheme
                                                                        .of(
                                                                        context)
                                                                        .bodyMediumFamily,
                                                                    color: FlutterFlowTheme
                                                                        .of(
                                                                        context)
                                                                        .primary,
                                                                    fontSize: 13.0,
                                                                    useGoogleFonts: GoogleFonts
                                                                        .asMap()
                                                                        .containsKey(
                                                                        FlutterFlowTheme
                                                                            .of(
                                                                            context)
                                                                            .bodyMediumFamily),),),),),
                                                          ],),),),)
                                                      : SizedBox(),
                                                ],),),),),
                                          Padding(padding: EdgeInsetsDirectional
                                              .fromSTEB(15.0, 0.0, 20.0, 0.0),
                                            child: Container(width: 55.0,
                                              decoration: BoxDecoration(
                                                color: FlutterFlowTheme
                                                    .of(context)
                                                    .secondaryBackground,),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .end,
                                                children: [
                                                  Text('₹ ${(String var1) {
                                                    return var1
                                                        .split('.')
                                                        .first;
                                                  }(getJsonField(planListItem,
                                                    r'''$.discountedFee''',)
                                                      .toString())}',
                                                    style: FlutterFlowTheme
                                                        .of(context)
                                                        .bodyMedium
                                                        .override(
                                                      fontFamily: FlutterFlowTheme
                                                          .of(context)
                                                          .bodyMediumFamily,
                                                      fontSize: 16.0,
                                                      useGoogleFonts: GoogleFonts
                                                          .asMap().containsKey(
                                                          FlutterFlowTheme
                                                              .of(context)
                                                              .bodyMediumFamily),),),
                                                  Text('₹ ${(String var1) {
                                                    return var1
                                                        .split('.')
                                                        .first;
                                                  }(getJsonField(planListItem,
                                                    r'''$.fee''',)
                                                      .toString())}',
                                                    style: FlutterFlowTheme
                                                        .of(context)
                                                        .bodyMedium
                                                        .override(
                                                      fontFamily: FlutterFlowTheme
                                                          .of(context)
                                                          .bodyMediumFamily,
                                                      color: Color(0xFF858585),
                                                      fontSize: 12.0,
                                                      fontWeight: FontWeight
                                                          .normal,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      useGoogleFonts: GoogleFonts
                                                          .asMap().containsKey(
                                                          FlutterFlowTheme
                                                              .of(context)
                                                              .bodyMediumFamily),),),
                                                  Padding(
                                                    padding: EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 8.0, 0.0, 0.0),
                                                    child: Text(
                                                      '-${(String var1) {
                                                        return var1
                                                            .split('.')
                                                            .first;
                                                      }(getJsonField(
                                                        planListItem,
                                                        r'''$.discountPercentage''',)
                                                          .toString())}%',
                                                      style: FlutterFlowTheme
                                                          .of(context)
                                                          .bodyMedium
                                                          .override(
                                                        fontFamily: FlutterFlowTheme
                                                            .of(context)
                                                            .bodyMediumFamily,
                                                        color: Color(
                                                            0xFFEF4444),
                                                        fontSize: 12.0,
                                                        fontWeight: FontWeight
                                                            .normal,
                                                        useGoogleFonts: GoogleFonts
                                                            .asMap()
                                                            .containsKey(
                                                            FlutterFlowTheme
                                                                .of(context)
                                                                .bodyMediumFamily),),),),
                                                ],),),),
                                        ],),),
                                  ],),),),));
                    })),
                addOnWidget(),
                FFAppState().courseIdInt.toString()==widget.courseIdInt? Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  child: Stack(children: [
                    Padding(padding: EdgeInsetsDirectional.fromSTEB(
                        0.0, 17.0, 0.0, 0.0),
                      child: Container(
                        width: double.infinity, decoration: BoxDecoration(
                        color: FlutterFlowTheme
                            .of(context)
                            .secondaryBackground,
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(color: FlutterFlowTheme
                            .of(context)
                            .accent6, width: 1.0,),), child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 20.0, 16.0, 16.0),
                        child: Column(mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 12.0),
                              child: Row(mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Enroll Now & Get-', style: FlutterFlowTheme
                                      .of(context)
                                      .bodyMedium
                                      .override(fontFamily: FlutterFlowTheme
                                      .of(context)
                                      .bodyMediumFamily,
                                    color: FlutterFlowTheme
                                        .of(context)
                                        .primaryText,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(FlutterFlowTheme
                                        .of(context)
                                        .bodyMediumFamily),),),
                                ],),),
                            Padding(padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 12.0),
                              child: Row(mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10.0, 6.0, 10.0, 0.0),
                                    child: FaIcon(FontAwesomeIcons.solidCircle,
                                      color: FlutterFlowTheme
                                          .of(context)
                                          .primaryText, size: 9.0,),),
                                  Expanded(child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Align(alignment: AlignmentDirectional(
                                          0.0, 1.0),
                                        child: Text(
                                          "Complementary 25 Yrs PYQ Marked Phy + Chem + Bio NCERT with Q Attempting Feature & Video Solutions",
                                          style: FlutterFlowTheme
                                              .of(context)
                                              .bodyMedium
                                              .override(
                                            fontFamily: FlutterFlowTheme
                                                .of(context)
                                                .bodyMediumFamily,
                                            fontWeight: FontWeight.normal,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(FlutterFlowTheme
                                                .of(context)
                                                .bodyMediumFamily),),),),
                                    ],),),
                                ],),),
                            Padding(padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 12.0),
                              child: Row(mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10.0, 6.0, 10.0, 0.0),
                                    child: FaIcon(FontAwesomeIcons.solidCircle,
                                      color: FlutterFlowTheme
                                          .of(context)
                                          .primaryText, size: 9.0,),),
                                  Expanded(child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Align(alignment: AlignmentDirectional(
                                          0.0, 1.0),
                                        child: Text(
                                          '3 Day 100% Refund Guarantee (No Q Asked) if you don\'t like the batch',
                                          style: FlutterFlowTheme
                                              .of(context)
                                              .bodyMedium
                                              .override(
                                            fontFamily: FlutterFlowTheme
                                                .of(context)
                                                .bodyMediumFamily,
                                            fontWeight: FontWeight.normal,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(FlutterFlowTheme
                                                .of(context)
                                                .bodyMediumFamily),),),),
                                    ],),),
                                ],),),
                          ],),),),),
                    Align(alignment: AlignmentDirectional(-1.0, 0.0),
                      child: Padding(padding: EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 4.0, 0.0), child: Material(
                        color: Colors.transparent,
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),),
                        child: Container(height: 34.0,
                          decoration: BoxDecoration(color: FlutterFlowTheme
                              .of(context)
                              .sectionBackgroundColor,
                            boxShadow: [
                              BoxShadow(blurRadius: 3.0,
                                color: Color(0x13000000),
                                offset: Offset(0.0, 1.0),)
                            ],
                            borderRadius: BorderRadius.circular(8.0),),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 5.0, 10.0, 5.0),
                            child: Row(mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    'assets/images/discount-shape.png',
                                    width: 25.0,
                                    height: 25.0,
                                    fit: BoxFit.cover,
                                    color: FlutterFlowTheme
                                        .of(context)
                                        .primaryText,),),
                                Padding(padding: EdgeInsetsDirectional.fromSTEB(
                                    8.0, 0.0, 0.0, 0.0),
                                  child: Text('LIMITED TIME OFFER',
                                    style: FlutterFlowTheme
                                        .of(context)
                                        .bodyMedium
                                        .override(fontFamily: FlutterFlowTheme
                                        .of(context)
                                        .bodyMediumFamily,
                                      fontWeight: FontWeight.bold,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(FlutterFlowTheme
                                          .of(context)
                                          .bodyMediumFamily),),),),
                              ],),),),),),),
                  ],),):SizedBox(),
                Column(mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: double.infinity,
                      decoration: BoxDecoration(color: FlutterFlowTheme
                          .of(context)
                          .primaryBackground,),
                      child: Padding(padding: EdgeInsetsDirectional.fromSTEB(
                          16.0, 24.0, 16.0, 24.0),
                        child: Container(
                          width: double.infinity, decoration: BoxDecoration(
                          color: FlutterFlowTheme
                              .of(context)
                              .secondaryBackground,
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(color: FlutterFlowTheme
                              .of(context)
                              .accent6, width: 1.0,),), child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 20.0, 16.0, 20.0),
                          child: Column(mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 8.0),
                                child: Row(mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Text('Price', style: FlutterFlowTheme
                                        .of(context)
                                        .bodyMedium
                                        .override(fontFamily: FlutterFlowTheme
                                        .of(context)
                                        .bodyMediumFamily,
                                      color: Color(0xFF858585),
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(FlutterFlowTheme
                                          .of(context)
                                          .bodyMediumFamily),),),
                                    // if(false)
                                    Text('₹${(String var1, String var2) {
                                      return var1.isEmpty ? var2 : var1;
                                    }(_model.fee, (PaymentGroup
                                        .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                                        .offerFees(
                                      (_model.courseInfo?.jsonBody ?? ''),) ??
                                        '').toString())}',
                                      style: FlutterFlowTheme
                                          .of(context)
                                          .bodyMedium
                                          .override(fontFamily: FlutterFlowTheme
                                          .of(context)
                                          .bodyMediumFamily,
                                        color: FlutterFlowTheme
                                            .of(context)
                                            .primaryText,
                                        fontSize: 16.0,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(FlutterFlowTheme
                                            .of(context)
                                            .bodyMediumFamily),),),
                                  ],),),
                              // if(false)
                              Padding(padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 7.0),
                                child: Row(mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Text('Discount', style: FlutterFlowTheme
                                        .of(context)
                                        .bodyMedium
                                        .override(fontFamily: FlutterFlowTheme
                                        .of(context)
                                        .bodyMediumFamily,
                                      color: Color(0xFF858585),
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(FlutterFlowTheme
                                          .of(context)
                                          .bodyMediumFamily),),),
                                    Text('₹${((String var1, String var2) {
                                      return var1.isEmpty
                                          ? double.parse(var2)
                                          : double.parse(var1);
                                    }(_model.fee, (PaymentGroup
                                        .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                                        .offerFees(
                                      (_model.courseInfo?.jsonBody ??
                                          ''),) as List)
                                        .map<String>((s) => s.toString())
                                        .toList()
                                        .first) - double.parse(
                                            (String var1, String var2) {
                                          return var1.isEmpty ? var2 : var1;
                                        }(_model.amount, (PaymentGroup
                                            .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                                            .offerdispercent(
                                          (_model.courseInfo?.jsonBody ??
                                              ''),) as List).map<String>((s) =>
                                            s.toString())
                                            .toList()
                                            .first
                                            .toString()))).toString()}',
                                      style: FlutterFlowTheme
                                          .of(context)
                                          .bodyMedium
                                          .override(fontFamily: FlutterFlowTheme
                                          .of(context)
                                          .bodyMediumFamily,
                                        color: Color(0xFFEF4444),
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.normal,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(FlutterFlowTheme
                                            .of(context)
                                            .bodyMediumFamily),),),
                                  ],),),
                              Divider(
                                thickness: 1.0, color: Color(0xFFE9E9E9),),

                              ///COUPON CODE IMPLEMENTATION
                              // if(false)
                              CouponCodeWidget(context),
                              Padding(padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 7.0, 0.0, 0.0),
                                child: Row(mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Text(
                                      'Total Payment', style: FlutterFlowTheme
                                        .of(context)
                                        .bodyMedium
                                        .override(fontFamily: FlutterFlowTheme
                                        .of(context)
                                        .bodyMediumFamily,
                                      color: FlutterFlowTheme
                                          .of(context)
                                          .primaryText,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(FlutterFlowTheme
                                          .of(context)
                                          .bodyMediumFamily),),),
                                    // if(false)
                                    Text('₹ ${(String var1, String var2) {
                                      return var1.isEmpty ? var2 : var1;
                                    }(_model.amount, (PaymentGroup
                                        .getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
                                        .offerDiscountedFees(
                                      (_model.courseInfo?.jsonBody ?? ''),) ??
                                        '').toString())}',
                                      style: FlutterFlowTheme
                                          .of(context)
                                          .bodyMedium
                                          .override(fontFamily: FlutterFlowTheme
                                          .of(context)
                                          .bodyMediumFamily,
                                        fontSize: 16.0,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(FlutterFlowTheme
                                            .of(context)
                                            .bodyMediumFamily),),),
                                  ],),),
                            ],),),),),),
                  ],),
              ]);
        },),),);
  }

  Widget addOnWidget() {
    return Container(decoration: BoxDecoration(color: FlutterFlowTheme
        .of(context)
        .primaryBackground,),
      padding: EdgeInsets.fromLTRB(16, 5, 16, 5),
      child: Column(mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (_model.complimentaryAddOnList != null &&
              _model.complimentaryAddOnList.isNotEmpty) ||
              (_model.addOnCourseList != null &&
                  _model.addOnCourseList.isNotEmpty) ? Padding(
            padding: const EdgeInsets.only(bottom: 14.0),
            child: Text("SPECIAL DEALS 🤝 FOR YOU", style: FlutterFlowTheme
                .of(context)
                .bodyMedium
                .override(fontFamily: FlutterFlowTheme
                .of(context)
                .bodyMediumFamily,
              fontWeight: FontWeight.w400,
              color: Color(0xff858585),
              fontSize: 14.0,
              useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme
                  .of(context)
                  .bodyMediumFamily),),),) : Container(),
          _model.addOnCourseList != null && _model.addOnCourseList.isNotEmpty
              ? addOnCourseWidget(
              _model.addOnCourseList!, _model.addOnCheckBoxList)
              : Container(),
          _model.complimentaryAddOnList != null &&
              _model.complimentaryAddOnList.isNotEmpty
              ? complimentaryCourseOfferWidget(_model.complimentaryAddOnList!,
              _model.complimentaryAddOnCheckBoxList)
              : Container(),
        ],),);
  }

  Widget addOnCourseWidget(List<dynamic> availableAddOnCourseList,
      List<bool> checkBoxList) {
    return Column(mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: double.infinity,
            child: Column(children: List.generate(
              availableAddOnCourseList.length, (index) =>
                Container(margin: EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(13.0),
                  width: double.infinity,
                  decoration: BoxDecoration(color: FlutterFlowTheme
                      .of(context)
                      .secondaryBackground,
                    border: Border.all(color: FlutterFlowTheme
                        .of(context)
                        .accent6, width: 1.0,),
                    borderRadius: BorderRadius.circular(10.0), // Uniform radius
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Checkbox(activeColor: FlutterFlowTheme
                            .of(context)
                            .primary,
                          value: _model.addOnCheckBoxList[index],
                          onChanged: (bool? value) {
                            setState(() {
                              print("checkbox value " +
                                  _model.addOnCheckBoxList[index].toString());
                              if (!_model.addOnCheckBoxList[index]) {
                                _model.fee = (double.parse(_model.fee) +
                                    double.parse(
                                        availableAddOnCourseList[index]!['addonCourseOffer'] !=
                                            null
                                            ? availableAddOnCourseList[index]!['addonCourseOffer']['fee']
                                            : availableAddOnCourseList[index]!['addonCourse']['fee']))
                                    .toString();
                                _model.amount = (double.parse(_model.amount) +
                                    double.parse(
                                        availableAddOnCourseList[index]!['addonCourseOffer'] !=
                                            null
                                            ? availableAddOnCourseList[index]!['addonCourseOffer']['discountedFee']
                                            : availableAddOnCourseList[index]!['addonCourse']['discountedFee']))
                                    .toString();
                                availableAddOnCourseList[index]!['addonCourseOffer'] !=
                                    null
                                    ? availableAddOnCourseList[index]!['addonCourseOffer']["hasShipment"] ==
                                    true
                                    : availableAddOnCourseList[index]!['addonCourse']["hasShipment"] ==
                                    true ? _model
                                    .hasShipmentInSelectedAddOnCoursesList[index] =
                                true : _model
                                    .hasShipmentInSelectedAddOnCoursesList[index] =
                                false;
                                _model.selectedAddOnCoursesList?.add(
                                    availableAddOnCourseList[index]!['addonCourseId'] as int);
                              } else {
                                _model.fee = (double.parse(_model.fee) -
                                    double.parse(
                                        availableAddOnCourseList[index]!['addonCourseOffer'] !=
                                            null
                                            ? availableAddOnCourseList[index]!['addonCourseOffer']['fee']
                                            : availableAddOnCourseList[index]!['addonCourse']['fee']))
                                    .toString();
                                _model.amount = (double.parse(_model.amount) -
                                    double.parse(
                                        availableAddOnCourseList[index]!['addonCourseOffer'] !=
                                            null
                                            ? availableAddOnCourseList[index]!['addonCourseOffer']['discountedFee']
                                            : availableAddOnCourseList[index]!['addonCourse']['discountedFee']))
                                    .toString();
                                _model
                                    .hasShipmentInSelectedAddOnCoursesList[index] =
                                false;
                                _model.selectedAddOnCoursesList?.remove(
                                    availableAddOnCourseList[index]!['addonCourseId'] as int);
                              }

                              _model.addOnCheckBoxList[index] =
                              !_model.addOnCheckBoxList[index];
                            });
                          },), Flexible(child: Column(mainAxisSize: MainAxisSize
                            .min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(child: Text(
                              availableAddOnCourseList[index]!['addonCourseOffer'] !=
                                  null
                                  ? availableAddOnCourseList[index]!['addonCourseOffer']["title"]
                                  : availableAddOnCourseList[index]!['addonCourse']["name"],
                              style: FlutterFlowTheme
                                  .of(context)
                                  .bodyMedium
                                  .override(fontFamily: FlutterFlowTheme
                                  .of(context)
                                  .bodyMediumFamily,
                                fontWeight: FontWeight.w600,
                                color: FlutterFlowTheme
                                    .of(context)
                                    .primaryText,
                                fontSize: 14.0,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme
                                        .of(context)
                                        .bodyMediumFamily),),)),
                            (availableAddOnCourseList[index]!['addonCourseId']
                                .toString() == "4577" || availableAddOnCourseList[index]!['addonCourseOffer'] !=
                                null &&
                                availableAddOnCourseList[index]!['addonCourseOffer']["description"] !=
                                    null ||
                                availableAddOnCourseList[index]!['addonCourse']["description"] !=
                                    null) ? Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: InkWell(onTap: () {
                                if (availableAddOnCourseList[index]!['addonCourseOffer'] !=
                                    null &&
                                    (availableAddOnCourseList[index]!['addonCourseOffer']['id'] ==
                                        "Q291cnNlT2ZmZXI6MjE5ODY1MQ==" ||
                                        availableAddOnCourseList[index]!['addonCourseOffer']['id'] ==
                                            "Q291cnNlT2ZmZXI6MjE5ODY1Mg==")) {
                                  _model.purchaseARBottomSheet(context);
                                } else
                                if (
                                    availableAddOnCourseList[index]!['addonCourseId']
                                        .toString() == "4181") {
                                  _model.purchaseHTSBottomSheet(context);
                                }else if (availableAddOnCourseList[index]!['addonCourseOffer'] ==
                                    null &&
                                    availableAddOnCourseList[index]!['addonCourseId']
                                        .toString() == "5535") {
                                  _model.purchaseIncorrectMarkedBottomSheet(context);
                                } else if (availableAddOnCourseList[index]!['addonCourseOffer'] ==
                                    null &&
                                    availableAddOnCourseList[index]!['addonCourseId']
                                        .toString() == "5534") {
                                  _model.purchasePyqBottomSheet(context);
                                } else
                                if (availableAddOnCourseList[index]!['addonCourseId']
                                    .toString() == "4247") {
                                  _model.purchaseEssentialBottomSheet(context);
                                } else
                                if (availableAddOnCourseList[index]!['addonCourseId']
                                    .toString() == "3488") {
                                  _model.purchaseFlashcardBottomSheet(context);
                                }
                                else if (availableAddOnCourseList[index]!['addonCourseId']
                                    .toString() == "3125") {
                                  _model.purchaseAbhyasBottomSheet(context);
                                }
                                else if (availableAddOnCourseList[index]!['addonCourseId']
                                    .toString() == "4775") {
                                  _model.purchaseAbhyas2BottomSheet(context);
                                }
                              }, child: Container(width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.32,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme
                                      .of(context)
                                      .accent8,
                                  borderRadius: BorderRadius.circular(10),),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10.0, 6.0, 10.0, 6.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    children: [
                                      Icon(Icons.info_outline,
                                          color: FlutterFlowTheme
                                              .of(context)
                                              .primary, size: 18),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            2.0, 0.0, 11.0, 0.0),
                                        child: FittedBox(child: Text(
                                          availableAddOnCourseList[index]!['addonCourseOffer'] !=
                                              null &&
                                              availableAddOnCourseList[index]!['addonCourseOffer']["hasShipment"] !=
                                                  false ||
                                              availableAddOnCourseList[index]!['addonCourse']["hasShipment"] !=
                                                  false ? ' Book Info' : 'Info',
                                          style: FlutterFlowTheme
                                              .of(context)
                                              .bodyMedium
                                              .override(
                                            fontFamily: FlutterFlowTheme
                                                .of(context)
                                                .bodyMediumFamily,
                                            color: FlutterFlowTheme
                                                .of(context)
                                                .primary,
                                            fontSize: 13.0,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(FlutterFlowTheme
                                                .of(context)
                                                .bodyMediumFamily),),),),),
                                    ],),),),),) : SizedBox(),
                            availableAddOnCourseList[index]!['addonCourseOffer'] !=
                                null
                                ? availableAddOnCourseList[index]!['addonCourseOffer']['expiryAt'] !=
                                null
                                ? Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 4.0, 0.0, 0.0),
                              child: Row(mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Valid Till:', style: FlutterFlowTheme
                                      .of(context)
                                      .bodyMedium
                                      .override(fontFamily: FlutterFlowTheme
                                      .of(context)
                                      .bodyMediumFamily,
                                    color: Color(0xFFB9B9B9),
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.normal,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(FlutterFlowTheme
                                        .of(context)
                                        .bodyMediumFamily),),),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        2.0, 0.0, 11.0, 0.0),
                                    child: Text(functions.formatDate(
                                        (availableAddOnCourseList[index]!['addonCourseOffer']['expiryAt']
                                            .toString()), 'yMMMd'),
                                      style: FlutterFlowTheme
                                          .of(context)
                                          .bodyMedium
                                          .override(fontFamily: FlutterFlowTheme
                                          .of(context)
                                          .bodyMediumFamily,
                                        color: Color(0xFF858585),
                                        fontSize: 12.0,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(FlutterFlowTheme
                                            .of(context)
                                            .bodyMediumFamily),),),),
                                ],),)
                                : availableAddOnCourseList[index]!['addonCourse']['expiryAt'] !=
                                null ? Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 4.0, 0.0, 0.0),
                              child: Row(mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Valid Till:', style: FlutterFlowTheme
                                      .of(context)
                                      .bodyMedium
                                      .override(fontFamily: FlutterFlowTheme
                                      .of(context)
                                      .bodyMediumFamily,
                                    color: Color(0xFFB9B9B9),
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.normal,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(FlutterFlowTheme
                                        .of(context)
                                        .bodyMediumFamily),),),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        2.0, 0.0, 11.0, 0.0),
                                    child: Text(functions.formatDate(
                                        (availableAddOnCourseList[index]!['addonCourse']['expiryAt']
                                            .toString()), 'yMMMd'),
                                      style: FlutterFlowTheme
                                          .of(context)
                                          .bodyMedium
                                          .override(fontFamily: FlutterFlowTheme
                                          .of(context)
                                          .bodyMediumFamily,
                                        color: Color(0xFF858585),
                                        fontSize: 12.0,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(FlutterFlowTheme
                                            .of(context)
                                            .bodyMediumFamily),),),),
                                ],),) : Container()
                                : Container(),
                            Flexible(child: Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    availableAddOnCourseList[index]!['addonCourseOffer'] !=
                                        null ? "₹ " +
                                        availableAddOnCourseList[index]!['addonCourseOffer']["discountedFee"]
                                            .toString() : "₹ " +
                                        availableAddOnCourseList[index]!['addonCourse']["discountedFee"]
                                            .toString(), style: FlutterFlowTheme
                                      .of(context)
                                      .bodyMedium
                                      .override(fontFamily: FlutterFlowTheme
                                      .of(context)
                                      .bodyMediumFamily,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff0D6EFD),
                                    fontSize: 16.0,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(FlutterFlowTheme
                                        .of(context)
                                        .bodyMediumFamily),),),
                                  SizedBox(width: 10),
                                  Text(
                                    availableAddOnCourseList[index]!['addonCourseOffer'] !=
                                        null ? "₹ " +
                                        availableAddOnCourseList[index]!['addonCourseOffer']["fee"]
                                            .toString() : "₹ " +
                                        availableAddOnCourseList[index]!['addonCourse']["fee"]
                                            .toString(), style: FlutterFlowTheme
                                      .of(context)
                                      .bodyMedium
                                      .override(fontFamily: FlutterFlowTheme
                                      .of(context)
                                      .bodyMediumFamily,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff858585),
                                    fontSize: 16.0,
                                    decoration: TextDecoration.lineThrough,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(FlutterFlowTheme
                                        .of(context)
                                        .bodyMediumFamily),),)
                                ],),))
                          ],),),
                        ],),
                    ],),),),)),
      ],);
  }

  Widget complimentaryCourseOfferWidget(List<dynamic> availableAddOnCourseList,
      List<bool> checkBoxList) {
    print(availableAddOnCourseList.toString());
    return Column(mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Container(decoration: BoxDecoration(color: FlutterFlowTheme
          .of(context)
          .primaryBackground,),
          width: double.infinity,
          child: Column(
            children: List.generate(availableAddOnCourseList.length, (index) =>
                Container(margin: EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(13.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: FlutterFlowTheme
                        .of(context)
                        .accent6, width: 1.0,),
                    color: FlutterFlowTheme
                        .of(context)
                        .secondaryBackground,
                    borderRadius: BorderRadius.circular(10.0), // Uniform radius
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Checkbox(activeColor: FlutterFlowTheme
                            .of(context)
                            .primary,
                          value: _model.complimentaryAddOnCheckBoxList[index],
                          onChanged: (bool? value) {

                          },), Flexible(child: Column(mainAxisSize: MainAxisSize
                            .min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(child: Text(
                              availableAddOnCourseList[index]!['complimentaryCourseOffer'] !=
                                  null
                                  ? availableAddOnCourseList[index]!['complimentaryCourseOffer']["title"]
                                  : availableAddOnCourseList[index]!['complimentaryCourse']["name"],
                              style: FlutterFlowTheme
                                  .of(context)
                                  .bodyMedium
                                  .override(fontFamily: FlutterFlowTheme
                                  .of(context)
                                  .bodyMediumFamily,
                                fontWeight: FontWeight.w600,
                                color: FlutterFlowTheme
                                    .of(context)
                                    .primaryText,
                                fontSize: 14.0,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme
                                        .of(context)
                                        .bodyMediumFamily),),)),
                            ( availableAddOnCourseList[index]!['complimentaryCourseOffer']['courseId']
                                .toString() != "4577" && availableAddOnCourseList[index]!['complimentaryCourseOffer'] !=
                                null &&
                                availableAddOnCourseList[index]!['complimentaryCourseOffer']["description"] !=
                                    null ||
                                availableAddOnCourseList[index]!['complimentaryCourse']["description"] !=
                                    null) &&
                                (availableAddOnCourseList[index]!['complimentaryCourseOffer'] !=
                                    null) ? Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: InkWell(onTap: () {
                                print(
                                    availableAddOnCourseList[index]!['complimentaryCourseId']
                                        .toString());
                                if (availableAddOnCourseList[index]!['complimentaryCourseOffer'] !=
                                    null &&
                                    availableAddOnCourseList[index]!['complimentaryCourseOffer']['courseId']
                                        .toString() == "4148") {
                                  _model.purchaseARBottomSheet(context);
                                } else
                                if (
                                    availableAddOnCourseList[index]!['complimentaryCourseOffer']['courseId']
                                        .toString() == "4181") {
                                  _model.purchaseHTSBottomSheet(context);
                                } if (
                                    availableAddOnCourseList[index]!['complimentaryCourseOffer']['courseId']
                                        .toString() == "5535") {
                                  _model.purchaseIncorrectMarkedBottomSheet(context);
                                } else if (
                                    availableAddOnCourseList[index]!['complimentaryCourseOffer']['courseId']
                                        .toString() == "5534") {
                                  _model.purchasePyqBottomSheet(context);
                                }
                                else
                                if (availableAddOnCourseList[index]!['complimentaryCourseOffer']['courseId']
                                    .toString() == "4247") {
                                  _model.purchaseEssentialBottomSheet(context);
                                } else
                                if (availableAddOnCourseList[index]!['complimentaryCourseOffer']['courseId']
                                    .toString() == "3488") {
                                  _model.purchaseFlashcardBottomSheet(context);
                                }else   if (availableAddOnCourseList[index]!['complimentaryCourseOffer']['courseId']
                                    .toString() == "4775") {
                                  _model.purchaseAbhyas2BottomSheet(context);
                                }
                                else   if (availableAddOnCourseList[index]!['complimentaryCourseOffer']['courseId']
                                    .toString() == "4841") {
                                  _model.purchaseAbhyasEssentialBooksBottomSheet(context);
                                }
                              }, child: Container(width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.32,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme
                                      .of(context)
                                      .accent8,
                                  borderRadius: BorderRadius.circular(10),),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10.0, 6.0, 10.0, 6.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    children: [
                                      Icon(Icons.info_outline,
                                          color: FlutterFlowTheme
                                              .of(context)
                                              .primary, size: 18),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            2.0, 0.0, 11.0, 0.0),
                                        child: FittedBox(child: Text(
                                          availableAddOnCourseList[index]!['complimentaryCourseOffer'] !=
                                              null &&
                                              availableAddOnCourseList[index]!['complimentaryCourseOffer']["hasShipment"] !=
                                                  false ||
                                              availableAddOnCourseList[index]!['complimentaryCourseOffer']["hasShipment"] !=
                                                  false ? ' Book Info' : 'Info',
                                          style: FlutterFlowTheme
                                              .of(context)
                                              .bodyMedium
                                              .override(
                                            fontFamily: FlutterFlowTheme
                                                .of(context)
                                                .bodyMediumFamily,
                                            color: FlutterFlowTheme
                                                .of(context)
                                                .primary,
                                            fontSize: 13.0,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(FlutterFlowTheme
                                                .of(context)
                                                .bodyMediumFamily),),),),),
                                    ],),),),),) : SizedBox(),
                            availableAddOnCourseList[index]!['complimentaryCourseOffer'] !=
                                null
                                ? availableAddOnCourseList[index]!['complimentaryCourseOffer']['expiryAt'] !=
                                null && availableAddOnCourseList[index]!['complimentaryCourseOffer']['hasShipment'] !=
                                true
                                ? Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 4.0, 0.0, 0.0),
                              child: Row(mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Valid Till:', style: FlutterFlowTheme
                                      .of(context)
                                      .bodyMedium
                                      .override(fontFamily: FlutterFlowTheme
                                      .of(context)
                                      .bodyMediumFamily,
                                    color: Color(0xFFB9B9B9),
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.normal,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(FlutterFlowTheme
                                        .of(context)
                                        .bodyMediumFamily),),),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        2.0, 0.0, 11.0, 0.0),
                                    child: Text(functions.formatDate(
                                        (availableAddOnCourseList[index]!['complimentaryCourseOffer']['expiryAt']
                                            .toString()), 'yMMMd'),
                                      style: FlutterFlowTheme
                                          .of(context)
                                          .bodyMedium
                                          .override(fontFamily: FlutterFlowTheme
                                          .of(context)
                                          .bodyMediumFamily,
                                        color: Color(0xFF858585),
                                        fontSize: 12.0,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(FlutterFlowTheme
                                            .of(context)
                                            .bodyMediumFamily),),),),
                                ],),)
                                : availableAddOnCourseList[index]!['complimentaryCourseOffer']['expiryAt'] !=
                                null && availableAddOnCourseList[index]!['complimentaryCourseOffer']['hasShipment'] !=
                                true? Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 4.0, 0.0, 0.0),
                              child: Row(mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Valid Till:', style: FlutterFlowTheme
                                      .of(context)
                                      .bodyMedium
                                      .override(fontFamily: FlutterFlowTheme
                                      .of(context)
                                      .bodyMediumFamily,
                                    color: Color(0xFFB9B9B9),
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.normal,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(FlutterFlowTheme
                                        .of(context)
                                        .bodyMediumFamily),),),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        2.0, 0.0, 11.0, 0.0),
                                    child: Text(functions.formatDate(
                                        (availableAddOnCourseList[index]!['complimentaryCourseOffer']['expiryAt']
                                            .toString()), 'yMMMd'),
                                      style: FlutterFlowTheme
                                          .of(context)
                                          .bodyMedium
                                          .override(fontFamily: FlutterFlowTheme
                                          .of(context)
                                          .bodyMediumFamily,
                                        color: Color(0xFF858585),
                                        fontSize: 12.0,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(FlutterFlowTheme
                                            .of(context)
                                            .bodyMediumFamily),),),),
                                ],),) : Container()
                                : Container(),
                            Flexible(child: Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    availableAddOnCourseList[index]!['complimentaryCourseOffer'] !=
                                        null ? "₹ " + "0.00" : "0.00",
                                    style: FlutterFlowTheme
                                        .of(context)
                                        .bodyMedium
                                        .override(fontFamily: FlutterFlowTheme
                                        .of(context)
                                        .bodyMediumFamily,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff0D6EFD),
                                      fontSize: 16.0,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(FlutterFlowTheme
                                          .of(context)
                                          .bodyMediumFamily),),),
                                  SizedBox(width: 10),
                                  Text(
                                    availableAddOnCourseList[index]!['complimentaryCourse']['origFee'] !=
                                        null ? "₹ " +
                                        availableAddOnCourseList[index]!['complimentaryCourse']["origFee"]
                                            .toString() : "₹ " +
                                        availableAddOnCourseList[index]!['complimentaryCourseOffer']["discountedFee"]
                                            .toString(), style: FlutterFlowTheme
                                      .of(context)
                                      .bodyMedium
                                      .override(fontFamily: FlutterFlowTheme
                                      .of(context)
                                      .bodyMediumFamily,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff858585),
                                    fontSize: 16.0,
                                    decoration: TextDecoration.lineThrough,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(FlutterFlowTheme
                                        .of(context)
                                        .bodyMediumFamily),),)
                                ],),))
                          ],),),
                        ],),
                    ],),),),)),
      ],);
  }

  Widget CouponCodeWidget(context) {
    return Column(children: [
      Padding(padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _model.couponButtonText == "Remove" ? _model.isCouponValidated
                    ? Icon(Icons.check_circle_outline, color: Color(0xff10B981))
                    : SvgPicture.asset(
                    'assets/images/close_circle.svg', fit: BoxFit.none,
                    color: Color(0xffEF4444)) : SizedBox(),
                SizedBox(width: 5),
                Flexible(child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: TextField(
                      controller: _model.couponCodeController,
                      enabled: _model.couponButtonText == "Remove"
                          ? false
                          : true,
                      decoration: InputDecoration(hintText: 'Enter Coupon ',
                        border: InputBorder.none,
                        hintStyle: FlutterFlowTheme
                            .of(context)
                            .bodyMedium
                            .override(fontFamily: FlutterFlowTheme
                            .of(context)
                            .bodyMediumFamily,
                          fontSize: 14.0,
                          color: Color(0xffb9b9b9),
                          fontWeight: FontWeight.w400,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme
                                  .of(context)
                                  .bodyMediumFamily),),),),),
                    Flexible(child: TextButton(

                      onPressed: !_model
                        .enableCouponButton ? null : () async {
                        setState((){
                          _model.enableCouponButton = false;
                        });
                      if (_model.couponButtonText == "Remove") {
                        _model.couponCodeController.text = "";
                        _model.amount = (double.parse(_model.amount) +
                            double.parse(
                                _model.discountAfterCouponIsApplied ?? "0.0"))
                            .toString();
                        print( "_model.discountAfterCouponIsApplied "+ _model.discountAfterCouponIsApplied.toString() );
                        _model.couponButtonText = "Apply";
                        _model.isCouponValidated = false;
                        _model.couponValidityError ="";

                        return;
                      }
                      Set<int> selectedAddOnCoursesSet = Set.from(
                          _model.selectedAddOnCoursesList ?? []);
                      Map<String,
                          String> couponData = {
                        'TXN_AMOUNT': _model.amount,
                        'EMAIL': currentUserEmail.toString(),
                        'COURSE': widget.courseIdInt,
                        'COURSE_OFFER_ID': _model.cc.toString(),
                        'USERID': FFAppState().userIdInt.toString(),
                        'addonCourseIds': selectedAddOnCoursesSet.toString(),
                        'coupon_code': _model.couponCodeController.text,
                      };
                      print(couponData);
                      if (_model.couponCodeController.text != null &&
                          _model.couponCodeController.text.isNotEmpty &&
                          _model.couponButtonText == "Apply") {

                        var result = await _model.checkCouponValidity(
                            couponData);
                        String? couponValidityResponseAmount = result?['amount'];
                       _model.couponValidityError = result?['error'];
                       print("result"+result.toString());
                        ;
                        if (couponValidityResponseAmount != null) {
                          if (double.parse(couponValidityResponseAmount) ==
                              double.parse(_model.amount)) {
                            _model.isCouponValidated = false;
                            _model.couponId = null;
                            _model.discountAfterCouponIsApplied =null;
                          } else {
                            _model.discountAfterCouponIsApplied =
                                (double.parse(_model.amount) -
                                    double.parse(couponValidityResponseAmount))
                                    .toString();
                            _model.amount = couponValidityResponseAmount;
                            _model.isCouponValidated = true;
                          }
                          _model.couponButtonText = "Remove";
                        } else {
                          Fluttertoast.showToast(msg: "Something went wrong!");
                        }

                        //  else {

                      } else {
                        Fluttertoast.showToast(msg: "Please enter coupon code");
                      }

                        setState((){
                          _model.enableCouponButton = true;
                        });

                    }, child: Text(_model.couponButtonText,
                      style: FlutterFlowTheme
                          .of(context)
                          .bodyMedium
                          .override(fontFamily: FlutterFlowTheme
                          .of(context)
                          .bodyMediumFamily,
                        fontSize: 14.0,
                        color: _model.couponButtonText == "Remove" ? Color(
                            0xffEF4444) : _model.couponCodeController.text
                            .isNotEmpty ? FlutterFlowTheme
                            .of(context)
                            .primary : Color(0xffb9b9b9),
                        fontWeight: FontWeight.w700,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme
                                .of(context)
                                .bodyMediumFamily),),),))
                  ],),),
              ],),
            Column(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _model.couponButtonText == "Remove" ? _model.isCouponValidated
                      ? RichText(text: TextSpan(children: [
                    TextSpan(text: 'Saved ', style: FlutterFlowTheme
                        .of(context)
                        .bodyMedium
                        .override(fontFamily: FlutterFlowTheme
                        .of(context)
                        .bodyMediumFamily,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff10B981),
                      fontSize: 15.0,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme
                              .of(context)
                              .bodyMediumFamily),),),
                    TextSpan(text: "₹ " +
                        _model.discountAfterCouponIsApplied.toString(),
                      style: FlutterFlowTheme
                          .of(context)
                          .bodyMedium
                          .override(fontFamily: FlutterFlowTheme
                          .of(context)
                          .bodyMediumFamily,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff10B981),
                        fontSize: 15.0,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme
                                .of(context)
                                .bodyMediumFamily),),),
                  ], style: FlutterFlowTheme
                      .of(context)
                      .bodyMedium,),)
                      : Text(_model.couponValidityError!, style: FlutterFlowTheme
                      .of(context)
                      .bodyMedium
                      .override(fontFamily: FlutterFlowTheme
                      .of(context)
                      .bodyMediumFamily,
                    fontWeight: FontWeight.w500,
                    color: Color(0xffEF4444),
                    fontSize: 14.0,
                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                        FlutterFlowTheme
                            .of(context)
                            .bodyMediumFamily),),) : Container()
                  // Text('Saved ₹ 300')
                ])
          ],),),
      Divider(thickness: 1.0, color: Color(0xFFE9E9E9),),
    ]);
  }
}


