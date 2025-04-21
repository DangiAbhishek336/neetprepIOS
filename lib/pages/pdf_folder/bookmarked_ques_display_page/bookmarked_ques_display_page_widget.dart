import '/backend/api_requests/api_calls.dart';
import '/components/html_question/html_question_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'bookmarked_ques_display_page_model.dart';
export 'bookmarked_ques_display_page_model.dart';

class BookmarkedQuesDisplayPageWidget extends StatefulWidget {
  const BookmarkedQuesDisplayPageWidget({Key? key}) : super(key: key);

  @override
  _BookmarkedQuesDisplayPageWidgetState createState() =>
      _BookmarkedQuesDisplayPageWidgetState();
}

class _BookmarkedQuesDisplayPageWidgetState
    extends State<BookmarkedQuesDisplayPageWidget> {
  late BookmarkedQuesDisplayPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BookmarkedQuesDisplayPageModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return FutureBuilder<ApiCallResponse>(
      future: PracticeGroup.getAllQuestionStatusGivenTestIDCall.call(
        testIdInt: 2123625,
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          );
        }
        final bookmarkedQuesDisplayPageGetAllQuestionStatusGivenTestIDResponse =
            snapshot.data!;
        return Title(
            title: 'BookmarkedQuesDisplayPage',
            color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
            child: GestureDetector(
              onTap: () =>
                  FocusScope.of(context).requestFocus(_model.unfocusNode),
              child: Scaffold(
                key: scaffoldKey,
                body: NestedScrollView(
                  floatHeaderSlivers: true,
                  headerSliverBuilder: (context, _) => [
                    SliverAppBar(
                      pinned: false,
                      floating: true,
                      snap: true,
                      backgroundColor: Colors.white,
                      automaticallyImplyLeading: false,
                      leading: FlutterFlowIconButton(
                        borderColor: Colors.transparent,
                        borderRadius: 30.0,
                        borderWidth: 1.0,
                        buttonSize: 60.0,
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 30.0,
                        ),
                        onPressed: () async {
                          context.pop();
                        },
                      ),
                      title: Text(
                        'Bookmarks',
                        style: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .override(
                              fontFamily: FlutterFlowTheme.of(context)
                                  .headlineMediumFamily,
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 18.0,
                              fontWeight: FontWeight.normal,
                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                  FlutterFlowTheme.of(context)
                                      .headlineMediumFamily),
                            ),
                      ),
                      actions: [],
                      centerTitle: true,
                      elevation: 0.0,
                    )
                  ],
                  body: Builder(
                    builder: (context) {
                      return SafeArea(
                        top: false,
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              1.0, 14.0, 1.0, 0.0),
                          child: Builder(
                            builder: (context) {
                              final allBookmarkedQues = PracticeGroup
                                      .getAllQuestionStatusGivenTestIDCall
                                      .bookQues(
                                        bookmarkedQuesDisplayPageGetAllQuestionStatusGivenTestIDResponse
                                            .jsonBody,
                                      )
                                      ?.toList() ??
                                  [];
                              return SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children:
                                      List.generate(allBookmarkedQues.length,
                                          (allBookmarkedQuesIndex) {
                                    final allBookmarkedQuesItem =
                                        allBookmarkedQues[
                                            allBookmarkedQuesIndex];
                                    return Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 14.0),
                                      child: Material(
                                        color: Colors.transparent,
                                        elevation: 3.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 4.0,
                                                color: Color(0x33000000),
                                                offset: Offset(0.0, 2.0),
                                              )
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10.0, 10.0, 10.0, 10.0),
                                            child: HtmlQuestionWidget(
                                              key: Key(
                                                  'Keywog_${allBookmarkedQuesIndex}_of_${allBookmarkedQues.length}'),
                                              questionHtmlStr: getJsonField(
                                                allBookmarkedQuesItem,
                                                r'''$''',
                                              ).toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ));
      },
    );
  }
}
