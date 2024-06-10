import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:nyxx/nyxx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/constants.dart';
import '../../../common/utils/globals.dart';

final profileControllerProvider = ChangeNotifierProvider((ref) => ProfileController());

class ProfileController extends ChangeNotifier {
  Map<String, dynamic> botActivity = {
    'current-online-status': 'online',
    'current-activity-text': '',
    'current-activity-type': 'custom',
    'since': ';'
  };
  int currentSeconds = 0;
  Timer? timer;
  
  Duration? getDuration(DateTime? datetime) {
    Duration? duration;
    if (botActivity['since'] != ';' && datetime != null) {
      duration = DateTime.parse(botActivity['since'].split(';')[0]).difference(datetime);
    }
    return duration;
  }

  void clearPresence() {
    botActivity['current-activity-text'] = '';
    botActivity['since'] = ';';
    currentSeconds = 0;
  }
  
  void updatePresence({required bool save, DateTime? datetime}) {
    Duration? duration = getDuration(datetime);
    if (duration != null) {
      currentSeconds = duration.inSeconds;
      timer?.cancel();
      if (currentSeconds <= 0) {
        clearPresence();
      }
    }
    else if (botActivity['since'] == ';') {
      timer?.cancel();
      currentSeconds = 0;
    }
    client!.updatePresence(
      PresenceBuilder(
        isAfk: false,
        status: onlineStatus[botActivity['current-online-status']]!,
        activities: botActivity['current-activity-text'].isNotEmpty ?[ 
          botActivity['current-activity-type'] != 'custom' 
          ? ActivityBuilder(
              name: botActivity['current-activity-text'],
              type: activityTypes[botActivity['current-activity-type']]!
            )
          : ActivityBuilder(
              name: 'Custom Status',
              state: botActivity['current-activity-text'],
              type: activityTypes[botActivity['current-activity-type']]!,
            )
        ]: null,
      )
      // HAD TO DO THIS BECAUSE ITS JUST DISCORD :)
    );
    if (duration != null && currentSeconds > 0) {
      startTimer();
    }
    if (save) {
      final Map<String, dynamic> botData = jsonDecode(prefs.getString('bot-data')!);
      botData['activity'] = botActivity;
      prefs.setString('bot-data', jsonEncode(botData));
    }
    notifyListeners();
  }

  Future <void> updateProfile({
    required String username,
    required String description,
    required ImageBuilder avatar,
    required ImageBuilder? banner,
  }) async {
    user = await client!.users.updateCurrentUser(
      UserUpdateBuilder(
        avatar: avatar,
        username: username,
        banner: banner
      )
    );
    application = await client!.applications.updateCurrentApplication(
      ApplicationUpdateBuilder(
        icon: avatar,
        coverImage: banner,
        description: description,
      )
    );
    notifyListeners();
  }
  
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentSeconds == 0) {
        clearPresence();
        updatePresence(save: true);
      } else {
        notifyListeners();
        currentSeconds--;
      }
    });
  }
}