import 'package:discord/src/common/components/custom_button.dart';
import 'package:discord/src/common/utils/asset_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:nyxx/nyxx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/common/utils/extensions.dart';
import 'package:discord/src/common/components/drag_handle.dart';
import 'package:discord/src/common/controllers/theme_controller.dart';
import 'package:discord/src/common/components/settings_icon_button.dart';
import 'package:discord/src/common/components/online_status/online.dart';
import 'package:discord/src/common/components/online_status/invisible.dart';

class TextChannelOptionsSheet extends ConsumerWidget {
  final Guild guild;
  final GuildTextChannel textChannel;
  final ScrollController controller;

  const TextChannelOptionsSheet({
    required this.guild,
    required this.textChannel,
    required this.controller,
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.read(themeController);
    final Color color1 = appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
    final Color color2 = appTheme<Color>(theme, light: const Color(0xFFFFFFFF), dark: const Color(0xFF25282F), midnight: const Color(0XFF141318));
    final Color color3 = appTheme<Color>(theme, light: const Color(0XFFEBEBEB), dark: const Color(0XFF2C2D36), midnight: const Color(0XFF1C1B21));

    final String? guildIcon = guild.icon?.url.toString();
    List<Widget> children = [
      Align(
        alignment: Alignment.topCenter,
        child: DragHandle(
          color: appTheme<Color>(theme, light: const Color(0XFFD8DADD), dark: const Color(0XFF2F3039), midnight: const Color(0XFF151518))
        )
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: guildIcon == null 
                ? const Color(0XFF536CF8)
                : Colors.transparent,
                image: guildIcon != null 
                ? DecorationImage(
                  image: CachedNetworkImageProvider(
                    guildIcon,
                    errorListener: (error) {},
                  ),
                )
                : null,
                borderRadius: BorderRadius.circular(15)
              ),
              child: guildIcon == null 
              ? Center(
                child: Text(
                  guild.name[0],
                  style: TextStyle(
                    color: appTheme<Color>(
                      theme, 
                      light: const Color(0xFF000000),
                      dark: const Color(0xFFFFFFFF), 
                      midnight: const Color(0xFFFFFFFF)
                    ),
                    fontSize: 16,
                  ),
                ),
              )
              : null
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '#${textChannel.name}',
              style: TextStyle(
                color: color1,
                fontSize: 20,
                fontFamily: 'GGSansSemibold'
              ),
            ),
          ),
          const SizedBox(width: 20)
        ],
      ),
      const SizedBox(height: 20),
      Container(
        decoration: BoxDecoration(
          color: color2,
          borderRadius: BorderRadius.circular(16)
        ),
        child: Column(
          children: [
            TextChannelOptionButton(
              leading: SvgPicture.asset(
                AssetIcon.addUser,
                height: 22,
                colorFilter: ColorFilter.mode(
                  color1.withOpacity(0.8),
                  BlendMode.srcIn
                )
              ),
              title: 'Invite',
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16)
              ),
              onPressed: () {}
            ),
            Divider(
              thickness: 1,
              height: 0,
              indent: 54,
              color: color3,
            ),
            TextChannelOptionButton(
              leading: SvgPicture.asset(
                AssetIcon.link,
                height: 22,
                colorFilter: ColorFilter.mode(
                  color1.withOpacity(0.8),
                  BlendMode.srcIn
                )
              ),
              title: 'Copy Link',
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16)
              ),
              onPressed: () {}
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      Container(
        decoration: BoxDecoration(
          color: color2,
          borderRadius: BorderRadius.circular(16)
        ),
        child: Column(
          children: [
            TextChannelOptionButton(
              leading: Icon(
                Icons.settings,
                color: color1.withOpacity(0.8),
                size: 22,
              ),
              title: 'Edit Channel',
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16)
              ),
              onPressed: () {}
            ),
            Divider(
              thickness: 1,
              height: 0,
              indent: 54,
              color: color3,
            ),
            TextChannelOptionButton(
              leading: SvgPicture.asset(
                AssetIcon.copy,
                height: 22,
                colorFilter: ColorFilter.mode(
                  color1.withOpacity(0.8),
                  BlendMode.srcIn
                )
              ),
              title: 'Duplicate Channel',
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16)
              ),
              onPressed: () {}
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      TextChannelOptionButton(
        backgroundColor: color2,
        leading: SvgPicture.asset(
          AssetIcon.id,
          height: 22,
          colorFilter: ColorFilter.mode(
            color1.withOpacity(0.8),
            BlendMode.srcIn
          )
        ),
        title: 'Copy Channel ID',
        borderRadius: BorderRadius.circular(16),
        onPressed: () {}
      ),
    ];
    return ListView.builder(
      controller: controller,
      padding: EdgeInsets.only(top: 8, left: 16, right: 16, bottom: context.padding.bottom + 12),
      itemCount: children.length,
      itemBuilder: (context, idx) => children[idx],
    );
  }
}

class TextChannelOptionButton extends ConsumerWidget {
  final Widget leading;
  final String title;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Function() onPressed;
  const TextChannelOptionButton({
    required this.leading,
    required this.title,
    this.borderRadius,
    this.backgroundColor,
    required this.onPressed,
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.read(themeController);
    return CustomButton(
      height: 60,
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? Colors.transparent,
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
          Text(
            title,
            style: TextStyle(
              color: appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
              fontSize: 16,
              fontFamily: 'GGSansSemibold'
            )
          )
        ],
      ),
    );
  }
}