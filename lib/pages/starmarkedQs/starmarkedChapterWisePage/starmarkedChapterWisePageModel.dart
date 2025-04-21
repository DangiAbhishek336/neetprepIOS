import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:neetprep_essential/app_state.dart';

import '../../../backend/api_requests/api_manager.dart';

class StarmarkedChapterWisePageModel extends ChangeNotifier {

  String? newToken;
  Map<String, List> subjectTopicMap = {};
  bool isLoading = false;
  List<int> chapterIdList = [];
  List<int> countQuestionList = [];
  ApiCallResponse? userAccessJson;
  bool hasAccess = false;

  Future<void> fetchNewToken(String bearerToken) async {
    final url = Uri.parse('https://www.neetprep.com/get_new_token');

    try {
      isLoading  =  true;
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        print('Token successfully retrieved: ${response.body}');
        String responseBody = response.body;
        Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
        newToken = jsonResponse['new_id_token'];
        FFAppState().newToken = newToken??"";
        isLoading = false;
        notifyListeners();

      } else {
        print('Failed to retrieve token. Status code: ${response.statusCode}');
        newToken = null;
      }
      // isLoading = false;
      // notifyListeners();
    } catch (error) {
      print('Error: $error');
      return null;
    }
  }

  Future<dynamic> fetchChaptersData(authToken) async {
    subjectTopicMap={};
    chapterIdList = [];
    countQuestionList = [];
    final String url = '${FFAppState().baseUrl2}/StarmarkedQuestionChapter';
    final Map<String, String> headers = {
      'Authorization': 'Bearer $authToken',
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> chapters = List<Map<String, dynamic>>.from(json.decode(response.body));
         FFAppState().allSearchItemsForStarmarkedQs = chapters.toList()
             .cast<dynamic>();
        subjectTopicMap={};
        for (var chapter in chapters) {
          String subjectName = chapter['subjectName'];
          String topicName = chapter['topicName'];
          int count = chapter['count'];
          int chapterId = chapter['chapterId'];
          subjectTopicMap.putIfAbsent(subjectName, () => []);
          subjectTopicMap[subjectName]?.add([topicName,chapterId,count]);
          chapterIdList.add(chapter['chapterId']);
          countQuestionList.add(chapter['count']);

        }
        // subjectTopicMap.forEach((subject, topics) {
        //   print('$subject: $topics');
        // });

        return response.body;
      } else {
        print('Error: ${response.statusCode}, ${response.reasonPhrase}');
        return null; // or handle the error as needed
      }
    } catch (error) {
      print('Error: $error');
      return error;
    }
  }







}

