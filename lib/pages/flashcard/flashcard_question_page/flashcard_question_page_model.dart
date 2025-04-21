import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../../app_state.dart';
import '../../../backend/api_requests/api_calls.dart';
import '../../../components/custom_html_view/custom_html_view_model.dart';
import '../../../flutter_flow/flutter_flow_model.dart';

class  FlashcardQuestionPageModel extends ChangeNotifier {

  final PageController pageController = PageController();
  int currentPageIndex = 0;
  bool isLoading = false;
  String question ="";
  List questions=[];
  var apiResponse;
  int selectedIndex = -1;
  bool showExplanation = true;
  bool isBookmarked = false;

  late FlutterFlowDynamicModels<CustomHtmlViewModel> customHtmlViewModels1;
  late FlutterFlowDynamicModels<CustomHtmlViewModel>customHtmlViewModels2;


  Future<dynamic> fetchFlashcardQuestion(String questionId) async{

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      isLoading = true;
      notifyListeners();
    });

    var response = await FlashcardGroup.getFlashcardQuestionsForPracticeCall
        .call(
      questionId: questionId,
      authToken: FFAppState().subjectToken,
    );

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      isLoading = false;
      notifyListeners();
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = response.jsonBody;
      print(data['data'].toString());
       question = data['data']['question']['question'];
       isBookmarked = data['data']['question']['bookmarkQuestion']!=null? true:false;
        SchedulerBinding.instance.addPostFrameCallback((_) async {
        notifyListeners();
      });
        print(data['data'].toString());
        apiResponse = data['data']['question'];
      return data['data'];

    }
    else {
      log("API Error: ${response.statusCode}");
    }
    return null;
  }

  void navigateToPage( bool isPrevious) async{
    if(isPrevious)
      await pageController
          .previousPage(
        duration: Duration(
            milliseconds:
            300),
        curve: Curves.ease,
      );
    else
      await pageController
          .nextPage(
        duration: Duration(
            milliseconds:
            300),
        curve: Curves.ease,
      );

  }

  bool isQuestionFromNCERT( val){
    return val==null|| val==false ? false:true;
  }

  bool testIsExam(question){
    if(question["questionDetails"]["edges"].isNotEmpty){
      return true;
    }
    return false;
  }

  String? getExam(question){
    return (question["questionDetails"]["edges"][0]["node"]["exam"]??"").toString();
  }

  String? getYear(question){
    return (question["questionDetails"]["edges"][0]["node"]["year"] ?? "PYQ").toString();
  }

  String? userAnswer(question){
    if(question["userAnswer"]!=null){

      return  question["userAnswer"]["userAnswer"].toString();
    }
    return null;
  }

  String? correctOptionIndex(question){

    if(question["correctOptionIndex"]!=null){
      return  question["correctOptionIndex"].toString();
    }
    return null;
  }

  String? getExplanationWithoutAudio(question){
    if(question["explanationWithoutAudio"]!=null){
      return  question["explanationWithoutAudio"].toString();
    }
    return null;
  }

  String? getExplanation(question){
    if(question["explanation"]!=null){
      return  question["explanation"].toString();
    }
    return null;

  }









}