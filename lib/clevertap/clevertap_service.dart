
import 'dart:developer';
import 'dart:io' show Platform;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:clevertap_plugin/clevertap_plugin.dart';


class CleverTapService {


  static void recordPageView(String pageViewed)  {
    log("pageViewed "+ pageViewed.toString());
    CleverTapPlugin.recordEvent(pageViewed,{});
  }
  static void recordEvent(String eventName, var eventData)  {
    log("event "+ eventName.toString()+eventData.toString());
    CleverTapPlugin.recordEvent(eventName,eventData);
  }

  static void onUserLogin(profile){
    log("profile "+ profile.toString());
    CleverTapPlugin.onUserLogin(profile);
  }

  static void profileSet(profile){

    CleverTapPlugin.profileSet(profile);
  }



  static Future<void> enablePushNotification() async{
    try {
      if (kIsWeb) {
        final fcmToken = await FirebaseMessaging.instance.getToken();
        CleverTapPlugin.setPushToken(fcmToken ?? "");
        CleverTapPlugin.enableWebPush({
          'titleText': 'Would you like to receive notifications?',
          'bodyText': 'Stay updated with relevant alerts.',
          'okButtonText': 'Yes',
          'rejectButtonText': 'No',
          'serviceWorkerPath': '/firebase-messaging-sw.js',
        });
      } else if (Platform.isAndroid) {

        CleverTapPlugin.createNotificationChannel(
          "Essential",
          "Essential Notifications",
          "General Notifications",
          5,
          true,
        );

        final fcmToken = await FirebaseMessaging.instance.getToken();
        CleverTapPlugin.setPushToken(fcmToken ?? "");
      } else if (Platform.isIOS) {
        CleverTapPlugin.registerForPush();
        CleverTapPlugin().setCleverTapProfileDidInitializeHandler(() {
          log("CleverTap profile initialized.");
        });

        log("CleverTap initialized successfully.");
      }
    }
   catch (e) {
  log("Error initializing CleverTap: $e");
  }
}
}







