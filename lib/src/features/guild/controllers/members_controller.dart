import 'dart:async';

import 'package:discord/src/common/utils/globals.dart';
import 'package:discord/src/features/guild/controllers/guilds_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import 'package:nyxx/nyxx.dart';

final membersControllerProvider = ChangeNotifierProvider<MembersController>((ref) => MembersController());

class MembersController extends ChangeNotifier {
  StreamSubscription<GuildMemberUpdateEvent>? guildMemberUpdateEvent;

  Future<void> stopListeningEvents() async {
    await guildMemberUpdateEvent?.cancel();
  }
  Future<void> listenEvents() async {
    await stopListeningEvents();
    guildMemberUpdateEvent = client?.onGuildMemberUpdate.listen((event) async {
      currentMember = event.member;
      notifyListeners();
    });
  }
}