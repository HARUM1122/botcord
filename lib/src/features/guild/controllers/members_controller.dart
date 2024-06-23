import 'dart:async';

import 'package:nyxx/nyxx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/globals.dart';
import '../../../features/guild/utils/utils.dart';
import '../../../features/guild/controllers/channels_controller.dart';


final membersControllerProvider = ChangeNotifierProvider<MembersController>((ref) => MembersController(
  channelsController: ref.read(guildChannelsControllerProvider)
));

class MembersController extends ChangeNotifier {
  final GuildChannelsController channelsController;
  MembersController({
    required this.channelsController
  });
  StreamSubscription<GuildMemberUpdateEvent>? guildMemberUpdateEvent;

  Future<void> stopListeningEvents() async {
    await guildMemberUpdateEvent?.cancel();
  }
  Future<void> listenEvents(Guild guild) async {
    await stopListeningEvents();

    guildMemberUpdateEvent = client?.onGuildMemberUpdate.listen((event) async {
      if (event.guildId == guild.id) {
        if (currentMember?.id == event.member.id) {
          currentMember = event.member;
          final GuildChannel? channel = channelsController.currentChannel;
          if (channel != null && !(await computeOverwrites(event.member, channel)).canViewChannel) {
            await channelsController.selectIfCanView(shouldRefresh: false);
          }
          channelsController.refresh();
        }
        notifyListeners();
      }
    });
  }
}