import 'package:discord/src/features/guild/controllers/channels_controller.dart';
import 'package:discord/src/features/guild/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:nyxx/nyxx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/globals.dart';

final guildsControllerProvider = ChangeNotifierProvider<GuildsController>((ref) => GuildsController(
  channelsControllerProvider: ref.read(guildChannelsControllerProvider)
));

class GuildsController extends ChangeNotifier {
  final GuildChannelsController channelsControllerProvider;
  GuildsController({
    required this.channelsControllerProvider
  });

  List<Guild> guildsCache = [];
  Guild? currentGuild;
  
  void listenGuildEvents() {
    client?.onGuildCreate.listen((event) async {
      Guild guild = event is GuildCreateEvent ? event.guild : await event.guild.get();
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
          currentGuild = event.guild.id == currentGuild?.id ? event.guild : currentGuild;
          guildsCache = sortGuilds(guildsCache);
          notifyListeners();
          break;
        }
      }
    });
    client?.onGuildDelete.listen((event) {
      guildsCache.removeWhere((guild) => guild.id == event.guild.id);
      if (currentGuild?.id == event.guild.id) {
        currentGuild = guildsCache.isNotEmpty ? guildsCache.first : null;
        Navigator.pushReplacementNamed(globalNavigatorKey.currentContext!, '/home-route');
      }
      guildsCache = sortGuilds(guildsCache);
      notifyListeners();
    });
  }


  Future<void> selectGuild(Guild guild) async {
    if (guild.id == currentGuild?.id) return;
    currentGuild = guild;
    await channelsControllerProvider.fetchAllChannels(guild);
    notifyListeners();
  }

  void clearCache() {
    guildsCache.clear();
  }
}