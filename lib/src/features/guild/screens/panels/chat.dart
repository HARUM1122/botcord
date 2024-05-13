import 'dart:async';

import 'package:discord/src/common/utils/globals.dart';
import 'package:discord/src/features/guild/controllers/guilds_controller.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'package:discord/theme_provider.dart';

import 'package:discord/src/common/utils/utils.dart';
import 'package:nyxx/nyxx.dart';

import '../guild.dart';



class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.read(themeProvider);
    final Color color1 = appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
    return Scaffold(
      backgroundColor: appTheme<Color>(theme, light: const Color(0XFFFFFFFF), dark: const Color(0XFF1C1D23), midnight: const Color(0xFF000000)),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => GuildsScreen.of(context)?.revealLeft(),
          splashRadius: 18,
          icon: Icon(
            Icons.arrow_back,
            color: appTheme<Color>(theme, light: const Color(0XFF565960), dark: const Color(0XFF878A93), midnight: const Color(0XFF838594))
          )
        ),
        title: Text(
          "# COMMANDS",
          style: TextStyle(
            color: color1,
            fontFamily: 'GGSansBold',
            fontSize: 18
          ),
        ),
      ),
      body: Center(
        child: () {
            return Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final GuildsController controller = ref.read(guildsControllerProvider);
                    controller.listenGuildEvents();
                    // List<UserGuild> guilds = await client!.listGuilds();
                    // client!.onGuildCreate.listen((event) async { 
                    //   UserGuild guild = await event.guild.get();
                    //   print(guild.name);
                    // });
                    // client!.onGuildCreate.listen((event) {
                    //   print(event.guild.get());
                    // });
                    // client!.onGuildDelete.listen((event) {
                    //   print(event.deletedGuild!.name);
                    // });
                  },
                  child: Text("Press"),
                ),
              ],
            );
          }()
      ),
    );
  }
}