import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';


class ThankYouPageWithCenterAvailable extends StatelessWidget {
  const ThankYouPageWithCenterAvailable({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body:Center(
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height*0.95,
                padding:EdgeInsets.fromLTRB(16,40,16,30),
                child: Center(
                    child:Column(
                      mainAxisSize: MainAxisSize.min,
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Spacer(),
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
                          Center(
                            child: Text('Your request has been successfully  submitted.\nWe’ll reach out to you within the next 24 hours.',style:FlutterFlowTheme.of(context)
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
                            ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: (){
                              context.pop();
                            },
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Text('Go to  Main Page',style: FlutterFlowTheme.of(context)
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
                          ),

                        ]
                    )
                ),
              ),
            ),
          )
      ),
    );
  }
}





