// Automatic FlutterFlow imports
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';

import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openWebUrlOnExcecption({
  String? msg,
  String? orderId,
  String? amount,
  String? txnToken,
  int? paymentId,
  String? mid,
}) async {
  print(msg);
  if (isWeb) {
    /* TODO: the below is a test url, we either need to change it to a relative path
  on the current url or provide an absolute url*/
    final String encodedAppTitle = Uri.encodeComponent('NEETprep Essential');
    final String redirectDomain = 'essential.neetprep.com';
    final url = '${FFAppState().baseUrl}/payment/js_payment' +
        '?orderId=$orderId&token=$txnToken&amount=$amount' +
        '&paymentId=$paymentId&mid=$mid&title=$encodedAppTitle' +
        '&redirect_domain=$redirectDomain';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, webOnlyWindowName: '_self');
    } else {
      throw 'Could not launch $url';
    }
  } else {
    print("not handled platform scenario");
  }
}

Future<String?> paytmIntegration(String orderId, String amount, String txnToken,
    int paymentId, String mid, String callbackUrl) async {
  try {
    Trace customTrace = FirebasePerformance.instance.newTrace("custom-trace");
    await customTrace.start();
    customTrace.incrementMetric("paytm-integration", 1);
    var response = await AllInOneSdk.startTransaction(
        mid, orderId, amount, txnToken, callbackUrl, false, false);
    print("Paytm Response: " + response.toString());
    await customTrace.stop();
    return response!['STATUS'].toString();
  } on PlatformException catch (e,stackTrace) {
    print("PaytmPlatformExceptionError:" +
        "\n" +
        e.message! +
        " \n  " +
        e.details.toString());
    print(e.toString());
    openWebUrlOnExcecption(
      msg: "platform exception error",
      orderId: orderId,
      amount: amount,
      txnToken: txnToken,
      paymentId: paymentId,
      mid: mid,
    );
    FirebaseCrashlytics.instance.setCustomKey('paytm_error', e.toString());
    FirebaseCrashlytics.instance.log("Paytm Platform Exception "+ e.toString());
    FirebaseCrashlytics.instance.recordError(e, stackTrace);
    return e.details?['STATUS'].toString();
  } on Exception catch (e,stackTrace) {
    print("PaytmNotPlatformExceptionError:" + "\n" + e.toString());
    print(e.toString());
    openWebUrlOnExcecption(
      msg: "not platform exception error",
      orderId: orderId,
      amount: amount,
      txnToken: txnToken,
      paymentId: paymentId,
      mid: mid,
    );
    FirebaseCrashlytics.instance.setCustomKey('paytm_error', e.toString());
    FirebaseCrashlytics.instance.log("Paytm Not Platform Exception "+ e.toString());
    FirebaseCrashlytics.instance.recordError(e, stackTrace);
    return null;
  } catch (e,stackTrace) {
    // No specified type, handles all
    print('Something really unknown: $e');
    FirebaseCrashlytics.instance.setCustomKey('paytm_error', e.toString());
    FirebaseCrashlytics.instance.log("Something really unknown: "+ e.toString());
    FirebaseCrashlytics.instance.recordError(e, stackTrace);
    return null;
  }
}
