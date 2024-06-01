import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:discord/src/common/utils/globals.dart';

final themeController = StateNotifierProvider<ThemeController, String>((ref) => ThemeController());

class ThemeController extends StateNotifier<String> {
  ThemeController() : super('dark');
  
  Future<void> setTheme(String appTheme, bool save, bool init) async {
    if (init) await Future.delayed(const Duration(seconds: 1));
    state = appTheme;
    if (save) {
      final Map<String, dynamic> appData = jsonDecode(prefs.getString('app-data')!);
      appData['theme'] = appTheme;
      await prefs.setString('app-data', jsonEncode(appData));
    }
  }
}