import 'dart:async';

import 'package:discord/src/common/utils/globals.dart';
import 'package:discord/src/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nyxx/nyxx.dart';

final guildsControllerProvider = ChangeNotifierProvider((ref) => GuildsController());

class GuildsController extends ChangeNotifier {
  List<UserGuild> guilds = [];
  UserGuild? currentGuild;

  void selectGuild(UserGuild guild) {
    currentGuild = guild;
    notifyListeners();
  }

  void listenGuildEvents() {
    Timer? debounce;
    client?.onGuildCreate.listen((event) async {
      UserGuild guild = await event.guild.get();
      guilds.add(guild);
      if ((debounce?.isActive ?? false)) debounce?.cancel();
      debounce = Timer(const Duration(milliseconds: 500), () {
        currentGuild = guilds.isNotEmpty ? guilds.first : null; 
        notifyListeners();
      });
    });
    client?.onGuildUpdate.listen((event) {
      for (int i = 0; i < guilds.length; i++) {
        if (guilds[i].id == event.guild.id) {
          guilds[i] = event.guild;
          notifyListeners();
          break;
        }
      }
    });
    client?.onGuildDelete.listen((event) {
      guilds.removeWhere((guild) => guild.id == event.guild.id);
      notifyListeners();
    });
  }
}