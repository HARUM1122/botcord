import 'package:flutter/material.dart';

import 'package:nyxx/nyxx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/theme_provider.dart';

import '../../../common/utils/utils.dart';

import 'guild_button.dart';

class GuildsList extends ConsumerWidget {
  final List<UserGuild> guilds;
  final UserGuild currentGuild;
  const GuildsList({
    required this.guilds,
    required this.currentGuild,
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView.builder(
    itemCount: guilds.isEmpty ? 0 : guilds.length + 1,
    itemBuilder: (context, index) {
      return index < guilds.length 
      ? GuildButton(
        guild: guilds[index],
        selected: guilds[index].id == currentGuild.id,
      )
      : GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/invite-bot-route'),
        child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: appTheme<Color>(
                ref.read(themeProvider), 
                light: const Color(0XFFF2F4F5), 
                dark: const Color(0XFF1C1D23), 
                midnight: const Color(0XFF0F1014)
              )
            ),
            child: const Center(
              child: Icon(
                Icons.add,
                color: Color(0xFF26A558),
                size: 30,
              ),
            ),
        ),
      );
    }
  );
}