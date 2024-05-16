import 'package:cached_network_image/cached_network_image.dart';
import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/features/guild/components/guild_avatar.dart';
import 'package:discord/theme_provider.dart';
import 'package:flutter/material.dart';

import 'package:nyxx/nyxx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/guilds_controller.dart';

class GuildButton extends ConsumerWidget {
  final UserGuild guild;
  final bool selected;
  const GuildButton({required this.guild, required this.selected, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.read(themeProvider);
    final GuildsController guildsController = ref.read(guildsControllerProvider);
    final String? guildIcon = guild.icon?.url.toString();
    return GestureDetector(
      onTap: () => guildsController.selectGuild(guild),
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
                  light: const Color(0XFFF2F4F5), 
                  dark: const Color(0XFF1C1D23), 
                  midnight: const Color(0XFF0F1014)
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
                    color: appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
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
