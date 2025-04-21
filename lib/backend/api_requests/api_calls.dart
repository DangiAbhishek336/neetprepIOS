import 'dart:convert';

import '../../flutter_flow/flutter_flow_util.dart';

import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

/// Start Practice Group Code

class PracticeGroup {
  static String baseUrl = FFAppState().baseUrl;
  static Map<String, String> headers = {};
  static GetPracticeTestsToShowSubjectsInThePracticeTabCall
      getPracticeTestsToShowSubjectsInThePracticeTabCall =
      GetPracticeTestsToShowSubjectsInThePracticeTabCall();
  static GetPracticeTestsToShowChapterWiseCall
      getPracticeTestsToShowChapterWiseCall =
      GetPracticeTestsToShowChapterWiseCall();
  static GetPracticeTestsToShowOpenAndLockedTopicsCall
      getPracticeTestsToShowOpenAndLockedTopicsCall =
      GetPracticeTestsToShowOpenAndLockedTopicsCall();
  static GetPracticeTestDetailsForAnExampleSubjectAnatomyCall
      getPracticeTestDetailsForAnExampleSubjectAnatomyCall =
      GetPracticeTestDetailsForAnExampleSubjectAnatomyCall();
  static ResetAttemptsOfAPracticeTestShownOnClickingOnTheThreeDotsBesidesTestNameCall
      resetAttemptsOfAPracticeTestShownOnClickingOnTheThreeDotsBesidesTestNameCall =
      ResetAttemptsOfAPracticeTestShownOnClickingOnTheThreeDotsBesidesTestNameCall();
  static GetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall
      getPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall =
      GetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall();
  static GetStatusOfAllPracticeQuestionsForATestForAGivenUserCall
      getStatusOfAllPracticeQuestionsForATestForAGivenUserCall =
      GetStatusOfAllPracticeQuestionsForATestForAGivenUserCall();
  static CreateAnswerForAPracticeQuestionByAUserWithSpecificMarkedOptionCall
      createAnswerForAPracticeQuestionByAUserWithSpecificMarkedOptionCall =
      CreateAnswerForAPracticeQuestionByAUserWithSpecificMarkedOptionCall();
  static CreateQuestionIssueReportedByAUserForAQuestionAndForAnIssueTypeCall
      createQuestionIssueReportedByAUserForAQuestionAndForAnIssueTypeCall =
      CreateQuestionIssueReportedByAUserForAQuestionAndForAnIssueTypeCall();
  static CreateOrDeleteBookmarkForAPracticeQuestionByAUserCall
      createOrDeleteBookmarkForAPracticeQuestionByAUserCall =
      CreateOrDeleteBookmarkForAPracticeQuestionByAUserCall();
  static GetQuestionIssueListForIssueReportingCall
      getQuestionIssueListForIssueReportingCall =
      GetQuestionIssueListForIssueReportingCall();
  static GetAllQuestionStatusGivenTestIDCall
      getAllQuestionStatusGivenTestIDCall =
      GetAllQuestionStatusGivenTestIDCall();
}

class GetPracticeTestsToShowSubjectsInThePracticeTabCall {
  Future<ApiCallResponse> call({
    String? courseId = 'Q291cnNlOjIxMzU=',
  }) {
    final body = '''
{
  "query": "query GetPracticeModeTestList(\$id: ID!) {\\n  course(id: \$id) {\\n    tests(orderBy: [SEQID, ID], where: {allowPracticeMode: true}) {\\n      edges {\\n        node {\\n          id\\n          name\\n          numQuestions\\n          durationInMin\\n        }\\n      }\\n    }\\n  }\\n}\\n",
  "variables": "{\\"id\\": \\"$courseId\\"}",
  "operationName": "GetPracticeModeTestList"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Get Practice Tests to show subjects in the practice tab',
      apiUrl: '${PracticeGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {
        ...PracticeGroup.headers,
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: true,
    );
  }

  dynamic practiceTests(dynamic response) => getJsonField(
        response,
        r'''$.data.course.tests.edges[:].node''',
        true,
      );
}

class GetPracticeTestsToShowChapterWiseCall {
  Future<ApiCallResponse> call({
    String? courseId = 'Q291cnNlOjIwNjk=',
  }) {
    final body = '''
{
  "query": "query GetPracticeModeTestList(\$id:ID) {\\n  course(id: \$id) {\\n    subjects{\\n      edges{\\n        node{\\n          topics(orderBy: [SEQID, ID]){\\n            edges{\\n              node{\\n                name\\n                id\\n                questionSets (orderBy:SEQID){\\n                  edges{\\n                    node{\\n                      id\\n                      qsChapters{\\n        edges{\\n          node{\\n         id\\n        }\\n        }\\n         }\\n         name\\n                      sections\\n                      numQuestions\\n                    }\\n                  }\\n                }\\n              }\\n            }\\n          }\\n        }\\n      }\\n    }\\n  }\\n}",
  "variables": "{\\n  \\"id\\": \\"$courseId\\"\\n}",
  "operationName": "GetPracticeModeTestList"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Get Practice Tests to show chapter wise',
      apiUrl: '${PracticeGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {
        ...PracticeGroup.headers,
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: true,
    );
  }

  dynamic topicNodes(dynamic response) => getJsonField(
        response,
        r'''$.data.course.subjects.edges[:].node.topics.edges[:].node''',
        true,
      );

  dynamic topicNames(dynamic response) => getJsonField(
        response,
        r'''$.data.course.subjects.edges[:].node.topics.edges[:].node.name''',
        true,
      );

  dynamic allSubTopicName(dynamic response) => getJsonField(
        response,
        r'''$.data.course.subjects.edges[:].node.topics.edges[:].node.questionSets.edges[:].node.name''',
        true,
      );

  dynamic allChapterWithId(dynamic response) => getJsonField(
        response,
        r'''$.data.course.subjects.edges[:].node.topics.edges[:].node.questionSets.edges[:].node''',
        true,
      );
}

class GetPracticeTestsToShowOpenAndLockedTopicsCall {
  Future<ApiCallResponse> call({
    required String authToken,
    required String courseId,
    required List<String>? excludeIds,
  }) {
    // Convert excludeIds to a GraphQL-compatible string format
    final excludeIdsFormatted =
        excludeIds != null ? excludeIds.map((id) => id).toList() : [];

    // Prepare the GraphQL request body
    final body = jsonEncode({
      "query": """
      query GetPracticeModeTestList(\$id: ID, \$excludeIds: [ID]) {
        course(id: \$id) {
          subjects {
            edges {
              node {
                openTopics: topics(id_in: \$excludeIds, orderBy: [SEQID, ID]) {
                  edges {
                    node {
                      id
                      name
                      questionSets(orderBy: SEQID) {
                        edges {
                          node {
                            qsChapters{
                            edges{
                            node{
                            id
                             }
                               }
                                 }
                            id
                            name
                            sections
                            numQuestions
                          }
                        }
                      }
                    }
                  }
                }
                lockedTopics: topics(id_not_in: \$excludeIds, orderBy: [SEQID, ID]) {
                  edges {
                    node {
                      id
                      name
                      questionSets(orderBy: SEQID) {
                        edges {
                          node {
                           qsChapters{
                            edges{
                            node{
                            id
                             }
                               }
                                 }
                            id
                            name
                            sections
                            numQuestions
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    """,
      "variables": {
        "id": courseId,
        "excludeIds": excludeIdsFormatted,
      },
      "operationName": "GetPracticeModeTestList"
    });

    // Print the body for debugging
    print("GraphQL Request Body: $body");

    return ApiManager.instance.makeApiCall(
      callName: 'Get practice mode test list',
      apiUrl: '${SignupGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {
        ...SignupGroup.headers,
        'Authorization': 'Bearer $authToken',
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: true,
    );
  }

  dynamic openTopics(dynamic response) => getJsonField(
        response,
        r'''$.data.course.subjects.edges[:].node.openTopics.edges''',
        true,
      );

  dynamic openTopicNodes(dynamic response) => getJsonField(
        response,
        r'''$.data.course.subjects.edges[:].node.openTopics.edges[:].node''',
        true,
      );

  dynamic lockedTopicNodes(dynamic response) => getJsonField(
        response,
        r'''$.data.course.subjects.edges[:].node.lockedTopics.edges[:].node''',
        true,
      );

  dynamic lockedTopics(dynamic response) => getJsonField(
        response,
        r'''$.data.course.subjects.edges[:].node.lockedTopics.edges''',
        true,
      );

  dynamic openTopicsQuestionSetsId(dynamic response) => getJsonField(
        response,
        r'''$.data.course.subjects.edges[:].node.openTopics.edges[:].node.questionSets.edges[:].node''',
        true,
      );
  dynamic lockedTopicsQuestionSetsId(dynamic response) => getJsonField(
        response,
        r'''$.data.course.subjects.edges[:].node.lockedTopics.edges[:].node.questionSets.edges[:].node''',
        true,
      );
}

class GetPracticeTestDetailsForAnExampleSubjectAnatomyCall {
  Future<ApiCallResponse> call({
    String? testId = '',
  }) {
    final body = '''
{
  "query": "query GetTestDetail(\$id:ID){\\n    test(id:\$id) {\\n    name\\n    numQuestions\\n    sections\\n    sectionNumQues\\n  }\\n}",
  "variables": "{\\"id\\":  \\"$testId\\"}",
  "operationName": "GetTestDetail"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Get Practice Test details for an example subject Anatomy ',
      apiUrl: '${PracticeGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {
        ...PracticeGroup.headers,
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: true,
    );
  }

  dynamic sections(dynamic response) => getJsonField(
        response,
        r'''$.data.test.sections''',
        true,
      );

  dynamic sectionNumQues(dynamic response) => getJsonField(
        response,
        r'''$.data.test.sectionNumQues''',
        true,
      );

  dynamic test(dynamic response) => getJsonField(
        response,
        r'''$.data.test''',
      );

  dynamic sectionFirstQues(dynamic response) => getJsonField(
        response,
        r'''$.data.test.sections[:][1]''',
        true,
      );
}

class ResetAttemptsOfAPracticeTestShownOnClickingOnTheThreeDotsBesidesTestNameCall {
  Future<ApiCallResponse> call({
    int? selectedId,
    String? authToken = '',
  }) {
    return ApiManager.instance.makeApiCall(
      callName:
          'Reset Attempts of a Practice Test shown on clicking on the three dots besides test name ',
      apiUrl: '${PracticeGroup.baseUrl}/api/v1/user/deleteQuestionSetAttempt',
      callType: ApiCallType.POST,
      headers: {
        ...PracticeGroup.headers,
        'Authorization': 'Bearer $authToken',
      },
      params: {
        'ignoreTopic': 1,
        'selectedId': selectedId,
      },
      bodyType: BodyType.X_WWW_FORM_URL_ENCODED,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class GetPracticeQuestionsForATestGivenIdOffsetAndFirstNQuestionsCall {
  Future<ApiCallResponse> call({
    String? testId = 'VGVzdDoyMTIzNjI1',
    int? first = 400,
    int? offset = 0,
  }) {
    final body = '''
{
  "query": "query GetChunkParticularTest(\$id: ID!, \$first: Int!, \$offset: Int!) {\\n  test(id: \$id) {\\n    id\\n    numQuestions\\n    questions(orderBy: [SEQASC],first: \$first, offset:\$offset) {\\n      edges {\\n        node {\\n          id\\n          question\\n          ncert\\n          options\\n          correctOptionIndex\\n         explanation\\n         explanationWithoutAudio\\n ncertSentences(first: 10) {\\n edges { \\n node { \\n sentenceHtml \\n sentenceUrl \\n fullSentenceUrl}}}\\n questionDetails(last: 1) {\\n edges { \\n node { \\n year \\n exam}}} \\n tags {          \\n edges           {          \\n node {          \\n id          \\n tag          \\n seqId          \\n public          \\n }          \\n }          \\n }\\n bookmarkQuestion {\\n            id\\n          }\\n          userAnswer {\\n            id\\n            userAnswer\\n          }\\n                topics(first: 1) {\\n            edges {\\n              node {\\n                id\\n                name\\n              }\\n              id\\n              cursor\\n            }\\n          }\\n          analytics {\\n            correctPercentage\\n            correctAnswerCount\\n            incorrectAnswerCount\\n            option1Percentage\\n            option2Percentage\\n            option3Percentage\\n            option4Percentage\\n               \\n}          \\n        }\\n      }\\n    }\\n  }\\n}",
  "variables": "{\\"id\\":  \\"$testId\\",\\n\\"first\\":$first,\\n  \\"offset\\": $offset\\n}",
  "operationName": "GetChunkParticularTest"
}''';
    return ApiManager.instance.makeApiCall(
      callName:
          'Get Practice Questions for a test given id offset and first n questions',
      apiUrl: '${PracticeGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {
        ...PracticeGroup.headers,
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: true,
    );
  }

  dynamic testQuestions(dynamic response) => getJsonField(
        response,
        r'''$.data.test.questions.edges[:].node''',
        true,
      );
  dynamic getNcertSentenceAtIndex(
          dynamic response, int questionIndex, int sentenceIndex) =>
      getJsonField(
        response,
        r'''$.data.test.questions.edges[''' +
            questionIndex.toString() +
            r'''].node.ncertSentences.edges[:].node''',
      );
  dynamic haveNcertSentenceAtIndex(dynamic response, int questionIndex) =>
      getJsonField(
        response,
        r'''$.data.test.questions.edges[''' +
            questionIndex.toString() +
            r'''].node.ncertSentences.edges''',
      );
  dynamic ncertSentences(dynamic response) => getJsonField(
        response,
        r'''$.data.test.questions.edges[:].node.ncertSentences.edges[*].node.sentenceUrl''',
        true,
      );

  dynamic questionExams(dynamic response) => getJsonField(
        response,
        r'''$.data.test.questions.edges[:].node.questionDetails[:].edges[:].node.exam''',
        true,
      );

  dynamic testHtmlQuestionsArr(dynamic response) => getJsonField(
        response,
        r'''$.data.test.questions.edges[:].node.question''',
        true,
      );

  dynamic testQuestionIdArr(dynamic response) => getJsonField(
        response,
        r'''$.data.test.questions.edges[:].node.id''',
        true,
      );

  dynamic testHtmlExplanationsArr(dynamic response) => getJsonField(
        response,
        r'''$.data.test.questions.edges[:].node.explanation''',
        true,
      );

  dynamic testQuestionCorrectPercentages(dynamic response) {
    final questions = getJsonField(
      response,
      r'''$.data.test.questions.edges[:].node''',
      true,
    );

    if (questions is List) {
      return questions.map((question) {
        final correctPercentage = question['analytics'] != null
            ? question['analytics']['correctPercentage']
            : null;
        return correctPercentage ?? null;
      }).toList();
    } else {
      return [];
    }
  }

  dynamic testQuestionCorrectOptionIndices(dynamic response) => getJsonField(
        response,
        r'''$.data.test.questions.edges[:].node.correctOptionIndex''',
        true,
      );

  dynamic testHtmlFullExplanationsArr(dynamic response) => getJsonField(
        response,
        r'''$.data.test.questions.edges[:].node.explanation''',
        true,
      );

  dynamic testIsNcert(dynamic response) => getJsonField(
        response,
        r'''$.data.test.questions.edges[:].node.ncert''',
        true,
      );

  dynamic testIsExam(dynamic response) => getJsonList(
        response,
        r'''$.data.test.questions.edges[:].node.questionDetails.edges''',
        true,
      );

  dynamic testTags(dynamic response) => getJsonList(
        response,
        r'''$.data.test.questions.edges[:].node.tags.edges''',
        true,
      );

  dynamic testExamYear(dynamic response) => getJsonField(
        response,
        r'''$.data.test.questions.edges[:].node.questionDetails.edges[:].node.year''',
        true,
      );

  dynamic showMeNcert(dynamic response) => getJsonField(
        response,
        r'''$.data.test.questions.edges[:].node.ncertSentences.edges''',
        true,
      );
}

class GetStatusOfAllPracticeQuestionsForATestForAGivenUserCall {
  Future<ApiCallResponse> call({
    int? testIdInt,
    String? authToken =
        'eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MTcyMDU4NCwiZW1haWwiOiJ0aG9yZGV2ZWxvcGVyLnRlY2hAZ21haWwuY29tIiwiZXhwIjoxNjkxOTExOTkyLCJpYXQiOjE2NzYzNTk5OTJ9.7IHkbud_C4J72freq3HpsE2B9q5Z_K9yx9qHq4x20ys',
  }) {
    final body = '''
{
  "query": "query GetQuestionsStatus(\$testId: String) {\\n    allQuestions(testId: \$testId, strict: true, removeHooks: true) {\\n        edges {\\n            node {\\n                id\\n                correctOptionIndex\\n                userAnswer {\\n                    userAnswer\\n                durationInSec\\n                }\\n                bookmarkQuestion {\\n                    id\\n                }\\n                starmarkQuestion {\\n                    id\\n                }\\n                        }\\n        }\\n    }\\n}\\n",
  "variables": "{\\n  \\"testId\\": \\"$testIdInt\\"\\n}",
  "operationName": "GetQuestionsStatus"
}''';
    return ApiManager.instance.makeApiCall(
      callName:
          'Get Status of all Practice Questions for a test for a given user',
      apiUrl: '${PracticeGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {
        ...PracticeGroup.headers,
        'Authorization': 'Bearer $authToken',
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }

  dynamic allQuestions(dynamic response) => getJsonField(
        response,
        r'''$.data.allQuestions.edges[:].node''',
        true,
      );
}

class CreateAnswerForAPracticeQuestionByAUserWithSpecificMarkedOptionCall {
  Future<ApiCallResponse> call({
    String? questionId = 'UXVlc3Rpb246NzE3MQ==',
    String? userId = 'VXNlcjo5Nw==',
    int? userAnswer = 3,
    int? durationInSec = 0,
    String? authToken =
        'eyJhbGciOiJIUzI1NiJ9.eyJpZCI6OTcsInBob25lIjoiKzkxNzAyMjAwMTQzNSIsImV4cCI6MTY4OTQwOTQ5OSwiaWF0IjoxNjczODU3NDk5fQ.jNEEFn_BpF7JQoJEDB8lhEdKvujvuOHD12IrdP6_KFk',
  }) {
    final body = durationInSec == null || durationInSec == 0
        ? '''{
      "query": "mutation createAnswer(\$input: createAnswerInput!) {\\n    createAnswer(input: \$input) {\\n        clientMutationId\\n    \\t\\tquestion{\\n          userAnswer{\\n            userAnswer\\n          durationInSec\\n          }\\n        }\\n    }\\n}",
      "variables": "{\\n  \\"input\\": {\\n    \\"questionId\\": \\"$questionId\\",\\n    \\"userId\\": \\"$userId\\",\\n    \\"userAnswer\\": $userAnswer\\n  }\\n}",
      "operationName": "createAnswer"
    }'''
        : '''
{
  "query": "mutation createAnswer(\$input: createAnswerInput!) {\\n    createAnswer(input: \$input) {\\n        clientMutationId\\n    \\t\\tquestion{\\n          userAnswer{\\n            userAnswer\\n          durationInSec\\n          }\\n        }\\n    }\\n}",
  "variables": "{\\n  \\"input\\": {\\n    \\"questionId\\": \\"$questionId\\",\\n    \\"userId\\": \\"$userId\\",\\n    \\"durationInSec\\": \\"$durationInSec\\",\\n    \\"userAnswer\\": $userAnswer\\n  }\\n}",
  "operationName": "createAnswer"
}''';
    return ApiManager.instance.makeApiCall(
      callName:
          'Create answer for a practice question by a user with specific marked option ',
      apiUrl: '${PracticeGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {
        ...PracticeGroup.headers,
        'Authorization': 'Bearer $authToken',
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class CreateQuestionIssueReportedByAUserForAQuestionAndForAnIssueTypeCall {
  Future<ApiCallResponse> call({
    String? questionId = '',
    String? userId = '',
    String? typeId = '',
    String? authToken = '',
    String? description = '',
    String? testId = '',
  }) {
    final body = '''
{
  "query": "mutation postCustomerIssue(\$createCustomerIssueInput: createCustomerIssueInput!) {\\n    createCustomerIssue(input: \$createCustomerIssueInput) {\\n        clientMutationId\\n    }\\n}",
  "variables": "{\\n  \\"createCustomerIssueInput\\": {\\n    \\"questionId\\": \\"$questionId\\",\\n    \\"testId\\": \\"$testId\\",\\n    \\"typeId\\": \\"$typeId\\",\\n    \\"description\\": \\"$description\\",\\n    \\"userId\\": \\"$userId\\"\\n    }\\n}",
  "operationName": "postCustomerIssue"
}''';
    return ApiManager.instance.makeApiCall(
      callName:
          'Create question issue reported by a user for a question and for an issue type',
      apiUrl: '${PracticeGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {
        ...PracticeGroup.headers,
        'Authorization': 'Bearer $authToken',
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class CreateOrDeleteBookmarkForAPracticeQuestionByAUserCall {
  Future<ApiCallResponse> call({
    String? questionId = '',
    String? userId = '',
    String? authToken = '',
  }) {
    final body = '''
{
  "query": "mutation CreateBookmarkQuestionMutation(\$input: createOrDeleteBookmarkQuestionInput!) {\\n    createOrDeleteBookmarkQuestion(input: \$input) {\\n        clientMutationId\\n    \\t\\tquestion{\\n          bookmarkQuestion{\\n            userId\\n          }\\n        }\\n    }\\n}",
  "variables": "{\\n  \\"input\\": {\\n    \\"questionId\\": \\"$questionId\\",\\n    \\"userId\\": \\"$userId\\"\\n  }\\n}",
  "operationName": "CreateBookmarkQuestionMutation"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Create or delete bookmark for a practice question by a user',
      apiUrl: '${PracticeGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {
        ...PracticeGroup.headers,
        'Authorization': 'Bearer $authToken',
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class CreateOrDeleteStarmarkQuestionCall {
  Future<ApiCallResponse> call({
    required String questionId,
    required String userId,
    required String authToken,
  }) {
    final body = '''
{
  "query": "mutation CreateOrDeleteStarmarkQuestion(\$input: createOrDeleteStarmarkQuestionInput!) {\\n    createOrDeleteStarmarkQuestion(input: \$input) {\\n        clientMutationId\\n        question {\\n          id\\n          starmarkQuestion {\\n            id\\n            userId\\n          }\\n        }\\n    }\\n}",
  "variables": {
    "input": {
      "questionId": "$questionId",
      "userId": "$userId"
    }
  },
  "operationName": "CreateOrDeleteStarmarkQuestion"
}
''';

    return ApiManager.instance.makeApiCall(
      callName: 'Create or delete starmark for a question by a user',
      apiUrl: '${PracticeGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {
        ...PracticeGroup.headers,
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class CreateOrDeleteStarMarkForAPracticeQuestionByAUserCall {
  Future<ApiCallResponse> call({
    String? questionId = '',
    String? userId = '',
    String? authToken = '',
  }) {
    final body = '''
{
  "query": "mutation CreateBookmarkQuestionMutation(\$input: createOrDeleteBookmarkQuestionInput!) {\\n    createOrDeleteBookmarkQuestion(input: \$input) {\\n        clientMutationId\\n    \\t\\tquestion{\\n          bookmarkQuestion{\\n            userId\\n          }\\n        }\\n    }\\n}",
  "variables": "{\\n  \\"input\\": {\\n    \\"questionId\\": \\"$questionId\\",\\n    \\"userId\\": \\"$userId\\"\\n  }\\n}",
  "operationName": "CreateBookmarkQuestionMutation"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Create or delete bookmark for a practice question by a user',
      apiUrl: '${PracticeGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {
        ...PracticeGroup.headers,
        'Authorization': 'Bearer $authToken',
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class GetQuestionIssueListForIssueReportingCall {
  Future<ApiCallResponse> call() {
    final body = '''
{
  "query": "query GetCustomerIssue(\$focusArea: FocusArea!) {\\n    getCustomerIssueTypes(focusArea: \$focusArea, removeExplanationIssue: true) {\\n        code\\n        id\\n        displayName\\n        description\\n        focusArea\\n    }\\n}",
  "variables": "{\\n  \\"focusArea\\": \\"question\\"\\n}",
  "operationName": "GetCustomerIssue"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Get question issue list for Issue reporting',
      apiUrl: '${PracticeGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {
        ...PracticeGroup.headers,
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: true,
    );
  }

  dynamic questionIssueTypes(dynamic response) => getJsonField(
        response,
        r'''$.data.getCustomerIssueTypes''',
        true,
      );
}

class GetAllQuestionStatusGivenTestIDCall {
  Future<ApiCallResponse> call({
    String? authToken = '',
    int? testIdInt,
  }) {
    final body = '''
{
  "query": " { allQuestions(testId: \\"$testIdInt\\", strict: true, removeHooks: true, bookmark:true) { edges { node { id correctOptionIndex question explanation userAnswer { userAnswer } bookmarkQuestion { id } } } } }"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Get All Question Status Given Test ID',
      apiUrl: '${PracticeGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {
        ...PracticeGroup.headers,
        'Authorization': 'Bearer $authToken',
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }

  dynamic bookQues(dynamic response) => getJsonField(
        response,
        r'''$.data.allQuestions.edges[:].node''',
        true,
      );
}

/// End Practice Group Code

/// Start Flashcard Group Code

class FlashcardGroup {
  static String baseUrl = FFAppState().baseUrl;
  static Map<String, String> headers = {};
  static GetDecksToShowChapterWiseCall getDecksToShowChapterWiseCall =
      GetDecksToShowChapterWiseCall();
  static GetDeckDetailsByDeckIdCall getDeckDetailsByDeckIdCall =
      GetDeckDetailsByDeckIdCall();
  static GetBookmarkedDeckDetailsByDeckIdCall
      getBookmarkedDeckDetailsByDeckIdCall =
      GetBookmarkedDeckDetailsByDeckIdCall();
  static GetFlashcardsForDeckGivenIdOffsetAndFirstNLimitCall
      getFlashcardsForDeckGivenIdOffsetAndFirstNLimitCall =
      GetFlashcardsForDeckGivenIdOffsetAndFirstNLimitCall();
  static GetFlashcardQuestionsForPracticeCall
      getFlashcardQuestionsForPracticeCall =
      GetFlashcardQuestionsForPracticeCall();
  static CreateOrDeleteBookmarkForAFlashcardByAUserCall
      createOrDeleteBookmarkForAFlashcardByAUserCall =
      CreateOrDeleteBookmarkForAFlashcardByAUserCall();
  static GetBookmarkedFlashcardsForDeckGivenIdOffsetAndFirstNLimitCall
      getBookmarkedFlashcardsForDeckGivenIdOffsetAndFirstNLimitCall =
      GetBookmarkedFlashcardsForDeckGivenIdOffsetAndFirstNLimitCall();
}

class GetDecksToShowChapterWiseCall {
  Future<ApiCallResponse> call(
      {String? courseId = 'Q291cnNlOjMxMjU=',
      int? limit = 10,
      int? subjectOffset = 0,
      int? topicOffset = 0}) {
    final body = '''
{
  "query": "query GetDeckList(\$id: ID) {\\n  course(id: \$id) {\\n    subjects(offset:$subjectOffset){\\n      edges{\\n        node{\\n          topics(orderBy: [SEQID, ID],offset:$topicOffset){\\n            edges{\\n              node{\\n                name\\n                decks (orderBy:SEQID){\\n                  edges{\\n                    node{\\n                      id\\n                      name\\n                      sections\\n                      numCards\\n                    }\\n                  }\\n                }\\n              }\\n            }\\n          }\\n        }\\n      }\\n    }\\n  }\\n}",
  "variables": "{\\"id\\": \\"$courseId\\"}",
  "operationName": "GetDeckList"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Get Deck List',
      apiUrl: '${FlashcardGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {...FlashcardGroup.headers},
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: true,
    );
  }

  dynamic topicNodes(dynamic response) => getJsonField(
        response,
        r'''$.data.course.subjects.edges[:].node.topics.edges[:].node''',
        true,
      );

  dynamic topicNames(dynamic response) => getJsonField(
        response,
        r'''$.data.course.subjects.edges[:].node.topics.edges[:].node.name''',
        true,
      );

  dynamic allSubTopicName(dynamic response) => getJsonField(
        response,
        r'''$.data.course.subjects.edges[:].node.topics.edges[:].node.decks.edges[:].node.name''',
        true,
      );

  dynamic allChapterWithId(dynamic response) => getJsonField(
        response,
        r'''$.data.course.subjects.edges[:].node.topics.edges[:].node.decks.edges[:].node''',
        true,
      );
}

class GetDeckDetailsByDeckIdCall {
  Future<ApiCallResponse> call({
    String? deckId = '',
  }) {
    final body = '''
{
  "query": "query GetDeckDetail(\$id:ID){\\n    deck(id:\$id) {\\n    name\\n    numCards\\n    sections\\n    sectionNumQues\\n  }\\n}",
  "variables": "{\\"id\\":  \\"$deckId\\"}",
  "operationName": "GetDeckDetail"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Get Practice Test details for an example subject Anatomy ',
      apiUrl: '${PracticeGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {
        ...FlashcardGroup.headers,
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: true,
    );
  }

  dynamic sections(dynamic response) => getJsonField(
        response,
        r'''$.data.deck.sections''',
        true,
      );

  dynamic sectionNumQues(dynamic response) => getJsonField(
        response,
        r'''$.data.deck.sectionNumQues''',
        true,
      );

  dynamic deck(dynamic response) => getJsonField(
        response,
        r'''$.data.deck''',
      );

  dynamic sectionFirstQues(dynamic response) => getJsonField(
        response,
        r'''$.data.deck.sections[:][1]''',
        true,
      );
}

class GetBookmarkedDeckDetailsByDeckIdCall {
  Future<ApiCallResponse> call({String? deckId = '', String? authToken = ''}) {
    final body = '''
{
  "query": "query GetDeckDetail(\$id: ID){\\n    deck(id:\$id) {\\n    name\\n    numCards\\n    sections\\n    sectionNumQues\\n    cards(orderBy: [SEQASC],bookmark:true) {\\n      total\\n      edges {\\n        node {\\n          id\\n          title\\n          content\\n            questionId\\n            contentWoQuetion\\n            bookmark {\\n            id\\n          }\\n                  }\\n    }\\n}                  }\\n    }",
  "variables": "{\\"id\\": \\"$deckId\\"}",
  "operationName": "GetDeckDetail"
}
''';
    return ApiManager.instance.makeApiCall(
      callName: 'Get Practice Test details for an example subject Anatomy ',
      apiUrl: '${FlashcardGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {
        ...FlashcardGroup.headers,
        'Authorization': 'Bearer $authToken',
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: true,
    );
  }

  dynamic deckCards(dynamic response) => getJsonField(
        response,
        r'''$.data.deck.cards.edges[:].node''',
        true,
      );

  dynamic numBookmarkCards(dynamic response) => getJsonField(
        response,
        r'''$.data.deck.cards.total''',
        false,
      );
}

class GetFlashcardsForDeckGivenIdOffsetAndFirstNLimitCall {
  Future<ApiCallResponse> call({
    String? deckId = 'RGVjazoy',
    int? first = 400,
    int? offset = 0,
  }) {
    final body = '''
{
  "query": "query GetDeckCards(\$id: ID!, \$first: Int!, \$offset: Int!) {\\n  deck(id: \$id) {\\n    id\\n    numCards\\n     sectionNumQues\\n    cards(orderBy: [SEQASC],first: \$first, offset:\$offset) {\\n      edges {\\n        node {\\n          id\\n          title\\n          content\\n            questionId\\n            contentWoQuetion\\n            bookmark {\\n            id\\n          }\\n                  }\\n      }\\n    }\\n  }\\n}",
  "variables": "{\\"id\\":  \\"$deckId\\",\\n\\"first\\":$first,\\n  \\"offset\\": $offset\\n}",
  "operationName": "GetDeckCards"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Get flashcards for a deck given id offset and first n limit',
      apiUrl: '${FlashcardGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {
        ...FlashcardGroup.headers,
        'Authorization': 'Bearer ' + FFAppState().subjectToken,
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: true,
    );
  }

  dynamic deckCards(dynamic response) => getJsonField(
        response,
        r'''$.data.deck.cards.edges[:].node''',
        true,
      );

  dynamic deckCardTitleArr(dynamic response) => getJsonField(
        response,
        r'''$.data.deck.cards.edges[:].node.title''',
        true,
      );

  dynamic deckCardIdArr(dynamic response) => getJsonField(
        response,
        r'''$.data.deck.cards.edges[:].node.id''',
        true,
      );

  dynamic deckCardContentArr(dynamic response) => getJsonField(
        response,
        r'''$.data.deck.cards.edges[:].node.content''',
        true,
      );

  dynamic deckCardContentWoQuestionArr(dynamic response) => getJsonField(
        response,
        r'''$.data.deck.cards.edges[:].node.contentWoQuetion''',
        true,
      );

  dynamic deckCardQuestionIdArr(dynamic response) => getJsonField(
        response,
        r'''$.data.deck.cards.edges[:].node.questionId''',
        true,
      );

  dynamic allCardsInDeck(dynamic response) => getJsonField(
        response,
        r'''$.data.deck.cards.edges[:].node.bookmark''',
        true,
      );
}

class GetFlashcardQuestionsForPracticeCall {
  Future<ApiCallResponse> call({
    String? questionId = '',
    String? authToken = '',
  }) {
    final params = {
      "query": '''
{
      question(id: "$questionId") {
        question
        correctOptionIndex
        explanation
        options
        userAnswer {
          userAnswer
        }
        bookmarkQuestion {
          userId
        }
        ncert
        correctOptionIndex
        analytics{
        option2Percentage
        option1Percentage
        option3Percentage
        option4Percentage
      }
        questionDetails(last: 1) {
          edges { 
            node { 
               year 
               exam
             }
            }
          }
      }
    }
    '''
    };

    return ApiManager.instance.makeApiCall(
      callName: 'Get recommended questions for practice',
      apiUrl: '${TestGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {
        ...TestGroup.headers,
        'Authorization': 'Bearer $authToken',
      },
      params: params,
      body: null,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class CreateOrDeleteBookmarkForAFlashcardByAUserCall {
  Future<ApiCallResponse> call({
    String? cardId = '',
    String? userId = '',
    String? authToken = '',
  }) {
    final body = '''
{
  "query": "mutation CreateUserCardMutation(\$input: createOrDeleteUserCardInput!) {\\n    createOrDeleteUserCard(input: \$input) {\\n        clientMutationId\\n    \\t\\tcard{\\n          id\\n          content\\n         bookmark{\\n            userId\\n          }\\n        }\\n    }\\n}",
  "variables": "{\\n  \\"input\\": {\\n    \\"flashCardId\\": \\"$cardId\\",\\n    \\"userId\\": \\"$userId\\"\\n  }\\n}",
  "operationName": "CreateUserCardMutation"
}''';

    return ApiManager.instance.makeApiCall(
      callName: 'Create or delete bookmark for a  flashcard by a user',
      apiUrl: '${FlashcardGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {
        ...FlashcardGroup.headers,
        'Authorization': 'Bearer $authToken',
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class GetBookmarkedFlashcardsForDeckGivenIdOffsetAndFirstNLimitCall {
  Future<ApiCallResponse> call({
    String? deckId = 'RGVjazoy',
    int? first = 800,
    int? offset = 0,
  }) {
    final body = '''
{
  "query": "query GetDeckCards(\$id: ID!, \$first: Int!, \$offset: Int!) {\\n  deck(id: \$id) {\\n    id\\n    numCards\\n     sectionNumQues\\n    cards(orderBy: [SEQASC],first: \$first, offset:\$offset, bookmark:true) {\\n        total       edges {\\n        node {\\n          id\\n          title\\n          content\\n            questionId\\n            contentWoQuetion\\n            bookmark {\\n            id\\n          }\\n                  }\\n      }\\n    }\\n  }\\n}",
  "variables": "{\\"id\\":  \\"$deckId\\",\\n\\"first\\":$first,\\n  \\"offset\\": $offset\\n}",
  "operationName": "GetDeckCards"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Get flashcards for a deck given id offset and first n limit',
      apiUrl: '${FlashcardGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {
        ...FlashcardGroup.headers,
        'Authorization': 'Bearer ' + FFAppState().subjectToken,
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }

  dynamic deckCards(dynamic response) => getJsonField(
        response,
        r'''$.data.deck.cards.edges[:].node''',
        true,
      );

  dynamic deckCardTitleArr(dynamic response) => getJsonField(
        response,
        r'''$.data.deck.cards.edges[:].node.title''',
        true,
      );

  dynamic deckCardIdArr(dynamic response) => getJsonField(
        response,
        r'''$.data.deck.cards.edges[:].node.id''',
        true,
      );

  dynamic deckCardContentArr(dynamic response) => getJsonField(
        response,
        r'''$.data.deck.cards.edges[:].node.content''',
        true,
      );

  dynamic deckCardContentWoQuestionArr(dynamic response) => getJsonField(
        response,
        r'''$.data.deck.cards.edges[:].node.contentWoQuetion''',
        true,
      );

  dynamic deckCardQuestionIdArr(dynamic response) => getJsonField(
        response,
        r'''$.data.deck.cards.edges[:].node.questionId''',
        true,
      );

  dynamic allCardsInDeck(dynamic response) => getJsonField(
        response,
        r'''$.data.deck.cards.edges[:].node''',
        true,
      );
}

/// End Flashcard Group Code

/// Start Test Group Code

class TestGroup {
  static String baseUrl = FFAppState().baseUrl;
  static Map<String, String> headers = {};
  static ListOfCustomCreatedTestsByTheUserOrderedByDateOfCreationDescendingCall
      listOfCustomCreatedTestsByTheUserOrderedByDateOfCreationDescendingCall =
      ListOfCustomCreatedTestsByTheUserOrderedByDateOfCreationDescendingCall();
  static GetTestDetailsForSingleTestForTheStartTestPageCall
      getTestDetailsForSingleTestForTheStartTestPageCall =
      GetTestDetailsForSingleTestForTheStartTestPageCall();
  static GetPreviousYearTestsInTestsTabCall getPreviousYearTestsInTestsTabCall =
      GetPreviousYearTestsInTestsTabCall();
  static GetSubjectsAndChaptersForTheCustomTestCreationUsingQuestionsFromChosenSubjectsAndChaptersCall
      getSubjectsAndChaptersForTheCustomTestCreationUsingQuestionsFromChosenSubjectsAndChaptersCall =
      GetSubjectsAndChaptersForTheCustomTestCreationUsingQuestionsFromChosenSubjectsAndChaptersCall();
  static CreateCustomTestAsPerSelectedParametersCall
      createCustomTestAsPerSelectedParametersCall =
      CreateCustomTestAsPerSelectedParametersCall();
  static UpdateTestAttemptForATestByAUserBasedOnQuestionsAttemptedAndTimeSpendEtcCall
      updateTestAttemptForATestByAUserBasedOnQuestionsAttemptedAndTimeSpendEtcCall =
      UpdateTestAttemptForATestByAUserBasedOnQuestionsAttemptedAndTimeSpendEtcCall();
  static GetCompletedTestAttemptDataWithTestResultForATestAttemptCall
      getCompletedTestAttemptDataWithTestResultForATestAttemptCall =
      GetCompletedTestAttemptDataWithTestResultForATestAttemptCall();
  static CreateTestAttemptForATestByAUserCall
      createTestAttemptForATestByAUserCall =
      CreateTestAttemptForATestByAUserCall();
}

class ListOfCustomCreatedTestsByTheUserOrderedByDateOfCreationDescendingCall {
  Future<ApiCallResponse> call({
    String? authToken =
        'eyJhbGciOiJIUzI1NiJ9.eyJpZCI6OTcsInBob25lIjoiKzkxNzAyMjAwMTQzNSIsImV4cCI6MTY4OTQwOTQ5OSwiaWF0IjoxNjczODU3NDk5fQ.jNEEFn_BpF7JQoJEDB8lhEdKvujvuOHD12IrdP6_KFk',
    int? first = 10,
    int? offset = 0,
    String? courseId = 'Q291cnNlOjIwNjk=',
  }) {
    final body = '''
{
  "query": "query GetCustomTests(\$first: Int!, \$offset: Int!, \$courseId: ID!) {\\n  course(id: \$courseId) {\\n    customTests(orderBy: [IDDESC], first: \$first, offset: \$offset) {\\n      edges {\\n        node {\\n          id\\n          name\\n          durationInMin\\n          numQuestions\\n          resumeAttempt {\\n            id\\n          }\\n          completedAttempt {\\n            id\\n            completed\\n          }\\n        }\\n      }\\n    }\\n  }\\n}\\n",
  "variables": "{\\n  \\"first\\": $first,\\n  \\"offset\\": $offset\\n,\\n  \\"courseId\\": \\"$courseId\\"\\n}",
  "operationName": "GetCustomTests"
}''';
    return ApiManager.instance.makeApiCall(
      callName:
          'List of custom created tests by the user ordered by date of creation descending ',
      apiUrl: '${TestGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {
        ...TestGroup.headers,
        'Authorization': 'Bearer $authToken',
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }

  dynamic myCustomTestNodes(dynamic response) => getJsonField(
        response,
        r'''$.data.course.customTests.edges''',
        true,
      );

  dynamic myCustomTests(dynamic response) => getJsonField(
        response,
        r'''$.data.course.customTests.edges[:].node''',
        true,
      );
}

class GetTestDetailsForSingleTestForTheStartTestPageCall {
  Future<ApiCallResponse> call({
    String? authToken = '',
    String? testId = '',
  }) {
    final body = '''
{
  "query": "query GetTest(\$id: ID!) {test(id: \$id){id\\n          name\\n          pdfURL\\n          durationInMin\\n          numQuestions\\n          canReview\\n          startedAt\\n          canStart\\n          maxMarks\\n          positiveMarks\\n          resumeAttempt {\\n            id\\n          }\\n          completedAttempt {\\n            id\\n            completed\\n          }\\n        }\\n }\\n",
  "variables": "{\\"id\\": \\"$testId\\"}",
  "operationName": "GetTest"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Get test details for single test for the start test page',
      apiUrl: '${TestGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {
        ...TestGroup.headers,
        'Authorization': 'Bearer $authToken',
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }

  dynamic completedAttemptId(dynamic response) => getJsonField(
        response,
        r'''$.data.test.completedAttempt.id''',
      );

  dynamic numQuestions(dynamic response) => getJsonField(
        response,
        r'''$.data.test.numQuestions''',
      );

  dynamic durationInMin(dynamic response) => getJsonField(
        response,
        r'''$.data.test.durationInMin''',
      );

  dynamic testName(dynamic response) => getJsonField(
        response,
        r'''$.data.test.name''',
      );

  dynamic testId(dynamic response) => getJsonField(
        response,
        r'''$.data.test.id''',
      );

  dynamic test(dynamic response) => getJsonField(
        response,
        r'''$.data.test''',
      );

  dynamic resumeAttemptId(dynamic response) => getJsonField(
        response,
        r'''$.data.test.resumeAttempt.id''',
      );

  dynamic positiveMarksPerQ(dynamic response) => getJsonField(
        response,
        r'''$.data.test.positiveMarks''',
      );

  dynamic canReview(dynamic response) => getJsonField(
        response,
        r'''$.data.test.canReview''',
      );

  dynamic canStart(dynamic response) => getJsonField(
        response,
        r'''$.data.test.canStart''',
      );

  dynamic startedAt(dynamic response) => getJsonField(
        response,
        r'''$.data.test.startedAt''',
      );

  dynamic pdfURL(dynamic response) => getJsonField(
        response,
        r'''$.data.test.pdfURL''',
      );
}

class GetPreviousYearTestsInTestsTabCall {
  Future<ApiCallResponse> call({
    String? courseId = '',
    String? authToken = '',
  }) {
    final body = '''
{
  "query": "query GetPracticeModeTestList(\$id: ID!) {me{\\nid\\n}\\n  course(id: \$id) {\\n    tests(orderBy: [STARTEDAT, SEQID, ID]) {\\n      total\\n      edges {\\n        node {\\n          id\\n          name\\n          syllabus\\n          canStart\\n          startedAt\\n           free\\n          numQuestions\\n          positiveMarks\\n          durationInMin\\n   resumeAttempt {\\n            id\\n          }\\n   completedAttempt {\\n            id\\n            completed\\n          }\\n     }\\n      }\\n    }\\n  }\\n}\\n",
  "variables": "{\\"id\\": \\"$courseId\\"}",
  "operationName": "GetPracticeModeTestList"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Get previous year tests in tests tab',
      apiUrl: '${TestGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {
        ...TestGroup.headers,
        'Authorization': 'Bearer $authToken',
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: true,
    );
  }

  dynamic previousTest(dynamic response) => getJsonField(
        response,
        r'''$.data.course.tests.edges[:].node''',
        true,
      );
}

class GetSubjectsAndChaptersForTheCustomTestCreationUsingQuestionsFromChosenSubjectsAndChaptersCall {
  Future<ApiCallResponse> call({
    String? courseId = 'Q291cnNlOjIxMzU=',
  }) {
    final body = '''
{
  "query": "query GetCourseSubjectAndTopicList(\$id: ID!) {\\n  course(id: \$id) {\\n    subjects {\\n      total\\n      edges {\\n        node {\\n          id\\n          name\\n          topics(orderBy: SEQID) {\\n            total\\n            edges {\\n              node {\\n                id\\n                name\\n                duplicateChapter{\\n origId}\\n              }\\n            }\\n          }\\n        }\\n      }\\n    }\\n  }\\n}",
  "variables": "{\\n  \\"id\\": \\"$courseId\\"\\n}",
  "operationName": "GetCourseSubjectAndTopicList"
}''';
    return ApiManager.instance.makeApiCall(
      callName:
          'Get subjects and chapters for the custom test creation using questions from chosen subjects and chapters',
      apiUrl: '${TestGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {
        ...TestGroup.headers,
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: true,
    );
  }

  dynamic subjectWithChapters(dynamic response) => getJsonField(
        response,
        r'''$.data.course.subjects.edges[:].node''',
        true,
      );

  dynamic chapters(dynamic response) => getJsonField(
        response,
        r'''$.data.course.subjects.edges[:].node.topics.edges[:].node''',
        true,
      );
}

class CreateCustomTestAsPerSelectedParametersCall {
  Future<ApiCallResponse> call({
    int? numQuestions,
    dynamic topicIdsJson,
    dynamic subjectIdsJson,
    int? includeBookmarks,
    String? authToken = '',
    String? selectedExam = 'BOTH',
    int? durationInMin,
    int? courseId,
  }) {
    final topicIds = _serializeJson(topicIdsJson);
    final subjectIds = _serializeJson(subjectIdsJson);
    final body = '''
{
  "num_questions": $numQuestions,
  "topic_ids": $topicIds,
  "subject_ids": $subjectIds,
  "include_bookmarks": $includeBookmarks,
  "selected_exam": "$selectedExam",
  "duration_in_min": $durationInMin,
  "course_id": $courseId
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Create custom test as per selected parameters',
      apiUrl: '${TestGroup.baseUrl}/create_custom_test',
      callType: ApiCallType.POST,
      headers: {
        ...TestGroup.headers,
        'Authorization': 'Bearer $authToken',
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class UpdateTestAttemptForATestByAUserBasedOnQuestionsAttemptedAndTimeSpendEtcCall {
  Future<ApiCallResponse> call({
    String? testId = '',
    String? userId = '',
    String? authToken = '',
    String? testAttemptId = '',
    String? userAnswersJsonStr = '',
    String? userQuestionWiseDurationInSecJsonStr = '',
    String? visitedQuestionsJsonStr = '',
    String? markedQuestionsJsonStr = '',
    int? elapsedDurationInSec,
    int? currentQuestionOffset,
    bool? completed,
  }) {
    final body = '''
{
  "query": "mutation updateTestAttempt(\$updateTestAttemptInput: updateTestAttemptInput!) {\\n  updateTestAttempt(input: \$updateTestAttemptInput) {\\n    clientMutationId\\n,    newTestAttempt{\\n     id, result\\n    }\\n    }\\n}\\n",
  "variables": "{\\n  \\"updateTestAttemptInput\\": {\\n    \\"id\\":\\"$testAttemptId\\",\\n    \\"values\\": {\\n    \\t\\"testId\\": \\"$testId\\",\\n      \\"userId\\": \\"$userId\\",\\n      \\"userAnswers\\": $userAnswersJsonStr,\\n      \\"userQuestionWiseDurationInSec\\":$userQuestionWiseDurationInSecJsonStr ,\\n      \\"visitedQuestions\\": $visitedQuestionsJsonStr,\\n      \\"markedQuestions\\": $markedQuestionsJsonStr,\\n      \\"elapsedDurationInSec\\": $elapsedDurationInSec,\\n      \\"currentQuestionOffset\\": $currentQuestionOffset,\\n      \\"completed\\": $completed\\n   }\\n  }\\n}",
  "operationName": "updateTestAttempt"
}''';
    return ApiManager.instance.makeApiCall(
      callName:
          'update test attempt for a test by a user based on questions attempted and time spend etc ',
      apiUrl: '${TestGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {
        ...TestGroup.headers,
        'Authorization': 'Bearer $authToken',
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class GetCompletedTestAttemptDataWithTestResultForATestAttemptCall {
  Future<ApiCallResponse> call({
    String? testAttemptId = '',
    String? authToken = '',
  }) {
    final body = '''
{
  "query": "query GetTestAttemptDetailsQuery(\$id: ID!) {\\n  testAttempt(id: \$id) {\\n    id\\n    elapsedDurationInSec\\n    result\\n    userQuestionWiseDurationInSec\\n    userAnswers\\n    createdAt\\n    completed\\n    detail {\\n      showAnswer\\n     queStatusArr\\n    }\\n    test {\\n      id\\n      name\\n      durationInMin\\n      resultMsgHtml\\n      canReview\\n      reviewAt\\n      numQuestions\\n      positiveMarks\\n      maxMarks\\n questions(first: 400, orderBy: SEQASC){\\n edges{\\n node{\\n bookmarkQuestion{\\n  id}\\n id\\n, question\\n correctOptionIndex\\n explanation\\n explanationWithoutAudio\\n  analytics{\\n correctPercentage, option1Percentage, option2Percentage, option3Percentage, option4Percentage}}}}       myRank {\\n        rank\\n        testAttemptId\\n        id\\n      }\\n      toppers {\\n        total\\n      }\\n    }\\n  }\\n}",
  "variables": "{\\n  \\"id\\": \\"$testAttemptId\\"\\n}",
  "operationName": "GetTestAttemptDetailsQuery"
}''';
    return ApiManager.instance.makeApiCall(
      callName:
          'Get completed test attempt data with test result for a test attempt',
      apiUrl: '${TestGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {
        ...TestGroup.headers,
        'Authorization': 'Bearer $authToken',
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }

  dynamic correctAnswerCount(dynamic response) => getJsonField(
        response,
        r'''$.data.testAttempt.result.correctAnswerCount''',
      );

  dynamic incorrectAnswerCount(dynamic response) => getJsonField(
        response,
        r'''$.data.testAttempt.result.incorrectAnswerCount''',
      );

  dynamic totalMarks(dynamic response) => getJsonField(
        response,
        r'''$.data.testAttempt.result.totalMarks''',
      );

  dynamic elapsedDurationInSec(dynamic response) => getJsonField(
        response,
        r'''$.data.testAttempt.elapsedDurationInSec''',
      );

  dynamic rank(dynamic response) => getJsonField(
        response,
        r'''$.data.testAttempt.test.myRank.rank''',
      );

  dynamic toppers(dynamic response) => getJsonField(
        response,
        r'''$.data.testAttempt.test.toppers.total''',
      );

  dynamic questionsList(dynamic response) => getJsonField(
        response,
        r'''$.data.testAttempt.test.questions.edges[:].node''',
        true,
      );

  dynamic bookmarkIdsList(dynamic response) => getJsonField(
        response,
        r'''$.data.testAttempt.test.bookmarkQuestion.edges[:].node.id''',
        true,
      );

  dynamic userAnswers(dynamic response) => getJsonField(
        response,
        r'''$.data.testAttempt.userAnswers''',
      );

  dynamic showAnswer(dynamic response) => getJsonField(
        response,
        r'''$.data.testAttempt.detail.showAnswer''',
      );

  dynamic testName(dynamic response) => getJsonField(
        response,
        r'''$.data.testAttempt.test.name''',
      );

  dynamic createdAt(dynamic response) => getJsonField(
        response,
        r'''$.data.testAttempt.createdAt''',
      );

  dynamic completed(dynamic response) => getJsonField(
        response,
        r'''$.data.testAttempt.completed''',
      );

  dynamic questionsStatus(dynamic response) => getJsonField(
        response,
        r'''$.data.testAttempt.detail.queStatusArr''',
        true,
      );

  dynamic numQuestions(dynamic response) => getJsonField(
        response,
        r'''$.data.testAttempt.test.numQuestions''',
      );

  dynamic testAttemptDetail(dynamic response) => getJsonField(
        response,
        r'''$.data.testAttempt.detail''',
      );

  dynamic questionIdsList(dynamic response) => getJsonField(
        response,
        r'''$.data.testAttempt.test.questions.edges[:].node.id''',
        true,
      );

  dynamic durationInMin(dynamic response) => getJsonField(
        response,
        r'''$.data.testAttempt.test.durationInMin''',
      );

  dynamic userQuestionWiseDurationInSec(dynamic response) => getJsonField(
        response,
        r'''$.data.testAttempt.userQuestionWiseDurationInSec''',
      );

  dynamic canReview(dynamic response) => getJsonField(
        response,
        r'''$.data.testAttempt.test.canReview''',
      );

  dynamic reviewAt(dynamic response) => getJsonField(
        response,
        r'''$.data.testAttempt.test.reviewAt''',
      );

  dynamic testId(dynamic response) => getJsonField(
        response,
        r'''$.data.testAttempt.test.id''',
      );

  dynamic sectionWiseMarks(dynamic response) => getJsonField(
        response,
        r'''$.data.testAttempt.result.sections''',
      );
}

class CreateTestAttemptForATestByAUserCall {
  Future<ApiCallResponse> call({
    String? testId = '',
    String? userId = '',
    String? authToken = '',
  }) {
    final body = '''
{
  "query": "mutation createTestAttempt(\$createTestAttemptInput: createTestAttemptInput!) {\\n  createTestAttempt(input: \$createTestAttemptInput) {\\n    clientMutationId\\n    newTestAttempt {\\n      id\\n    }\\n  }\\n}",
  "variables": "{\\n  \\"createTestAttemptInput\\": {\\n    \\"testId\\": \\"$testId\\",\\n    \\"userId\\": \\"$userId\\"\\n  }\\n}",
  "operationName": "createTestAttempt"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Create test attempt for a test by a user',
      apiUrl: '${TestGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {
        ...TestGroup.headers,
        'Authorization': 'Bearer $authToken',
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }

  dynamic testAttemptId(dynamic response) => getJsonField(
        response,
        r'''$.data.createTestAttempt.newTestAttempt.id''',
      );
}

/// End Test Group Code

/// Start Notes Group Code

class NotesGroup {
  static String baseUrl = FFAppState().baseUrl;
  static Map<String, String> headers = {};
  static GetCourseNotesWhichHaveExternalUrlAsLinksForDownloadingPdfCall
      getCourseNotesWhichHaveExternalUrlAsLinksForDownloadingPdfCall =
      GetCourseNotesWhichHaveExternalUrlAsLinksForDownloadingPdfCall();
}

class GetCourseNotesWhichHaveExternalUrlAsLinksForDownloadingPdfCall {
  Future<ApiCallResponse> call({
    String? courseId = '',
  }) {
    final body = '''
{
  "query": "query GetCoursePdfList(\$id: ID!) {\\n  course(id: \$id) {\\n    notes {\\n      total\\n      edges {\\n        node {\\n          id\\n          name\\n          externalURL\\n          free\\n        }\\n      }\\n    }\\n  }\\n}",
  "variables": "{\\n  \\"id\\": \\"$courseId\\"\\n}",
  "operationName": "GetCoursePdfList"
}''';
    return ApiManager.instance.makeApiCall(
      callName:
          'Get Course Notes which have external url as links for downloading pdf ',
      apiUrl: '${NotesGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {
        ...NotesGroup.headers,
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: true,
    );
  }

  dynamic notes(dynamic response) => getJsonField(
        response,
        r'''$.data.course.notes.edges[:].node''',
        true,
      );
}

/// End Notes Group Code

/// Start Signup Group Code

class SignupGroup {
  static String baseUrl = FFAppState().baseUrl;
  static Map<String, String> headers = {};
  static LoggedInUserInformationAndCourseAccessCheckingApiCall
      loggedInUserInformationAndCourseAccessCheckingApiCall =
      LoggedInUserInformationAndCourseAccessCheckingApiCall();
  static LoggedInUserInformationAndMultipleCourseAccessCheckingApiCall
      loggedInUserInformationAndMultipleCourseAccessCheckingApiCall =
      LoggedInUserInformationAndMultipleCourseAccessCheckingApiCall();
  static GoogleLoginServerCallWithCodeReceivedFromGoogleAuthenticationCall
      googleLoginServerCallWithCodeReceivedFromGoogleAuthenticationCall =
      GoogleLoginServerCallWithCodeReceivedFromGoogleAuthenticationCall();
  static CreateOrUpdateUserProfile createOrUpdateUserProfile =
      CreateOrUpdateUserProfile();
  static CreateOrUpdateUserProfile2 createOrUpdateUserProfile2 =
      CreateOrUpdateUserProfile2();
  static GetUserInformationApiCall getUserInformationApiCall =
      GetUserInformationApiCall();
}

class LoggedInUserInformationAndCourseAccessCheckingApiCall {
  Future<ApiCallResponse> call({
    String? authToken = '',
    int? courseIdInt,
    String? altCourseIds = '',
  }) {
    final body = '''
{
  "query": "query GetMe {\\n  me {\\n    phone\\n      phoneConfirmed\\n      profile {\\n      id\\n      displayName\\n      picture\\n      email\\n    phone\\n      city\\n      state\\n      neetExamYear\\n      courseStatus\\n      }\\n    userCourses(where: {courseId: [$courseIdInt, $altCourseIds]}) {\\n      edges {\\n        node {\\n          expiryAt\\n        trial\\n        freeChapters\\n        }\\n      }\\n    }\\n  }\\n}",
  "variables": "",
  "operationName": "GetMe"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Logged in user information and course access checking api ',
      apiUrl: '${SignupGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {
        ...SignupGroup.headers,
        'Authorization': 'Bearer $authToken',
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: true,
    );
  }

  dynamic me(dynamic response) => getJsonField(
        response,
        r'''$.data.me''',
      );

  dynamic courseStatus(dynamic response) => getJsonField(
        response,
        r'''$.data.me.profile.courseStatus''',
      );
  dynamic freeChapters(dynamic response) => getJsonField(
        response,
        r'''$.data.me.userCourses.edges[:].node.freeChapters''',
        true,
      );
  dynamic courses(dynamic response) => getJsonField(
        response,
        r'''$.data.me.userCourses.edges''',
        true,
      );
  dynamic expiryCourse(dynamic response) => getJsonField(
        response,
        r'''$.data.me.userCourses.edges[:].node''',
        true,
      );
  dynamic expiryDate(dynamic response) => getJsonField(
        response,
        r'''$.data.me.userCourses.edges[:].node.expiryAt''',
        false,
      );
  dynamic courseStatusForSpecificId(dynamic response, int courseId) {
    final courseStatus = getJsonField(
      response,
      r'''$.data.me.profile.courseStatus''',
    );

    // Check if the courseStatus contains the specific course ID
    if (courseStatus is Map && courseStatus.containsKey(courseId.toString())) {
      return courseStatus[courseId.toString()];
    }
    return null; // Return null if the course ID is not found
  }

  dynamic phoneConfirmed(dynamic response) => getJsonField(
        response,
        r'''$.data.me.phoneConfirmed''',
        false,
      );
  dynamic phone(dynamic response) => getJsonField(
        response,
        r'''$.data.me.phone''',
        false,
      );
}

class LoggedInUserInformationAndMultipleCourseAccessCheckingApiCall {
  Future<ApiCallResponse> call({
    String? authToken = '',
    List<String>? courseIdInts,
  }) {
    final body = '''
{
  "query": "query GetMe {\\n  me {\\n    profile {\\n      id\\n      displayName\\n      picture\\n      email\\n    phone\\n      city\\n      state\\n      neetExamYear\\n      }\\n    userCourses(where: {courseId: $courseIdInts}) {\\n      edges {\\n        node {\\n          expiryAt\\n        }\\n      }\\n    }\\n  }\\n}",
  "variables": "",
  "operationName": "GetMe"
}''';
    print(body.toString());
    return ApiManager.instance.makeApiCall(
      callName: 'Logged in user information and course access checking api ',
      apiUrl: '${SignupGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {
        ...SignupGroup.headers,
        'Authorization': 'Bearer $authToken',
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: true,
    );
  }

  dynamic me(dynamic response) => getJsonField(
        response,
        r'''$.data.me''',
      );

  dynamic courses(dynamic response) => getJsonField(
        response,
        r'''$.data.me.userCourses.edges''',
        true,
      );
  dynamic expiryCourse(dynamic response) => getJsonField(
        response,
        r'''$.data.me.userCourses.edges[:].node''',
        true,
      );

  dynamic freeChapters(dynamic response) => getJsonField(
        response,
        r'''$.data.me.userCourses.edges[:].node.freeChapters''',
        true,
      );

  // Extracts courseStatus
  dynamic courseStatus(dynamic response) => getJsonField(
        response,
        r'''$.data.me.profile.courseStatus''',
      );
}

class GetUserInformationApiCall {
  Future<ApiCallResponse> call({
    String? authToken = '',
  }) {
    final body = '''
{
  "query": "query me{\\n  me {\\n    profile {\\n      id\\n      firstName\\n      lastName\\n      displayName\\n      picture\\n      email\\n    phone\\n      parentPhone\\n      city\\n      state\\n      pincode\\n      neetExamYear\\n      boardExamYear\\n      registrationNumber\\n      dob\\n      }\\n  }\\n}",
  "variables": "",
  "operationName": "me"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Get User information api ',
      apiUrl: '${SignupGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {
        ...SignupGroup.headers,
        'Authorization': 'Bearer $authToken',
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }

  dynamic me(dynamic response) => getJsonField(
        response,
        r'''$.data.me''',
      );

  dynamic phone(dynamic response) => getJsonField(
        response,
        r'''$.data.me.profile.phone''',
        false,
      );

  dynamic parentPhone(dynamic response) => getJsonField(
        response,
        r'''$.data.me.profile.parentPhone''',
        false,
      );

  dynamic city(dynamic response) => getJsonField(
        response,
        r'''$.data.me.profile.city''',
        false,
      );

  dynamic state(dynamic response) => getJsonField(
        response,
        r'''$.data.me.profile.state''',
        false,
      );

  dynamic neetExamYear(dynamic response) => getJsonField(
        response,
        r'''$.data.me.profile.neetExamYear''',
        false,
      );

  dynamic pincode(dynamic response) => getJsonField(
        response,
        r'''$.data.me.profile.pincode''',
        false,
      );

  dynamic boardExamYear(dynamic response) => getJsonField(
        response,
        r'''$.data.me.profile.boardExamYear''',
        false,
      );

  dynamic firstName(dynamic response) => getJsonField(
        response,
        r'''$.data.me.profile.firstName''',
        false,
      );

  dynamic lastName(dynamic response) => getJsonField(
        response,
        r'''$.data.me.profile.lastName''',
        false,
      );

  dynamic registrationNo(dynamic response) => getJsonField(
        response,
        r'''$.data.me.profile.registrationNumber''',
        false,
      );

  dynamic dob(dynamic response) => getJsonField(
        response,
        r'''$.data.me.profile.dob''',
        false,
      );
}

class CreateOrUpdateUserProfile {
  Future<ApiCallResponse> call(
      {String? city = '',
      String? state = '',
      String? userId = '',
      String? authToken = '',
      String? phone = '',
      String? neetExamYear = '',
      String? firstName = '',
      String? lastName = '',
      String? pincode = '',
      String? boardExamYear = '',
      String? registrationNumber = '',
      String? dob = ''}) {
    final body = '''
{
  "query": "mutation setProfile(\$input: createOrUpdateProfileInput!) {\\n  createOrUpdateProfile(input: \$input) {\\n    clientMutationId\\n    }\\n}\\n",
  "variables": "{\\n  \\"input\\": {\\n    \\"pincode\\": \\"$pincode\\",\\n    \\"city\\": \\"$city\\",\\n    \\"userId\\": \\"$userId\\",\\n    \\"phone\\": \\"$phone\\",\\n    \\"firstName\\": \\"$firstName\\",\\n    \\"lastName\\": \\"$lastName\\",\\n    \\"neetExamYear\\": \\"$neetExamYear\\",\\n    \\"boardExamYear\\": \\"$boardExamYear\\",\\n    \\"state\\": \\"$state\\",\\n    \\"registrationNumber\\": \\"$registrationNumber\\",\\n    \\"dob\\": \\"$dob\\"\\n  }\\n}",
  "operationName": "setProfile"
}''';

    return ApiManager.instance
        .makeApiCall(
      callName: 'Create or update user profile',
      apiUrl: '${SignupGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {
        ...SignupGroup.headers,
        'Authorization': 'Bearer $authToken',
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    )
        .then((response) {
      print(response.jsonBody.toString());
      return response;
    }).catchError((error, stackTrace) {
      print('API Error: $error');
      return Future.value(); // Handle the error response appropriately
    });
  }

  dynamic clientMutationId(dynamic response) => getJsonField(
        response,
        r'''$.data.createOrUpdateProfile.clientMutationId''',
      );
}

class CreateOrUpdateUserProfile2 {
  Future<ApiCallResponse> call(
      {String? city = '',
      String? state = '',
      String? userId = '',
      String? authToken = '',
      String? parentPhone = '',
      String? neetExamYear = '',
      String? firstName = ''}) {
    final body = '''
{
  "query": "mutation setProfile(\$input: createOrUpdateProfileInput!) {\\n  createOrUpdateProfile(input: \$input) {\\n    clientMutationId\\n    }\\n}\\n",
  "variables": "{\\n  \\"input\\": {\\n   \\"city\\": \\"$city\\",\\n    \\"userId\\": \\"$userId\\",\\n    \\"parentPhone\\": \\"$parentPhone\\",\\n    \\"firstName\\": \\"$firstName\\",\\n     \\"neetExamYear\\": \\"$neetExamYear\\",\\n    \\"state\\": \\"$state\\"\\n    }\\n}",
  "operationName": "setProfile"
}''';

    return ApiManager.instance
        .makeApiCall(
      callName: 'Create or update user profile',
      apiUrl: '${SignupGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {
        ...SignupGroup.headers,
        'Authorization': 'Bearer $authToken',
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    )
        .then((response) {
      print(response.jsonBody.toString());
      return response;
    }).catchError((error, stackTrace) {
      print('API Error: $error');
      return Future.value(); // Handle the error response appropriately
    });
  }

  dynamic clientMutationId(dynamic response) => getJsonField(
        response,
        r'''$.data.createOrUpdateProfile.clientMutationId''',
      );
}

class GoogleLoginServerCallWithCodeReceivedFromGoogleAuthenticationCall {
  Future<ApiCallResponse> call({
    String? token = '',
    String? email = 'thordeveloper.tech@gmail.com',
    String? name = 'Thor Developers',
    String? picture =
        'https://lh3.googleusercontent.com/a/AEdFTp6WiotPy2D7VWwzHoWTNxvqrZaLVGuQZSfIbG4N=s360-p-no',
  }) {
    return ApiManager.instance.makeApiCall(
      callName:
          'Google login server call with code received from google authentication',
      apiUrl: '${SignupGroup.baseUrl}/authenticate/googleAuth',
      callType: ApiCallType.POST,
      headers: {
        ...SignupGroup.headers,
      },
      params: {
        'token': token,
        'email': email,
        'name': name,
        'picture': picture,
      },
      bodyType: BodyType.X_WWW_FORM_URL_ENCODED,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }

  dynamic user(dynamic response) => getJsonField(
        response,
        r'''$''',
      );
}

/// End Signup Group Code

/// Start Payment Group Code

class PaymentGroup {
  static String baseUrl = FFAppState().baseUrl;
  static Map<String, String> headers = {};
  static CreatePaymentForAUserForACourseAndCourseOfferAndGetChecksumCall
      createPaymentForAUserForACourseAndCourseOfferAndGetChecksumCall =
      CreatePaymentForAUserForACourseAndCourseOfferAndGetChecksumCall();
  static GetCoursePriceAndCourseOffersToSelectFromToStartPaymentCall
      getCoursePriceAndCourseOffersToSelectFromToStartPaymentCall =
      GetCoursePriceAndCourseOffersToSelectFromToStartPaymentCall();
  static PaymentSuccessBackendProcessingCallToEnableCourseCall
      paymentSuccessBackendProcessingCallToEnableCourseCall =
      PaymentSuccessBackendProcessingCallToEnableCourseCall();
  static CreatePaymentForBookOrderCall createPaymentForBookOrderCall =
      CreatePaymentForBookOrderCall();
}

class CreatePaymentForAUserForACourseAndCourseOfferAndGetChecksumCall {
  Future<ApiCallResponse> call(
      {int? txnAmount,
      String? email = '',
      String? mobile = '',
      String? course = '',
      String? courseOfferId = '',
      String? authToken = '',
      int? userid,
      bool? hasShipment,
      Object? addOns,
      String? couponId}) {
    Map<String, dynamic> params = hasShipment == true
        ? {
            "allow_shipment": 1,
            'TXN_AMOUNT': txnAmount,
            'EMAIL': email,
            'MOBILE': mobile,
            'COURSE': course,
            'COURSE_OFFER_ID': courseOfferId,
            'USERID': userid,
            "addonCourseIds": addOns,
            "couponId": couponId.toString()
          }
        : {
            'TXN_AMOUNT': txnAmount,
            'EMAIL': email,
            'MOBILE': mobile,
            'COURSE': course,
            'COURSE_OFFER_ID': courseOfferId,
            'USERID': userid,
            "addonCourseIds": addOns,
            "couponId": couponId.toString()
          };
    if (params['addonCourseIds']?.isEmpty ?? false) {
      params.remove('addonCourseIds');
    }
    if (params['couponId']?.isEmpty || params['couponId'] == null) {
      params.remove('couponId');
    }
    print("create payment api params" + params.toString());
    return ApiManager.instance.makeApiCall(
      callName:
          'Create payment for a user for a course and course offer and get checksum',
      apiUrl: '${PaymentGroup.baseUrl}/api/v1/generate_txn_token',
      callType: ApiCallType.POST,
      headers: {
        ...PaymentGroup.headers,
        'Authorization': 'Bearer $authToken',
      },
      params: params,
      bodyType: BodyType.X_WWW_FORM_URL_ENCODED,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }

  dynamic paymentId(dynamic response) => getJsonField(
        response,
        r'''$.payment_id''',
      );

  dynamic orderId(dynamic response) => getJsonField(
        response,
        r'''$.order_id''',
      );

  dynamic checksum(dynamic response) => getJsonField(
        response,
        r'''$.checksum''',
      );

  dynamic mid(dynamic response) => getJsonField(
        response,
        r'''$.mid''',
      );

  dynamic amount(dynamic response) => getJsonField(
        response,
        r'''$.amount''',
      );

  dynamic txnToken(dynamic response) => getJsonField(
        response,
        r'''$.txnToken''',
      );

  dynamic callbackUrl(dynamic response) => getJsonField(
        response,
        r'''$.callbackUrl''',
      );

  dynamic isStaging(dynamic response) => getJsonField(
        response,
        r'''$.isStaging''',
      );

  dynamic restrictAppInvoke(dynamic response) => getJsonField(
        response,
        r'''$.restrictAppInvoke''',
      );
}

class GetCoursePriceAndCourseOffersToSelectFromToStartPaymentCall {
  Future<ApiCallResponse> call({
    String? authToken = '',
    String? courseId = '',
  }) {
    final body = courseId == "Q291cnNlOjMyNTc="
            ? '''
{
  "query": "query GetCourseDetail(\$id: ID!) {\\n  course(id: \$id) {\\n    id\\n    name\\n    description\\n    fee\\n    discountedFee\\n    hasShipment\\n          discountPercentage\\n    public\\n    expiryAt\\n    image\\n    bestSeller\\n    origFee\\n    feeTitle\\n    feeDesc\\n    allowAddon\\n    addons: addons(orderBy: [IDDESC]) {\\n      edges {\\n        node {\\n          id\\n          courseId\\n          addonCourseId\\n          addonCourseOffer{\\n            id\\n          title\\n          fee\\n          discountedFee\\n          offerExpiryAt\\n          hasShipment\\n          description\\n                 }\\n        addonCourse {\\n            id\\n          }\\n        }\\n      }\\n    }\\n    offers: allOffers(orderBy: [IDASC])  {\\n      edges {\\n        node {\\n          id\\n          title\\n          description\\n          fee\\n          discountPercentage\\n          discountedFee\\n          expiryAt\\n          durationInDays\\n          hasShipment\\n          addons: addons(orderBy: IDASC]){\\n            edges {\\n              node {\\n                id\\n                courseId\\n                courseOfferId\\n                addonCourseOffer{\\n            id\\n          title\\n          fee\\n          discountedFee\\n          offerExpiryAt\\n          hasShipment\\n          description\\n                 }\\n        addonCourseId\\n                addonCourse {\\n                  id\\n                }\\n              }\\n            }\\n          }\\n        }\\n      }\\n    }\\n    neet24Offers: allOffers(where: {title: {like: \\"%24%\\"}}) {\\n      edges {\\n        node {\\n          id\\n          title\\n          description\\n          fee\\n          discountPercentage\\n          discountedFee\\n          expiryAt\\n          durationInDays\\n          hasShipment\\n          addons: addons(orderBy: [IDDESC]){\\n            edges {\\n              node {\\n                id\\n                courseId\\n                courseOfferId\\n                addonCourseId\\n                addonCourseOffer{\\n            id\\n          title\\n          fee\\n          discountedFee\\n          offerExpiryAt\\n          hasShipment\\n          description\\n                 }\\n        addonCourse {\\n                  id\\n                name\\n                 description\\n                 fee\\n                discountedFee\\n                hasShipment\\n                description\\n                 }\\n              }\\n            }\\n          }\\n        }\\n      }\\n    }\\n    neet25Offers: allOffers(where: {title: {like: \\"%25%\\"}}) {\\n      edges {\\n        node {\\n          id\\n          title\\n          description\\n          fee\\n          discountPercentage\\n          discountedFee\\n          expiryAt\\n          durationInDays\\n          hasShipment\\n          addons: addons(orderBy: [IDDESC]){\\n            edges {\\n              node {\\n                id\\n                courseId\\n                courseOfferId\\n                addonCourseId\\n                addonCourseOffer{\\n            id\\n          title\\n          fee\\n          discountedFee\\n          offerExpiryAt\\n          hasShipment\\n          description\\n                 }\\n        addonCourse {\\n                  id\\n                name\\n                 description\\n                 fee\\n                discountedFee\\n                hasShipment\\n                }\\n              }\\n            }\\n          }\\n        }\\n      }\\n    }\\n    neet26Offers: allOffers(where: {title: {like: \\"%26%\\"}}) {\\n      edges {\\n        node {\\n          id\\n          title\\n          description\\n          fee\\n          discountPercentage\\n          discountedFee\\n          expiryAt\\n          durationInDays\\n          hasShipment\\n          addons: addons(orderBy: [IDDESC]) {\\n            edges {\\n              node {\\n                id\\n                courseId\\n                courseOfferId\\n                addonCourseId\\n                addonCourseOffer{\\n            id\\n          title\\n          fee\\n          discountedFee\\n          offerExpiryAt\\n          hasShipment\\n           description\\n          }\\n                addonCourse {\\n                  id\\n                name\\n                 description\\n                 fee\\n                discountedFee\\n                hasShipment\\n                description\\n                 }\\n              }\\n            }\\n          }\\n        }\\n      }\\n    }\\n  }\\n}",
  "variables": "{\\n  \\"id\\": \\"$courseId\\"\\n}",
  "operationName": "GetCourseDetail"
}'''
            :
            //     : courseId == FFAppState().courseId
            //          ?
            '''
{
  "query": "query GetCourseDetail(\$id: ID!) {\\n  course(id: \$id) {\\n    id\\n    name\\n    description\\n    fee\\n    discountedFee\\n    hasShipment\\n    discountPercentage\\n    public\\n    expiryAt\\n    image\\n    bestSeller\\n    origFee\\n    feeTitle\\n    feeDesc\\n    allowAddon\\n    offers: allOffers(orderBy: [IDASC]) {\\n      edges {\\n        node {\\n          id\\n          title\\n          description\\n          fee\\n          discountPercentage\\n          discountedFee\\n          expiryAt\\n          durationInDays\\n          hasShipment\\n          addons: addons(orderBy: [IDASC]) {\\n            edges {\\n              node {\\n                id\\n                courseId\\n                courseOfferId\\n                addonCourseOffer {\\n                  id\\n                  title\\n                  fee\\n                  discountedFee\\n                  offerExpiryAt\\n                  hasShipment\\n                  description\\n                }\\n                addonCourseId\\n                addonCourse {\\n                  id\\n                  name\\n                  fee\\n                  discountedFee\\n                  expiryAt\\n                  hasShipment\\n                  description\\n                }\\n              }\\n            }\\n          }\\n          complimentaryAddons: complimentaryAddons(orderBy: [IDASC]) {\\n            edges {\\n              node {\\n                id\\n                courseId\\n                courseOfferId\\n                complimentaryCourseOffer {\\n                  id\\n                  title\\n                  fee\\n                  discountedFee\\n                  offerExpiryAt\\n                  hasShipment\\n                  description\\n                courseId\\n                }\\n                addonCourseId\\n                complimentaryCourse {\\n                  id\\n                  name\\n                  fee\\n                  origFee\\n                  discountedFee\\n                  expiryAt\\n                  hasShipment\\n                  description\\n                }\\n              }\\n            }\\n          }\\n        }\\n      }\\n    }\\n    neet25Offers: allOffers(where: {title: {like: \\"%25%\\"}},orderBy: [IDASC]) {\\n      edges {\\n        node {\\n          id\\n          title\\n          description\\n          fee\\n          discountPercentage\\n          discountedFee\\n          expiryAt\\n          durationInDays\\n          hasShipment\\n          woTaxFee\\n          parentCourseOfferId\\n          finalCourseOfferId\\n          complimentaryAddons(orderBy: [IDASC]) {\\n            edges {\\n              node {\\n                id\\n                courseId\\n                courseOfferId\\n                complimentaryCourse {\\n                  id\\n                  name\\n                fee\\n          origFee\\n          discountPercentage\\n          discountedFee\\n          expiryAt\\n         hasShipment\\n         }\\n                complimentaryCourseOffer {\\n                  id\\n                  title\\n                  fee\\n                  discountedFee\\n                  offerExpiryAt\\n                  expiryAt\\n                  hasShipment\\n                  description\\n                courseId}\\n              }\\n            }\\n          }\\n          addons: addons(orderBy: [IDASC]) {\\n            edges {\\n              node {\\n                id\\n                courseId\\n                courseOfferId\\n                addonCourseId\\n                addonCourseOffer {\\n                  id\\n                  title\\n                  fee\\n                  discountedFee\\n                  offerExpiryAt\\n                  hasShipment\\n                  description\\n                }\\n                addonCourse {\\n                  id\\n                  name\\n                  description\\n                  fee\\n                  origFee\\n                  discountedFee\\n                  hasShipment\\n                }\\n              }\\n            }\\n          }\\n        }\\n      }\\n    }\\n neet27Offers: allOffers(where: {title: {like: \\"%27%\\"}},orderBy: [IDASC]) {\\n      edges {\\n        node {\\n          id\\n          title\\n          description\\n          fee\\n          discountPercentage\\n          discountedFee\\n          expiryAt\\n          durationInDays\\n          hasShipment\\n          woTaxFee\\n          parentCourseOfferId\\n          finalCourseOfferId\\n          complimentaryAddons(orderBy: [IDASC]) {\\n            edges {\\n              node {\\n                id\\n                courseId\\n                courseOfferId\\n                complimentaryCourse {\\n                  id\\n                  name\\n                fee\\n          origFee\\n          discountPercentage\\n          discountedFee\\n          expiryAt\\n         hasShipment\\n         }\\n                complimentaryCourseOffer {\\n                  id\\n                  title\\n                  fee\\n                  discountedFee\\n                  offerExpiryAt\\n                  expiryAt\\n                  hasShipment\\n                  description\\n                courseId}\\n              }\\n            }\\n          }\\n          addons: addons(orderBy: [IDASC]) {\\n            edges {\\n              node {\\n                id\\n                courseId\\n                courseOfferId\\n                addonCourseId\\n                addonCourseOffer {\\n                  id\\n                  title\\n                  fee\\n                  discountedFee\\n                  offerExpiryAt\\n                  hasShipment\\n                  description\\n                }\\n                addonCourse {\\n                  id\\n                  name\\n                  description\\n                  fee\\n                  origFee\\n                  discountedFee\\n                  hasShipment\\n                }\\n              }\\n            }\\n          }\\n        }\\n      }\\n    }\\n    neet26Offers: allOffers(where: {title: {like: \\"%26%\\"}},orderBy: [IDASC]) {\\n      edges {\\n        node {\\n          id\\n          title\\n          description\\n          fee\\n          discountPercentage\\n          discountedFee\\n          expiryAt\\n          durationInDays\\n          hasShipment\\n          woTaxFee\\n          parentCourseOfferId\\n          finalCourseOfferId\\n          complimentaryAddons (orderBy: [IDASC]){\\n            edges {\\n              node {\\n                id\\n                courseId\\n                courseOfferId\\n                complimentaryCourse {\\n                  id\\n                  name\\n                description\\n                fee\\n                origFee\\n                discountedFee\\n                expiryAt\\n                hasShipment\\n }\\n                complimentaryCourseOffer {\\n                  id\\n                  title\\n                  fee\\n                  discountedFee\\n                  offerExpiryAt\\n                  expiryAt\\n                  hasShipment\\n                  description\\n                courseId\\n }\\n              }\\n            }\\n          }\\n          addons: addons(orderBy: [IDASC]) {\\n            edges {\\n              node {\\n                id\\n                courseId\\n                courseOfferId\\n                addonCourseId\\n                addonCourseOffer {\\n                  id\\n                  title\\n                  fee\\n                  discountedFee\\n                  offerExpiryAt\\n                  hasShipment\\n                  description\\n                }\\n                addonCourse {\\n                  id\\n                  name\\n                  description\\n                  fee\\n                  origFee\\n                  discountedFee\\n                  hasShipment\\n                  description\\n                }\\n              }\\n            }\\n          }\\n        }\\n      }\\n    }\\n  }\\n}",
  "variables": "{\\n \\"id\\": \\"$courseId\\"\\n}",
  "operationName": "GetCourseDetail"
}

'''
//             : '''
// {

//   "query": "query GetCourseDetail(\$id: ID!) {\\n    course(id: \$id) {\\n        id\\n        name\\n        description\\n        fee\\n        discountedFee\\n        discountPercentage\\n        public\\n        expiryAt\\n        image\\n        bestSeller\\n        origFee\\n        feeTitle\\n        feeDesc\\n        hasShipment\\n        type\\n        offers:allOffers {\\n              edges {\\n                node {\\n                id\\n                  title\\n                  description\\n                  fee\\n                  discountPercentage\\n                  discountedFee\\n                  expiryAt\\n                  durationInDays\\n                hasShipment\\n                  }\\n            }\\n        }\\n    }\\n}",
//   "variables": "{\\n  \\"id\\": \\"$courseId\\"\\n}",
//   "operationName": "GetCourseDetail"
// }'''
        ;
    return ApiManager.instance.makeApiCall(
      callName:
          'Get course price and course offers to select from to start payment',
      apiUrl: '${PaymentGroup.baseUrl}/graphql',
      callType: ApiCallType.POST,
      headers: {
        ...PaymentGroup.headers,
        'Authorization': 'Bearer $authToken',
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }

  dynamic course(dynamic response) => getJsonField(
        response,
        r'''$.data''',
      );

  dynamic getAllAddOnCoursesForFirstCourseOfferOfNEET24(dynamic response) =>
      getJsonField(
        response,
        r'''$.data.course.neet24Offers.edges[0].node.addons.edges[:].node''',
        true,
      );

  dynamic neet24CourseOffers(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet24Offers.edges[:].node''',
        true,
      );

  dynamic neet24OfferDiscountedFees(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet24Offers.edges[:].node.discountedFee''',
        true,
      );

  dynamic neet24OfferFees(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet24Offers.edges[:].node.fee''',
        true,
      );

  dynamic neet24OfferTitles(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet24Offers.edges[:].node.title''',
        true,
      );

  dynamic neet24OfferDurations(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet24Offers.edges[:].node.durationInDays''',
        true,
      );

  dynamic neet24Offerdispercent(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet24Offers.edges[:].node.discountPercentage''',
        true,
      );

  dynamic neet24HasShipment(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet24Offers.edges[:].node.hasShipment''',
        true,
      );

  dynamic neet24courseOffersId(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet24Offers.edges[:].node.id''',
        true,
      );

  dynamic neet25courseOffersId(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet25Offers.edges[:].node.id''',
        true,
      );

  dynamic neet25CourseOffers(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet25Offers.edges[:].node''',
        true,
      );

  dynamic neet25OfferDiscountedFees(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet25Offers.edges[:].node.discountedFee''',
        true,
      );

  dynamic neet25OfferFees(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet25Offers.edges[:].node.fee''',
        true,
      );

  dynamic neet25OfferTitles(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet25Offers.edges[:].node.title''',
        true,
      );

  dynamic neet25OfferDurations(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet25Offers.edges[:].node.durationInDays''',
        true,
      );

  dynamic neet25Offerdispercent(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet25Offers.edges[:].node.discountPercentage''',
        true,
      );

  dynamic neet25HasShipment(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet25Offers.edges[:].node.hasShipment''',
        true,
      );

  dynamic getAllAddOnCoursesForFirstCourseOfferOfNEET25(dynamic response) =>
      getJsonField(
        response,
        r'''$.data.course.neet25Offers.edges[0].node.addons.edges[:].node''',
        true,
      );

  dynamic getAllcomplimentaryCourseOffersForFirstCourseOfferOfNEET25(
          dynamic response) =>
      getJsonField(
        response,
        r'''$.data.course.neet25Offers.edges[0].node.complimentaryAddons.edges[:].node''',
        true,
      );
  dynamic getAllcomplimentaryCourseOffersForFirstCourseOfferOfNEET26(
          dynamic response) =>
      getJsonField(
        response,
        r'''$.data.course.neet26Offers.edges[0].node.complimentaryAddons.edges[:].node''',
        true,
      );

  dynamic neet26courseOffersId(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet26Offers.edges[:].node.id''',
        true,
      );

  dynamic neet26CourseOffers(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet26Offers.edges[:].node''',
        true,
      );

  dynamic neet26OfferDiscountedFees(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet26Offers.edges[:].node.discountedFee''',
        true,
      );

  dynamic neet26OfferFees(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet26Offers.edges[:].node.fee''',
        true,
      );

  dynamic neet26OfferTitles(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet26Offers.edges[:].node.title''',
        true,
      );

  dynamic neet26OfferDurations(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet26Offers.edges[:].node.durationInDays''',
        true,
      );

  dynamic neet26Offerdispercent(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet26Offers.edges[:].node.discountPercentage''',
        true,
      );

  dynamic neet26HasShipment(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet26Offers.edges[:].node.hasShipment''',
        true,
      );

  dynamic getAllAddOnCoursesForFirstCourseOfferOfNEET26(dynamic response) =>
      getJsonField(
        response,
        r'''$.data.course.neet26Offers.edges[0].node.addons.edges[:].node''',
        true,
      );

  dynamic getAllcomplimentaryCourseOffersForFirstCourseOfferOfNEET27(
          dynamic response) =>
      getJsonField(
        response,
        r'''$.data.course.neet27Offers.edges[0].node.complimentaryAddons.edges[:].node''',
        true,
      );
  dynamic neet27courseOffersId(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet27Offers.edges[:].node.id''',
        true,
      );

  dynamic neet27CourseOffers(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet27Offers.edges[:].node''',
        true,
      );

  dynamic neet27OfferDiscountedFees(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet27Offers.edges[:].node.discountedFee''',
        true,
      );

  dynamic neet27OfferFees(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet27Offers.edges[:].node.fee''',
        true,
      );

  dynamic neet27OfferTitles(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet27Offers.edges[:].node.title''',
        true,
      );

  dynamic neet27OfferDurations(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet27Offers.edges[:].node.durationInDays''',
        true,
      );

  dynamic neet27Offerdispercent(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet27Offers.edges[:].node.discountPercentage''',
        true,
      );

  dynamic neet27HasShipment(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet27Offers.edges[:].node.hasShipment''',
        true,
      );

  dynamic getAllAddOnCoursesForFirstCourseOfferOfNEET27(dynamic response) =>
      getJsonField(
        response,
        r'''$.data.course.neet27Offers.edges[0].node.addons.edges[:].node''',
        true,
      );

  dynamic courseOffers(dynamic response) => getJsonField(
        response,
        r'''$.data.course.offers.edges[:].node''',
        true,
      );

  dynamic offerDiscountedFees(dynamic response) => getJsonField(
        response,
        r'''$.data.course.offers.edges[:].node.discountedFee''',
        true,
      );

  dynamic offerFees(dynamic response) => getJsonField(
        response,
        r'''$.data.course.offers.edges[:].node.fee''',
        true,
      );

  dynamic offerTitles(dynamic response) => getJsonField(
        response,
        r'''$.data.course.offers.edges[:].node.title''',
        true,
      );

  dynamic offerDurations(dynamic response) => getJsonField(
        response,
        r'''$.data.course.offers.edges[:].node.durationInDays''',
        true,
      );

  dynamic offerdispercent(dynamic response) => getJsonField(
        response,
        r'''$.data.course.offers.edges[:].node.discountPercentage''',
        true,
      );

  dynamic hasShipment(dynamic response) => getJsonField(
        response,
        r'''$.data.course.offers.edges[:].node.hasShipment''',
        true,
      );

  dynamic defaultId(dynamic response) => getJsonField(
        response,
        r'''$.data.course.id''',
      );

  dynamic defaultName(dynamic response) => getJsonField(
        response,
        r'''$.data.course.name''',
      );

  dynamic defaultFee(dynamic response) => getJsonField(
        response,
        r'''$.data.course.fee''',
      );

  dynamic defaultDiscountPrice(dynamic response) => getJsonField(
        response,
        r'''$.data.course.discountedFee''',
      );

  dynamic defaultDisPercent(dynamic response) => getJsonField(
        response,
        r'''$.data.course.discountPercentage''',
      );

  dynamic defaultExpiryAt(dynamic response) => getJsonField(
        response,
        r'''$.data.course.expiryAt''',
      );

  dynamic getAllComplimentaryCourseOffers(dynamic response) => getJsonField(
        response,
        r'''$.data.course.offers.edges[:].node.complimentaryAddons.edges[:].node''',
        true,
      );
  dynamic getAllAddonsCourseOffers(dynamic response) => getJsonField(
        response,
        r'''$.data.course.offers.edges[:].node.addons.edges[:].node''',
        true,
      );
}

class PaymentSuccessBackendProcessingCallToEnableCourseCall {
  Future<ApiCallResponse> call({
    String? orderId = '',
    int? paymentId,
  }) {
    return ApiManager.instance.makeApiCall(
      callName: 'Payment Success Backend Processing call to enable course',
      apiUrl: '${PaymentGroup.baseUrl}/reflex_payment_response.json',
      callType: ApiCallType.POST,
      headers: {
        ...PaymentGroup.headers,
      },
      params: {
        'redirect_domain': "mib.neetprep.com",
        'orderId': orderId,
        'paymentId': paymentId,
      },
      bodyType: BodyType.X_WWW_FORM_URL_ENCODED,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }

  dynamic paymentResponse(dynamic response) => getJsonField(
        response,
        r'''$.payment_response''',
      );

  dynamic paymentResponseStatus(dynamic response) => getJsonField(
        response,
        r'''$.payment_response.STATUS''',
      );

  dynamic neet24courseOffersId(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet24Offers.edges[:].node.id''',
        true,
      );

  dynamic neet25courseOffersId(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet25Offers.edges[:].node.id''',
        true,
      );

  dynamic neet26courseOffersId(dynamic response) => getJsonField(
        response,
        r'''$.data.course.neet25Offers.edges[:].node.id''',
        true,
      );
}

class CreatePaymentForBookOrderCall {
  Future<ApiCallResponse> call(
      {String response = "",
      String amount = '',
      String? userId = 'VXNlcjo5Nw==',
      String? userName = "",
      String? userEmail = "",
      String? userPhone = "",
      String? landmark = "",
      String? userCity = "",
      String? userState = "",
      String? address1 = "",
      String? address2 = "",
      String? pincode = "",
      String? mobileNum2 = "",
      int? paymentForId = 3125,
      String paymentForType = "Course",
      String? courseOfferId,
      String authToken = '',
      String orderId = '',
      String paymentId = ''}) {
    final body = '''
{
  "query": "mutation updatePayment(\$input: updatePaymentInput!) {\\n    updatePayment(input: \$input) {\\n        clientMutationId\\n   }\\n}",
  "variables":  "{\\n  \\"input\\": {\\n  \\"id\\": \\"$paymentId\\",\\n  \\"values\\": {\\n    \\"userId\\": \\"$userId\\",\\n    \\"courseOfferId\\": \\"$courseOfferId\\",\\n    \\"amount\\": \\"$amount\\",\\n    \\"address1\\": \\"$address1\\",\\n    \\"userCity\\": \\"$userCity\\",\\n    \\"userState\\": \\"$userState\\",\\n    \\"address2\\": \\"$address2\\",\\n    \\"pincode\\": \\"$pincode\\",\\n    \\"landmark\\": \\"$landmark\\",\\n    \\"mobile2\\": \\"$mobileNum2\\",\\n    \\"userPhone\\": \\"$userPhone\\"\\n  }\\n}\\n}",
  "operationName": "updatePayment"
}
''';
    return ApiManager.instance.makeApiCall(
      callName: 'Create Payment for online book purchase ',
      apiUrl: "${PaymentGroup.baseUrl}/graphql",
      callType: ApiCallType.POST,
      headers: {
        ...PracticeGroup.headers,
        'Authorization': 'Bearer ' + FFAppState().subjectToken,
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

/// End Payment Group Code

/// Start Misc Group Code

class MiscGroup {
  static String baseUrl = 'https://mib.neetprep.com/';
  static Map<String, String> headers = {};
  static GetCoursesForSwitchingCall getCoursesForSwitchingCall =
      GetCoursesForSwitchingCall();
}

class GetCoursesForSwitchingCall {
  Future<ApiCallResponse> call() {
    return ApiManager.instance.makeApiCall(
      callName: 'Get Courses for switching',
      apiUrl: '${MiscGroup.baseUrl}/files/courses.json',
      callType: ApiCallType.GET,
      headers: {
        ...MiscGroup.headers,
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }

  dynamic courseIdInts(dynamic response) => getJsonField(
        response,
        r'''$[:].courseId''',
        true,
      );

  dynamic courseNames(dynamic response) => getJsonField(
        response,
        r'''$[:].courseName''',
        true,
      );

  dynamic altCourseIdInts(dynamic response) => getJsonField(
        response,
        r'''$[:].courseIdInts''',
        true,
      );
}

/// End Misc Group Code

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list);
  } catch (_) {
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar);
  } catch (_) {
    return isList ? '[]' : '{}';
  }
}
