import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:nyxx/nyxx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/common/utils/globals.dart';
import 'package:discord/src/common/utils/extensions.dart';
import 'package:discord/src/common/utils/asset_constants.dart';
import 'package:discord/src/common/components/drag_handle.dart';
import 'package:discord/src/common/components/custom_button.dart';
import 'package:discord/src/common/controllers/theme_controller.dart';
import 'package:discord/src/common/components/radio_button_indicator/radio_button_indicator.dart';

import 'package:discord/src/features/guild/utils/utils.dart';
import 'package:discord/src/features/guild/controllers/channels_controller.dart';

class InactiveChannelsSheet extends ConsumerWidget {
  final ScrollController controller;
  final Snowflake? selectedInactiveChannelId;
  const InactiveChannelsSheet({required this.controller, required this.selectedInactiveChannelId, super.key});

  Future<List<GuildVoiceChannel>> filterChannels(List<GuildChannel> channels) async {
    List<GuildVoiceChannel> voiceChannels = [];
    if (currentMember == null) {
      return voiceChannels;
    }
    for (final GuildChannel channel in channels) {
      if (channel.type == ChannelType.guildVoice && (await computeOverwrites(currentMember!, channel)).canViewChannel) {
        voiceChannels.add(channel as GuildVoiceChannel);
      }
    }
    return voiceChannels;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.read(themeController);
    final GuildChannelsController channelsController = ref.watch(guildChannelsControllerProvider);

    final Color color1 = appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));

    List<Widget> children = [
      Align(
        alignment: Alignment.topCenter,
        child: DragHandle(
          color: appTheme<Color>(theme, light: const Color(0XFFD8DADD), dark: const Color(0XFF2F3039), midnight: const Color(0XFF151518))
        )
      ),
      const SizedBox(height: 10),
      Align(
        alignment: Alignment.topCenter,
        child: Text(
          'Select a Channel',
          style: TextStyle(
            color: color1,
            fontSize: 18,
            fontFamily: 'GGSansBold'
          ),
        ),
      ),
      const SizedBox(height: 20),
      NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowIndicator();
          return true;
        },
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: appTheme<Color>(theme, light: const Color(0xFFFFFFFF), dark: const Color(0xFF25282F), midnight: const Color(0XFF141318)),
              borderRadius: BorderRadius.circular(16)
            ),
            child: FutureBuilder(
              future: filterChannels(channelsController.channels),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  final List<GuildChannel> voiceChannels = snapshot.data!;
                  final List<Widget> voiceChannelWidgets = [
                    VoiceChannelRadioButton(
                      title: 'No Inactive Channel',
                      leading: Icon(
                        Icons.cancel,
                        color: color1.withOpacity(0.8),
                        size: 22,
                      ),
                      borderRadius: voiceChannels.isEmpty 
                      ? BorderRadius.circular(16) 
                      : const BorderRadius.vertical(
                        top: Radius.circular(16)
                      ),
                      selected: selectedInactiveChannelId == null,
                      onPressed: () => Navigator.pop(context, 'No Inactive Channel')
                    )
                  ];
                  int length = voiceChannels.length;
                  for (int i = 0; i < length; i++) {
                    final GuildChannel voiceChannel = voiceChannels[i];
                    if (i < length) {
                      voiceChannelWidgets.add(
                        Divider(
                          color: appTheme<Color>(theme, light: const Color(0XFFEBEBEB), dark: const Color(0XFF2C2D36), midnight: const Color(0XFF1C1B21)),
                          thickness: 1,
                          height: 0,
                          indent: 54,
                        )
                      ); 
                    }
                    voiceChannelWidgets.add(
                      VoiceChannelRadioButton(
                        title: voiceChannel.name,
                        leading: SvgPicture.asset(
                          AssetIcon.speakerWave,
                          height: 22,
                          colorFilter: ColorFilter.mode(color1.withOpacity(0.8), BlendMode.srcIn),
                        ),
                        borderRadius: i == length - 1 
                        ?  const BorderRadius.vertical(
                          bottom: Radius.circular(16)
                        ) 
                        : null,
                        selected: voiceChannels[i].id == selectedInactiveChannelId,
                        onPressed: () => Navigator.pop(context, voiceChannel)
                      )
                    );
                  }
                  return Column(
                    children: voiceChannelWidgets
                  );
                }
                return const SizedBox();
              },
            )
          )
        )
      )
    ];
    return ListView.builder(
      controller: controller,
      padding: EdgeInsets.only(top: 8, left: 16, right: 16, bottom: context.padding.bottom + 12),
      itemCount: children.length,
      itemBuilder: (context, idx) => children[idx],
    );
  }
}

class VoiceChannelRadioButton extends ConsumerWidget {
  final String title;
  final Widget leading;
  final bool selected;
  final BorderRadius? borderRadius;
  final Function() onPressed;

  const VoiceChannelRadioButton({
    required this.title,
    required this.leading,
    required this.selected,
    this.borderRadius,
    required this.onPressed,
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.read(themeController);
    return CustomButton(
      height: 60,
      onPressed: onPressed,
      backgroundColor: Colors.transparent,
      onPressedColor: appTheme<Color>(theme, light: const Color(0XFFE1E1E1), dark: const Color(0XFF2F323A), midnight: const Color(0XFF202226)),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.zero
      ),
      applyClickAnimation: false,
      child: Row(
        children: [
          const SizedBox(width: 14),
          leading,
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
                fontSize: 16,
                fontFamily: 'GGSansSemibold'
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 6),
          RadioButtonIndicator(
            radius: 24, 
            selected: selected
          ),
          const SizedBox(width: 14)
        ],
      ),
    );
  }
}