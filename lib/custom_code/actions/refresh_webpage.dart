// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:universal_html/html.dart' as html;

Future refreshWebpage() async {
  if (isWeb) {
    html.window.location.reload();
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the button on the right!
