import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neetprep_essential/pages/starmarkedQs/starmarkedSearchPage/starmarkedSearchPageModel.dart';
import 'package:neetprep_essential/providers/commonProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../clevertap/clevertap_service.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';




class StarmarkedSearchPageWidget extends StatefulWidget {
  const StarmarkedSearchPageWidget({Key? key}) : super(key: key);

  @override
  _StarmarkedSearchPageWidgetState createState() =>
      _StarmarkedSearchPageWidgetState();
}

class _StarmarkedSearchPageWidgetState extends State<StarmarkedSearchPageWidget> {
  late StarmarkedSearchPageModel _model;
  List<List<dynamic>> searchHistory = [];
  bool isLoading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "StarmarkedSearchPage");
    CleverTapService.recordPageView("Starmarked Search Page Opened");
    loadSearchHistory();
    _model = createModel(context, () => StarmarkedSearchPageModel());
    _model.textController ??= TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  void loadSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic>? searchHistoryStrings = prefs.getStringList('starmarksSearchHistory');
    if (searchHistoryStrings != null) {
      setState(() {
        searchHistory = searchHistoryStrings
            .map((item) => item.split(','))
            .toList()
            .map((list) => [list[0], list[1]])
            .toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void saveSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> searchHistoryStrings = searchHistory
        .map((item) => item.map((value) => value.toString()).toList().join(','))
        .toList();
    await prefs.setStringList('starmarksSearchHistory', searchHistoryStrings);
  }

  void addToSearchHistory(String id, String name) {
    setState(() {
      List<dynamic> historyItem = [id, name];
      if (!searchHistory.contains(historyItem)) {
        if (searchHistory.length >= 15) {
          searchHistory.removeAt(0);
        }
        searchHistory.add(historyItem);
        saveSearchHistory();
      }
    });
  }

  // List<List<dynamic>> searchHisReverse = [];
  // searchHisReverse = searchHistory.reversed.toList();
  // searchHistory.reversed.toList();
  @override
  void dispose() {
    _model.dispose();
    saveSearchHistory();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    _model.searchResRev = searchHistory.reversed.toList();
    if (isLoading) {
      return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
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
    } else {
      return Title(
          title: 'StarmarkSearchPage',
          color: FlutterFlowTheme.of(context).primaryBackground,
          child: GestureDetector(
            onTap: () =>
                FocusScope.of(context).requestFocus(_model.unfocusNode),
            child: Consumer<CommonProvider>(
              builder: (context,commonProvider,child) {
                return Scaffold(
                  floatingActionButton: !FFAppState().isScreenshotCaptureDisabled && !commonProvider.isFeedbackSubmitted ?
                  FloatingActionButton(
                    backgroundColor: Colors.black,
                    onPressed: () {
                      commonProvider.showFeedBackFormBottomSheet(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/messages-3.svg',
                          width: 24.0,
                          height: 24.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ):null,
                  key: scaffoldKey,
                  backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                  appBar: AppBar(
                    backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                    automaticallyImplyLeading: false,
                    leading: FlutterFlowIconButton(
                      borderColor: Colors.transparent,
                      borderRadius: 30.0,
                      borderWidth: 0.5,
                      buttonSize: 60.0,
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: Color(0xFF252525),
                        size: 30.0,
                      ),
                      onPressed: () async {
                        context.pop();
                      },
                    ),
                    title: Text(
                      'Search',
                      style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily:
                        FlutterFlowTheme.of(context).headlineMediumFamily,
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).headlineMediumFamily),
                      ),
                    ),
                    actions: [],
                    centerTitle: true,
                    elevation: 0.0,
                  ),
                  body: SafeArea(
                    top: true,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding:
                          EdgeInsetsDirectional.fromSTEB(12.0, 16.0, 12.0, 8.0),
                          child: Container(
                            width: double.infinity,
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).secondaryBackground,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color:  FlutterFlowTheme.of(context).secondaryBorderColor,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 0.0, 8.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        4.0, 0.0, 4.0, 0.0),
                                    child: Icon(
                                      Icons.search_rounded,
                                      color: Color(0xFF6E6E6E),
                                      size: 24.0,
                                    ),
                                  ),
                                  Flexible(
                                    child: Align(
                                      alignment: AlignmentDirectional(0.0, 1.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            4.0, 0.0, 0.0, 0.0),
                                        child: TextFormField(
                                          controller: _model.textController,
                                          onChanged: (_) => EasyDebounce.debounce(
                                            '_model.textController',
                                            Duration(milliseconds: 200),
                                                () async {
                                              setState(() {
                                                _model.showSearchRes = true;
                                                _model.simpleSearchResults =
                                                    FFAppState()
                                                        .allSearchItemsForStarmarkedQs
                                                        .where((item) {
                                                      String name = item['topicName']
                                                          .toString()
                                                          .toLowerCase();
                                                      if (name.contains(_model
                                                          .textController.text
                                                          .toLowerCase())) {
                                                        return true;
                                                      }

                                                      return false;
                                                    }).toList();
                                              });
                                              setState(() {
                                                _model.showSearchRes = true;
                                              });
                                            },
                                          ),
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            fillColor: FlutterFlowTheme.of(context).primaryBackground,
                                            hintText: 'Search Chapters...',
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                topRight: Radius.circular(4.0),
                                              ),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                topRight: Radius.circular(4.0),
                                              ),
                                            ),
                                            errorBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                topRight: Radius.circular(4.0),
                                              ),
                                            ),
                                            focusedErrorBorder:
                                            UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                topRight: Radius.circular(4.0),
                                              ),
                                            ),
                                            suffixIcon: _model
                                                .textController!.text.isNotEmpty
                                                ? InkWell(
                                              onTap: () async {
                                                _model.textController
                                                    ?.clear();
                                                setState(() {
                                                  _model.showSearchRes =
                                                  false;
                                                  _model.simpleSearchResults =
                                                      FFAppState()
                                                          .allSearchItemsForStarmarkedQs
                                                          .where((item) {
                                                        String name = item['topicName']
                                                            .toString()
                                                            .toLowerCase();

                                                          if (name.contains(_model
                                                              .textController.text
                                                              .toLowerCase())) {
                                                            return true;
                                                          }


                                                        return false;
                                                      }).toList();
                                                });
                                              },
                                              child: Icon(
                                                Icons.clear,
                                                color: FlutterFlowTheme.of(
                                                    context)
                                                    .primaryText,
                                                size: 20.0,
                                              ),
                                            )
                                                : null,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                            fontFamily: 'Poppins',
                                            color: Color(0xFFB9B9B9),
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.normal,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                          ),
                                          validator: _model.textControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (_model.showSearchRes)
                          Flexible(
                            child: Builder(
                              builder: (context) {
                                final serachResults =
                                _model.simpleSearchResults.toList();
                                return ListView.separated(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: serachResults.length,
                                  separatorBuilder: (_, __) =>
                                      SizedBox(height: 10.0),
                                  itemBuilder: (context, serachResultsIndex) {
                                    String serachResultsItemName =
                                    serachResults[serachResultsIndex]['topicName'];
                                    String serachResultsItemId =
                                    serachResults[serachResultsIndex]['chapterId'].toString();
                                    String serachResultsItemNumQuestions =
                                    serachResults[serachResultsIndex]
                                    ['count']
                                        .toString();
                                    final serachResultsItem =
                                    serachResults[serachResultsIndex];
                                    return Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          16, 0, 16, 0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Row(
                                          //   mainAxisSize: MainAxisSize.max,
                                          //   children: [
                                          //     FaIcon(
                                          //       FontAwesomeIcons.search,
                                          //       color: FlutterFlowTheme.of(context)
                                          //           .secondaryText,
                                          //       size: 24.0,
                                          //     ),
                                          //     // Text(
                                          //     //   serachResultsItemId.toString(),
                                          //     //   style: FlutterFlowTheme.of(context)
                                          //     //       .bodyMedium,
                                          //     // ),
                                          //     Text(
                                          //       serachResultsItemName,
                                          //       style: FlutterFlowTheme.of(context)
                                          //           .bodyMedium,
                                          //     ),
                                          //   ],
                                          // ),
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 10.0),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor: Colors.transparent,
                                              onTap: () async {
                                                // _model.showSearchRes = false;
                                                addToSearchHistory(
                                                    serachResultsItemId,
                                                    serachResultsItemName);
                                                _model.numTabs =
                                                await actions.getTabs(
                                                  101,
                                                );
                                                context.pushNamed(
                                                  'StarmarkQuestionsPage',
                                                  queryParameters: {
                                                    'chapterId': serializeParam(
                                                      serachResultsItemId,
                                                      ParamType.String,
                                                    ),
                                                    'topicName': serializeParam(
                                                      serachResultsItemName,
                                                      ParamType.String,
                                                    )
                                                  }.withoutNulls,
                                                );

                                                setState(() {});
                                              },
                                              child: Material(
                                                color: Colors.transparent,
                                                elevation: 2.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(16.0),
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        blurRadius: 60.0,
                                                        color: Color(0x04060F0D),
                                                        offset: Offset(0.0, 4.0),
                                                        spreadRadius: 0.0,
                                                      )
                                                    ],
                                                    borderRadius:
                                                    BorderRadius.circular(16.0),
                                                  ),
                                                  alignment: AlignmentDirectional(
                                                      0.0, 0.0),
                                                  child: Padding(
                                                    padding: EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 0.0, 10.0, 0.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                      MainAxisSize.min,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisSize:
                                                          MainAxisSize.min,
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    16.0,
                                                                    0.0,
                                                                    15.0,
                                                                    0.0),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          0.0,
                                                                          20.0,
                                                                          0.0,
                                                                          0.0),
                                                                      child:
                                                                      AutoSizeText(
                                                                        serachResultsItemName,
                                                                        maxLines: 2,
                                                                        style: FlutterFlowTheme.of(
                                                                            context)
                                                                            .bodyMedium
                                                                            .override(
                                                                          fontFamily:
                                                                          FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          fontSize:
                                                                          14.0,
                                                                          fontWeight:
                                                                          FontWeight.w600,
                                                                          useGoogleFonts:
                                                                          GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          20.0),
                                                                      child: Text(
                                                                        'No of Questions: ' +
                                                                            serachResultsItemNumQuestions
                                                                                .toString(),
                                                                        style: FlutterFlowTheme.of(
                                                                            context)
                                                                            .bodyMedium
                                                                            .override(
                                                                          fontFamily:
                                                                          FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          color:
                                                                          Color(0xFF858585),
                                                                          fontSize:
                                                                          12.0,
                                                                          fontWeight:
                                                                          FontWeight.normal,
                                                                          useGoogleFonts:
                                                                          GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              child: Align(
                                                                alignment:
                                                                AlignmentDirectional(
                                                                    0.0, 0.0),
                                                                child: Padding(
                                                                  padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      16.0,
                                                                      0.0,
                                                                      20.0,
                                                                      0.0),
                                                                  child:
                                                                  Image.asset(
                                                                    'assets/images/arrow-right.png',
                                                                    width: 24.0,
                                                                    height: 24.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          // if (!_model.showSearchRes)
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        if (!_model.showSearchRes)
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 33, 16, 20),
                                child: Text(
                                  'Recent Searches',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    fontSize: 16.0,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(
                                        FlutterFlowTheme.of(context)
                                            .bodyMediumFamily),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (!_model.showSearchRes)
                          Container(
                            child: Expanded(
                              child: ListView.builder(
                                itemCount: _model.searchResRev.length,
                                itemBuilder: (context, index) {
                                  String id = _model.searchResRev[index][0];
                                  String name = _model.searchResRev[index][1];
                                  return Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        16, 0, 16, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Row(
                                        //   mainAxisSize: MainAxisSize.max,
                                        //   children: [
                                        //     FaIcon(
                                        //       FontAwesomeIcons.search,
                                        //       color: FlutterFlowTheme.of(context)
                                        //           .secondaryText,
                                        //       size: 24.0,
                                        //     ),
                                        //     // Text(
                                        //     //   serachResultsItemId.toString(),
                                        //     //   style: FlutterFlowTheme.of(context)
                                        //     //       .bodyMedium,
                                        //     // ),
                                        //     Text(
                                        //       serachResultsItemName,
                                        //       style: FlutterFlowTheme.of(context)
                                        //           .bodyMedium,
                                        //     ),
                                        //   ],
                                        // ),
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 10.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              // _model.showSearchRes = false;
                                              addToSearchHistory(id, name);
                                              _model.numTabs =
                                              await actions.getTabs(
                                                101,
                                              );
                                              // FFAppState().numberOfTabs =
                                              //     FFAppState()
                                              //         .numberOfTabs
                                              //         .toList()
                                              //         .cast<int>();
                                              // FFAppState().topicNameForEachPage =
                                              //     name;

                                              context.pushNamed(
                                                'StarmarkQuestionsPage',
                                                queryParameters: {
                                                  'chapterId': serializeParam(
                                                    id,
                                                    ParamType.String,
                                                  ),
                                                  'topicName': serializeParam(
                                                    name,
                                                    ParamType.String,
                                                  )
                                                }.withoutNulls,
                                              );

                                              setState(() {});
                                            },
                                            child: Material(
                                              color: Colors.transparent,
                                              elevation: 2.0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(16.0),
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      blurRadius: 60.0,
                                                      color: Color(0x04060F0D),
                                                      offset: Offset(0.0, 4.0),
                                                      spreadRadius: 0.0,
                                                    )
                                                  ],
                                                  borderRadius:
                                                  BorderRadius.circular(16.0),
                                                ),
                                                alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      0.0, 0.0, 10.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                        MainAxisSize.min,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  16.0,
                                                                  0.0,
                                                                  15.0,
                                                                  0.0),
                                                              child: Column(
                                                                mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        0.0,
                                                                        20.0,
                                                                        0.0,
                                                                        20.0),
                                                                    child:
                                                                    AutoSizeText(
                                                                      name,
                                                                      maxLines: 2,
                                                                      style: FlutterFlowTheme.of(
                                                                          context)
                                                                          .bodyMedium
                                                                          .override(
                                                                        fontFamily:
                                                                        FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        fontSize:
                                                                        14.0,
                                                                        fontWeight:
                                                                        FontWeight.w600,
                                                                        useGoogleFonts:
                                                                        GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            child: Padding(
                                                              padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  16.0,
                                                                  0.0,
                                                                  20.0,
                                                                  0.0),
                                                              child: Image.asset(
                                                                'assets/images/arrow-right.png',
                                                                width: 24.0,
                                                                height: 24.0,
                                                                fit: BoxFit.cover,
                                                                color: FlutterFlowTheme.of(context).primaryText,

                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // if (!_model.showSearchRes)
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }
            ),
          ));
    }
  }
}
