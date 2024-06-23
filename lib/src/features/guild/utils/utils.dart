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
List<UserGuild> sortGuilds(List<UserGuild> guilds) {
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



Future<GuildChannel?> getChannel(Snowflake id, {Guild? guild}) async {
  try {
    GuildChannel channel = await client!.channels.get(id) as GuildChannel;
    if (guild != null && channel.guild.id != guild.id) return null;
    return channel;
  } catch (_) {
    return null;
  }
}

Future<Member?> getMember(Guild guild, Snowflake id) async {
  try {
    return await guild.members.get(id);
  } catch (_) {
    return null;
  }
}

List<GuildChannel> sortChannels(List<GuildChannel> channels) {
  channels.sort((a, b) {
    int typeComparison = getTypePriority(a.type).compareTo(getTypePriority(b.type));
    if (typeComparison != 0) {
      return typeComparison;
    }
    return a.position.compareTo(b.position);
  });
  return channels;
}

int getTypePriority(ChannelType type) {
  switch (type) {
    case ChannelType.guildText || ChannelType.guildAnnouncement || ChannelType.guildForum :
      return 0;
    case ChannelType.guildVoice || ChannelType.guildStageVoice:
      return 1;
    case ChannelType.guildCategory:
      return 2;
    default:
      return 3;
  }
}

bool isTextChannel(GuildChannel channel) => const [ChannelType.guildAnnouncement, ChannelType.guildForum, ChannelType.guildText].contains(channel.type);

Future<Permissions> computeBasePermissions(Guild guild, Member member) async {
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

Future<Permissions> computeOverwrites(Member member, GuildChannel channel) async {
  final Guild guild = await channel.guild.get();
  final Permissions basePermissions = await computeBasePermissions(guild, member);
  if (basePermissions.isAdministrator) {
    return Permissions.allPermissions;
  }
  Flags<Permissions> permissions = basePermissions;
  final PermissionOverwrite? everyoneOverwrite = channel.permissionOverwrites.where((overwrite) => overwrite.id == guild.id).singleOrNull;

  if (everyoneOverwrite != null) {
    permissions &= ~everyoneOverwrite.deny;
    permissions |= everyoneOverwrite.allow;
  }

  Flags<Permissions> allow = const Permissions(0);
  Flags<Permissions> deny = const Permissions(0);
  for (final Snowflake roleId in member.roleIds) {
    final PermissionOverwrite? roleOverwrite = channel.permissionOverwrites.where((overwrite) => overwrite.id == roleId).singleOrNull;
    if (roleOverwrite != null) {
      allow |= roleOverwrite.allow;
      deny |= roleOverwrite.deny;
    }
  }
  permissions &= ~deny;
  permissions |= allow;
  final PermissionOverwrite? memberOverwrite = channel.permissionOverwrites.where((overwrite) => overwrite.id == member.id).singleOrNull;
  if (memberOverwrite != null) {
    permissions &= ~memberOverwrite.deny;
    permissions |= memberOverwrite.allow;
  }
  return Permissions(permissions.value);
}