import 'package:firebase_analytics/firebase_analytics.dart';

import '../../../clevertap/clevertap_service.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_pdf_viewer.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'notes_viewer_page_model.dart';
export 'notes_viewer_page_model.dart';

class NotesViewerPageWidget extends StatefulWidget {
  const NotesViewerPageWidget({
    Key? key,
    this.pdfURL,
    String? pdfName,
  })  : this.pdfName = pdfName ?? 'Notes',
        super(key: key);

  final String? pdfURL;
  final String pdfName;

  @override
  _NotesViewerPageWidgetState createState() => _NotesViewerPageWidgetState();
}

class _NotesViewerPageWidgetState extends State<NotesViewerPageWidget> {
  late NotesViewerPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotesViewerPageModel());
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "NotesViewerPage",);
    CleverTapService.recordPageView("NotesViewerPage");
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Title(
        title: 'NotesViewerPage',
        color: FlutterFlowTheme.of(context).primaryBackground,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, _) => [
                SliverAppBar(
                  pinned: true,
                  floating: false,
                  snap: false,
                  backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                  automaticallyImplyLeading: false,
                  leading: FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 30.0,
                    borderWidth: 1.0,
                    buttonSize: 60.0,
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 30.0,
                    ),
                    showLoadingIndicator: true,
                    onPressed: () async {
                      context.pop();
                    },
                  ),
                  title: Text(
                    '${widget.pdfName} Notes',
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).headlineMediumFamily,
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context)
                                  .headlineMediumFamily),
                        ),
                  ),
                  actions: [],
                  centerTitle: true,
                  elevation: 0.0,
                )
              ],
              body: Builder(
                builder: (context) {
                  return SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: FlutterFlowPdfViewer(
                            networkPath: widget.pdfURL!,
                            // networkPath:
                            //     "https://dsbihjlymzdyy.cloudfront.net/PG_PDFs/GLOMERULAR%20DISORDERS.pdf",
                            width: double.infinity,
                            height: double.infinity,
                            horizontalScroll: false,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ));
  }
}
