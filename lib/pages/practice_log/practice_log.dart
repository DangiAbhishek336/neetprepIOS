import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neetprep_essential/flutter_flow/flutter_flow_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:neetprep_essential/pages/practice_log/practice_log_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../clevertap/clevertap_service.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'indicator.dart';
import 'package:provider/provider.dart';

class PracticeLog extends StatefulWidget {
  const PracticeLog({super.key});

  @override
  State<PracticeLog> createState() => _PracticeLogState();
}

class _PracticeLogState extends State<PracticeLog> {
  Map<String, Map<String, dynamic>> _events = {};
  int noOfQsPracticedThisWeek = 0;
  int noOfQsPracticedThisMonth = 0;
  bool isLoading = false;

  Future<Map<String, dynamic>> _fetchDataForMonth(startDate, endDate) async {
    var calenderProvider =
        Provider.of<PracticeLogProvider>(context, listen: false);
    Map<String, dynamic> data =
        await calenderProvider.fetchCalendarData(startDate, endDate);
    noOfQsPracticedThisWeek = data['questions_this_week'];
    noOfQsPracticedThisMonth = data['questions_this_month'];
    setState(() {
      Map<String, Map<String, dynamic>> newEvents =
          _parseEvents(data['calendar']);
      newEvents.forEach((key, value) {
        if (!_events.containsKey(key)) {
          _events[key] = value;
        }
      });
    });

    return data;
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  Map<String, Map<String, dynamic>> _parseEvents(
      Map<String, dynamic> calendar) {
    Map<String, Map<String, dynamic>> events = {};
    calendar.forEach((dateString, eventData) {
      DateTime date = DateTime.parse(dateString);
      String formattedDate = formatDate(date); // Format the date as DD-MM-YYYY
      events[formattedDate] = eventData;
    });
    return events;
  }

  void handleRefreshStreakData(BuildContext context) async {
    var calenderProvider =
        Provider.of<PracticeLogProvider>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    try {
      await calenderProvider.refreshStreakData();
      _fetchDataForMonth(calenderProvider.getStartDate(),
          calenderProvider.getEndDateOfMonth(calenderProvider.getStartDate()));
    } catch (e) {}
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    _events = {};
    isLoading = false;
    handleRefreshStreakData(context);
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "PracticeLog");
    CleverTapService.recordPageView("PracticeLog");
    super.initState();
  }

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: FlutterFlowTheme.of(context).primaryText),
            onPressed: () {
              Navigator.of(context).pop(); // Go back to the previous screen
            },
          ),
          title: Text(
            'Q Practice Calender',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  useGoogleFonts: GoogleFonts.asMap().containsKey(
                      FlutterFlowTheme.of(context).bodyMediumFamily),
                ),
          ),
          actions: [
            InkWell(
                onTap: () {
                  showInfoSheet(context);
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Icon(
                    Icons.info_outline,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                ))
          ], // Set the title here
        ),
        body: isLoading
            ? Container(
                height: MediaQuery.of(context).size.height * 0.9,
                child: Center(
                    child: CircularProgressIndicator(
                        color: FlutterFlowTheme.of(context).primary)),
              )
            : Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            border: Border.all(
              color: FlutterFlowTheme.of(context).accent4,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
          margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Calender(),
                      SizedBox(height: 10),
                      // Add other widgets here if needed
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MonthlyTargetContainer(noOfQsPracticedThisMonth),
                    SizedBox(height: 5.0),
                    WeeklyTargetContainer(noOfQsPracticedThisWeek),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }

  Widget Calender() {
    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      headerStyle: HeaderStyle(
          titleCentered: true,
          titleTextStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
              )),
      rowHeight: 60,
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        isTodayHighlighted: false,
        defaultTextStyle: TextStyle(
          fontFamily: FlutterFlowTheme.of(context)
              .bodyMediumFamily, // Set custom font for dates
          fontSize: 16,
          color: Colors.red,
        ),
      ),
      onDaySelected: (selectedDay, focusedDay) {
        String formattedDate = formatDate(selectedDay);
        if (_events[formattedDate]?['questions'] > 0) {
          showModalBottom(context, formattedDate, _events[formattedDate]);
        } else {
          Fluttertoast.showToast(
            msg: "No Data found",
          );
        }
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
        int day = _focusedDay.day;
        int month = _focusedDay.month;
        int year = _focusedDay.year;
        String startDate =
            '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
        print("startDateInClick $startDate");
        var calenderProvider =
            Provider.of<PracticeLogProvider>(context, listen: false);
        String endDate = calenderProvider.getEndDateOfMonth(startDate);
        bool dateExists =
            _events.containsKey(startDate) && _events.containsKey(endDate);
        if (!dateExists) {
          _fetchDataForMonth(startDate, endDate);
        } else {
          print("Dates already exist in _events, no need to fetch.");
        }
      },
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month', // Only allow the month view
      },
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, date, _) {
          String formattedDate = formatDate(date);
          if (_events.containsKey(formattedDate)) {
            int questions = _events[formattedDate]?['questions'] ?? 0;

            return Container(
              height:70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: questions > 50
                          ? Color(0xffd1f9e5)
                          : questions > 24
                              ? Color(0xfffaecd3)
                              : questions > 0
                                  ? Color(0xfffde2e1)
                                  : FlutterFlowTheme.of(context)
                                      .tertiaryBackground,
                      border: Border.all(
                        color: questions > 50
                            ? Color(0xff2fc392)
                            : questions > 24
                                ? Color(0xffecbb62)
                                : questions > 0
                                    ? Color(0xfff37e7d)
                                    : Color(0xff858585),
                      ),
                      shape: BoxShape.circle, // Makes
                    ),
                    child: Center(
                      child: Text('$questions',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: Color(0xff858585),
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              )),
                    ),
                  ),
                  Text(date.day.toString(),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: Color(0xff858585),
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).bodyMediumFamily),
                          ))
                ],
              ),
            );
          }
          return Container(
            height: 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).tertiaryBackground,
                    border: Border.all(
                      color: Color(0xff858585),
                    ),
                    shape: BoxShape.circle, // Makes
                  ),
                  child: Center(
                    child: Text('0',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              color: Color(0xff858585),
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                  FlutterFlowTheme.of(context)
                                      .bodyMediumFamily),
                            )),
                  ),
                ),
                Text(date.day.toString(),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          color: Color(0xff858585),
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).bodyMediumFamily),
                        ))
              ],
            ),
          );
        },
      ),
    );
  }

  Widget WeeklyTargetContainer(int noOfQsPracticedThisWeek) {

    int qsLeft = 0;
    if(noOfQsPracticedThisWeek<300) {
      qsLeft = 300 - noOfQsPracticedThisWeek;
    }
    else{
      qsLeft = 0;
    }
    double percentage = noOfQsPracticedThisWeek / 3;
    return Container(
        padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xfffaecd3),
          border: Border.all(
            color: FlutterFlowTheme.of(context).accent4,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: qsLeft==0?
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Text("Congratulations!",style: FlutterFlowTheme.of(context).bodyMedium.override(
                   fontFamily:
                   FlutterFlowTheme.of(context).bodyMediumFamily,
                   color: Colors.black,
                   fontSize: 13.0,
                   fontWeight: FontWeight.bold,
                   useGoogleFonts: GoogleFonts.asMap().containsKey(
                       FlutterFlowTheme.of(context).bodyMediumFamily),
                 )),
                  Text("You've achieved your weekly target! 🎉",style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily:
                    FlutterFlowTheme.of(context).bodyMediumFamily,
                    color: Colors.black,
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                        FlutterFlowTheme.of(context).bodyMediumFamily),
                  )),
                  Text("Total Qs Attempted: ${noOfQsPracticedThisWeek}",style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily:
                    FlutterFlowTheme.of(context).bodyMediumFamily,
                    color: Colors.black,
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                        FlutterFlowTheme.of(context).bodyMediumFamily),
                  ))
                ]
            )
            :Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${qsLeft} Qs Left',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: Colors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).bodyMediumFamily),
                          )),
                  SizedBox(height: 5.0),
                  Text('From 300 Qs Weekly Target',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: Colors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).bodyMediumFamily),
                          )),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    value: (percentage / 100),
                    // Set a value between 0.0 to 1.0 to indicate progress
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                      '${((percentage * 10).truncateToDouble() / 10).toString()}%',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: Colors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).bodyMediumFamily),
                          ))
                ],
              )
            ]));
  }

  Widget MonthlyTargetContainer(int noOfQsPracticedThisMonth) {

    int qsLeft = 0;
    if(noOfQsPracticedThisMonth<1300){
      qsLeft =  1300 - noOfQsPracticedThisMonth;
    }
    else{
     qsLeft=0;
    }

    double percentage = noOfQsPracticedThisMonth / 13;
    return Container(
      width: double.infinity,
        padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
        decoration: BoxDecoration(
          color: Color(0xFF4A4A4A),
          border: Border.all(
            color: FlutterFlowTheme.of(context).accent4,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: qsLeft==0?
             Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Congratulations!",style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily:
                FlutterFlowTheme.of(context).bodyMediumFamily,
                color: Colors.white,
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                useGoogleFonts: GoogleFonts.asMap().containsKey(
                    FlutterFlowTheme.of(context).bodyMediumFamily),
              )),
              Text("You've achieved your monthly target! 🎉",style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily:
                FlutterFlowTheme.of(context).bodyMediumFamily,
                color: Colors.white,
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                useGoogleFonts: GoogleFonts.asMap().containsKey(
                    FlutterFlowTheme.of(context).bodyMediumFamily),
              )),
              Text("Total Qs Attempted: ${noOfQsPracticedThisMonth}",style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily:
                FlutterFlowTheme.of(context).bodyMediumFamily,
                color: Colors.white,
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                useGoogleFonts: GoogleFonts.asMap().containsKey(
                    FlutterFlowTheme.of(context).bodyMediumFamily),
              ))
            ]
        )
            : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${qsLeft} Qs Left',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).bodyMediumFamily),
                          )),
                  SizedBox(height: 5.0),
                  Text('From 1300 Qs Monthly Target',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).bodyMediumFamily),
                          )),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    value: (percentage / 100),
                    // Set a value between 0.0 to 1.0 to indicate progress
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                        FlutterFlowTheme.of(context).primary),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                      '${((percentage * 10).truncateToDouble() / 10).toString()}%',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).bodyMediumFamily),
                          ))
                ],
              )
            ]));
  }

  void showModalBottom(context, selectedDay, infoObject) async {
    int touchedIndex = -1;
    print("infoObject ${infoObject}");
    print("selectedDay ${selectedDay}");
    String incorrectQs = infoObject["incorrect"].toString();
    final String correctQs = infoObject["correct"].toString();
    String titleDate = formatDateToReadableString(selectedDay);

    List<PieChartSectionData> showingSections() {
      return List.generate(2, (i) {
        final isTouched = i == touchedIndex;
        final fontSize = isTouched ? 25.0 : 16.0;
        final radius = isTouched ? 20.0 : 20.0;
        const shadows = [Shadow(color: Colors.black, blurRadius: 0)];
        switch (i) {
          case 0:
            return PieChartSectionData(
              showTitle: false,
              color: Color(0xff5FD1B1),
              value: infoObject["correct"].toDouble(),
              title: infoObject["correct"].toString(),
              radius: radius,
              titleStyle: FlutterFlowTheme.of(context).bodyMedium,
            );
          case 1:
            return PieChartSectionData(
              showTitle: false,
              color: Color(0xfffde2e1),
              value: infoObject["incorrect"].toDouble(),
              title: infoObject["incorrect"].toString(),
              radius: radius,
              titleStyle: FlutterFlowTheme.of(context).bodyMedium,
            );
          default:
            throw Error();
        }
      });
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.0)),
      ),
      builder: (BuildContext builder) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(titleDate,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              fontSize: 18.0,
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontWeight: FontWeight.w700,
                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                  FlutterFlowTheme.of(context)
                                      .bodyMediumFamily),
                            )),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset('assets/images/close_circle.svg',
                          fit: BoxFit.none,
                          color: FlutterFlowTheme.of(context).primaryText),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Text("Detailed analytics of Qs attempted on this date.",
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          fontSize: 13.0,
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontWeight: FontWeight.w500,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).bodyMediumFamily),
                        )),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/images/questions.svg",
                          height: 25,
                          width: 25,
                          color: FlutterFlowTheme.of(context).primaryText),
                      Text("Overall Performance",
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                fontSize: 16.0,
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontWeight: FontWeight.w600,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              )),
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: PieChart(
                            PieChartData(
                              pieTouchData: PieTouchData(
                                touchCallback:
                                    (FlTouchEvent event, pieTouchResponse) {
                                  setState(() {
                                    if (!event.isInterestedForInteractions ||
                                        pieTouchResponse == null ||
                                        pieTouchResponse.touchedSection ==
                                            null) {
                                      touchedIndex = -1;
                                      return;
                                    }
                                    touchedIndex = pieTouchResponse
                                        .touchedSection!.touchedSectionIndex;
                                  });
                                },
                              ),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              sectionsSpace: 0,
                              centerSpaceRadius: 60,
                              sections: showingSections(),
                            ),
                          ),
                        ),
                        Positioned(
                            child: Center(
                          child: RichText(
                            text: TextSpan(
                              text: ' ${infoObject["questions"]}',
                              // Default style applied to this part
                              style: FlutterFlowTheme.of(context).bodyBold,
                              children: <TextSpan>[
                                TextSpan(
                                  text: '\n Qs attempted ',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        fontSize: 12.0,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontWeight: FontWeight.w500,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                )
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Color(0xFFE0E3E7),
                          width: 1.0,
                        )),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Indicator(
                          color: Color(0xff5FD1B1),
                          text: 'Correct Qs',
                          textValue: correctQs,
                          isSquare: false,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Indicator(
                          color: Color(0xfffde2e1),
                          text: 'Incorrect Qs',
                          textValue: incorrectQs,
                          isSquare: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 28,
              ),
            ],
          ),
        );
      },
    );
  }

  void showInfoSheet(context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.0)),
      ),
      builder: (BuildContext builder) {
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
                      child: SvgPicture.asset(
                        "assets/images/info.svg",
                        height: 60,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 5),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Master Your Q Practice Calender',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    fontWeight: FontWeight.w700,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
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
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text('Quick Tips for Using Your Data',
                          style: FlutterFlowTheme.of(context)
                              .bodyRegular
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: Color(0xff858585),
                                fontSize: 12.0,
                                fontWeight: FontWeight.normal,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              )),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: ListTile(
                          leading: Text('📊'),
                          minLeadingWidth: 0.0,
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Overall Performance",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontSize: 14,
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontWeight: FontWeight.w700,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      )),
                              Text(
                                "See how many questions you got right versus wrong.",
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontSize: 12,
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color: Color(0xff858585),
                                      fontWeight: FontWeight.w400,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily),
                                    ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: ListTile(
                          leading: Text('📅'),
                          minLeadingWidth: 0.0,
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Calendar View",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontSize: 14,
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontWeight: FontWeight.w700,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      )),
                              Text(
                                "Track your daily question count with color-coded indicators.\nAim for 🟢 green days to stay on target.",
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontSize: 12,
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color: Color(0xff858585),
                                      fontWeight: FontWeight.w400,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily),
                                    ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: ListTile(
                          leading: Text('📈'),
                          minLeadingWidth: 0.0,
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Target Progress",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontSize: 14,
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontWeight: FontWeight.w700,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      )),
                              RichText(
                                text: TextSpan(
                                  text: "Weekly & Monthly Goals: ",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontSize: 12,
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: Color(0xff858585),
                                        fontWeight: FontWeight.w700,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          "Check how close you are to hitting your practice targets.\n",
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontSize: 12,
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: Color(0xff858585),
                                            fontWeight: FontWeight.w400,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily),
                                          ),
                                    ),
                                    TextSpan(
                                      text: "Tip: ",
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontSize: 12,
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: Color(0xff858585),
                                            fontWeight: FontWeight.w700,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily),
                                          ),
                                    ),
                                    TextSpan(
                                      text:
                                          "Adjust your daily practice to stay on track.",
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontSize: 12,
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: Color(0xff858585),
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: ListTile(
                          leading: Text('🔎'),
                          minLeadingWidth: 0.0,
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Detailed Breakdown",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontSize: 14,
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontWeight: FontWeight.w700,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      )),
                              RichText(
                                text: TextSpan(
                                  text: "Day-by-Day Insights: ",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontSize: 12,
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: Color(0xff858585),
                                        fontWeight: FontWeight.w700,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          "Click any date for a quick review of your performance.",
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontSize: 12,
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: Color(0xff858585),
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: ListTile(
                          leading: Text('🎨'),
                          minLeadingWidth: 0.0,
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Color Codes",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontSize: 14,
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontWeight: FontWeight.w700,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      )),
                              RichText(
                                text: TextSpan(
                                  text: "🔴 Red: ",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontSize: 12,
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: Color(0xff858585),
                                        fontWeight: FontWeight.w700,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "Below goal.\n",
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontSize: 12,
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: Color(0xff858585),
                                            fontWeight: FontWeight.w400,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily),
                                          ),
                                    ),
                                    TextSpan(
                                      text: "🟡 Yellow: ",
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontSize: 12,
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: Color(0xff858585),
                                            fontWeight: FontWeight.w700,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily),
                                          ),
                                    ),
                                    TextSpan(
                                      text: "Near goal.\n",
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontSize: 12,
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: Color(0xff858585),
                                            fontWeight: FontWeight.w400,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily),
                                          ),
                                    ),
                                    TextSpan(
                                      text: "🟢 Green: ",
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontSize: 12,
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: Color(0xff858585),
                                            fontWeight: FontWeight.w700,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily),
                                          ),
                                    ),
                                    TextSpan(
                                      text: "Goal achieved.",
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontSize: 12,
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: Color(0xff858585),
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
                            ],
                          ),
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
                  Navigator.pop(context);
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
                child: Text('Okay',
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

  String formatDateToReadableString(String date) {
    // Parse the input date string
    DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(date);

    // Format the parsed date to "1 November 2023"
    String formattedDate = DateFormat("d MMMM yyyy").format(parsedDate);

    return formattedDate;
  }
}
