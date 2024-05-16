import 'dart:async';

import 'package:discord/src/common/utils/globals.dart';
import 'package:discord/src/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nyxx/nyxx.dart';

final guildsControllerProvider = ChangeNotifierProvider((ref) => GuildsController());

class GuildsController extends ChangeNotifier {
  List<UserGuild> guildsCache = [];
  UserGuild? currentGuild;

  void selectGuild(UserGuild guild) {
    if (guild.id == currentGuild?.id) return;
    currentGuild = guild;
    notifyListeners();
  }

  void listenGuildEvents() {
    client?.onGuildCreate.listen((event) async {
      UserGuild guild = await event.guild.get();
      currentGuild = currentGuild != null ? guild : currentGuild;
      guildsCache.add(guild);
      notifyListeners();
    });
    client?.onGuildUpdate.listen((event) {
      for (int i = 0; i < guildsCache.length; i++) {
        if (guildsCache[i].id == event.guild.id) {
          guildsCache[i] = event.guild;
          notifyListeners();
          break;
        }
      }
    });
    client?.onGuildDelete.listen((event) {
      if (currentGuild?.id == event.guild.id) {
        currentGuild = guildsCache.isNotEmpty ? guildsCache.first : null;
      }
      guildsCache.removeWhere((guild) => guild.id == event.guild.id);
      notifyListeners();
    });
  }

  void clearCache() {
    guildsCache.clear();
    currentGuild = null;
  }
}