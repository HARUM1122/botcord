import 'package:flutter/material.dart';

import 'package:nyxx/nyxx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'button.dart';

import '../../../../common/utils/utils.dart';
import '../../../../common/utils/extensions.dart';
import '../../../../common/controllers/theme_controller.dart';

import '../../../../features/guild/components/server_add_options_dialog.dart';

class GuildsList extends ConsumerWidget {
  final List<UserGuild> guilds;
  final Guild currentGuild;
  const GuildsList({
    required this.guilds,
    required this.currentGuild,
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => NotificationListener<OverscrollIndicatorNotification>(
    onNotification: (notification) {
      notification.disallowIndicator();
      return true;
    },
    child: ListView.builder(
      itemCount: guilds.length + 1,
      itemBuilder: (context, index) {
        return index < guilds.length 
        ? GuildButton(
          guild: guilds[index],
          selected: guilds[index].id == currentGuild.id,
        )
        : GestureDetector(
          onTap: () => showDialogBox(
            context: context,
            child: const ServerAddOptionsDialog()
          ),
          child: Container(
              margin: EdgeInsets.only(bottom: 70 + context.padding.bottom,),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: appTheme<Color>(
                  ref.read(themeController), 
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
    ),
  );
}