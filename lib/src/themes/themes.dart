import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dark.dart';
import 'light.dart';
import 'midnight.dart';

import 'package:discord/src/common/utils/cache.dart';

final themeProvider = StateNotifierProvider<ThemeProvider, String>((ref) => ThemeProvider());

class ThemeProvider extends StateNotifier<String> {
  ThemeProvider() : super('dark');
  
  Future<void> setTheme(String appTheme, bool save) async {
    switch (appTheme) {
      case 'light':
        theme = lightTheme;
      case 'dark':
        theme = darkTheme;
      default:
        theme = midnightTheme;
      state = appTheme;
    }
    if (save) {
      await prefs.setString('app-theme', appTheme);
    }
  }
}