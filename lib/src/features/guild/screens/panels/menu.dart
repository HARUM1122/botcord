import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:nyxx/nyxx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/common/utils/extensions.dart';
import 'package:discord/src/common/providers/theme_provider.dart';

import '../../components/guild/list.dart';
import '../../components/badges/badges.dart';
import '../../components/bottom_sheet/guild_options/guild_options.dart';

class MenuScreen extends ConsumerWidget {
  final List<Guild> guilds;
  final Guild currentGuild;
  const MenuScreen({required this.guilds, required this.currentGuild, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.read(themeProvider);
    bool running = false;
    return Material(
      color: appTheme<Color>(
        theme, light: const Color(0XFFECEEF0),
        dark: const Color(0XFF141318),
        midnight: const Color(0xFF000000)
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            color: Colors.transparent,
            child: GuildsList(
              guilds: guilds,
              currentGuild: currentGuild,
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: context.padding.top, right: 40),
              padding: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: appTheme<Color>(theme, light: const Color(0XFFECEEF0), dark: const Color(0XFF1C1D23), midnight: const Color(0xFF000000)),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(26),
                  topRight: Radius.circular(6)
                )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (currentGuild.banner != null) Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(26),
                        topRight: Radius.circular(6)
                      ),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          currentGuild.banner!.url.toString(),
                          errorListener: (error) {},
                        ),
                      )
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (running) return;
                      running = true;
                      Guild guild = await currentGuild.fetch(withCounts: true);
                      running = false;
                      if (!context.mounted) return;
                      showSheet(
                        context: context,
                        height: 0.7,
                        maxHeight: 0.8,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16)
                        ),
                        color: appTheme<Color>(theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0xFF000000)),
                        builder: (context, controller, offset) => GuildOptionsSheet(
                          guild: guild, 
                          controller: controller
                        )
                      );
                    },
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        if (currentGuild.features.hasCommunity) 
                          const CommunityBadge(size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            currentGuild.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: appTheme<Color>(
                                theme, 
                                light: const Color(0xFF000000),
                                dark: const Color(0xFFFFFFFF),
                                midnight: const Color(0xFFFFFFFF)
                              ),
                              fontSize: 20,
                              fontFamily: 'GGSansBold'
                            ),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: appTheme<Color>(theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFF81818D)),
                        ),
                        const SizedBox(width: 30)
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}