import 'package:discord/src/common/controllers/theme_controller.dart';
import 'package:discord/src/common/utils/globals.dart';
import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/features/guild/controllers/channels_controller.dart';
import 'package:discord/src/features/guild/screens/panels/menu/components/bottom_sheet/channel_options/text_channel/text_channels_options.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nyxx/nyxx.dart';

import 'package:discord/src/common/utils/extensions.dart';

import 'package:discord/src/features/guild/utils/utils.dart';

import 'channel_types/channel_types.dart';

class ChannelsList extends ConsumerWidget {
  final List<GuildChannel> channels;
  final Snowflake? currentChannelId;
  final Guild guild;
  const ChannelsList({
    required this.channels,
    required this.currentChannelId,
    required this.guild,
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.read(themeController);
    final GuildChannelsController channelsController = ref.read(guildChannelsControllerProvider);
    if (currentMember == null) {
      return const SizedBox();
    }
    return StretchingOverscrollIndicator(
      axisDirection: AxisDirection.down,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowIndicator();
          return true;
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: context.padding.bottom + 65),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: () {
              List<Widget> allChannels = [];
              for (final GuildChannel channel in channels) {
                final bool hasParent = channel.parentId != null;
                bool selected = currentChannelId == channel.id;
                if (channel.type == ChannelType.guildText && !hasParent) {
                  allChannels.add(
                    FutureBuilder(
                      future: computeOverwrites(currentMember!, channel),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Offstage(
                            offstage: !snapshot.data!.canViewChannel,
                            child: TextChannelButton(
                              textChannel: channel as GuildTextChannel,
                              selected: selected,
                              onPressed: () async => await channelsController.selectChannel(channel),
                              onLongPress: () => showSheet(
                                context: context,
                                height: 0.6,
                                maxHeight: 0.8,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16)
                                ),
                                color: appTheme<Color>(theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0xFF000000)),
                                builder: (context, controller, offset) => TextChannelOptionsSheet(
                                  guild: guild, 
                                  textChannel: channel, 
                                  controller: controller
                                )
                              )
                            ),
                          );
                        }
                        return const SizedBox();
                      }
                    )
                  );
                } else if (channel.type == ChannelType.guildVoice && !hasParent) {
                  allChannels.add(
                    FutureBuilder(
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
                    )
                  );
                } else if (channel.type == ChannelType.guildCategory) {
                  allChannels.add(
                    FutureBuilder(
                      future: computeOverwrites(currentMember!, channel),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return CategoryButton(
                            category: channel as GuildCategory,
                            permissions: snapshot.data!,
                            channels: channels,
                            canView: snapshot.data!.canViewChannel,
                          );
                        }
                        return const SizedBox();
                      }
                    )
                  );
                } else if (channel.type == ChannelType.guildForum && !hasParent) {
                  allChannels.add(
                    FutureBuilder(
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
                    )
                  );
                } else if (channel.type == ChannelType.guildAnnouncement && !hasParent) {
                  allChannels.add(
                    FutureBuilder(
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
                    )
                  );
                } else if (channel.type == ChannelType.guildStageVoice && !hasParent) {
                  allChannels.add(
                    FutureBuilder(
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
                    )
                  );
                } 
              }
              return allChannels;
            }()
          ),
        ),
      ),
    );
  }
}

