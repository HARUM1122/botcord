import 'dart:async';
import 'dart:convert';

import 'package:discord/src/common/utils/globals.dart';
import 'package:discord/src/features/guild/utils/utils.dart';
import 'package:flutter/foundation.dart';  

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyxx/nyxx.dart';

final guildChannelsControllerProvider = ChangeNotifierProvider<GuildChannelsController>((ref) => GuildChannelsController());

class GuildChannelsController extends ChangeNotifier {
  List<GuildChannel> channels = [];
  GuildChannel? currentChannel;
  
  StreamSubscription<ChannelCreateEvent>? channelCreateEvent;
  StreamSubscription<ChannelUpdateEvent>? channelUpdateEvent;
  StreamSubscription<ChannelDeleteEvent>? channelDeleteEvent;

  Future<void> stopListeningEvents() async {
    await channelCreateEvent?.cancel();
    await channelUpdateEvent?.cancel();
    await channelDeleteEvent?.cancel();
  }

  Future<void> listenEvents(Guild guild) async {
    await stopListeningEvents();

    channelCreateEvent = client?.onChannelCreate.listen((event) async {
      if (event.channel is GuildChannel && (event.channel as GuildChannel).guildId == guild.id) {
        final GuildChannel channel = event.channel as GuildChannel;
        if (isTextChannel(channel) && currentChannel == null && (await computeOverwrites(currentMember!, channel)).canViewChannel) {
          await selectChannel(channel, shouldRefresh: false);
        }
        channels.add(channel);
        channels = sortChannels(channels);
        refresh();
      }
    });

    channelUpdateEvent = client?.onChannelUpdate.listen((event) async {
      if (event.channel is GuildChannel && (event.channel as GuildChannel).guildId == guild.id) {
        final GuildChannel channel = event.channel as GuildChannel;
        final bool canViewChannel = (await computeOverwrites(currentMember!, channel)).canViewChannel;
        if (isTextChannel(channel) && currentChannel == null && canViewChannel) {
          await selectChannel(channel, shouldRefresh: false);
        } else if (currentChannel?.id == channel.id && !canViewChannel) {
          await selectIfCanView(shouldRefresh: false);
        } 
        channels[channels.indexOf(channel)] = channel;
        channels = sortChannels(channels);
        refresh();
      }
    });

    channelDeleteEvent = client?.onChannelDelete.listen((event) async {
      if (event.channel is GuildChannel && (event.channel as GuildChannel).guildId == guild.id) {
        channels.remove(event.channel);
        if (currentChannel?.id == event.channel.id) {
          await selectIfCanView(shouldRefresh: false);
        }
        channels = sortChannels(channels);
        refresh();
      }
    });
  }

  Future<void> selectIfCanView({bool shouldRefresh = true}) async {
    currentChannel = null;
     // TODO STOP LISTENING MESSAGE EVENTS
    for (GuildChannel channel in channels) {
      if (isTextChannel(channel) && currentChannel == null && (await computeOverwrites(currentMember!, channel)).canViewChannel) {
        await selectChannel(channel, shouldRefresh: false);
        break;
      }
    }
    if (shouldRefresh) refresh();
  }

  Future<void> selectChannel(GuildChannel channel, {bool shouldRefresh = true}) async {
    if (channel.id == currentChannel?.id) return;
    currentChannel = channel;
    final Map<String, dynamic> appData = jsonDecode(prefs.getString('app-data')!);
    appData['selected-channel-id'] = channel.id.toString();
    await prefs.setString('app-data', jsonEncode(appData));
    // TODO LISTEN MESSAGE EVENTS
    if (shouldRefresh) refresh();
  }

  Future<void> fetchAllChannels(Guild guild, {GuildChannel? channel}) async {
    channels
    ..clear()
    ..addAll(await guild.fetchChannels());
    channels = sortChannels(channels);
    currentChannel = null;
    if (channel != null && (await computeOverwrites(currentMember!, channel)).canViewChannel) {
      await selectChannel(channel);
    } else {
      
      for (final GuildChannel guildChannel in channels) {
        if (
          !isTextChannel(guildChannel) ||
          !(await computeOverwrites(currentMember!, guildChannel)).canViewChannel
        ) continue;
        await selectChannel(guildChannel);
        break;
      }
    }
    await listenEvents(guild);
    refresh();
  }

  void refresh() => notifyListeners();
}