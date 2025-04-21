import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neetprep_essential/app_state.dart';
import 'package:neetprep_essential/backend/api_requests/api_calls.dart';
import 'package:provider/provider.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:http/http.dart' as http;



class PracticeLogProvider extends ChangeNotifier {

  String getStartDate() {
    DateTime now = DateTime.now();
    return '01/${now.month.toString().padLeft(2, '0')}/${now.year}';
  }

  String getEndDate() {
    DateTime now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
  }
  String getEndDateOfMonth(String startDate) {
    List<String> dateParts = startDate.split('/');
    int day = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);


    int lastDayOfMonth = DateTime(year, month + 1, 0).day;

    DateTime endDateTime = DateTime(year, month, lastDayOfMonth);


    String endDate = '${endDateTime.day.toString().padLeft(2, '0')}/'
        '${endDateTime.month.toString().padLeft(2, '0')}/'
        '${endDateTime.year}';

    return endDate;
  }



  Future<void> refreshStreakData() async {
    final String url = '${FFAppState().baseUrl}/api/v2/refresh_streak_data';
    final String token = FFAppState().subjectToken;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {

        print('Streak data refreshed successfully.');

        final responseData = json.decode(response.body);
        print(responseData);
      } else {

        print('Failed to refresh streak data. Status code: ${response.statusCode}');
      }
    } catch (e) {

      print('Error refreshing streak data: $e');
    }
  }


  Future<Map<String, dynamic>> fetchCalendarData(startDate,endDate ) async {

    final String url = '${FFAppState().baseUrl}/getCalendar';
    print("startDate"); print(startDate);
    print("endDate");print(endDate);


    final Uri uri = Uri.parse('$url?startDate=$startDate&endDate=$endDate');


    final Map<String, String> headers = {
      'Authorization': 'Bearer ${FFAppState().subjectToken}',
    };

    try {

      final http.Response response = await http.get(uri, headers: headers);


      if (response.statusCode == 200) {
        print(json.decode(response.body));
        return json.decode(response.body);

      } else {

        throw Exception('Failed to load calendar data');
      }
    } catch (e) {

      throw Exception('Error fetching calendar data: $e');
    }
  }



}
