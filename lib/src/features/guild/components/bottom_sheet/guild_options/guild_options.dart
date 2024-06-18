import 'package:flutter/material.dart';

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
import '../../badges/badges.dart';

class GuildOptionsSheet extends ConsumerWidget {
  final Guild guild;
  final ScrollController controller;

  const GuildOptionsSheet({
    required this.guild,
    required this.controller,
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.read(themeController);
    final Color color1 = appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
    final Color color2 = appTheme<Color>(theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFF81818D));

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          SettingsIconButton(
            onPressed: () => Navigator.popAndPushNamed(context, '/guild-settings-route'),
            size: 25,
            backgroundColor: appTheme<Color>(theme, light: const Color(0XFFDFE1E3), dark: const Color(0XFF373A42), midnight: const Color(0XFF2C2D36)),
            iconColor: color1
          )
        ],
      ),
      const SizedBox(height: 20),
      Row(
        children: [
          if (guild.features.isVerified) ...[
            const VerifiedBadge(size: 20),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              guild.name,
              style: TextStyle(
                color: color1,
                fontSize: 20,
                fontFamily: 'GGSansBold'
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (guild.features.hasCommunity) ...[
            Container(
              width: 130,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: appTheme<Color>(theme, light: const Color(0XFFE0E3E7), dark: const Color(0XFF2A2D35), midnight: const Color(0XFF15191C))
              ),
              child: Row(
                children: [
                  const CommunityBadge(size: 14),
                  const SizedBox(width: 10),
                  Text(
                    'Community Server',
                    style: TextStyle(
                      color: color2,
                      fontSize: 12
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16)
          ],
          const OnlineStatus(radius: 8, borderColor: null),
          const SizedBox(width: 6),
          () {
            int length = guild.approximatePresenceCount!;
            return Text(
              '$length ${length == 1 ? 'member' : 'members'}',
              style: TextStyle(
                color: color2,
                fontSize: 12
              ),
            );
          }(),
          const SizedBox(width: 16),
          const InvisibleStatus(radius: 8, borderColor: null,),
          const SizedBox(width: 6),
          () {
            int length = guild.approximateMemberCount!;
            return Text(
              '$length ${length == 1 ? 'member' : 'members'}',
              style: TextStyle(
                color: color2,
                fontSize: 12
              ),
            );
          }(),
        ],
      ),
      const SizedBox(height: 20),
    ];
    return ListView.builder(
      controller: controller,
      padding: EdgeInsets.only(top: 8, left: 16, right: 16, bottom: context.padding.bottom + 12),
      itemCount: children.length,
      itemBuilder: (context, idx) => children[idx],
    );
  }
}