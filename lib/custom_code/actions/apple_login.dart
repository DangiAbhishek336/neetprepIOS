// Automatic FlutterFlow imports

import 'dart:developer';

import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '../../auth/firebase_auth/auth_util.dart';

import '../../backend/api_requests/api_calls.dart';

Future<dynamic> appleLogin(BuildContext context) async {
  var userData;
  dynamic userAccessInfo;
  final signInFunc = () async {
    try {
      /*if (kIsWeb) {
        // Once signed in, return the UserCredential
        return await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
      }*/

      await authManager.signOut().catchError((_) => null);
      userData = await authManager.signInWithApple(context);
      userAccessInfo = await SignupGroup
          .googleLoginServerCallWithCodeReceivedFromGoogleAuthenticationCall
          .call(
        email: userData?.email.toLowerCase(),
        name: userData?.displayName,
        picture: userData?.photoUrl,
      )
          .then((value) {
        log("userAccessInfo");
        log(value.jsonBody.toString());
        ;
        FFAppState().userIdInt =
            getJsonField((value.jsonBody ?? ''), r'''$.id''');
        FFAppState().subjectToken =
            getJsonField((value.jsonBody ?? ''), r'''$.token''');
      });

      log(FFAppState().subjectToken.toString());
    } catch (e, stackTrace) {
      // The idea is to have a fallback login on debug mode as that would allow testing the app which is currently
      // failing due to javascript origin mismatch for google sign in
      log("Error in apple login: $e");
      log("Error in apple login stacktrace: $stackTrace");
    }
  };

  await signInFunc();

  dynamic userJson = {
    "email": userData?.email,
    "profile": userData?.photoUrl,
    "name": userData?.displayName,
    "accessToken": FFAppState().subjectToken ?? '',
  };

  return userJson;
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the button on the right!
