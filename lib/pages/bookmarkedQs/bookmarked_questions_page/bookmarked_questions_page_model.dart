import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:neetprep_essential/app_state.dart';

class BookmarkedQuestionPageModel extends ChangeNotifier {
  Map<String, List<String>> subjectTopicMap = {};
  List<Map<String, dynamic>> dataList = [];
  List<String> questions = [];
  List<String> questionIds = [];
  List<String> explanations = [];
  List<int> correctOptionIndices = [];
  List<int?> userAttemptedIndices = [];
  List<bool> isNcert = [];
  List<Map<String, dynamic>?> questionDetailList = [];
  List<String?> examList = [];
  List<int?> yearList = [];
  int currentPageIndex = 0;
  final PageController pageController = PageController();
  int? selectedPageNumber;
  List<int> selectedIndexArray = [];
  bool showExplanation = true;
  bool isLoading = true;
  bool isBookmarkVisible = true;
  List<bool> allBookmarkQsStatus = [];
  List<bool> allStarmarkedQsStatus = [];


  Future<dynamic> getUserBookmarkedQuestions(
      int offset, int chapterId, String? courseId) async {
    questions = [];
    questionIds = [];
    explanations = [];
    correctOptionIndices = [];
    userAttemptedIndices = [];
    dataList = [];
    isNcert = [];
    questionDetailList = [];
    examList = [];
    yearList = [];
    allBookmarkQsStatus = [];
    allBookmarkQsStatus = [];
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      isLoading = true;
      notifyListeners();
    });
    var baseUrl =
        'https://www.neetprep.com/api/v1/get_essential_bookmarked_questions';
    // '${FFAppState().baseUrl2}/get_essential_bookmarked_questions';
    //https://www.neetprep.com/v2api
    final url = Uri.parse(baseUrl);
    print(chapterId.toString());
    print(courseId.toString());
    print(FFAppState().subjectToken.toString());
    final Map<String, String> headers = {
      'Authorization': 'Bearer ${FFAppState().subjectToken}'
    };
    Uri uri = Uri.parse(
            "https://www.neetprep.com/api/v1/get_essential_bookmarked_questions")
        .replace(queryParameters: {
      'courseId': courseId!,
      'topicId': chapterId.toString(),
    });
    try {
      final response = await http.get(uri, headers: headers);
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        isLoading = false;
        notifyListeners();
      });
      if (response.statusCode == 200) {
        dataList = List<Map<String, dynamic>>.from(json.decode(response.body));
       log(dataList.toString());
        for (Map<String, dynamic> data in dataList) {
          questions.add(data["question"]);
          questionIds.add(data["questionId"].toString());
          explanations.add(data["explanation"]);
          correctOptionIndices.add(data["correctOptionIndex"]);
          userAttemptedIndices.add(data["userAnswer"]);
          questionDetailList.add(data["GetLatestQuestionDetail"]);
          if (data["GetLatestQuestionDetail"] != null) {
            examList.add(data["GetLatestQuestionDetail"]['exam']);
            yearList.add(data["GetLatestQuestionDetail"]['year']);
          } else {
            examList.add(null);
            yearList.add(null);
          }
          isNcert.add(data['ncert']);
          allBookmarkQsStatus.add(true);
          allStarmarkedQsStatus.add(data["isStarmarked"]);
        }
      } else {
        print(
            'Failed to fetch user bookmarked questions. Status code: ${response.statusCode}');
      }

      return json.decode(response.body);
    } catch (error) {
      print('Error: $error');
      return null;
    }
  }

  void navigateToPage(bool isPrevious) async {
    if (isPrevious)
      await pageController?.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    else
      await pageController?.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
  }
}
