import 'package:flutter/material.dart';

import 'package:nyxx/nyxx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/theme_provider.dart';

import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/common/utils/extensions.dart';
import 'package:discord/src/features/guild/components/guild/list.dart';


class MenuScreen extends ConsumerWidget {
  final List<UserGuild> guilds;
  final UserGuild currentGuild;
  const MenuScreen({required this.guilds, required this.currentGuild, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.read(themeProvider);
    return Material(
      color: appTheme<Color>(theme, light: const Color(0XFFECEEF0), dark: const Color(0XFF141318), midnight: const Color(0xFF000000)),
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
                  GestureDetector(
                    child: Row(
                      children: [
                        const SizedBox(width: 20),
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