import 'package:discord/src/common/components/custom_button.dart';
import 'package:discord/src/common/components/drag_handle.dart';
import 'package:discord/src/common/components/radio_button_indicator/radio_button_indicator.dart';
import 'package:discord/src/common/controllers/theme_controller.dart';
import 'package:discord/src/common/utils/asset_constants.dart';
import 'package:discord/src/common/utils/extensions.dart';
import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/features/guild/controllers/channels_controller.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nyxx/nyxx.dart';


class SystemChannelsSheet extends ConsumerWidget {
  final ScrollController controller;
  final Snowflake? selectedSystemChannelId;
  const SystemChannelsSheet({required this.controller, required this.selectedSystemChannelId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.read(themeController);
    final GuildChannelsController channelsController = ref.watch(guildChannelsControllerProvider);

    final Color color1 = appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
    final Color color2 = appTheme<Color>(theme, light: const Color(0XFF4C4F57), dark: const Color(0XFFC8C9D1), midnight: const Color(0xFFFFFFFF));

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
      const SizedBox(height: 10),
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
            child: Column(
              children: [
                ...() {
                  final List<GuildTextChannel> textChannels = [
                    for (GuildChannel channel in channelsController.channels) 
                      if (channel.type == ChannelType.guildText) 
                        channel as GuildTextChannel
                  ];
                  final List<Widget> textChannelWidgets = [
                    TextChannelRadioButton(
                      title: 'No System Messages',
                      leading: Icon(
                        Icons.cancel,
                        color: color2,
                        size: 22,
                      ),
                      borderRadius: textChannels.isEmpty 
                      ? BorderRadius.circular(16) 
                      : const BorderRadius.vertical(
                        top: Radius.circular(16)
                      ),
                      selected: selectedSystemChannelId == null,
                      onPressed: () => Navigator.pop(context, 'No System Messages')
                    )
                  ];
                  int length = textChannels.length;
                  for (int i = 0; i < length; i++) {
                    final GuildTextChannel textChannel = textChannels[i];
                    if (i < length) {
                      textChannelWidgets.add(
                        Divider(
                          color: appTheme<Color>(theme, light: const Color(0XFFEBEBEB), dark: const Color(0XFF2C2D36), midnight: const Color(0XFF1C1B21)),
                          thickness: 1,
                          height: 0,
                          indent: 54,
                        )
                      ); 
                    }
                    textChannelWidgets.add(
                      TextChannelRadioButton(
                        title: textChannel.name,
                        leading: SvgPicture.asset(
                          AssetIcon.hash,
                          height: 22,
                          colorFilter: ColorFilter.mode(color2, BlendMode.srcIn),
                        ),
                        borderRadius: i == length - 1 
                        ?  const BorderRadius.vertical(
                          bottom: Radius.circular(16)
                        ) 
                        : null,
                        selected: textChannels[i].id == selectedSystemChannelId,
                        onPressed: () => Navigator.pop(context, textChannel)
                      )
                    );
                  }
                  return textChannelWidgets;
                }(),
              ],
            ),
          ),
        ),
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

class TextChannelRadioButton extends ConsumerWidget {
  final String title;
  final Widget leading;
  final bool selected;
  final BorderRadius? borderRadius;
  final Function() onPressed;

  const TextChannelRadioButton({
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