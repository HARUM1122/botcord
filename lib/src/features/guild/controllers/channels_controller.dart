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
        if (const [ChannelType.guildAnnouncement, ChannelType.guildForum, ChannelType.guildText].contains(channel.type) && currentChannel == null && (await computeOverwrites(currentMember!, channel)).canViewChannel) {
          await selectChannel(channel, refresh: false);
        }
        channels.add(channel);
        channels = sortChannels(channels);
        notifyListeners();
      }
    });

    channelUpdateEvent = client?.onChannelUpdate.listen((event) async {
      if (event.channel is GuildChannel && (event.channel as GuildChannel).guildId == guild.id) {
        final GuildChannel channel = event.channel as GuildChannel;
        final bool canViewChannel = (await computeOverwrites(currentMember!, channel)).canViewChannel;
        if (const [ChannelType.guildAnnouncement, ChannelType.guildForum, ChannelType.guildText].contains(channel.type) && currentChannel == null && canViewChannel) {
          await selectChannel(channel, refresh: false);
        } else if (currentChannel?.id == channel.id && !canViewChannel) {
          currentChannel = null;
           // TODO STOP LISTENING MESSAGE EVENTS
          for (GuildChannel channel in channels) {
            if (const [ChannelType.guildAnnouncement, ChannelType.guildForum, ChannelType.guildText].contains(channel.type) && currentChannel == null && (await computeOverwrites(currentMember!, channel)).canViewChannel) {
              await selectChannel(channel, refresh: false);
              break;
            }
          }
        } 
        channels[channels.indexOf(channel)] = channel;
        channels = sortChannels(channels);
        notifyListeners();
      }
    });

    channelDeleteEvent = client?.onChannelDelete.listen((event) async {
      if (event.channel is GuildChannel && (event.channel as GuildChannel).guildId == guild.id) {
        channels.remove(event.channel);
        if (currentChannel?.id == event.channel.id) {
          currentChannel = null;
           // TODO STOP LISTENING MESSAGE EVENTS
          for (GuildChannel channel in channels) {
            if (const [ChannelType.guildAnnouncement, ChannelType.guildForum, ChannelType.guildText].contains(channel.type) && currentChannel == null && (await computeOverwrites(currentMember!, channel)).canViewChannel) {
              await selectChannel(channel, refresh: false);
              break;
            }
          }
        }
        channels = sortChannels(channels);
        notifyListeners();
      }
    });
  }

  Future<void> selectChannel(GuildChannel channel, {bool refresh = true}) async {
    print(channel.name);
    if (channel.id == currentChannel?.id) return;
    currentChannel = channel;
    final Map<String, dynamic> appData = jsonDecode(prefs.getString('app-data')!);
    appData['selected-channel-id'] = channel.id.toString();
    await prefs.setString('app-data', jsonEncode(appData));
    // TODO LISTEN MESSAGE EVENTS
    if (refresh) notifyListeners();
  }

  Future<void> fetchAllChannels(Guild guild, {GuildChannel? channel}) async {
    channels.clear();
    channels.addAll(await guild.fetchChannels());
    channels = sortChannels(channels);
    currentChannel = null;
    if (channel != null && (await computeOverwrites(currentMember!, channel)).canViewChannel) {
      await selectChannel(channel);
    } else {
      for (final GuildChannel guildChannel in channels) {
        if (
          !const [ChannelType.guildAnnouncement, ChannelType.guildForum, ChannelType.guildText].contains(guildChannel.type) ||
          !(await computeOverwrites(currentMember!, guildChannel)).canViewChannel
        ) continue;
        await selectChannel(guildChannel);
        break;
      }
    }
    await listenEvents(guild);
    notifyListeners();
  }
}