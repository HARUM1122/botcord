import 'package:cached_network_image/cached_network_image.dart';
import 'package:discord/src/common/providers/theme_provider.dart';
import 'package:discord/src/common/utils/globals.dart';
import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/features/guild/components/info_tile.dart';
import 'package:discord/src/features/guild/controllers/guilds_controller.dart';
import 'package:discord/src/features/guild/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyxx/nyxx.dart';

class GuildSettingsPage extends ConsumerWidget {
  const GuildSettingsPage({super.key});

  Future<Permissions?> computePerms(Guild? guild, User user) async {
    if (guild == null) return null;
    final Member member = await guild.members[user.id].get();
    return computePermissions(guild, member);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.read(themeProvider);
    final GuildsController controller = ref.watch(guildsControllerProvider);
    final Guild? guild = controller.currentGuild;

    final Color color1 = appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
    final Color color2 = appTheme<Color>(theme, light: const Color(0XFF4C4F57), dark: const Color(0XFFC8C9D1), midnight: const Color(0xFFFFFFFF));
    final Color color3 = appTheme<Color>(theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFFA8AAB0));
    final Color color4 = appTheme<Color>(theme, light: const Color(0XFFEBEBEB), dark: const Color(0XFF2C2D36), midnight: const Color(0XFF1C1B21));
    final Color color5 =  appTheme<Color>(theme, light: const Color(0xFFFFFFFF), dark: const Color(0xFF25282F), midnight: const Color(0XFF141318));
    final Color color6 = appTheme<Color>(theme, light: const Color(0XFFE1E1E1), dark: const Color(0XFF2F323A), midnight: const Color(0XFF202226));

    return Scaffold(
      appBar: AppBar(
        leading:  IconButton(
          onPressed: () => Navigator.pop(context),
          splashRadius: 18,
          icon: Icon(
            Icons.close,
            color: appTheme<Color>(theme, light: const Color(0XFF565960), dark: const Color(0XFF878A93), midnight: const Color(0XFF838594))
          )
        ),
        title: Text(
          'Server Settings',
          style: TextStyle(
            color: color1,
            fontFamily: 'GGSansBold',
            fontSize: 18
          ),
        ),
      ),
      backgroundColor: appTheme<Color>(theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0XFF141318)),
      body: FutureBuilder(
        future: computePerms(guild, user!),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0XFF536CF8),
              ),
            );
          }
          Permissions? perms = snapshot.data;
          if (perms != null) {
            final String? guildIcon = guild?.icon?.url.toString();
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: guildIcon != null 
                        ? DecorationImage(
                          image: CachedNetworkImageProvider(
                            guildIcon,
                            errorListener: (error) {},
                          ),
                          fit: BoxFit.cover
                        )
                        : null
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      guild?.name ?? '',
                      style: TextStyle(
                        color: color1,
                        fontSize: 14
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Settings',
                    style: TextStyle(
                      color: color3,
                      fontSize: 14,
                      fontFamily: 'GGSansSemibold'
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: color5,
                      borderRadius: BorderRadius.circular(16)
                    ),
                    child: Column(
                      children: [
                        InfoTile(
                          offstage: false,
                          backgroundColor: Colors.transparent,
                          onPressedColor: color6,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                            bottom: 
                          ),
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.info,
                                  color: color2,
                                ),
                                const SizedBox(width: 18),
                                Text(
                                  'Overview',
                                  style: TextStyle(
                                    color: color1,
                                    fontSize: 16,
                                    fontFamily: 'GGSansSemibold'
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }
          return const SizedBox();
        }
      )
    );
  }
}