import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBkCwHfmBau9fiWl2jT-XFiyWhd5D4nfbk",
            authDomain: "neetprep-essential.firebaseapp.com",
            projectId: "neetprep-essential",
            storageBucket: "neetprep-essential.appspot.com",
            messagingSenderId: "623494990675",
            appId: "1:623494990675:web:b0c2b9f992f35938af2fa6",
            measurementId: "G-BQXRP3W5QE"));
  } else {
    await Firebase.initializeApp();
  }
}
