import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:neetprep_essential/app_state.dart';
import 'package:provider/provider.dart';

import '../../../backend/api_requests/api_manager.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';

class BookmarkedChapterWisePageModel extends ChangeNotifier {


  Map<String, List>? subjectTopicMap = {};
  bool isLoading = false;
  ApiCallResponse? userAccessJson;
  bool hasAccess = false;
  String selectedCategory = "All";
  String showCategory = "All";
  String? selectedCourseId = null;


  Future<dynamic> fetchChaptersData() async {
    subjectTopicMap={};
    isLoading = true;
    notifyListeners();
    print(selectedCategory);
    if(selectedCategory=="All")
      selectedCourseId = null;
    if(selectedCategory=="NCERT Abhyas")
      selectedCourseId = "3125";
    if(selectedCategory=="A/R Power Up")
      selectedCourseId = "3622";
    if(selectedCategory=="Abhyas Essential")
      selectedCourseId = "4247";
    if(selectedCategory=="Pagewise Flashcard")
      selectedCourseId = "3488";
    if(selectedCategory=="Custom Abhyas")
      selectedCourseId = "4775";


    final Map<String, String> headers = {
      'Authorization': 'Bearer ${FFAppState().subjectToken}',
    };
    try {
      Uri uri = Uri.parse("${FFAppState().baseUrl}/api/v1/get_bookmarks_essential").replace(queryParameters: {
        "courseId": selectedCourseId ?? "null", // Default to "null" if not provided
      });

      final response = await http.get(
        uri,
        headers: headers,
      );

      if (response.statusCode == 200) {
        List<Map<String, dynamic>> chapters = List<Map<String, dynamic>>.from(json.decode(response.body));
         FFAppState().allSearchItemsForBookmarkedQs = chapters.toList()
             .cast<dynamic>();
        subjectTopicMap={};
        for (var chapter in chapters) {
          String subjectName = chapter['subjectName'];
          String topicName = chapter['topicName'];
          int count = chapter['count'];
          int chapterId = chapter['chapterId'];
          subjectTopicMap?.putIfAbsent(subjectName, () => []);
          subjectTopicMap?[subjectName]?.add([topicName,chapterId,count]);

        }
        isLoading=false;
        notifyListeners();
        return response.body;
      } else {
        print('Error: ${response.statusCode}, ${response.reasonPhrase}');
        subjectTopicMap = null;
        isLoading=false;
        notifyListeners();
        return null; // or handle the error as needed
      }
    } catch (error) {
      print('Error: $error');
      subjectTopicMap = null;
      isLoading=false;
      notifyListeners();
      return error;
    }
  }


}

