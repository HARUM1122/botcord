import 'package:flutter/material.dart';

import 'package:nyxx/nyxx.dart';

import 'guild_button.dart';

class GuildsList extends StatelessWidget {
  final List<UserGuild> guilds;
  final UserGuild currentGuild;
  const GuildsList({
    required this.guilds,
    required this.currentGuild,
    super.key
  });

  @override
  Widget build(BuildContext context) => ListView.builder(
    itemCount: guilds.length,
    itemBuilder: (context, index) {
      print(guilds[index].name);
      return GuildButton(
        guild: guilds[index],
        selected: guilds[index].id == currentGuild.id,
      );
    }
  );
}