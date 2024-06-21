import 'package:discord/src/common/utils/globals.dart';
import 'package:discord/src/features/guild/controllers/channels_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nyxx/nyxx.dart';

import 'package:discord/src/common/utils/extensions.dart';

import 'package:discord/src/features/guild/utils/utils.dart';

import 'channel_types/channel_types.dart';

class ChannelsList extends ConsumerWidget {
  final List<GuildChannel> channels;
  final Snowflake? currentChannelId;
  const ChannelsList({
    required this.channels,
    required this.currentChannelId,
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GuildChannelsController channelsController = ref.read(guildChannelsControllerProvider);
    if (currentMember == null) {
      return const SizedBox();
    }
    return ListView.builder(
      padding: EdgeInsets.only(bottom: context.padding.bottom + 65),
      itemCount: channels.length,
      itemBuilder: (context, index) {
        final GuildChannel channel = channels[index];
        final bool hasParent = channel.parentId != null;
        bool selected = currentChannelId == channel.id;
        if (channel.type == ChannelType.guildText && !hasParent) {
          return FutureBuilder(
            future: computeOverwrites(currentMember!, channel),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Offstage(
                  offstage: !snapshot.data!.canViewChannel,
                  child: TextChannelButton(
                    textChannel: channel as GuildTextChannel,
                    selected: selected,
                    onPressed: () async => await channelsController.selectChannel(channel),
                    onLongPress: () {},
                  ),
                );
              }
              return const SizedBox();
            }
          );
        } else if (channel.type == ChannelType.guildVoice && !hasParent) {
          return FutureBuilder(
            future: computeOverwrites(currentMember!, channel),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Offstage(
                  offstage: !snapshot.data!.canViewChannel,
                  child: VoiceChannelButton(
                    voiceChannel: channel as GuildVoiceChannel,
                    onPressed: () async {
                    }
                  ),
                );
              }
              return const SizedBox();
            }
          );
        } else if (channel.type == ChannelType.guildCategory) {
          return FutureBuilder(
            future: computeOverwrites(currentMember!, channel),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Offstage(
                  offstage: !snapshot.data!.canViewChannel,
                  child: CategoryButton(
                    category: channel as GuildCategory,
                    permissions: snapshot.data!,
                    channels: channels,
                  )
                );
              }
              return const SizedBox();
            }
          );
        } else if (channel.type == ChannelType.guildForum && !hasParent) {
          return FutureBuilder(
            future: computeOverwrites(currentMember!, channel),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Offstage(
                  offstage: !snapshot.data!.canViewChannel,
                  child: ForumChannnelButton(
                    forumChannel: channel as ForumChannel,
                    selected: selected, 
                    onPressed: () async => await channelsController.selectChannel(channel),
                  )
                );
              }
              return const SizedBox();
            }
          );
        } else if (channel.type == ChannelType.guildAnnouncement && !hasParent) {
          return FutureBuilder(
            future: computeOverwrites(currentMember!, channel),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Offstage(
                  offstage: !snapshot.data!.canViewChannel,
                  child: AnnouncementChannelButton(
                    announcementChannel: channel as GuildAnnouncementChannel,
                    selected: selected,
                    onPressed: () async => await channelsController.selectChannel(channel),
                  )
                );
              }
              return const SizedBox();
            }
          );
        } else if (channel.type == ChannelType.guildStageVoice && !hasParent) {
          return FutureBuilder(
            future: computeOverwrites(currentMember!, channel),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Offstage(
                  offstage: !snapshot.data!.canViewChannel,
                  child: StageChannelButton(
                    stageChannel: channel as GuildStageChannel,
                    onPressed: () {}
                  )
                );
              }
              return const SizedBox();
            }
          );
        } 
        return const SizedBox();
      }
    );
  }
}