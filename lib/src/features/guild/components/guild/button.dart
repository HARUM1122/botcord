import 'package:flutter/material.dart';

import 'package:nyxx/nyxx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:discord/src/common/controllers/theme_controller.dart';

import '../../controllers/guilds_controller.dart';

import '../../../../common/utils/utils.dart';

class GuildButton extends ConsumerWidget {
  final Guild guild;
  final bool selected;
  const GuildButton({required this.guild, required this.selected, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.read(themeController);
    final GuildsController guildsController = ref.read(guildsControllerProvider);
    final String? guildIcon = guild.icon?.url.toString();
    bool running = false;

    return GestureDetector(
      onTap: () async {
        if (!running) {
          running = true;
          await guildsController.selectGuild(guild);
          running = false;
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        width: 55,
        height: 55,
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: 6,
              height: selected ? 45 : 0,
              decoration: BoxDecoration(
                color: appTheme<Color>(
                  theme, 
                  light: const Color(0xFF000000), 
                  dark: const Color(0xFFFFFFFF), 
                  midnight: const Color(0xFFFFFFFF)
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10), 
                  bottomRight:Radius.circular(10)
                )
              ),
            ),
            const SizedBox(width: 10),
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: guildIcon == null 
                ? appTheme<Color>(
                  theme, 
                  light: Color(!selected ? 0XFFF2F4F5 : 0XFF536CF8), 
                  dark: Color(!selected ? 0XFF1C1D23 : 0XFF536CF8), 
                  midnight: Color(!selected ? 0XFF0F1014 : 0XFF536CF8)
                )
                : Colors.transparent,
                image: guildIcon != null 
                ? DecorationImage(
                  image: CachedNetworkImageProvider(
                    guildIcon,
                    errorListener: (error) {},
                  ),
                )
                : null,
                borderRadius: BorderRadius.circular(selected ? 15 : 25)
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
          ],
        ),
      ),
    );
  }
}
