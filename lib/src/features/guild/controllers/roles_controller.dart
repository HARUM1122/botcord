import 'dart:async';

import 'package:discord/src/common/utils/globals.dart';
import 'package:discord/src/features/guild/controllers/channels_controller.dart';
import 'package:discord/src/features/guild/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nyxx/nyxx.dart';

final rolesControllerProvider = ChangeNotifierProvider<RolesController>((ref) => RolesController(
  channelsController: ref.read(guildChannelsControllerProvider)
));

class RolesController extends ChangeNotifier {
  final GuildChannelsController channelsController;
  RolesController({
    required this.channelsController
  });
  StreamSubscription<GuildRoleUpdateEvent>? guildRoleUpdateEvent;

  Future<void> stopListeningEvents() async {
    await guildRoleUpdateEvent?.cancel();
  }
  Future<void> listenEvents(Guild guild) async {
    await stopListeningEvents();

    guildRoleUpdateEvent = client?.onGuildRoleUpdate.listen((event) async {
      if (event.guildId == guild.id) {
        if (currentMember?.roles.contains(event.role) ?? false) {
          currentMember!.roles[currentMember!.roles.indexOf(event.role)] = event.role as PartialRole;
          final GuildChannel? channel = channelsController.currentChannel;
          if (channel != null && !(await computeOverwrites(currentMember!, channel)).canViewChannel) {
            channelsController.selectIfCanView(shouldRefresh: false);
          }
          channelsController.refresh();
        }
      }
      notifyListeners();
    });
  }
}