import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_state.dart';

class ThemeNotifier extends ValueNotifier<ThemeMode> {
  ThemeNotifier(ThemeMode mode) : super(mode);

  void toggleDarkMode() {
    value = value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    FFAppState().isDarkMode = !FFAppState().isDarkMode;
    _setLauncherIcon(FFAppState().isDarkMode);
  }
}

// Global instance
final ThemeNotifier themeNotifier = ThemeNotifier(ThemeMode.light);

Future<void> _setLauncherIcon(bool isDarkMode) async {
  try {
    const platform = MethodChannel('def');
    await platform.invokeMethod('setLauncherIcon', {'isDarkMode': isDarkMode});
  } on PlatformException catch (e) {
    print("Failed to change icon: ${e.message}");
  }
}
