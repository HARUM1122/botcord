import 'package:discord/src/features/guild/utils/utils.dart';
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
      if (!guildsCache.contains(guild)) {
        guildsCache.add(guild);
        guildsCache = sortGuilds(guildsCache);
        notifyListeners();
      }
    });
    client?.onGuildUpdate.listen((event) {
      for (int i = 0; i < guildsCache.length; i++) {
        if (guildsCache[i].id == event.guild.id) {
          guildsCache[i] = event.guild;
          guildsCache = sortGuilds(guildsCache);
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
      guildsCache = sortGuilds(guildsCache);
      notifyListeners();
    });
  }

  void clearCache() {
    currentGuild = null;
    guildsCache.clear();
  }
}