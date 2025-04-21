import '/backend/api_requests/api_calls.dart';
import '/components/nav_bar/nav_bar_widget.dart';
import '/components/no_data_component/no_data_component_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CreateAndPreviewTestPageModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for ListView widget.

  PagingController<ApiPagingParams, dynamic>? listViewPagingController1;
  Function(ApiPagingParams nextPageMarker)? listViewApiCall1;

  // Model for noDataComponent component.
  late NoDataComponentModel noDataComponentModel;
  // Model for navBar component.
  late NavBarModel navBarModel;
  List<Map<String, dynamic>> upcomingTests = [];
  List<Map<String, dynamic>> previousTests = [];
  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    noDataComponentModel = createModel(context, () => NoDataComponentModel());
    navBarModel = createModel(context, () => NavBarModel());
  }

  void dispose() {
    unfocusNode.dispose();
    listViewPagingController1?.dispose();
    noDataComponentModel.dispose();
    navBarModel.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.

  PagingController<ApiPagingParams, dynamic> setListViewController1(
    Function(ApiPagingParams) apiCall,
  ) {
    listViewApiCall1 = apiCall;
    return listViewPagingController1 ??= _createListViewController1(apiCall);
  }

  PagingController<ApiPagingParams, dynamic> _createListViewController1(
    Function(ApiPagingParams) query,
  ) {
    final controller = PagingController<ApiPagingParams, dynamic>(
      firstPageKey: ApiPagingParams(
        nextPageNumber: 0,
        numItems: 0,
        lastResponse: null,
      ),
    );
    return controller
      ..addPageRequestListener(
          listViewListOfCustomCreatedTestsByTheUserOrderedByDateOfCreationDescendingPage1);
  }

  void listViewListOfCustomCreatedTestsByTheUserOrderedByDateOfCreationDescendingPage1(
          ApiPagingParams nextPageMarker) =>
      listViewApiCall1!(nextPageMarker).then(
          (listViewListOfCustomCreatedTestsByTheUserOrderedByDateOfCreationDescendingResponse) {
        final pageItems = (TestGroup
                    .listOfCustomCreatedTestsByTheUserOrderedByDateOfCreationDescendingCall
                    .myCustomTests(
                  listViewListOfCustomCreatedTestsByTheUserOrderedByDateOfCreationDescendingResponse
                      .jsonBody,
                )! ??
                [])
            .toList() as List;
        final newNumItems = nextPageMarker.numItems + pageItems.length;
        listViewPagingController1?.appendPage(
          pageItems,
          (pageItems.length > 0)
              ? ApiPagingParams(
                  nextPageNumber: nextPageMarker.nextPageNumber + 1,
                  numItems: newNumItems,
                  lastResponse:
                      listViewListOfCustomCreatedTestsByTheUserOrderedByDateOfCreationDescendingResponse,
                )
              : null,
        );
      });




  void segregateTests(List tests) {
    upcomingTests.clear();
    previousTests.clear();

    for (Map<String, dynamic> test in tests) {
      String testName = test['startedAt'];
      print(testName);
        DateTime currentDate = DateTime.now();
        String dateString = testName.split(' ').sublist(1, 4).join(' ');
        DateTime date2 = parseCustomDate(dateString)??DateTime.now();
        if (date2!=null && date2.isAfter(currentDate)) {
          upcomingTests.add(test);
        } else {
          previousTests.add(test);
        }


    }

  }

  DateTime? parseCustomDate(String dateString) {
    try {
      List<String> parts = dateString.split(' ');
      int year = int.parse(parts[2]);
      int month;
      switch (parts[0]) {
        case 'Jan':
          month = 1;
          break;
        case 'Feb':
          month = 2;
          break;
        case 'Mar':
          month = 3;
          break;
        case 'Apr':
          month = 4;
          break;
        case 'May':
          month = 5;
          break;
        case 'Jun':
          month = 6;
          break;
        case 'Jul':
          month = 7;
          break;
        case 'Aug':
          month = 8;
          break;
        case 'Sep':
          month = 9;
          break;
        case 'Oct':
          month = 10;
          break;
        case 'Nov':
          month = 11;
          break;
        case 'Dec':
          month = 12;
          break;
        default:
          return null;
      }
      int day = int.parse(parts[1]);
      return DateTime(year, month, day);
    } catch (e) {
      return null;
    }
  }
}
