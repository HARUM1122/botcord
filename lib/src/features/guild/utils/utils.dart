import 'package:discord/src/common/utils/globals.dart';
import 'package:nyxx/nyxx.dart';

int customSort(String key) {
  if (key.contains(RegExp(r'^[\W_]+$'))) {
    return 1;
  } else if (key.contains(RegExp(r'^\d+$'))) {
    return 2;
  } else if (key.contains(RegExp(r'^[A-Z]+$'))) {
    return 3;
  } else {
    return 4;
  }
}
List<Guild> sortGuilds(List<Guild> guilds) {
  if (guilds.isEmpty) return guilds;
  return guilds..sort((a, b) {
    int aSort = customSort(a.name[0].toUpperCase());
    int bSort = customSort(b.name[0].toUpperCase());
    if (aSort == bSort) {
      return a.name[0].toUpperCase().compareTo(b.name[0].toUpperCase());
    } else {
      return aSort.compareTo(bSort);
    }
  });
}

Future<Permissions> computePermissions(Guild guild, Member member) async {
  if (guild.ownerId == member.id) {
    return Permissions.allPermissions;
  }
  Flags<Permissions> permissions = (await guild.roles[guild.id].get()).permissions;
  for (final PartialRole role in member.roles) {
    permissions |= (await role.get()).permissions;
  }
  permissions = Permissions(permissions.value);
  permissions as Permissions;
  return permissions.isAdministrator ? Permissions.allPermissions : permissions;
}

String getDuration(Duration duration) => switch(duration.inSeconds) {
    60 => '1 minute',
    300 => '5 minutes',
    900 => '15 minutes',
    1800 => '30 minutes',
    3600 => '1 hour',
    _=> ''
  };

String formatPermission(Flag<Permissions> permission) => switch (permission) {
  Permissions.createInstantInvite => 'Create instant invite',
  Permissions.kickMembers => 'Kick members',
  Permissions.banMembers => 'Ban members',
  Permissions.administrator => 'Administrator',
  Permissions.manageChannels => 'Manage channels',
  Permissions.manageGuild => 'Manage guild',
  Permissions.addReactions => 'Add reactions',
  Permissions.viewAuditLog => 'View audit log',
  Permissions.prioritySpeaker => 'Priority speaker',
  Permissions.stream => 'Stream',
  Permissions.viewChannel => 'View channel',
  Permissions.sendMessages => 'Send messages',
  Permissions.sendTtsMessages => 'Send TTS messages',
  Permissions.manageMessages => 'Manage messages',
  Permissions.embedLinks => 'Embed links',
  Permissions.attachFiles => 'Attach files',
  Permissions.readMessageHistory => 'Read message history',
  Permissions.mentionEveryone => 'Mention everyone',
  Permissions.useExternalEmojis => 'Use external emojis',
  Permissions.viewGuildInsights => 'View guild insights',
  Permissions.connect => 'Connect',
  Permissions.speak => 'Speak',
  Permissions.muteMembers => 'Mute members',
  Permissions.deafenMembers => 'Deafen members',
  Permissions.moveMembers => 'Move members',
  Permissions.useVad => 'Use VAD',
  Permissions.changeNickname => 'Change nickname',
  Permissions.manageNicknames => 'Manage nicknames',
  Permissions.manageRoles => 'Manage roles',
  Permissions.manageWebhooks => 'Manage webhooks',
  Permissions.manageEmojisAndStickers => 'Manage emojis and stickers',
  Permissions.useApplicationCommands => 'Use application commands',
  Permissions.requestToSpeak => 'Request to speak',
  Permissions.manageEvents => 'Manage events',
  Permissions.manageThreads => 'Manage threads',
  Permissions.createPublicThreads => 'Create public threads',
  Permissions.createPrivateThreads => 'Create private threads',
  Permissions.useExternalStickers => 'Use external stickers',
  Permissions.sendMessagesInThreads => 'Send messages in threads',
  Permissions.useEmbeddedActivities => 'Use embedded activities',
  Permissions.moderateMembers => 'Moderate members',
  Permissions.viewCreatorMonetizationAnalytics => 'View creator monetization analytics',
  Permissions.useSoundboard => 'Use soundboard',
  Permissions.createEmojiAndStickers => 'Create emoji and stickers',
  Permissions.createEvents => 'Create events',
  Permissions.useExternalSounds => 'Use external sounds',
  Permissions.sendVoiceMessages => 'Send voice messages',
  _ => '',
};

List<String> getAllPermissions(Permissions permissions) {
  List<String> perms = [];
  for (Flag<Permissions> permission in permissions) {
    final String formattedPermission = formatPermission(permission);
    if (formattedPermission.isNotEmpty) {
      perms.add(formattedPermission);
    }
  }
  return perms;
}

Future<GuildChannel?> getChannel(Snowflake id) async {
  try {
    final GuildChannel channel = await client!.channels.get(id) as GuildChannel;
    return channel;
  } catch (e) {
    return null;
  }
}