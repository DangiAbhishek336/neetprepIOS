import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:neetprep_essential/app_state.dart';
class StarmarkedQuestionPageModel extends ChangeNotifier {

  String? newToken;
  Map<String, List<String>> subjectTopicMap = {};
  List<Map<String, dynamic>> dataList = [];
  List<String> questions = [];
  List<String> explanations = [];
  List<int> correctOptionIndices = [];
  List<int?> userAttemptedIndices = [];
  List<bool> isNcert = [];
  List<Map<String,dynamic>?> questionDetailList = [];
  List<String?> examList = [];
  List<int?> yearList = [];
  int currentPageIndex = 0;
  final PageController pageController = PageController();
  int? selectedPageNumber;
  List<int> selectedIndexArray = [];
  bool showExplanation = true;
  bool isLoading = true;

  Future<dynamic> getUserStarmarkedQuestions(int offset, int chapterId, String authToken) async {
  // Reset lists
  questions = [];
  explanations = [];
  correctOptionIndices = [];
  userAttemptedIndices = [];
  dataList = [];
  isNcert = [];
  questionDetailList = [];
  examList = [];
  yearList = [];

  // Show loading state
  SchedulerBinding.instance.addPostFrameCallback((_) async {
    isLoading = true;
    notifyListeners();
  });

  var baseUrl = '${FFAppState().baseUrl2}/userStarmarkedQuestions';

  try {
    // Construct the URL with query parameters
    final url = Uri.parse(baseUrl).replace(queryParameters: {
      'chapterId': 'eq.$chapterId',
      'select': '*,GetLatestStarmarkedQuestionDetail(exam,year)',
    });

    // Make the GET request
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
    );

    // Stop loading state
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      isLoading = false;
      notifyListeners();
    });

    if (response.statusCode == 200) {
      // Parse the response and map the data
      dataList = List<Map<String, dynamic>>.from(json.decode(response.body));

      for (Map<String, dynamic> data in dataList) {
        questions.add(data["question"]);
        explanations.add(data["explanation"]);
        correctOptionIndices.add(data["correctOptionIndex"]);
        userAttemptedIndices.add(data["userAnswer"]);
        questionDetailList.add(data["GetLatestStarmarkedQuestionDetail"]);

        if (data["GetLatestStarmarkedQuestionDetail"] != null) {
          examList.add(data["GetLatestStarmarkedQuestionDetail"]['exam']);
          yearList.add(data["GetLatestStarmarkedQuestionDetail"]['year']);
        } else {
          examList.add(null);
          yearList.add(null);
        }

        isNcert.add(data['ncert']);
      }

      return dataList;
    } else {
      print('Failed to fetch user starmarked questions. Status code: ${response.statusCode}');
      return null;
    }
  } catch (error) {
    print('Error: $error');
    return null;
  }
}
  void navigateToPage( bool isPrevious) async{
    if(isPrevious)
      await pageController
          ?.previousPage(
        duration: Duration(
            milliseconds:
            300),
        curve: Curves.ease,
      );
    else
      await pageController
          ?.nextPage(
        duration: Duration(
            milliseconds:
            300),
        curve: Curves.ease,
      );

  }




}

