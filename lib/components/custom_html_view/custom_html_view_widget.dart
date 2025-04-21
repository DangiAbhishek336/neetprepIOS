import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_math/flutter_html_math.dart';
import 'package:flutter_html_svg/flutter_html_svg.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:flutter_html_audio/flutter_html_audio.dart';
import 'package:flutter_html_iframe/flutter_html_iframe.dart';
import 'package:provider/provider.dart';
import 'custom_html_view_model.dart';
export 'custom_html_view_model.dart';
import 'package:photo_view/photo_view.dart';

class CustomHtmlViewWidget extends StatefulWidget {
  const CustomHtmlViewWidget({
    Key? key,
    this.questionStr,
  }) : super(key: key);

  final String? questionStr;

  @override
  _CustomHtmlViewWidgetState createState() => _CustomHtmlViewWidgetState();
}

class _CustomHtmlViewWidgetState extends State<CustomHtmlViewWidget> {
  late CustomHtmlViewModel _model;
  late String finalHtmlStr;

  @override
  void setState(VoidCallback callback) {
    if (mounted) {
      super.setState(callback);
    }
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CustomHtmlViewModel());
    // TODO: replaceAll is placed much before it is needed. It should be moved closer to where it is needed
    finalHtmlStr =
        widget.questionStr!.replaceAll("<mo>&nbsp;</mo>", "<mo>~</mo>");

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Html(
      data: finalHtmlStr.replaceAll("%2D", "-"),
      style: {
        "body": Style(
          fontSize: FontSize(FlutterFlowTheme.of(context).titleSmall.fontSize!),
          /* Special handling for web as default font Poppins is not working well in custom html and custom web view */
          fontFamily: !isWeb
              ? FlutterFlowTheme.of(context).bodyMediumFamily
              : 'sans-serif',
          color: FlutterFlowTheme.of(context).primaryText,
          fontWeight: FontWeight.w400,
        ),
        "table": Style(
          height: Height.auto(),
          width: Width.auto(),
        ),
        "tr": Style(
          height: Height.auto(),
          width: Width.auto(),
          border: Border.all(
              width: 1.0, color: FlutterFlowTheme.of(context).secondaryText),
        ),
        "td": Style(
          padding: HtmlPaddings.all(6),
          height: Height.auto(),
          border: Border.all(
              width: 1.0, color: FlutterFlowTheme.of(context).secondaryText),
        ),
        "th": Style(
          padding: HtmlPaddings.all(6),
          height: Height.auto(),
          border: Border.all(
              width: 1.0, color: FlutterFlowTheme.of(context).secondaryText),
        ),
      },
      extensions: [
        MathHtmlExtension(),
        SvgHtmlExtension(),
        OnImageTapExtension(onImageTap: (src, attrs, ele) async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Center(
                child: Container(
                  height: 300,
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  color: Colors.white,
                  child: PhotoView(
                    backgroundDecoration: BoxDecoration(color: Colors.white),
                    imageProvider: NetworkImage(
                      src!,
                      // width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ),
              );
            },
          );
        }),
        TableHtmlExtension(),
        AudioHtmlExtension(),
        IframeHtmlExtension(),
        MatcherExtension(matcher: (context) {
          return (context.elementName == "span" &&
              context.classes.toList().contains("math-tex"));
        }, builder: (extensionContext) {
          return Math.tex(
              extensionContext.innerHtml
                  .substring(2, extensionContext.innerHtml.length - 2)
                  .replaceAll("&lt;", "<")
                  .replaceAll("&amp;", "&")
                  .replaceAll("&nbsp;", " ")
                  .replaceAll("&gt;", ">"),
              mathStyle: MathStyle.display,
              textStyle:
                  extensionContext.styledElement?.style.generateTextStyle(),
              onErrorFallback: (FlutterMathException e) {
            //optionally try and correct the Tex string here
            return Text(e.message);
          });
        }),
      ],
    );
  }
}
