import 'dart:async';

import 'package:discord/src/common/utils/globals.dart';
import 'package:flutter/foundation.dart';  

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyxx/nyxx.dart';

final guildChannelsControllerProvider = ChangeNotifierProvider<GuildChannelsController>((ref) => GuildChannelsController());

class GuildChannelsController extends ChangeNotifier {
  final List<GuildChannel> channels = [];
  GuildChannel? currentChannel;
  
  StreamSubscription<ChannelCreateEvent>? channelCreateEvent;
  StreamSubscription<ChannelUpdateEvent>? channelUpdateEvent;
  StreamSubscription<ChannelDeleteEvent>? channelDeleteEvent;

  Future<void> _listenChannelEvents(Guild guild) async {
    await channelCreateEvent?.cancel();
    await channelUpdateEvent?.cancel();
    await channelDeleteEvent?.cancel();

    channelCreateEvent = client?.onChannelCreate.listen((event) async {
      if (event.channel is GuildChannel && (event.channel as GuildChannel).guildId == guild.id) {
        channels.add(event.channel as GuildChannel);
        notifyListeners();
      } 
    });
    channelUpdateEvent = client?.onChannelUpdate.listen((event) {
      if (event.channel is GuildChannel && (event.channel as GuildChannel).guildId == guild.id) {
        final GuildChannel channel = event.channel as GuildChannel;
        channels[channels.indexOf(channel)] = channel;
        notifyListeners();
      }
    });
    channelDeleteEvent = client?.onChannelDelete.listen((event) {
      if (event.channel is GuildChannel && (event.channel as GuildChannel).guildId == guild.id) {
        channels.remove(event.channel);
        notifyListeners();
      }
    });
  }
   Future<void> fetchAllChannels(Guild guild) async {
    channels.clear();
    channels.addAll(await guild.fetchChannels());
    // TODO make a function named select channels and in that select channels function, fetch the messages
    await _listenChannelEvents(guild);
  }
}