import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '/backend/api_requests/api_calls.dart';
import '/components/custom_html_view/custom_html_view_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import 'package:flutter/material.dart';

class PracticeQuetionsPageModel extends FlutterFlowModel {
  ///  Local state fields for this page.

  bool isLoading = false;
  bool isRefresh = false;
  String currentExplanation = "";

  int chkAnswer = 0;

  bool showConfetti = false;

  int confettiParticleCount = 20;

  double confettiGravity = 0.8;

  bool showExplanation = true;
//TODO: change to false
  bool showMeNcert = false;

  bool ncertDropdown = false;

  int quesTitleNumber = 0;

  bool? sectionCompleted = false;

  String subTopicName = '';

int sectionNumber = 0;
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Backend Call - API (Get Status of all Practice Questions for a test for a given user)] action in PracticeQuetionsPage widget.
  ApiCallResponse? statusList;
  ApiCallResponse? userAccessJson;
  // Stores action output result for [Custom Action - chkJson] action in PracticeQuetionsPage widget.
  List<dynamic>? newStatusList;
  // Stores action output result for [Bottom Sheet - BubbleQuestions] action in Image widget.
  int? selectedPageNumber;
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // Stores action output result for [Backend Call - API (Create or delete bookmark for a practice question by a user)] action in Icon widget.
  ApiCallResponse? apiResultdn0;
  // Stores action output result for [Backend Call - API (Create or delete bookmark for a practice question by a user)] action in Icon widget.
  ApiCallResponse? apiResultdn1;
  // Stores action output result for [Backend Call - API (Create answer for a practice question by a user with specific marked option )] action in Container widget.
  ApiCallResponse? apiResultixv;
  InstantTimer? instantTimer;
  // Models for CustomHtmlView dynamic component.
  late FlutterFlowDynamicModels<CustomHtmlViewModel> customHtmlViewModels1;
  // Models for CustomHtmlView dynamic component.
  late FlutterFlowDynamicModels<CustomHtmlViewModel> customHtmlViewModels2;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    customHtmlViewModels1 =
        FlutterFlowDynamicModels(() => CustomHtmlViewModel());
    customHtmlViewModels2 =
        FlutterFlowDynamicModels(() => CustomHtmlViewModel());
  }

  void dispose() {
    unfocusNode.dispose();
    instantTimer?.cancel();
    // customHtmlViewModels1.dispose();
    // customHtmlViewModels2.dispose();
  }

  String extractHref(String htmlString) {
    final regex = RegExp(r'href="([^"]+)"');
    final match = regex.firstMatch(htmlString);
    return match != null ? match.group(1)! : '';
  }

  String appendParamsToUrl(String url, String idToken) {
    final uri = Uri.parse(url);

    final newUri = uri.replace(queryParameters: {
      ...uri.queryParameters, // retain existing query params
      'id_token': idToken,
      'embed': '1',
    });
    print(newUri.toString());

    return newUri.toString();
  }

  void showNcertSentencesBottomSheet(BuildContext context, List<dynamic> sentences) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // important for dynamic height + content
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets, // handles keyboard overlap too
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Wrap( // <-- Wrap makes it size dynamically
              children: [
                Container(
                  padding: EdgeInsets.only(bottom:16),
                  child: Text(
                    'NCERT Ref.',
                    style: FlutterFlowTheme.of(context).bodyBold,
                  ),
                ),
                const SizedBox(height: 20),
                ListView.separated(
                  shrinkWrap: true,  // <--- important
                  physics: const NeverScrollableScrollPhysics(), // let bottom sheet scroll if needed
                  itemCount: sentences.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final sentenceUrl = sentences[index]["sentenceUrl"];
                    return InkWell(
                      onTap: () async {
                        final url = extractHref(sentences[index]["fullSentenceUrl"]);
                        context.pushNamed('flutterWebView', queryParameters: {
                          'webUrl': appendParamsToUrl(url, FFAppState().subjectToken).toString(),
                          'title': "NCERT Ref."
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.open_in_new,
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                          const SizedBox(width: 5.0),
                          Expanded(
                            child: Text(
                              sentenceUrl,
                              style: FlutterFlowTheme.of(context).bodyRegular.override(
                                fontFamily: FlutterFlowTheme.of(context).bodyRegularFamily,
                                fontSize: 15,
                                color: FlutterFlowTheme.of(context).primaryText,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }



/// Action blocks are added here.

  /// Additional helper methods are added here.
}
