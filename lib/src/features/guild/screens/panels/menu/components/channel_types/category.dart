import 'package:flutter/material.dart';

import 'package:nyxx/nyxx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/common/controllers/theme_controller.dart';

import 'package:discord/src/features/guild/controllers/channels_controller.dart';
import 'package:discord/src/features/guild/screens/panels/menu/components/channel_types/text/text_channel.dart';
import 'package:discord/src/features/guild/screens/panels/menu/components/channel_types/voice/stage_channel.dart';
import 'package:discord/src/features/guild/screens/panels/menu/components/channel_types/voice/voice_channel.dart';
import 'package:discord/src/features/guild/screens/panels/menu/components/channel_types/text/announcement_channel.dart';

class CategoryButton extends ConsumerStatefulWidget {
  final GuildCategory category;
  final Permissions permissions;
  final List<GuildChannel> channels;
  const CategoryButton({
    required this.category,
    required this.permissions,
    required this.channels,
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

  @override
  Widget build(BuildContext context) {
    final GuildChannelsController channelsController = ref.watch(guildChannelsControllerProvider);
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
        if (_opened)
          Column(
            children: () {
              List<Widget> allChannels = [];
              for (GuildChannel channel in channelsController.channels) {
                if (channel.parentId != widget.category.id) continue;
                bool selected = channelsController.currentChannel?.id == channel.id;
                if (channel.type == ChannelType.guildText) {
                  allChannels.add(
                    TextChannelButton(
                      textChannel: channel as GuildTextChannel,
                      selected: selected,
                      onPressed: () {
                        print("HELLO");
                      },
                      onLongPress: () {},
                    )
                  );
                } else if (channel.type == ChannelType.guildAnnouncement) {
                  allChannels.add(
                    AnnouncementChannelButton(
                      announcementChannel: channel as GuildAnnouncementChannel,
                      selected: selected,
                      onPressed: () {}
                    )
                  );
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
              return allChannels;
          }()
        )
      ],
    );
  }
}