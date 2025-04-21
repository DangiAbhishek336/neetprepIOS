// Automatic FlutterFlow imports
import 'package:from_css_color/from_css_color.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom widgets
// Imports custom actions
// Imports custom functions
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '/components/custom_html_view/custom_html_view_widget.dart';

// Set your widget name, define your parameter, and then add the
// boilerplate code using the button on the right!

class CustomWebView extends StatefulWidget {
  final String src;
  final double height;
  final double width;
  final Key? key;

  CustomWebView(
      {required this.src, required this.height, required this.width, this.key})
      : super(key: key);

  @override
  _CustomWebViewState createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  final PlatformWebViewController _controller = PlatformWebViewController(
    const PlatformWebViewControllerCreationParams());
  double _height = 0;
  final Key htmlKey = UniqueKey();
  final PlatformNavigationDelegate? _myDelegate = isWeb ?
      null : PlatformNavigationDelegate(const PlatformNavigationDelegateCreationParams());
  late final List<YoutubePlayerController> _controllers;
  late final String _widgetSrcNoYT;
  late final bool _displayWebview;

  @override
  void initState() {
    super.initState();

    List<String> youtubeVideoIds = [];
    List<int?> startTimes = [];
  
    // TODO: this is a temporary fix to handle some html content in question and explanation to show as webview only till their content is fixed so that they they can be shown as a normal flutter html widget
    _displayWebview = widget.src.contains("<span class=\"display_webview\"></span>");
    RegExp regExp = RegExp(
      r'<iframe.*?src="https:\/\/www\.youtube(-nocookie)?\.com\/embed\/(.*?)\?((?!start).)*?(start=(\d+))?((?!start).)*?".*?><\/iframe>',
      caseSensitive: false,
      multiLine: true,
    );

    /*
       TODO: html fixes to make things work in short term
       1. load mathjax for math formula
       2. don't load audio on mobile as that seems to disable audio play in some cases on android
       3. replace all youtube videos and then load them via youtube_player_iframe
    */
    var htmlFix = (String src) {
      RegExp mathjaxRegex = RegExp(r'(<math.*>.*</math>|math-tex)');
      if (mathjaxRegex.hasMatch(src) && _displayWebview) {
        src += '''
          <script src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-MML-AM_CHTML"></script>
          <script type="text/x-mathjax-config">
            MathJax.Hub.Config({
              messageStyle: "none"
            });
          </script>
          <script>document.addEventListener("DOMContentLoaded", function(event) { MathJax.Hub.Queue(["Typeset",MathJax.Hub]);  });</script>
        ''';
      }
      src = src.replaceAllMapped(regExp, (match) {
        youtubeVideoIds.add(match.group(2)!);
        startTimes.add(match.group(5) != null ? int.parse(match.group(5)!) : null);
        return '';
      });
      return isWeb ? src : src.replaceAll('<audio ', '<audio preload="none" ');
    };

    _widgetSrcNoYT = htmlFix(widget.src); 

    _controllers = List.generate(
      youtubeVideoIds.length,
      (index) => YoutubePlayerController.fromVideoId(
        videoId: youtubeVideoIds[index],
        startSeconds: startTimes[index]?.toDouble(),
        autoPlay: false,
        params: const YoutubePlayerParams(showFullscreenButton: true),
      ),
    );

    if (!isWeb && _displayWebview) {
      _myDelegate?.setOnPageFinished((url) {
        var duration = const Duration(seconds: 1);
        sleep(duration);
        _controller.runJavaScriptReturningResult('document.body != null ? document.body.scrollHeight : ${widget.height};').then((height) {
          if (_height != double.tryParse(height.toString())) {
            setState(() {
              _height = double.tryParse(height.toString()) ?? widget.height;
            });
          }
        });
      });
      _controller.setPlatformNavigationDelegate(_myDelegate!);
    }
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_height == 0)
      _height = widget.height;
    String htmlStr ='''
      <!DOCTYPE html>
        <html>
          <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>
              iframe {
                max-width: 640px !important;
                max-height: 360px !important;
                position: static !important;
              }
              .youtube-embed-wrapper {
                max-width: 640px !important;
                max-height: 360px !important;
                padding-bottom: 0px !important;
                position: static !important;
                height: 100% !important;
              }
              body {
                /* Special handling for web as default font Poppins is not working well in custom html and custom web view */
                background-color: ${FFAppState().isDarkMode ? FlutterFlowTheme.of(context).secondaryBackground.toCssString() : 'white'};
                color: ${FlutterFlowTheme.of(context).primaryText.toCssString()};
                font-size: ${FlutterFlowTheme.of(context).titleSmall.fontSize!}px;
                font-family: ${!isWeb ? "'" + FlutterFlowTheme.of(context).bodyMediumFamily + "'" : 'sans-serif'};
                font-weight: ${FontWeight.w400.value};
              }
              img {
                max-width: 100%;
              }
              table {
                max-width: 100%;
              }
              .w-100 {
                width: 100%;
              }
            </style>
          </head>
          <body>
            <!--TODO: needs more investigation.. extremely bizzare issue of audio at times not playing on android and showing as greyed out..that was getting fixed by randomly moving to another page and coming back..so for now it seems that the explicitly avoiding preloading in android works-->
            $_widgetSrcNoYT
          </body>
        </html>
      ''';
    if (_controllers.isNotEmpty) {
      return Column(
        children: List.generate(_controllers.length, (index) {
          final _ytController = _controllers[index];

          return Container(
            margin: EdgeInsets.all(8.0),
            child: YoutubePlayer(
              key: ObjectKey(_ytController),
              enableFullScreenOnVerticalDrag: false,
              controller: _ytController
              ..setFullScreenListener(
                (_) async {
                  final videoData = await _ytController.videoData;
                  final startSeconds = await _ytController.currentTime;

                  final currentTime = await FullscreenYoutubePlayer.launch(
                    context,
                    videoId: videoData.videoId,
                    startSeconds: startSeconds,
                  );

                  if (currentTime != null) {
                    _ytController.seekTo(seconds: currentTime);
                  }
                },
              ),
              aspectRatio: 16 / 9,
            ),
          );
        })..add(_displayWebview == false ? 
          CustomHtmlViewWidget(
            key: htmlKey,
            questionStr: htmlStr
            ) : 
          SizedBox(
            // TODO: adding 20 as offset for final height as the scrollHeight seems to be just clipping the bottom
            height: _height + 20,
            child: PlatformWebViewWidget(
              PlatformWebViewWidgetCreationParams(
                gestureRecognizers: Set()..add(Factory<VerticalDragGestureRecognizer>(
                    () => VerticalDragGestureRecognizer()
                    )),
                controller: (!isWeb ?
                  (_controller..setJavaScriptMode(JavaScriptMode.unrestricted)) : _controller)
                ..loadHtmlString(htmlStr),
                key: htmlKey)).build(context))),
          );

    } else {
      return _displayWebview == false ? CustomHtmlViewWidget(key: htmlKey, questionStr: htmlStr) : SizedBox(
          // TODO: adding 20 as offset for final height as the scrollHeight seems to be just clipping the bottom
          height: _height + 20,
          child: PlatformWebViewWidget(
            PlatformWebViewWidgetCreationParams(
              gestureRecognizers: Set()..add(Factory<VerticalDragGestureRecognizer>(
                  () => VerticalDragGestureRecognizer()
                  )),
              controller: (!isWeb ?
                (_controller..setJavaScriptMode(JavaScriptMode.unrestricted)) : _controller)
              ..loadHtmlString(htmlStr),
              key: htmlKey)).build(context));
    }
  }
}
