import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:discord/src/common/utils/cache.dart';

final themeProvider = StateNotifierProvider<ThemeProvider, String>((ref) => ThemeProvider());

class ThemeProvider extends StateNotifier<String> {
  ThemeProvider() : super('dark');
  
  Future<void> setTheme(String appTheme, bool save, bool init) async {
    if (init) await Future.delayed(const Duration(seconds: 1));
    state = appTheme;
    if (save) {
      await prefs.setString('app-theme', appTheme);
    }
  }
}