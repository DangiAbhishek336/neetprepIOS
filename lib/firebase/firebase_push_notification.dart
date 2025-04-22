import 'dart:convert';
import 'dart:developer';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:neetprep_essential/app_state.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class FirebaseApi {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static String fcmToken = "";

  static final _androidChannel = const AndroidNotificationChannel(
    "High_importance_channel",
    "High Importance Notifications",
    description: "This channel is used for important channel ",
    importance: Importance.defaultImportance,
  );
  static Future<void> handelBackgroundMessage(RemoteMessage message) async {
    log('Title: ${message.notification?.title}');
    log('Body: ${message.notification?.body}');
    log('payload: ${message.data}');
    handelMessage(message);
  }

  static final _localNotifications = FlutterLocalNotificationsPlugin();
  static void handelMessage(RemoteMessage? message) async {
    if (message == null) return;

    // Extract deep link URL from the notification data
    final deepLink = message.data['deeplink'];
    if (deepLink != null && deepLink.isNotEmpty) {
      final uri = Uri.parse(deepLink);

      log("Here is the deeplink : ${deepLink}");

      dynamic canlaunch = canLaunchUrl(uri);

      // Wait until Flutter has initialized
      if (await canLaunchUrl(uri)) {
        log("entered the launch url method");

        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } else {
        log('Could not launch $deepLink');
      }
    } else {
      // Handle notifications without deep links (default behavior)
      log("Notification Title: ${message.notification?.title}");
      log("Notification Body: ${message.notification?.body}");
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
    const String url = 'https://www.neetprep.com/api/v1/user/fcmTokenUpdate';

    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authorizationToken',
        'x-app-id':
            '2e78f3bc-23df-4f1d-8189-8e6426612c7f', // Added app ID header
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
        // Fluttertoast.showToast(msg: "Something went wrong!");
      }
    } catch (e, stackTrace) {
      //Fluttertoast.showToast(msg: "Something went wrong!");
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      log('Exception occurred: $e');
    }
  }

  static Future<void> sendStartupApiRequest() async {
    log("YOYOYOYOYOYOYOYOYOYOYOYOY");
    final url = Uri.parse('https://www.neetprep.com/startup_api');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': FFAppState().subjectToken,
      'x-app-id': '2e78f3bc-23df-4f1d-8189-8e6426612c7f', // Added app ID header
    };
    final body = json.encode({
      'appName': 'reflexpg',
    });

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // Request was successful
        log('Response: ${response.body}');
      } else {
        // Request failed
        log('Failed to send request: ${response.statusCode}');
      }
    } catch (e) {
      // Error occurred
      print('Error: $e');
    }
  }

  static Future<void> initNotifications() async {
    try {
      await _firebaseMessaging.requestPermission();

      // Fetch the token safely
      final String? fCMToken = await _firebaseMessaging.getToken();

      if (fCMToken == null) {
        log("Error: FCM token is null");
        FirebaseCrashlytics.instance.log("FCM token is null");
        return; // Stop execution to prevent null crash
      }

      // Store and log the token safely
      FirebaseCrashlytics.instance.setCustomKey("fcm_token", fCMToken);
      log("Fcm Token : $fCMToken");
      fcmToken = fCMToken;
      log("updated value : $fcmToken");

      await updateFcmToken(
        authorizationToken: FFAppState().subjectToken,
        userId: FFAppState().userIdInt,
        fcmToken: fCMToken,
        deviceId: "",
        androidDetails: "",
        platform: "IOS",
        app: "NeetprepIOS",
        deviceAdsId: "",
      );

      initPushNotifications();
      initLocalNotifications();
    } catch (e, stack) {
      log("FCM Initialization Error: $e");
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }
}
