import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dark.dart';
import 'light.dart';
import 'midnight.dart';

import 'package:discord/src/common/utils/cache.dart';

final themeProvider = StateNotifierProvider<ThemeProvider, Map>((ref) => ThemeProvider());

class ThemeProvider extends StateNotifier<Map> {
  ThemeProvider() : super({});

  Future<void> setTheme(String appTheme, bool save) async {
    switch (appTheme) {
      case 'light':
        state = lightTheme;
      case 'dark':
        state = darkTheme;
      default:
        state = midnightTheme;
    }
    theme = state;
    if (save) {
      await prefs.setString('app-theme', appTheme);
    }
  }
}