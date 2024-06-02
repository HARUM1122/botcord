import 'package:discord/src/common/components/custom_button.dart';
import 'package:discord/src/common/components/drag_handle.dart';
import 'package:discord/src/common/components/radio_button_indicator/radio_button_indicator.dart';
import 'package:discord/src/common/controllers/theme_controller.dart';
import 'package:discord/src/common/utils/extensions.dart';
import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/features/guild/controllers/channels_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyxx/nyxx.dart';

class InactiveChannelsSheet extends ConsumerWidget {
  final ScrollController controller;
  final Snowflake? selectedInactiveChannelId;
  const InactiveChannelsSheet({required this.controller, required this.selectedInactiveChannelId, super.key});

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
      const SizedBox(height: 20),
      Text(
        'Select a Channel',
        style: TextStyle(
          color: color1,
          fontSize: 16,
          fontFamily: 'GGSansBold'
        ),
      ),
      SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: appTheme<Color>(theme, light: const Color(0xFFFFFFFF), dark: const Color(0xFF25282F), midnight: const Color(0XFF141318)),
            borderRadius: BorderRadius.circular(16)
          ),
          child: Column(
            children: [
              
            ],
          )
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

class InactiveChannelsRadioButton extends ConsumerWidget {
  final String title;
  final Widget leading;
  final bool selected;
  final Function() onPressed;

  const InactiveChannelsRadioButton({
    required this.title,
    required this.leading,
    required this.selected,
    required this.onPressed,
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.read(themeController);
    return CustomButton(
      onPressed: onPressed,
      backgroundColor: Colors.transparent,
      applyClickAnimation: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
        child: Row(
          children: [
            leading,
            Text(
              title,
              style: TextStyle(
                color: appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
                fontSize: 16,
                fontFamily: 'GGSansSemibold'
              ),
            ),
            const Spacer(),
            RadioButtonIndicator(
              radius: 20, 
              selected: selected
            ),
          ],
        ),
      ),
    );
  }
}