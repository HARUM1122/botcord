import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:nyxx/nyxx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/globals.dart';

import '../../../features/guild/utils/utils.dart';
import '../../../features/guild/controllers/roles_controller.dart';
import '../../../features/guild/controllers/members_controller.dart';
import '../../../features/guild/controllers/channels_controller.dart';

final guildsControllerProvider = ChangeNotifierProvider<GuildsController>((ref) => GuildsController(
  channelsControllerProvider: ref.read(guildChannelsControllerProvider),
  membersController: ref.read(membersControllerProvider),
  rolesController: ref.read(rolesControllerProvider)
));

class GuildsController extends ChangeNotifier {
  final GuildChannelsController channelsControllerProvider;
  final MembersController membersController;
  final RolesController rolesController;

  GuildsController({
    required this.channelsControllerProvider,
    required this.membersController,
    required this.rolesController
  });

  bool loading = true;
  bool errorOccurred = false;

  Guild? currentGuild;
  List<UserGuild> guildsCache = [];
  
  Future<void> selectGuild(UserGuild guild, {bool shouldRefresh = true, bool selectChannelFromDb = false}) async {
    if (guild.id == currentGuild?.id) return;
    currentGuild = await guild.get();
    currentMember = await guild.members[user!.id].get();
    final Map<String, dynamic> appData = jsonDecode(prefs.getString('app-data')!);
    appData['selected-guild-id'] = guild.id.toString();
    await channelsControllerProvider.fetchAllChannels(
      currentGuild!,
      channel: selectChannelFromDb ? await getChannel(Snowflake.parse(appData['selected-channel-id']), guild: currentGuild) : null
    );
    await membersController.listenEvents(currentGuild!);
    await rolesController.listenEvents(currentGuild!);
    await prefs.setString('app-data', jsonEncode(appData));
    if (shouldRefresh) notifyListeners();
  }

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
      print(appData);
      Snowflake selectedGuildId = Snowflake.parse(appData['selected-guild-id']);

      if (guildsCache.isNotEmpty) {
        selectGuild(guildsCache.firstWhere(
            (userGuild) => userGuild.id == selectedGuildId,
            orElse: () => guildsCache.first
          ),
          shouldRefresh: false,
          selectChannelFromDb: true
        );
      }
      listenEvents();
    } catch (_) {
      print(_);
      errorOccurred = true;
    }
    loading = false;
    notifyListeners();
  }

  void listenEvents() {
    client?.onGuildCreate.listen((event) async {
      Guild guild = await event.guild.get();
      if (!guildsCache.contains(guild)) {
        guildsCache.add(guild);
        guildsCache = sortGuilds(guildsCache);
        await selectGuild(guild, shouldRefresh: false);
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
          await selectGuild(guildsCache.first, shouldRefresh: false);
        } else {
          await channelsControllerProvider.stopListeningEvents();
          currentGuild = null;
        }
        await Future.delayed(const Duration(milliseconds: 200));
        await Navigator.pushReplacementNamed(globalNavigatorKey.currentContext!, '/home-route');
      }
      guildsCache = sortGuilds(guildsCache);
      notifyListeners();
    });
  }
}


