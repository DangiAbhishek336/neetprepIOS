import 'package:flutter/material.dart';
import 'custom_code/widgets/custom_banner.dart';
import 'flutter_flow/request_manager.dart';
import 'backend/api_requests/api_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static final FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _jwtToken = prefs.getString('ff_jwtToken') ?? _jwtToken;
    });
    _safeInit(() {
      _newToken = prefs.getString('ff_newToken') ?? _newToken;
    });
    _safeInit(() {
      _accessToken = prefs.getString('ff_accessToken') ?? _accessToken;
    });
    _safeInit(() {
      _userIdInt = prefs.getInt('ff_userIdInt') ?? _userIdInt;
    });
    _safeInit(() {
      _isDarkMode = prefs.getBool('ff_isDarkMode') ?? _isDarkMode;
    });
    _safeInit(() {
      if (prefs.containsKey('ff_memberShipRes')) {
        try {
          _memberShipRes =
              jsonDecode(prefs.getString('ff_memberShipRes') ?? '');
        } catch (e) {
          print("Can't decode persisted json. Error: $e.");
        }
      }
    });
    _safeInit(() {
      _memberShipResIdList =
          prefs.getStringList('ff_memberShipResIdList')?.map((x) {
                try {
                  return jsonDecode(x);
                } catch (e) {
                  print("Can't decode persisted json. Error: $e.");
                  return {};
                }
              }).toList() ??
              _memberShipResIdList;
    });
    _safeInit(() {
      _subjectToken = prefs.getString('ff_subjectToken') ?? _subjectToken;
    });
    _safeInit(() {
      _courseId = prefs.getString('ff_courseId') ?? _courseId;
    });
    _safeInit(() {
      _courseIdInt = prefs.getInt('ff_courseIdInt') ?? _courseIdInt;
    });
    _safeInit(() {
      _courseIdInts = prefs.getString('ff_courseIdInts') ?? _courseIdInts;
    });
    _safeInit(() {
      _phoneNum = prefs.getString('ff_phoneNum') ?? _phoneNum;
    });
    _safeInit(() {
      _quesQuota = prefs.getInt('ff_quesQuota') ?? _quesQuota;
    });
    _safeInit(() {
      _allSubTopics = prefs.getStringList('ff_allSubTopics') ?? _allSubTopics;
    });
    _safeInit(() {
      _searchHistory = prefs.getStringList('ff_searchHistory')?.map((x) {
            try {
              return jsonDecode(x);
            } catch (e) {
              print("Can't decode persisted json. Error: $e.");
              return {};
            }
          }).toList() ??
          _searchHistory;
    });
    _safeInit(() {
      _showRatingPrompt =
          prefs.getInt('ff_showRatingPrompt') ?? _showRatingPrompt;
    });
  }


  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  CustomBanner? _banner;

  CustomBanner? get banner => _banner;

  void setCustomBanner(CustomBanner newBanner) {
    _banner = newBanner;
    notifyListeners(); // Updates all listeners with the new data.
  }


  CustomBanner? abhyasBanner = null;
  CustomBanner? testSeriesBanner = null;
  CustomBanner? freeTrialBanner = null;
  Map<String,CustomBanner> _bannersByCourseId = {};
  Map<String,CustomBanner> get bannersByCourseId => _bannersByCourseId;
  set bannersByCourseId(Map<String,CustomBanner> _value) {
    _bannersByCourseId= _value;
  }

  String _baseUrl = 'https://www.neetprep.com';
  String get baseUrl => _baseUrl;
  set baseUrl(String _value) {
    _baseUrl = _value;
  }

  String _abhyasCourseStatus = '';
  String get abhyasCourseStatus => _abhyasCourseStatus;
  set abhyasCourseStatus(String _value) {
    _abhyasCourseStatus = _value;
  }

  String _baseUrl2 = 'https://www.neetprep.com/v2api';
  String get baseUrl2 => _baseUrl2;
  set baseUrl2(String _value) {
    _baseUrl2 = _value;
  }

  String _userName = '';
  String get userName => _userName;
  set userName(String _value) {
    _userName = _value;
  }

  String _firstName= '';
  String get firstName => _firstName;
  set firstName(String _value) {
    _firstName = _value;
  }

  String _lastName= '';
  String get lastName => _lastName;
  set lastName(String _value) {
    _lastName = _value;
  }
  String _emailId = '';
  String get emailId => _emailId;
  set emailId(String _value) {
    _emailId = _value;
  }

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;
  set isDarkMode(bool _value) {
    _isDarkMode = _value;
    prefs.setBool('ff_isDarkMode', _value);
  }

  bool _isFormCompleted = false;
  bool get isFormCompleted => _isFormCompleted;
  set isFormCompleted(bool _value) {
    _isFormCompleted = _value;
    prefs.setBool('ff_isFormCompleted', _value);
  }

  bool _showPhoneConfirmedModalSheet = true;
  bool get showPhoneConfirmedModalSheet => _showPhoneConfirmedModalSheet;
  set showPhoneConfirmedModalSheet(bool _value) {
    _showPhoneConfirmedModalSheet = _value;
    prefs.setBool('ff_showPhoneConfirmedModalSheet', _value);
  }

  String _displayImage = '';
  String get displayImage => _displayImage;
  set displayImage(String _value) {
    _displayImage = _value;
  }

  String _jwtToken = '';
  String get jwtToken => _jwtToken;
  set jwtToken(String _value) {
    _jwtToken = _value;
    prefs.setString('ff_jwtToken', _value);
  }

  String _newToken = '';
  String get newToken => _newToken;
  set newToken(String _value) {
    _newToken = _value;
    prefs.setString('ff_newToken', _value);
  }

  List<int> _numberOfTabs = [];
  List<int> get numberOfTabs => _numberOfTabs;
  set numberOfTabs(List<int> _value) {
    _numberOfTabs = _value;
  }

  void addToNumberOfTabs(int _value) {
    _numberOfTabs.add(_value);
  }

  void removeFromNumberOfTabs(int _value) {
    _numberOfTabs.remove(_value);
  }

  void removeAtIndexFromNumberOfTabs(int _index) {
    _numberOfTabs.removeAt(_index);
  }

  void updateNumberOfTabsAtIndex(
    int _index,
    int Function(int) updateFn,
  ) {
    _numberOfTabs[_index] = updateFn(_numberOfTabs[_index]);
  }

  bool _homeVisibility = true;
  bool get homeVisibility => _homeVisibility;
  set homeVisibility(bool _value) {
    _homeVisibility = _value;
  }

  bool _showLoading = false;
  bool get showLoading => _showLoading;
  set showLoading(bool _value) {
    _showLoading = _value;
  }

  bool _showBanners = true;
  bool get showBanners => _showBanners;
  set showBanners(bool _value) {
    _showBanners = _value;
  }

  bool _showFeedbackDrawerTooltip = true;
  bool get showFeedbackDrawerTooltip => _showFeedbackDrawerTooltip;
  set showFeedbackDrawerTooltip(bool _value) {
    _showFeedbackDrawerTooltip = _value;
  }

  bool _showFeedbackSubmitTooltip = true;
  bool get showFeedbackSubmitTooltip  => _showFeedbackSubmitTooltip ;
  set showFeedbackSubmitTooltip (bool _value) {
    _showFeedbackSubmitTooltip  = _value;
  }


  bool _showBannerForReview = true;
  bool get showBannerForReview => _showBannerForReview;
  set showBannerForReview(bool _value) {
    _showBannerForReview = _value;
  }


  bool _testVisibility = false;
  bool get testVisibility => _testVisibility;
  set testVisibility(bool _value) {
    _testVisibility = _value;
  }

  bool _notesVisibility = false;
  bool get notesVisibility => _notesVisibility;
  set notesVisibility(bool _value) {
    _notesVisibility = _value;
  }

  bool _isScreenshotCaptureDisabled = true;
  bool get isScreenshotCaptureDisabled => _isScreenshotCaptureDisabled;
  set isScreenshotCaptureDisabled(bool _value) {
    _isScreenshotCaptureDisabled = _value;
  }


  String _accessToken = '';
  String get accessToken => _accessToken;
  set accessToken(String _value) {
    _accessToken = _value;
    prefs.setString('ff_accessToken', _value);
  }

  bool _isCreatedTest = true;
  bool get isCreatedTest => _isCreatedTest;
  set isCreatedTest(bool _value) {
    _isCreatedTest = _value;
  }

  int _createdTestOffset = 0;
  int get createdTestOffset => _createdTestOffset;
  set createdTestOffset(int _value) {
    _createdTestOffset = _value;
  }

  int _count = 0;
  int get count => _count;
  set count(int _value) {
    _count = _value;
  }

  int _subTopicIndex = -1;
  int get subTopicIndex => _subTopicIndex;
  set subTopicIndex(int _value) {
    _subTopicIndex = _value;
  }

  bool _isInternetConnected = true;
  bool get isInternetConnected => _isInternetConnected;
  set isInternetConnected(bool _value) {
    _isInternetConnected = _value;
  }

  List<String> _topicName = [];
  List<String> get topicName => _topicName;
  set topicName(List<String> _value) {
    _topicName = _value;
  }

  void addToTopicName(String _value) {
    _topicName.add(_value);
  }

  void removeFromTopicName(String _value) {
    _topicName.remove(_value);
  }

  void removeAtIndexFromTopicName(int _index) {
    _topicName.removeAt(_index);
  }

  void updateTopicNameAtIndex(
    int _index,
    String Function(String) updateFn,
  ) {
    _topicName[_index] = updateFn(_topicName[_index]);
  }

  String _uniqueString = '';
  String get uniqueString => _uniqueString;
  set uniqueString(String _value) {
    _uniqueString = _value;
  }
  String _pdfURL = '';
  String get pdfURL => _pdfURL;
  set pdfURL(String _value) {
    _pdfURL = _value;
  }

  int _pageNumber = 0;
  int get pageNumber => _pageNumber;
  set pageNumber(int _value) {
    _pageNumber = _value;
  }

  List<dynamic> _questionList = [];
  List<dynamic> get questionList => _questionList;
  set questionList(List<dynamic> _value) {
    _questionList = _value;
  }

  void addToQuestionList(dynamic _value) {
    _questionList.add(_value);
  }

  void removeFromQuestionList(dynamic _value) {
    _questionList.remove(_value);
  }

  void removeAtIndexFromQuestionList(int _index) {
    _questionList.removeAt(_index);
  }

  void updateQuestionListAtIndex(
    int _index,
    dynamic Function(dynamic) updateFn,
  ) {
    _questionList[_index] = updateFn(_questionList[_index]);
  }

  bool _isPageLoad = true;
  bool get isPageLoad => _isPageLoad;
  set isPageLoad(bool _value) {
    _isPageLoad = _value;
  }

  List<int> _questionNumbers = [1, 2, 3, 4];
  List<int> get questionNumbers => _questionNumbers;
  set questionNumbers(List<int> _value) {
    _questionNumbers = _value;
  }

  void addToQuestionNumbers(int _value) {
    _questionNumbers.add(_value);
  }

  void removeFromQuestionNumbers(int _value) {
    _questionNumbers.remove(_value);
  }

  void removeAtIndexFromQuestionNumbers(int _index) {
    _questionNumbers.removeAt(_index);
  }

  void updateQuestionNumbersAtIndex(
    int _index,
    int Function(int) updateFn,
  ) {
    _questionNumbers[_index] = updateFn(_questionNumbers[_index]);
  }

  String _numberOfTimes = '6 months';
  String get numberOfTimes => _numberOfTimes;
  set numberOfTimes(String _value) {
    _numberOfTimes = _value;
  }

  double _actualAmount = 0.0;
  double get actualAmount => _actualAmount;
  set actualAmount(double _value) {
    _actualAmount = _value;
  }

  double _discountAmount = 0.0;
  double get discountAmount => _discountAmount;
  set discountAmount(double _value) {
    _discountAmount = _value;
  }

  List<dynamic> _allQuestionsStatus = [];
  List<dynamic> get allQuestionsStatus => _allQuestionsStatus;
  set allQuestionsStatus(List<dynamic> _value) {
    _allQuestionsStatus = _value;
  }

  List<dynamic> _allFlashcardQuestionsStatus = [];
  List<dynamic> get allFlashcardQuestionsStatus => _allFlashcardQuestionsStatus;
  set allFlashcardQuestionsStatus(List<dynamic> _value) {
    _allFlashcardQuestionsStatus = _value;
  }
  List<dynamic> _allFlashcardBookmarkedQuestionsStatus = [];
  List<dynamic> get allFlashcardBookmarkedQuestionsStatus => _allFlashcardBookmarkedQuestionsStatus;
  set allFlashcardBookmarkedQuestionsStatus(List<dynamic> _value) {
    _allFlashcardBookmarkedQuestionsStatus = _value;
  }

  void addToAllQuestionsStatus(dynamic _value) {
    _allQuestionsStatus.add(_value);
  }

  void removeFromAllQuestionsStatus(dynamic _value) {
    _allQuestionsStatus.remove(_value);
  }

  void removeAtIndexFromAllQuestionsStatus(int _index) {
    _allQuestionsStatus.removeAt(_index);
  }

  void updateAllQuestionsStatusAtIndex(
    int _index,
    dynamic Function(dynamic) updateFn,
  ) {
    _allQuestionsStatus[_index] = updateFn(_allQuestionsStatus[_index]);
  }

  String _mockUserName = 'Thor Developers';
  String get mockUserName => _mockUserName;
  set mockUserName(String _value) {
    _mockUserName = _value;
  }

  String _mockEmail = 'thordeveloper.tech@gmail.com';
  String get mockEmail => _mockEmail;
  set mockEmail(String _value) {
    _mockEmail = _value;
  }

  dynamic _bookMarkEmptyJson = jsonDecode('{\"name\":\"xyz\"}');
  dynamic get bookMarkEmptyJson => _bookMarkEmptyJson;
  set bookMarkEmptyJson(dynamic _value) {
    _bookMarkEmptyJson = _value;
  }

  dynamic _starMarkEmptyJson = jsonDecode('{\"name\":\"xyz\"}');
  dynamic get starMarkEmptyJson => _starMarkEmptyJson;
  set starMarkEmptyJson(dynamic _value) {
    _starMarkEmptyJson = _value;
  }

  int _userIdInt = 0;
  int get userIdInt => _userIdInt;
  set userIdInt(int _value) {
    _userIdInt = _value;
    prefs.setInt('ff_userIdInt', _value);
  }

  String _mockProfilePic =
      'https://lh3.googleusercontent.com/a/AEdFTp6WiotPy2D7VWwzHoWTNxvqrZaLVGuQZSfIbG4N=s360-p-no';
  String get mockProfilePic => _mockProfilePic;
  set mockProfilePic(String _value) {
    _mockProfilePic = _value;
  }

  String _topicNameForEachPage = '';
  String get topicNameForEachPage => _topicNameForEachPage;
  set topicNameForEachPage(String _value) {
    _topicNameForEachPage = _value;
  }

  dynamic _topicIds = jsonDecode('[]');
  dynamic get topicIds => _topicIds;
  set topicIds(dynamic _value) {
    _topicIds = _value;
  }

  dynamic _subIds = jsonDecode('[]');
  dynamic get subIds => _subIds;
  set subIds(dynamic _value) {
    _subIds = _value;
  }

  List<int> _testQueAnsList = [];
  List<int> get testQueAnsList => _testQueAnsList;
  set testQueAnsList(List<int> _value) {
    _testQueAnsList = _value;
  }

  void addToTestQueAnsList(int _value) {
    _testQueAnsList.add(_value);
  }

  void removeFromTestQueAnsList(int _value) {
    _testQueAnsList.remove(_value);
  }

  void removeAtIndexFromTestQueAnsList(int _index) {
    _testQueAnsList.removeAt(_index);
  }

  void updateTestQueAnsListAtIndex(
    int _index,
    int Function(int) updateFn,
  ) {
    _testQueAnsList[_index] = updateFn(_testQueAnsList[_index]);
  }

  List<int> _questionsListInInt = [];
  List<int> get questionsListInInt => _questionsListInInt;
  set questionsListInInt(List<int> _value) {
    _questionsListInInt = _value;
  }

  void addToQuestionsListInInt(int _value) {
    _questionsListInInt.add(_value);
  }

  void removeFromQuestionsListInInt(int _value) {
    _questionsListInInt.remove(_value);
  }

  void removeAtIndexFromQuestionsListInInt(int _index) {
    _questionsListInInt.removeAt(_index);
  }

  void updateQuestionsListInIntAtIndex(
    int _index,
    int Function(int) updateFn,
  ) {
    _questionsListInInt[_index] = updateFn(_questionsListInInt[_index]);
  }

  List<int> _answerListInInt = [];
  List<int> get answerListInInt => _answerListInInt;
  set answerListInInt(List<int> _value) {
    _answerListInInt = _value;
  }

  void addToAnswerListInInt(int _value) {
    _answerListInInt.add(_value);
  }

  void removeFromAnswerListInInt(int _value) {
    _answerListInInt.remove(_value);
  }

  void removeAtIndexFromAnswerListInInt(int _index) {
    _answerListInInt.removeAt(_index);
  }

  void updateAnswerListInIntAtIndex(
    int _index,
    int Function(int) updateFn,
  ) {
    _answerListInInt[_index] = updateFn(_answerListInInt[_index]);
  }

  List<int> _secondsList = [];
  List<int> get secondsList => _secondsList;
  set secondsList(List<int> _value) {
    _secondsList = _value;
  }

  void addToSecondsList(int _value) {
    _secondsList.add(_value);
  }

  void removeFromSecondsList(int _value) {
    _secondsList.remove(_value);
  }

  void removeAtIndexFromSecondsList(int _index) {
    _secondsList.removeAt(_index);
  }

  void updateSecondsListAtIndex(
    int _index,
    int Function(int) updateFn,
  ) {
    _secondsList[_index] = updateFn(_secondsList[_index]);
  }

  List<int> _secondsListInInt = [];
  List<int> get secondsListInInt => _secondsListInInt;
  set secondsListInInt(List<int> _value) {
    _secondsListInInt = _value;
  }

  void addToSecondsListInInt(int _value) {
    _secondsListInInt.add(_value);
  }

  void removeFromSecondsListInInt(int _value) {
    _secondsListInInt.remove(_value);
  }

  void removeAtIndexFromSecondsListInInt(int _index) {
    _secondsListInInt.removeAt(_index);
  }

  void updateSecondsListInIntAtIndex(
    int _index,
    int Function(int) updateFn,
  ) {
    _secondsListInInt[_index] = updateFn(_secondsListInInt[_index]);
  }

  String _testAttemptId = '';
  String get testAttemptId => _testAttemptId;
  set testAttemptId(String _value) {
    _testAttemptId = _value;
  }

  int _minutes = 0;
  int get minutes => _minutes;
  set minutes(int _value) {
    _minutes = _value;
  }

  int _seconds = 0;
  int get seconds => _seconds;
  set seconds(int _value) {
    _seconds = _value;
  }

  dynamic _questionsList;
  dynamic get questionsList => _questionsList;
  set questionsList(dynamic _value) {
    _questionsList = _value;
  }

  dynamic _testAttemptData;
  dynamic get testAttemptData => _testAttemptData;
  set testAttemptData(dynamic _value) {
    _testAttemptData = _value;
  }

  dynamic _memberShipRes;
  dynamic get memberShipRes => _memberShipRes;
  set memberShipRes(dynamic _value) {
    _memberShipRes = _value;
    prefs.setString('ff_memberShipRes', jsonEncode(_value));
  }

  List<dynamic> _memberShipResIdList = [];
  List<dynamic> get memberShipResIdList => _memberShipResIdList;
  set memberShipResIdList(List<dynamic> _value) {
    _memberShipResIdList = _value;
    prefs.setStringList(
        'ff_memberShipResIdList', _value.map((x) => jsonEncode(x)).toList());
  }

  dynamic _memberShipResForAssertion;
  dynamic get memberShipResForAssertion => _memberShipResForAssertion;
  set memberShipResForAssertion(dynamic _value) {
    _memberShipResForAssertion = _value;
    prefs.setString('ff_memberShipResForAssertion', jsonEncode(_value));
  }

  List<dynamic> _memberShipResForAssertionIdList = [];
  List<dynamic> get memberShipResForAssertionIdList => _memberShipResForAssertionIdList;
  set memberShipResForAssertionIdList(List<dynamic> _value) {
    _memberShipResForAssertionIdList = _value;
    prefs.setStringList(
        'ff_memberShipResForAssertionIdList', _value.map((x) => jsonEncode(x)).toList());
  }

  dynamic _memberShipResForEssential;
  dynamic get memberShipResForEssential => _memberShipResForEssential;
  set memberShipResForEssential(dynamic _value) {
    _memberShipResForEssential = _value;
    prefs.setString('ff_memberShipResForEssential', jsonEncode(_value));
  }

  List<dynamic> _memberShipResForEssentialIdList = [];
  List<dynamic> get memberShipResForEssentialIdList => _memberShipResForEssentialIdList;
  set memberShipResForEssentialIdList(List<dynamic> _value) {
    _memberShipResForEssentialIdList = _value;
    prefs.setStringList(
        'ff_memberShipResForEssentialIdList', _value.map((x) => jsonEncode(x)).toList());
  }



  void addToMemberShipResIdList(dynamic _value) {
    _memberShipResIdList.add(_value);
    prefs.setStringList('ff_memberShipResIdList',
        _memberShipResIdList.map((x) => jsonEncode(x)).toList());
  }

  void removeFromMemberShipResIdList(dynamic _value) {
    _memberShipResIdList.remove(_value);
    prefs.setStringList('ff_memberShipResIdList',
        _memberShipResIdList.map((x) => jsonEncode(x)).toList());
  }

  void removeAtIndexFromMemberShipResIdList(int _index) {
    _memberShipResIdList.removeAt(_index);
    prefs.setStringList('ff_memberShipResIdList',
        _memberShipResIdList.map((x) => jsonEncode(x)).toList());
  }

  void updateMemberShipResIdListAtIndex(
    int _index,
    dynamic Function(dynamic) updateFn,
  ) {
    _memberShipResIdList[_index] = updateFn(_memberShipResIdList[_index]);
    prefs.setStringList('ff_memberShipResIdList',
        _memberShipResIdList.map((x) => jsonEncode(x)).toList());
  }

  String _mid = 'GoodEd74716548680494';
  String get mid => _mid;
  set mid(String _value) {
    _mid = _value;
  }

  String _subjectToken = '';
  String get subjectToken => _subjectToken;
  set subjectToken(String _value) {
    _subjectToken = _value;
    prefs.setString('ff_subjectToken', _value);
  }

  String _courseId = 'Q291cnNlOjMxMjU=';
  String get courseId => _courseId;
  set courseId(String _value) {
    _courseId = _value;
    prefs.setString('ff_courseId', _value);
  }

  String _hardestQsCourseId = 'Q291cnNlOjU3NjU=';
  String get hardestQsCourseId => _hardestQsCourseId;
  set hardestQsCourseId(String _value) {
    _hardestQsCourseId = _value;
    prefs.setString('ff_hardestQsCourseId', _value);
  }
  String _pyqMarkedNcertCourseId = 'Q291cnNlOjU1MzQ=';
  String get pyqMarkedNcertCourseId => _pyqMarkedNcertCourseId;
  set pyqMarkedNcertCourseId(String _value) {
    _pyqMarkedNcertCourseId = _value;
    prefs.setString('ff_pyqMarkedNcertCourseId', _value);
  }

  String _incorrectMarkedNcertCourseId = 'Q291cnNlOjU1MzU=';
  String get incorrectMarkedNcertCourseId => _incorrectMarkedNcertCourseId;
  set incorrectMarkedNcertCourseId(String _value) {
    _incorrectMarkedNcertCourseId = _value;
    prefs.setString('ff_incorrectMarkedNcertCourseId', _value);
  }

  String _assertionCourseId = 'Q291cnNlOjM2MjI=';
  String get assertionCourseId => _assertionCourseId;
  set assertionCourseId(String _value) {
    _assertionCourseId = _value;
    prefs.setString('ff_assertionCourseId', _value);
  }

  String _offlineBookCourseId = 'Q291cnNlOjM4NTE=';
  String get offlineBookCourseId => _offlineBookCourseId;
  set offlineBookCourseId(String _value) {
    _offlineBookCourseId = _value;
    prefs.setString('ff_offlineBookCourseId', _value);
  }


  String _abhyasEssentialBookCourseId = 'Q291cnNlOjQ4NDE=';
  String get abhyasEssentialBookCourseId => _abhyasEssentialBookCourseId;
  set abhyasEssentialBookCourseId(String _value) {
    _abhyasEssentialBookCourseId = _value;
    prefs.setString('ff_abhyasEssentialBookCourseId', _value);
  }

  String _homeTestSeriesBookCourseId = 'Q291cnNlOjQxODE=';
  String get homeTestSeriesBookCourseId => _homeTestSeriesBookCourseId;
  set homeTestSeriesBookCourseId(String _value) {
    _homeTestSeriesBookCourseId = _value;
    prefs.setString('ff_homeTestSeriesBookCourseId', _value);
  }

  String _testCourseId = "Q291cnNlOjQ1Nzc=" ;
  String get testCourseId => _testCourseId;
  set testCourseId(String _value) {
    _testCourseId = _value;
    prefs.setString('ff_testCourseId', _value);
  }

  String _classroomTestCourseId = "Q291cnNlOjM0MjI=" ;

  String get classroomTestCourseId => _classroomTestCourseId;
  set classroomTestCourseId(String _value) {
    _classroomTestCourseId = _value;
    prefs.setString('ff_classroomTestCourseId', _value);
  }

  String _flashcardCourseId = "Q291cnNlOjM0ODg=";
      // 'Q291cnNlOjM0ODg=';
  String get flashcardCourseId => _flashcardCourseId;
  set flashcardCourseId(String _value) {
    _flashcardCourseId = _value;
    prefs.setString('ff_flashcardCourseId', _value);
  }

  String _essentialCourseId = 'Q291cnNlOjQyNDc=';
  String get essentialCourseId => _essentialCourseId;
  set essentialCourseId(String _value) {
    _essentialCourseId = _value;
    prefs.setString('ff_essentialCourseId', _value);
  }

  String _abhyas2CourseId = 'Q291cnNlOjQ3NzU=';
  String get abhyas2CourseId => _abhyas2CourseId;
  set abhyas2CourseId(String _value) {
    _abhyas2CourseId = _value;
    prefs.setString('ff_abhyas2CourseId', _value);
  }



  int _courseIdInt = 3125;
  int get courseIdInt => _courseIdInt;
  set courseIdInt(int _value) {
    _courseIdInt = _value;
    prefs.setInt('ff_courseIdInt', _value);
  }

  int _hardestQsCourseIdInt = 5765;
  int get hardestQsCourseIdInt  => _hardestQsCourseIdInt;
  set hardestQsCourseIdInt(int _value) {
    _hardestQsCourseIdInt = _value;
    prefs.setInt('ff_hardestQsCourseIdInt', _value);
  }

  int _pyqMarkedNcertCourseIdInt = 5534;
  int get pyqMarkedNcertCourseIdInt => _pyqMarkedNcertCourseIdInt;
  set pyqMarkedNcertCourseIdInt(int _value) {
    _pyqMarkedNcertCourseIdInt = _value;
    prefs.setInt('ff_pyqMarkedNcertCourseIdInt', _value);
  }

  int _incorrectMarkedNcertCourseIdInt = 5535;
  int get incorrectMarkedNcertCourseIdInt => _incorrectMarkedNcertCourseIdInt;
  set incorrectMarkedNcertCourseIdInt(int _value) {
    _incorrectMarkedNcertCourseIdInt = _value;
    prefs.setInt('ff_incorrectMarkedNcertCourseIdInt', _value);
  }

  int _altCourseIdInt = 3653;
  int get altCourseIdInt => _altCourseIdInt;
  set altCourseIdInt(int _value) {
    _altCourseIdInt = _value;
    prefs.setInt('ff_altCourseIdInt', _value);
  }


  int _offlineBookCourseIdInt = 3851;
  int get offlineBookCourseIdInt => _offlineBookCourseIdInt;
  set offlineBookCourseIdInt(int _value) {
    _offlineBookCourseIdInt= _value;
    prefs.setInt('ff_offlineBookCourseIdInt', _value);
  }

  int _abhyasEssentialBookCourseIdInt = 4841;
  int get abhyasEssentialBookCourseIdInt => _abhyasEssentialBookCourseIdInt;
  set abhyasEssentialBookCourseIdInt(int _value) {
    _abhyasEssentialBookCourseIdInt = _value;
    prefs.setInt('ff_abhyasEssentialBookCourseIdInt', _value);
  }

  int _homeTestSeriesBookCourseIdInt = 4181;
  int get homeTestSeriesBookCourseIdInt => _homeTestSeriesBookCourseIdInt;
  set homeTestSeriesBookCourseIdInt(int _value) {
    _homeTestSeriesBookCourseIdInt = _value;
    prefs.setInt('ff_homeTestSeriesBookCourseIdInt', _value);
  }



  int _assertionCourseIdInt = 3622;
  int get assertionCourseIdInt => _assertionCourseIdInt;
  set assertionCourseIdInt(int _value) {
    _assertionCourseIdInt = _value;
    prefs.setInt('ff_assertionCourseIdInt', _value);
  }


  int _abhyas2CourseIdInt = 4775;
  int get abhyas2CourseIdInt => _abhyas2CourseIdInt;
  set abhyas2CourseIdInt(int _value) {
    _abhyas2CourseIdInt = _value;
    prefs.setInt('ff_abhyas2CourseIdInt', _value);
  }



  String _courseIdInts = '3125,3653';
  String get courseIdInts => _courseIdInts;
  set courseIdInts(String _value) {
    _courseIdInts = _value;
    prefs.setString('ff_courseIdInts', _value);
  }

  String _hardestQsCourseIdInts = '';
  String get hardestQsCourseIdInts => _hardestQsCourseIdInts;
  set hardestQsCourseIdInts(String _value) {
    _hardestQsCourseIdInts = _value;
    prefs.setString('ff_hardestQsCourseIdInts', _value);
  }

  String _abhyas2CourseIdInts = '';
  String get abhyas2CourseIdInts=> _abhyas2CourseIdInts;
  set abhyas2CourseIdInts(String _value) {
    _abhyas2CourseIdInts = _value;
    prefs.setString('ff_abhyas2CourseIdInt', _value);
  }


  int _testCourseIdInt = 4577;

  int get testCourseIdInt => _testCourseIdInt;
  set bioProdigyTestCourseIdInt(int _value) {
    _testCourseIdInt = _value;
    prefs.setInt('ff_bioProdigyTestCourseIdInt', _value);
  }

  String _testCourseIdInts = '';

  String get testCourseIdInts => _testCourseIdInts;
  set bioProdigyTestCourseIdInts(String _value) {
    _testCourseIdInts = _value;
    prefs.setString('ff_bioProdigyTestCourseIdInts', _value);
  }

  int _classroomTestCourseIdInt = 3422;

  int get classroomTestCourseIdInt => _classroomTestCourseIdInt;
  set classroomTestCourseIdInt(int _value) {
    _classroomTestCourseIdInt = _value;
    prefs.setInt('ff_classroomTestCourseIdInt', _value);
  }

  String _classroomTestCourseIdInts = '';

  String get classroomTestCourseIdInts => _classroomTestCourseIdInts;
  set classroomTestCourseIdInts(String _value) {
    _classroomTestCourseIdInts = _value;
    prefs.setString('ff_classroomTestCourseIdInts', _value);
  }

  String _assertionCourseIdInts = '3622,4148';

  String get assertionCourseIdInts => _assertionCourseIdInts;
  set assertionCourseIdInts(String _value) {
    _assertionCourseIdInts = _value;
    prefs.setString('ff_assertionCourseIdInts', _value);
  }

  int _flashcardCourseIdInt = 3488;

  int get flashcardCourseIdInt => _flashcardCourseIdInt;
  set flashcardCourseIdInt(int _value) {
    _flashcardCourseIdInt = _value;
    prefs.setInt('ff_flashcardCourseIdInt', _value);
  }

  String _flashcardCourseIdInts = '3488';

  String get flashcardCourseIdInts => _flashcardCourseIdInts;
  set flashcardCourseIdInts(String _value) {
    _flashcardCourseIdInts= _value;
    prefs.setString('ff_flashcardCourseIdInts', _value);
  }

  String _essentialCourseIdInts = '4247';

  String get essentialCourseIdInts => _essentialCourseIdInts;
  set essentialCourseIdInts(String _value) {
    _essentialCourseIdInts = _value;
    prefs.setString('ff_essentialCourseIdInts', _value);
  }


  int _essentialCourseIdInt = 4247;
  int get essentialCourseIdInt => _essentialCourseIdInt;
  set essentialCourseIdInt(int _value) {
    _essentialCourseIdInt = _value;
    prefs.setInt('ff_essentialCourseIdInt', _value);
  }


  String _phoneNum = '';
  String get phoneNum => _phoneNum;
  set phoneNum(String _value) {
    _phoneNum = _value;
    prefs.setString('ff_phoneNum', _value);
  }

  String _userPhoneNumber = '';
  String get userPhoneNumber => _userPhoneNumber;
  set userPhoneNumber(String _value) {
    _userPhoneNumber = _value;
    prefs.setString('ff_userPhoneNum', _value);
  }

  int _quesQuota = 0;
  int get quesQuota => _quesQuota;
  set quesQuota(int _value) {
    _quesQuota = _value;
    prefs.setInt('ff_quesQuota', _value);
  }

  int _freeQuota = 100;
  int get freeQuota => _freeQuota;
  set freeQuota(int _value) {
    _freeQuota = _value;
  }

  String _deviceData = '';
  String get deviceData => _deviceData;
  set deviceData(String _value) {
    _deviceData = _value;
  }

  List<String> _allSubTopics = [];
  List<String> get allSubTopics => _allSubTopics;
  set allSubTopics(List<String> _value) {
    _allSubTopics = _value;
    prefs.setStringList('ff_allSubTopics', _value);
  }

  void addToAllSubTopics(String _value) {
    _allSubTopics.add(_value);
    prefs.setStringList('ff_allSubTopics', _allSubTopics);
  }

  void removeFromAllSubTopics(String _value) {
    _allSubTopics.remove(_value);
    prefs.setStringList('ff_allSubTopics', _allSubTopics);
  }

  void removeAtIndexFromAllSubTopics(int _index) {
    _allSubTopics.removeAt(_index);
    prefs.setStringList('ff_allSubTopics', _allSubTopics);
  }

  void updateAllSubTopicsAtIndex(
    int _index,
    String Function(String) updateFn,
  ) {
    _allSubTopics[_index] = updateFn(_allSubTopics[_index]);
    prefs.setStringList('ff_allSubTopics', _allSubTopics);
  }

  List<dynamic> _allSearchItems = [];
  List<dynamic> get allSearchItems => _allSearchItems;
  set allSearchItems(List<dynamic> _value) {
    _allSearchItems = _value;
  }

 Map<String, String> _testMap ={};
  Map<String, String> get testMap => _testMap;
  set testMap( Map<String, String> _value) {
    _testMap = _value;
  }

  List<dynamic> _allSearchItemsForBookmarkedQs = [];
  List<dynamic> get allSearchItemsForBookmarkedQs => _allSearchItemsForBookmarkedQs;
  set allSearchItemsForBookmarkedQs(List<dynamic> _value) {
    _allSearchItemsForBookmarkedQs = _value;
  }

   List<dynamic> _allSearchItemsForStarmarkedQs = [];
  List<dynamic> get allSearchItemsForStarmarkedQs => _allSearchItemsForStarmarkedQs;
  set allSearchItemsForStarmarkedQs(List<dynamic> _value) {
    _allSearchItemsForStarmarkedQs = _value;
  }

  List<dynamic> _allSearchItemsForFlashcards = [];
  List<dynamic> get allSearchItemsForFlashcards => _allSearchItemsForFlashcards;
  set allSearchItemsForFlashcards(List<dynamic> _value) {
    _allSearchItemsForFlashcards = _value;
  }

  List<dynamic> _allSearchItemsForAssertionReason = [];
  List<dynamic> get allSearchItemsForAssertionReason => _allSearchItemsForAssertionReason;
  set allSearchItemsForAssertionReason(List<dynamic> _value) {
    _allSearchItemsForAssertionReason = _value;
  }

  List<dynamic> _allSearchItemsForEssential = [];
  List<dynamic> get allSearchItemsForEssential => _allSearchItemsForEssential;
  set allSearchItemsForEssential(List<dynamic> _value) {
    _allSearchItemsForEssential = _value;
  }

  void addToAllSearchItems(dynamic _value) {
    _allSearchItems.add(_value);
  }

  void removeFromAllSearchItems(dynamic _value) {
    _allSearchItems.remove(_value);
  }

  void removeAtIndexFromAllSearchItems(int _index) {
    _allSearchItems.removeAt(_index);
  }

  void updateAllSearchItemsAtIndex(
    int _index,
    dynamic Function(dynamic) updateFn,
  ) {
    _allSearchItems[_index] = updateFn(_allSearchItems[_index]);
  }

  List<dynamic> _searchHistory = [];
  List<dynamic> get searchHistory => _searchHistory;
  set searchHistory(List<dynamic> _value) {
    _searchHistory = _value;
    prefs.setStringList(
        'ff_searchHistory', _value.map((x) => jsonEncode(x)).toList());
  }

  void addToSearchHistory(dynamic _value) {
    _searchHistory.add(_value);
    prefs.setStringList(
        'ff_searchHistory', _searchHistory.map((x) => jsonEncode(x)).toList());
  }

  void removeFromSearchHistory(dynamic _value) {
    _searchHistory.remove(_value);
    prefs.setStringList(
        'ff_searchHistory', _searchHistory.map((x) => jsonEncode(x)).toList());
  }

  void removeAtIndexFromSearchHistory(int _index) {
    _searchHistory.removeAt(_index);
    prefs.setStringList(
        'ff_searchHistory', _searchHistory.map((x) => jsonEncode(x)).toList());
  }

  void updateSearchHistoryAtIndex(
    int _index,
    dynamic Function(dynamic) updateFn,
  ) {
    _searchHistory[_index] = updateFn(_searchHistory[_index]);
    prefs.setStringList(
        'ff_searchHistory', _searchHistory.map((x) => jsonEncode(x)).toList());
  }

  int _showRatingPrompt = 0;
  int get showRatingPrompt => _showRatingPrompt;
  set showRatingPrompt(int _value) {
    _showRatingPrompt = _value;
    prefs.setInt('ff_showRatingPrompt', _value);
  }

  final _completedTestAttemptQueryManager =
      FutureRequestManager<ApiCallResponse>();
  Future<ApiCallResponse> completedTestAttemptQuery({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<ApiCallResponse> Function() requestFn,
  }) =>
      _completedTestAttemptQueryManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearCompletedTestAttemptQueryCache() =>
      _completedTestAttemptQueryManager.clear();
  void clearCompletedTestAttemptQueryCacheKey(String? uniqueKey) =>
      _completedTestAttemptQueryManager.clearRequest(uniqueKey);

  final _userInfoQueryManager = FutureRequestManager<ApiCallResponse>();
  Future<ApiCallResponse> userInfoQuery({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<ApiCallResponse> Function() requestFn,
  }) =>
      _userInfoQueryManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearUserInfoQueryCache() => _userInfoQueryManager.clear();
  void clearUserInfoQueryCacheKey(String? uniqueKey) =>
      _userInfoQueryManager.clearRequest(uniqueKey);

  final _testQuestionsCacheManager = FutureRequestManager<ApiCallResponse>();
  Future<ApiCallResponse> testQuestionsCache({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<ApiCallResponse> Function() requestFn,
  }) =>
      _testQuestionsCacheManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearTestQuestionsCacheCache() => _testQuestionsCacheManager.clear();
  void clearTestQuestionsCacheCacheKey(String? uniqueKey) =>
      _testQuestionsCacheManager.clearRequest(uniqueKey);

  final _deckCardsCacheManager = FutureRequestManager<ApiCallResponse>();
  Future<ApiCallResponse> deckCardsCache({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<ApiCallResponse> Function() requestFn,
  }) =>
      _deckCardsCacheManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearDeckCardsCacheCache() => _deckCardsCacheManager.clear();
  void clearDeckCardsCacheCacheKey(String? uniqueKey) =>
      _deckCardsCacheManager.clearRequest(uniqueKey);

  final _deckBookmarkedCardsCacheManager = FutureRequestManager<ApiCallResponse>();
  Future<ApiCallResponse> deckBookmarkedCardsCache({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<ApiCallResponse> Function() requestFn,
  }) =>
      _deckBookmarkedCardsCacheManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearDeckBookmarkedCardsCacheCache() => _deckBookmarkedCardsCacheManager.clear();
  void clearDeckBookmarkedCardsCacheCacheKey(String? uniqueKey) =>
      _deckBookmarkedCardsCacheManager.clearRequest(uniqueKey);

}


LatLng? _latLngFromString(String? val) {
  if (val == null) {
    return null;
  }
  final split = val.split(',');
  final lat = double.parse(split.first);
  final lng = double.parse(split.last);
  return LatLng(lat, lng);
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
