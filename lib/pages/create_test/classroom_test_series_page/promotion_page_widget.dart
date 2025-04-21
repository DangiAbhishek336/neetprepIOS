import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../flutter_flow/flutter_flow_theme.dart';

class PromotionPage extends StatelessWidget {
  const PromotionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child:Column(
            children:[
              Padding(
                padding: const EdgeInsets.fromLTRB(16,20,16,20),
                child: Align(
                  alignment: Alignment.topRight,
                  child:InkWell(
                      onTap:(){
                        context.pop();
                        },
                      child: Icon(Icons.close)
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16,8,16,10),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                        'Achieve NEET Excellence',
                        style: FlutterFlowTheme.of(
                            context)
                            .bodyMedium
                            .override(
                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                          fontWeight: FontWeight.w700,
                          color:Colors.black,
                          fontSize: 24.0,
                          useGoogleFonts:
                          GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                        ),
                      ),
                      TextSpan(
                        text: ' with Our Targeted Practice Tests',
                        style:  FlutterFlowTheme.of(
                            context)
                            .bodyMedium
                            .override(
                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                          fontWeight: FontWeight.w500,
                          color:Color(0xff252525),
                          fontSize: 24.0,
                          useGoogleFonts:
                          GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                        ),
                      ),
                    ],
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                ),
              ),
              SizedBox(height:10),
              infoWidget(
                  context,'📕' ,
                  'Exact NEET pattern & NCERT based',
                  'Pen and paper test at a center exactly like the real NEET exam, all questions from NCERT textbook',
              ),
              infoWidget(
                context,'🏢' ,
                '23 Tests at Centers',
                'Experience authentic exam conditions at our nearby test centers.',
              ),
              infoWidget(
                context,'📲 ' ,
                'In-App Multimedia Guides',
                'Detailed audio/video explanations  available on app',
              ),
              infoWidget(
                context,'🎁' ,
                'CASH PRIZE in each test',
                'Top 50 students of every test will be awarded a cash price of Rs 200/-  per student',
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16,10,16,5),
                child: ListTile(
                  leading: Text('⭐️'),
                  minLeadingWidth: 5.0,
                  title: Text('Join Community of Students',style:  FlutterFlowTheme.of(
                      context)
                      .bodyMedium
                      .override(
                    fontSize: 17,
                    fontFamily:
                    FlutterFlowTheme.of(context).bodyMediumFamily,
                    color:
                    Colors.black,
                    fontWeight:
                    FontWeight.w600,
                    useGoogleFonts:
                    GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                  ),),

                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20,10,20,15),
                child: Card(
                  elevation: 0,
                  child:Container(
                    padding: const EdgeInsets.only(bottom:10),
                    child: Column(
                      children:[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16,24,16,20),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                  '1,100+ ',
                                  style: FlutterFlowTheme.of(
                                      context)
                                      .bodyMedium
                                      .override(
                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                    fontWeight: FontWeight.w600,
                                    color:Colors.black,
                                    fontSize: 14.0,
                                    useGoogleFonts:
                                    GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                  ),
                                ),
                                TextSpan(
                                  text: "Students Who've Excelled in NEET with Our Series",
                                  style:  FlutterFlowTheme.of(
                                      context)
                                      .bodyMedium
                                      .override(
                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                    fontWeight: FontWeight.normal,
                                    color:Color(0xff252525),
                                    fontSize: 14.0,
                                    useGoogleFonts:
                                    GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                  ),
                                ),
                              ],
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            ),
                          ),

                        ),
                        Image.asset('assets/images/people_frame.png')
                      ]
                    ),
                  )
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(16, 10,16,20),
                width:MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: (){
                      context.pushNamed('CreateAndPreviewTestPage');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white, elevation:0,
                      side: BorderSide(color: Colors.white),
                      backgroundColor: FlutterFlowTheme.of(context).primary,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), // Border radius
                      ),
                    ),
                    child: Text('Buy now',style:FlutterFlowTheme.of(
                        context)
                        .bodyMedium
                        .override(
                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                      fontWeight: FontWeight.w600,
                      color:Colors.white,
                      fontSize: 16.0,
                      useGoogleFonts:
                      GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                    ))),
              )

            ]
          )
        ),
      ),
    );
  }

  Widget infoWidget(context,String leading, String title,String subTitle){
    return Padding(
      padding: const EdgeInsets.fromLTRB(16,10,16,5),
      child: ListTile(
        leading: Text(leading),
        minLeadingWidth: 5.0,
        title: Text(title,style: FlutterFlowTheme.of(
            context)
            .bodyMedium
            .override(
          fontSize: 17,
          fontFamily:
          FlutterFlowTheme.of(context).bodyMediumFamily,
          color:
          Colors.black,
          fontWeight:
          FontWeight.w600,
          useGoogleFonts:
          GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
        ),),
        subtitle: Text(subTitle,
            style:FlutterFlowTheme.of(
                context)
                .bodyMedium
                .override(
              fontSize: 15,
              fontFamily:
              FlutterFlowTheme.of(context).bodyMediumFamily,
              color:
              Color(0xff858585),
              fontWeight:
              FontWeight.w400,
              useGoogleFonts:
              GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
            )),
      ),
    );

  }
}
