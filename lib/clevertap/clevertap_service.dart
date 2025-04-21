import 'dart:developer';
import 'dart:io' show Platform;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:clevertap_plugin/clevertap_plugin.dart';

class CleverTapService {
  static final CleverTapPlugin clevertapPlugin = CleverTapPlugin();

  static Future<DateTime> getUserFirstLoginDate() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Get the user's metadata and extract the creation time
      DateTime? creationTime = user.metadata.creationTime;

      // If creationTime is null, return current time as a fallback
      return creationTime ?? DateTime.now();
    } else {
      // User is not logged in, return current time as fallback
      return DateTime.now();
    }
  }

  static Future<void> initialize(
      String name, String email, String phone) async {
    try {
      final DateTime? firstLoginDate = await getUserFirstLoginDate();
      String createdAt = firstLoginDate!
          .toIso8601String(); // You can also use millisecondsSinceEpoch if needed

      //expiry flow added for user course
      dynamic expiryDate = null;
      dynamic mbbsStartingYear = null;
      dynamic collegeName = null;

      Map<String, dynamic> profile = {
        'Name': name,
        'Email': email,
        'createdAt': createdAt,
        'courseExpiryDate': expiryDate != null ? expiryDate : '',
        'phone': phone,
        'MSG-whatsapp': true,
        'MBBS Starting Year': mbbsStartingYear,
        'College Name': collegeName
      };

      //It ends here

      if (kIsWeb) {
        print("here are the clevetap init");
        CleverTapPlugin.setDebugLevel(3);

        CleverTapPlugin.init("8RK-K84-8R7Z").onError((error, stackTrace) {
          print(error.toString());
        });
        // CleverTapPlugin.onUserLogin(profile);

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
          "Reflex",
          "Reflex Notifications",
          "General Notifications",
          5,
          true,
        );

        final fcmToken = await FirebaseMessaging.instance.getToken();
        log("semnding push $fcmToken}");
        CleverTapPlugin.setPushToken(fcmToken ?? "");
        CleverTapPlugin.onUserLogin(profile);
      } else if (Platform.isIOS) {
        CleverTapPlugin.registerForPush();
        CleverTapPlugin.onUserLogin(profile);
        CleverTapPlugin().setCleverTapProfileDidInitializeHandler(() {
          log("CleverTap profile initialized.");
        });

        log("CleverTap initialized successfully.");
      }
    } catch (e) {
      log("Error initializing CleverTap: $e");
    }
  }
}
