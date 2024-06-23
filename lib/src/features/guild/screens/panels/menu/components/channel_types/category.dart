import 'package:discord/src/common/utils/globals.dart';
import 'package:discord/src/features/guild/screens/panels/menu/components/channel_types/channel_types.dart';
import 'package:discord/src/features/guild/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:nyxx/nyxx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/common/controllers/theme_controller.dart';

import 'package:discord/src/features/guild/controllers/channels_controller.dart';

class CategoryButton extends ConsumerStatefulWidget {
  final GuildCategory category;
  final Permissions permissions;
  final List<GuildChannel> channels;
  final bool canView;
  const CategoryButton({
    required this.category,
    required this.permissions,
    required this.channels,
    required this.canView,
    super.key
  });

  @override
  ConsumerState<CategoryButton> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends ConsumerState<CategoryButton> {

  late final String _theme = ref.read(themeController);

  late final Color _color1 = appTheme<Color>(
    _theme,
    light: const Color(0xFF000000),
    dark: const Color(0xFFFFFFFF),
    midnight: const Color(0xFFFFFFFF)
  ).withOpacity(0.5);
  
  late bool _opened = widget.channels.isNotEmpty;

  Future<List<GuildChannel>> filterChannels() async {
    final List<GuildChannel> channels = [];
    for (final GuildChannel channel in widget.channels) {
      if (channel.parentId == widget.category.id && (await computeOverwrites(currentMember!, channel)).canViewChannel) {
        channels.add(channel);
      }
    }
    return channels;
  }

  @override
  Widget build(BuildContext context) {
    final GuildChannelsController channelsController = ref.read(guildChannelsControllerProvider);

    return FutureBuilder(
      future: filterChannels(),
      builder: (context, snapshot) {
        List<Widget> allChannels = [];
        Widget selectedChannel = const SizedBox();
        for (GuildChannel channel in snapshot.data ?? []) {
          bool selected = channelsController.currentChannel?.id == channel.id;
          if (channel.type == ChannelType.guildText) {
            allChannels.add(
              TextChannelButton(
                textChannel: channel as GuildTextChannel,
                selected: selected,
                onPressed: () async => await channelsController.selectChannel(channel),
                onLongPress: () {},
              )
            );
            if (selected) {
              selectedChannel = allChannels.last;
            }
          } else if (channel.type == ChannelType.guildAnnouncement) {
            allChannels.add(
              AnnouncementChannelButton(
                announcementChannel: channel as GuildAnnouncementChannel,
                selected: selected,
                onPressed: () async => await channelsController.selectChannel(channel)
              )
            );
            if (selected) {
              selectedChannel = allChannels.last;
            }
          } else if (channel.type == ChannelType.guildForum) {
            allChannels.add(
              ForumChannnelButton(
                forumChannel: channel as ForumChannel,
                selected: selected, 
                onPressed: () async => await channelsController.selectChannel(channel)
              )
            );
            if (selected) {
              selectedChannel = allChannels.last;
            }
          } else if (channel.type == ChannelType.guildVoice) {
            allChannels.add( 
              VoiceChannelButton(
                voiceChannel: channel as GuildVoiceChannel,
                onPressed: () {}
              )
            );
          } else if (channel.type == ChannelType.guildStageVoice) {
            allChannels.add(
              StageChannelButton(
                stageChannel: channel as GuildStageChannel,
                onPressed: () {}
              )
            );
          }   
        }
        if (allChannels.isEmpty && !widget.canView) return const SizedBox();
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [ 
            GestureDetector(
              onTap: () => setState(() => _opened = !_opened),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      _opened ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                      color: _color1,
                      size: 13,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        widget.category.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.2,
                          fontFamily: 'GGSansBold',
                          color: _color1
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            () {
              if (_opened) {
                return Column(
                  children: allChannels,
                );
              }
              return selectedChannel;
            }()
          ],
        );
      }
    );
    // Widget selectedChannel = const SizedBox();
    // List<Widget> allChannels = [];
    // bool hasChannels = false;
    // for (GuildChannel channel in channelsController.channels) {
    //   if (channel.parentId != widget.category.id) continue;
    //   bool selected = channelsController.currentChannel?.id == channel.id;
    //   if (channel.type == ChannelType.guildText) {
    //     allChannels.add(
    //       FutureBuilder(
    //         future: computeOverwrites(currentMember!, channel), 
    //         builder: (context, snapshot) {
    //           if (snapshot.hasData && snapshot.data!.canViewChannel) {
    //             hasChannels = true;
    //             return TextChannelButton(
    //               textChannel: channel as GuildTextChannel,
    //               selected: selected,
    //               onPressed: () async => await channelsController.selectChannel(channel),
    //               onLongPress: () {},
    //             );
    //           }
    //           return const SizedBox();
    //         }
    //       )
    //     );
    //     if (selected) {
    //       selectedChannel = allChannels.last;
    //     }
    //   } else if (channel.type == ChannelType.guildAnnouncement) {
    //     allChannels.add(
    //       FutureBuilder(
    //         future: computeOverwrites(currentMember!, channel),
    //         builder: (context, snapshot) {
    //           if (snapshot.hasData && snapshot.data!.canViewChannel) {
    //             hasChannels = true;
    //             return AnnouncementChannelButton(
    //               announcementChannel: channel as GuildAnnouncementChannel,
    //               selected: selected,
    //               onPressed: () async => await channelsController.selectChannel(channel)
    //             );
    //           }
    //           return const SizedBox();
    //         }
    //       )
    //     );
    //     if (selected) {
    //       selectedChannel = allChannels.last;
    //     }
    //   } else if (channel.type == ChannelType.guildForum) {
    //     allChannels.add(
    //       FutureBuilder(
    //         future: computeOverwrites(currentMember!, channel),
    //         builder: (context, snapshot) {
    //           if (snapshot.hasData && snapshot.data!.canViewChannel) {
    //             hasChannels = true;
    //             return ForumChannnelButton(
    //               forumChannel: channel as ForumChannel,
    //               selected: selected, 
    //               onPressed: () async => await channelsController.selectChannel(channel)
    //             );
    //           }
    //           return const SizedBox();
    //         }
    //       )
    //     );
    //     if (selected) {
    //       selectedChannel = allChannels.last;
    //     }
    //   } else if (channel.type == ChannelType.guildVoice) {
    //     allChannels.add( 
    //       FutureBuilder(
    //         future: computeOverwrites(currentMember!, channel),
    //         builder: (context, snapshot) {
    //           if (snapshot.hasData && snapshot.data!.canViewChannel) {
    //             hasChannels = true;
    //             return VoiceChannelButton(
    //               voiceChannel: channel as GuildVoiceChannel,
    //               onPressed: () {}
    //             );
    //           }
    //           return const SizedBox();
    //         }
    //       )
    //     );
    //   } else if (channel.type == ChannelType.guildStageVoice) {
    //     allChannels.add(
    //       FutureBuilder(
    //         future: computeOverwrites(currentMember!, channel),
    //         builder: (context, snapshot) {
    //           if (snapshot.hasData && snapshot.data!.canViewChannel) {
    //             hasChannels = true;
    //             return StageChannelButton(
    //               stageChannel: channel as GuildStageChannel,
    //               onPressed: () {}
    //             );
    //           }
    //           return const SizedBox();
    //         }
    //       )
    //     );
    //   }   
    // }
    // print('');
    // if (!hasChannels && !widget.canView) return const SizedBox();
    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.start,
    //   children: [ 
    //     GestureDetector(
    //       onTap: () => setState(() => _opened = !_opened),
    //       child: Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
    //         child: Row(
    //           children: [
    //             Icon(
    //               _opened ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
    //               color: _color1,
    //               size: 13,
    //             ),
    //             const SizedBox(width: 4),
    //             Expanded(
    //               child: Text(
    //                 widget.category.name,
    //                 overflow: TextOverflow.ellipsis,
    //                 style: TextStyle(
    //                   fontSize: 13.2,
    //                   fontFamily: 'GGSansBold',
    //                   color: _color1
    //                 ),
    //               ),
    //             )
    //           ],
    //         ),
    //       ),
    //     ),
    //     () {
    //       if (_opened) {
    //         return Column(
    //           children: allChannels,
    //         );
    //       }
    //       return selectedChannel;
    //     }()
    //   ],
    // );
  }
}