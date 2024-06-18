import 'dart:async';

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

  Future<void> listenChannelEvents(Guild guild) async {
    await stopListeningEvents();
    
    channelCreateEvent = client?.onChannelCreate.listen((event) async {
      if (event.channel is GuildChannel && (event.channel as GuildChannel).guildId == guild.id) {
        channels.add(event.channel as GuildChannel);
        channels = sortChannels(channels);
        notifyListeners();
      }
    });

    channelUpdateEvent = client?.onChannelUpdate.listen((event) {
      if (event.channel is GuildChannel && (event.channel as GuildChannel).guildId == guild.id) {
        final GuildChannel channel = event.channel as GuildChannel;
        channels[channels.indexOf(channel)] = channel;
        channels = sortChannels(channels);
        notifyListeners();
      }
    });

    channelDeleteEvent = client?.onChannelDelete.listen((event) {
      if (event.channel is GuildChannel && (event.channel as GuildChannel).guildId == guild.id) {
        channels.remove(event.channel);
        channels = sortChannels(channels);
        notifyListeners();
      }
    });
  }

  Future<void> fetchAllChannels(Guild guild) async {
    channels.clear();
    channels.addAll(await guild.fetchChannels());
    channels = sortChannels(channels);
    currentChannel = channels.isEmpty ? null : channels.first;
    await listenChannelEvents(guild);
    notifyListeners();
  }
}