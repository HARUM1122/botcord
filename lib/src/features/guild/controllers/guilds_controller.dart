import 'package:flutter/material.dart';

import 'package:nyxx/nyxx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/globals.dart';

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
      currentGuild ??= guild;
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