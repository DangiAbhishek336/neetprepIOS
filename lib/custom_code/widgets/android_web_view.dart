import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;

import 'package:neetprep_essential/app_state.dart';

class AndroidWebView extends StatelessWidget {
  final String html;

  AndroidWebView({required this.html});

  @override
  Widget build(BuildContext context) {
    return PlatformViewLink(
      viewType: "abc",
      surfaceFactory:
          (BuildContext context, PlatformViewController controller) {
        return AndroidViewSurface(
          controller: controller as AndroidViewController,
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
            Factory<OneSequenceGestureRecognizer>(
              () => EagerGestureRecognizer(),
            ),
          },
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (PlatformViewCreationParams params) {
        return PlatformViewsService.initSurfaceAndroidView(
          id: params.id,
          layoutDirection: ui.TextDirection.ltr,
          viewType: 'com.neetprep.ios/nativeview',
          creationParams: <String, dynamic>{
            'html': html,
            'darkMode': FFAppState().isDarkMode,
          },
          creationParamsCodec: const StandardMessageCodec(),
        )
          ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
          ..create();
      },
    );
  }
}
