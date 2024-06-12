import 'dart:convert';

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

  bool loading = true;
  bool errorOccurred = false;

  Guild? currentGuild;
  List<UserGuild> guildsCache = [];
  
  Future<void> selectGuild(UserGuild guild, {bool refresh = true}) async {
    if (guild.id == currentGuild?.id) return;
    currentGuild = await guild.get();
    await channelsControllerProvider.fetchAllChannels(currentGuild!);
    final Map<String, dynamic> appData = jsonDecode(prefs.getString('app-data')!);
    appData['selected-guild-id'] = currentGuild?.id.toString() ?? '0';
    await prefs.setString('app-data', jsonEncode(appData));
    if (refresh) notifyListeners();
  }

  // Future<void> createGuild(GuildBuilder guildBuilder) async {
  //   try {

  //   }
  //   selectGuild();
  // }

  Future<void> fetchMoreServers(Snowflake? after) async {

  }

  Future<void> init() async {
    loading = true;
    errorOccurred = false;
    guildsCache.clear();
    notifyListeners();
    try {
      guildsCache = List.of(await client?.listGuilds() ?? []);
      guildsCache = sortGuilds(guildsCache);
      final Map<String, dynamic> appData = jsonDecode(prefs.getString('app-data')!);
      Snowflake selectedGuildId = Snowflake.parse(appData['selected-guild-id']);

      if (guildsCache.isNotEmpty) {
        if (currentGuild == null) {
          selectGuild(guildsCache.firstWhere(
              (userGuild) => userGuild.id == selectedGuildId,
              orElse: () => guildsCache.first
            ),
            refresh: false
          );
        }
      }
      listenGuildEvents();
    } catch (_) {
      errorOccurred = true;
    }
    loading = false;
    notifyListeners();
  }

  void listenGuildEvents() {
    client?.onGuildCreate.listen((event) async {
      Guild guild = event is GuildCreateEvent ? event.guild : await event.guild.get();
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
    client?.onGuildDelete.listen((event) async {
      guildsCache.removeWhere((guild) => guild.id == event.guild.id);
      if (currentGuild?.id == event.guild.id) {
        if (guildsCache.isNotEmpty) {
          selectGuild(guildsCache.first);
        } else {
          currentGuild = null;
        }
        Navigator.pushReplacementNamed(globalNavigatorKey.currentContext!, '/home-route');
      }
      guildsCache = sortGuilds(guildsCache);
      notifyListeners();
    });
  }
}