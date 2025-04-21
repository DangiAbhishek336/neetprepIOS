import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neetprep_essential/pages/create_test/classroom_test_series_page/thankyou_page_model.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';


class ThankYouPageWidget extends StatefulWidget {
  const ThankYouPageWidget({Key? key}) : super(key: key);

  @override
  _ThankYouPageWidgetState createState() =>
      _ThankYouPageWidgetState();
}

class _ThankYouPageWidgetState
    extends State<ThankYouPageWidget> {
  late ThankYouPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "ThankYouPageWidget",);
    _model = createModel(context, () => ThankYouPageModel());
    FFAppState().isCreatedTest = false;
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   return SafeArea(
     child: Scaffold(
       body:SingleChildScrollView(
         child: Container(
           // height: MediaQuery.of(context).size.height*0.95,
           padding:EdgeInsets.fromLTRB(16,40,16,30),
           child: Center(
             child:Column(
               children:[
                 Column(
                   children:[
                     SvgPicture.asset(
                       'assets/images/illustration_picture.svg',
                       width:MediaQuery.of(context).size.width,
                       fit: BoxFit.none,
                     ),
                     SizedBox(height: 20,),
                     Text('Thank you!', style:FlutterFlowTheme.of(context)
                         .bodyMedium
                         .override(
                       fontFamily: FlutterFlowTheme.of(context)
                           .bodyMediumFamily,
                       color: Color(0xFF252525),
                       fontSize: 26.0,
                       fontWeight: FontWeight.w600,
                       useGoogleFonts: GoogleFonts.asMap()
                           .containsKey(FlutterFlowTheme.of(context)
                           .bodyMediumFamily),
                     ),),
                     SizedBox(height:15),
                     Text('Your request has been',style:FlutterFlowTheme.of(context)
                         .bodyMedium
                         .override(
                       fontFamily: FlutterFlowTheme.of(context)
                           .bodyMediumFamily,
                       color: Color(0xffadadad),
                       fontSize: 14.0,
                       fontWeight: FontWeight.w500,
                       useGoogleFonts: GoogleFonts.asMap()
                           .containsKey(FlutterFlowTheme.of(context)
                           .bodyMediumFamily),
                     ),),
                     Text('successfully submitted',style:FlutterFlowTheme.of(context)
                         .bodyMedium
                         .override(
                       fontFamily: FlutterFlowTheme.of(context)
                           .bodyMediumFamily,
                       color: Color(0xffadadad),
                       fontSize: 14.0,
                       fontWeight: FontWeight.w500,
                       useGoogleFonts: GoogleFonts.asMap()
                           .containsKey(FlutterFlowTheme.of(context)
                           .bodyMediumFamily),
                     ),),
                     SizedBox(height:20),
                     Padding(
                       padding: const EdgeInsets.fromLTRB(30.0,0,30,0),
                       child: Divider(
                         thickness:1.4,
                         color:Color(0xffe9e9e9),
                       ),
                     ),
                     SizedBox(height:30),
                     Stack(
                         children:[
                           Padding(
                             padding:EdgeInsets.only(top:30),
                             child: Container(
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(24.0),
                                   color:Color(0xffE4F0D3),
                                 ),
                                 child:Padding(
                                   padding: const EdgeInsets.fromLTRB(26,30,16,0),
                                   child:Row(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       children:[
                                         Flexible(
                                             flex:1,
                                             child: Column(
                                                 mainAxisAlignment: MainAxisAlignment.start,
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 mainAxisSize: MainAxisSize.min,
                                                 children:[
                                                   Flexible(
                                                     child: Text('Online Test Series',
                                                       style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                         fontFamily:
                                                         FlutterFlowTheme.of(context).headlineMediumFamily,
                                                         color: FlutterFlowTheme.of(context).primaryText,
                                                         fontSize: 26.0,
                                                         fontWeight: FontWeight.w700,
                                                         useGoogleFonts: GoogleFonts.asMap().containsKey(
                                                             FlutterFlowTheme.of(context).headlineMediumFamily),
                                                       ),
                                                     ),
                                                   ),
                                                   SizedBox(height:5),
                                                   Flexible(
                                                     child:RichText(
                                                       softWrap: true,
                                                       text: TextSpan(
                                                         text: 'NEET 2024 test series online with offline attempt & online scoring ',
                                                         style:FlutterFlowTheme.of(context).headlineMedium.override(
                                                         fontFamily:
                                                         FlutterFlowTheme.of(context).headlineMediumFamily,
                                                         color: FlutterFlowTheme.of(context).primaryText,
                                                         fontSize: 16.0,
                                                         fontWeight: FontWeight.normal,
                                                         useGoogleFonts: GoogleFonts.asMap().containsKey(
                                                             FlutterFlowTheme.of(context).headlineMediumFamily),
                                                       ),
                                                         children:  <TextSpan>[
                                                           TextSpan(
                                                               text: 'know more',
                                                               style: TextStyle(fontWeight: FontWeight.bold,decoration: TextDecoration.underline,),
                                                               recognizer: TapGestureRecognizer()..onTap = () {
                                                                 context.pop();
                                                                 context.pushNamed('CreateAndPreviewTestPage');
                                                               }
                                                           ),

                                                         ],
                                                       ),
                                                     )
                                                   ),
                                                   SizedBox(height: 15,),
                                                   Container(
                                                     padding: EdgeInsets.zero,
                                                     width:MediaQuery.of(context).size.width*0.4,
                                                     child: ElevatedButton(
                                                       style: ElevatedButton.styleFrom(
                                                           minimumSize: Size.fromHeight(20), backgroundColor: Colors.black,
                                                           shape: RoundedRectangleBorder(
                                                             borderRadius: BorderRadius.circular(10.0),
                                                             // side: BorderSide(width: 3, color: Colors.black),
                                                           ),
                                                           padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                                           textStyle:
                                                           TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                                       onPressed: () async {
                                                         context.pop();
                                                         context.pushNamed('CreateAndPreviewTestPage');
                                                       },
                                                       child: Text(
                                                         'Buy now',
                                                         style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                           fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                           fontSize: 14.0,
                                                           color: Colors.white,
                                                           fontWeight: FontWeight.bold,
                                                           useGoogleFonts: GoogleFonts.asMap().containsKey(
                                                               FlutterFlowTheme.of(context).bodyMediumFamily),
                                                         ),
                                                       ),
                                                     ),
                                                   ),
                                                   SizedBox(height:30),
                                                 ]
                                             )),
                                         Flexible(
                                             flex:1,
                                             child:Image.asset('assets/images/classroom_test_series_screen2.png')
                                         )

                                       ]
                                   ),
                                 )
                             ),
                           ),
                           Positioned(
                             top:0,
                             left:15,
                             child: SvgPicture.asset(
                               'assets/images/btw.svg',
                               fit: BoxFit.fill,
                             ),
                           ),

                         ]
                     ),
                     SizedBox(height:30),
                     Text('When a local center opens, your online test series fee will be credited towards the classroom series fee.',style:
                     FlutterFlowTheme.of(context)
                         .bodyMedium
                         .override(
                       fontFamily: FlutterFlowTheme.of(context)
                           .bodyMediumFamily,
                       fontSize: 15.0,
                       fontWeight: FontWeight.w400,
                       useGoogleFonts: GoogleFonts.asMap().containsKey(
                           FlutterFlowTheme.of(context)
                               .bodyMediumFamily),
                       color: Color(0xff4A4A4A),
                     ),),
                   ]
                 ),
                 SizedBox(height:10),
                 GestureDetector(
                   onTap: (){
                     context.pop();
                   },
                   child: Align(
                     alignment: Alignment.bottomCenter,
                     child: Text('Go to Main Page',style: FlutterFlowTheme.of(context)
                         .bodyMedium
                         .override(
                       fontFamily: FlutterFlowTheme.of(context)
                           .bodyMediumFamily,
                       fontSize: 15.0,
                       fontWeight: FontWeight.w400,
                       useGoogleFonts: GoogleFonts.asMap().containsKey(
                           FlutterFlowTheme.of(context)
                               .bodyMediumFamily),
                       color: FlutterFlowTheme.of(context).primary,
                     )),
                   ),
                 )
               ]
             )
           ),
         ),
       )
     ),
   );
  }
}




