import 'dart:convert';
import 'dart:developer';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neetprep_essential/app_state.dart';
import 'package:neetprep_essential/clevertap/clevertap_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:neetprep_essential/app_state.dart';

Future<void> handelBackgroundMessage(RemoteMessage message) async {
  log('Title: ${message.notification?.title}');
  log('Body: ${message.notification?.body}');
  log('payload: ${message.data}');
}

class FirebaseApi {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static String fcmToken = "";

  static final _androidChannel = const AndroidNotificationChannel(
    "High_importance_channel",
    "High Importance Notifications",
    description: "This channel is used for important channel ",
    importance: Importance.defaultImportance,
  );

  static final _localNotifications = FlutterLocalNotificationsPlugin();

  static void handelMessage(RemoteMessage? message) async {
    if (message == null) return;

    print("working");
    print(message.notification!.body);
    if (!await launchUrl(Uri.parse(message.notification!.body as String))) {
      throw Exception('Could not launch ${message.notification!.body}');
    }
  }

  static Future initLocalNotifications() async {
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android, iOS: iOS);
    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        final message = RemoteMessage.fromMap(
          jsonDecode(details.payload as String),
        );
        handelMessage(message);
      },
    );

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  static Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then(handelMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handelMessage);
    FirebaseMessaging.onBackgroundMessage(handelBackgroundMessage);
    FirebaseMessaging.onMessage.listen((event) {
      final notification = event.notification;
      if (notification == null) return;

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@drawable/ic_launcher',
          ),
        ),
        payload: jsonEncode(
          event.toMap(),
        ),
      );
    });
  }

  static Future<void> updateFcmToken({
    required String authorizationToken,
    required int userId,
    required String fcmToken,
    required String deviceId,
    required String deviceAdsId,
    required String androidDetails,
    required String platform,
    required String app,
  }) async {
    final String url = '${FFAppState().baseUrl}/api/v1/user/fcmTokenUpdate';

    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authorizationToken',
      };

      Map<String, dynamic> body = {
        'userId': userId,
        'fcmToken': fcmToken,
        'deviceId': deviceId,
        'deviceAdsId': deviceAdsId,
        'androidDetails': androidDetails,
        'platform': platform,
        'app': app,
      };

      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        log('Update successful. Response body: ${response.body}');
      } else {
        FirebaseCrashlytics.instance
            .setCustomKey('fcm_token_update_error', response.body.toString());
        log('Failed to update. Status code: ${response.statusCode}. Response body: ${response.body}');
        Fluttertoast.showToast(msg: "Something went wrong!");
      }
    } catch (e, stackTrace) {
      Fluttertoast.showToast(msg: "Something went wrong!");
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      log('Exception occurred: $e');
    }
  }

  static Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    final fCMToken = await _firebaseMessaging.getToken();
    FirebaseCrashlytics.instance.setCustomKey("fcm_token", fCMToken!);
    FirebaseCrashlytics.instance.setUserIdentifier(fCMToken ?? "");
    print("Fcm Token : $fCMToken");
    fcmToken = fCMToken;
    print("updated value : $fcmToken");
    await updateFcmToken(
        authorizationToken: FFAppState().subjectToken,
        userId: FFAppState().userIdInt,
        fcmToken: fCMToken,
        deviceId: "",
        androidDetails: "",
        platform: "android",
        app: "abhyas",
        deviceAdsId: "");
    initPushNotifications();
    initLocalNotifications();
  }
}
