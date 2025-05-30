// Automatic FlutterFlow imports
import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '../../auth/firebase_auth/google_auth.dart';

import '../../backend/api_requests/api_calls.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<dynamic> gmailLogin(BuildContext context) async {
  final _googleSignIn = GoogleSignIn(
    clientId:
        "545751718198-vuf6jdbui14uhcetonj1j2lob1k76jmh.apps.googleusercontent.com",
    scopes: ["profile", "email"],
  );
  var userData;
  dynamic userAccessInfo;
  final signInFunc = () async {
    try {
      /*if (kIsWeb) {
        // Once signed in, return the UserCredential
        return await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
      }*/

      await signOutWithGoogle().catchError((e, stackTrace) {
        FirebaseCrashlytics.instance.setCustomKey('login_error', e.toString());
        FirebaseCrashlytics.instance.log("Login Failed " + e.toString());
        FirebaseCrashlytics.instance.recordError(e, stackTrace);
      });
      userData = await _googleSignIn.signIn();
      userAccessInfo = await SignupGroup
          .googleLoginServerCallWithCodeReceivedFromGoogleAuthenticationCall
          .call(
        email: userData?.email.toLowerCase(),
        name: userData?.displayName,
        picture: userData?.photoUrl,
      );

      log("userAccessInfo");
      log(userAccessInfo!.jsonBody.toString());
      ;
      FFAppState().userIdInt =
          getJsonField((userAccessInfo?.jsonBody ?? ''), r'''$.id''');
      FFAppState().subjectToken =
          getJsonField((userAccessInfo?.jsonBody ?? ''), r'''$.token''');

      var authTokens = await userData.authentication;
      final credential = GoogleAuthProvider.credential(
          idToken: authTokens?.idToken, accessToken: authTokens?.accessToken);
      return FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e, stackTrace) {
      // The idea is to have a fallback login on debug mode as that would allow testing the app which is currently
      // failing due to javascript origin mismatch for google sign in
      print(e);
      FirebaseCrashlytics.instance.setCustomKey('login_error', e.toString());
      FirebaseCrashlytics.instance.log("Login Failed " + e.toString());
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      if (kDebugMode) {
        final auth =
            await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());

        userData = auth;

        dynamic userAccessInfo = await SignupGroup
            .googleLoginServerCallWithCodeReceivedFromGoogleAuthenticationCall
            .call(
          email: auth.user?.email?.toLowerCase(),
          name: auth.user?.displayName,
          picture: auth.user?.photoURL,
        );

        FFAppState().userIdInt =
            getJsonField((userAccessInfo?.jsonBody ?? ''), r'''$.id''');
        FFAppState().subjectToken =
            getJsonField((userAccessInfo?.jsonBody ?? ''), r'''$.token''');
        return auth;
      }
    }
  };

  await signInFunc();

  dynamic userJson = {
    "email": userData?.email,
    "profile": userData?.photoUrl,
    "name": userData?.displayName,
    "accessToken": FFAppState().subjectToken =
        getJsonField((userAccessInfo?.jsonBody ?? ''), r'''$.token'''),
  };

  return userJson;
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the button on the right!
