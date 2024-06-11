import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';


class DB {
  static void updateBotData(
    SharedPreferences prefs,
    {
      Map<String, dynamic>? bots,
      Map<String, dynamic>? activity,
      Map<String, dynamic>? currentBot
    }
  ) async {
    final Map<String, dynamic> botData = jsonDecode(prefs.getString('bot-data')!);
    if (bots != null) {
      botData['bots'] = bots;
    }
    if (activity != null) {
      botData['activity'] = activity;
    }
    if (currentBot != null) {
      botData['current-bot'] = currentBot;
    }
    await prefs.setString('current-bot', jsonEncode(botData));
  }
  static void updateAppData(
    SharedPreferences prefs,
    {
      String? theme,
      bool? isLanded,
      List<dynamic>? trustedDomains,
      String? selectedGuildId
    }
  ) async {
    final Map<String, dynamic> appData = jsonDecode(prefs.getString('app-data')!);
    if (theme != null) {
      appData['theme'] = theme;
    }
    if (isLanded != null) {
      appData['is-landed'] = isLanded;
    }
    if (trustedDomains != null) {
      appData['trusted-domains'] = trustedDomains;
    }
    if (selectedGuildId != null) {
      appData['selected-guild-id'] = selectedGuildId;
    }
    await prefs.setString('app-data', jsonEncode(appData));
  }
}

// await prefs.setString('app-data', jsonEncode(
//       {
//         'theme': 'dark',
//         'is-landed': false,
//         'trusted-domains': [],
//         'selected-guild-id' : ''
//       }
//     ));
//     await prefs.setString('bot-data', jsonEncode(
//       {
//         'bots': {},
//         'activity': {
//           'current-online-status': 'online',
//           'current-activity-text': '',
//           'current-activity-type': 'custom',
//           'since': ';'
//         },
//         'current-bot': {},
//       }
//     ));