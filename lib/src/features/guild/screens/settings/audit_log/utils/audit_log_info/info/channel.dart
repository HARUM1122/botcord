import 'package:discord/src/features/guild/utils/utils.dart';
import 'package:nyxx/nyxx.dart';

String addCommas(String number) {
  int count = 0;
  String res = '';
  for (int i = number.length - 1; i >= 0; i--) {
    res = number[i] + res;
    count++;
    if (count % 3 == 0 && i != 0) {
      res = ',$res';
    }
  }
  return res;
}

Future<(User, String, List<String>)> getCreateChannelLogEntryInfo(AuditLogEntry log) async {
  final User user = await log.user!.get();
  final List<String> allChanges = [];
  final List<AuditLogChange> changes = log.changes!;
  String channelName = '';
  String channelType = '';
  for (int i = 0; i < changes.length; i++) {
    final AuditLogChange auditLogChange = changes[i];
    switch (auditLogChange.key) {
      case 'name':
        final String name = auditLogChange.newValue;
        channelName = name;
        allChanges.add('Set the name to **$name**');
      case 'type':
        allChanges.add('Set type to **${() {
          String createdType = '';
          switch (auditLogChange.newValue) {
            case 0:
              createdType = 'Text Channel';
            case 2:
              createdType = 'Voice Channel';
            case 4:
              createdType = 'Category';
            case 5:
              createdType = 

    //               ChannelType.guildAnnouncement => 'announcement',
    // ChannelType.announcementThread => 'announcement Thread',
    // ChannelType.publicThread => 'public thread',
    // ChannelType.privateThread => 'private thread',
    // ChannelType.guildStageVoice => 'stage channel',
    // ChannelType.guildDirectory => 'directory',
    // ChannelType.guildForum => 'forum channel',
    // ChannelType.guildMedia => 'media channel',

  //               guildAnnouncement._(5),

  // /// A [Thread] in an announcement channel.
  // announcementThread._(10),

  // /// A public thread.
  // publicThread._(11),

  // /// A private thread.
  // privateThread._(12),

  // /// A stage channel in a [Guild].
  // guildStageVoice._(13),

  // /// A [Guild] directory.
  // guildDirectory._(14),

  // /// A forum channel in a [Guild].
  // guildForum._(15),

  // /// A media channel in a [Guild].
  // guildMedia._(16);
            
          }
          channelType = createdType.toLowerCase();
          return createdType;
        }()}**');
      case 'bitrate':
        allChanges.add('Set bitrate to **${auditLogChange.newValue} kbps**');
      case 'user_limit':
        allChanges.add('Set user limit to **${auditLogChange.newValue}**');
      case 'rate_limit_per_user':
        allChanges.add(auditLogChange.newValue == 0 ? '**Disabled** slowmode' : 'Set slowmode to **${auditLogChange.newValue} seconds**');
    }
  }
  return (user, '**created a $channelType** $channelName' ,allChanges);
}

Future<(User, String, List<String>)> getUpdateChannelLogEntryInfo(AuditLogEntry log) async {
  final User user = await log.user!.get();
  final GuildChannel? channel = await getChannel(log.targetId!);
  final String channelType = switch(channel?.type) {
    ChannelType.guildText => 'text channel',
    ChannelType.guildVoice => 'voice channel',
    ChannelType.guildCategory => 'category',
    ChannelType.guildAnnouncement => 'announcement channel',
    ChannelType.announcementThread => 'announcement Thread',
    ChannelType.publicThread => 'public thread',
    ChannelType.privateThread => 'private thread',
    ChannelType.guildStageVoice => 'stage channel',
    ChannelType.guildDirectory => 'directory',
    ChannelType.guildForum => 'forum channel',
    ChannelType.guildMedia => 'media channel',
    _=> ''
  };
  final List<String> allChanges = [];
  final List<AuditLogChange> changes = log.changes!;
  for (int i = 0; i < changes.length; i++) {
    final AuditLogChange auditLogChange = changes[i];
    switch (auditLogChange.key) {
      case 'topic':
        allChanges.add(
          auditLogChange.oldValue == null
          ? 'Set the topic to **${auditLogChange.newValue}**' 
          : 'Changed the topic to **${auditLogChange.newValue}**' 
        );
      case 'name':
        allChanges.add('Changed the name from **${auditLogChange.oldValue}** to **${auditLogChange.newValue}**');
      case 'nsfw':
        allChanges.add('${auditLogChange.newValue ? 'Marked' : 'Unmarked'} the channel as **age-restricted**');
      case 'default_auto_archive_duration':
        allChanges.add('${auditLogChange.oldValue == null ? 'Set' : 'Changed'} default hide duration to **${addCommas(auditLogChange.newValue.toString())} minutes**');
      case 'user_limit':
        allChanges.add('Changed the user limit to **${auditLogChange.newValue}**');
      case 'rtc_region':
        allChanges.add('Set the region override to **${auditLogChange.newValue}**');
      case 'video_quality_mode':
        allChanges.add('Set the video quality mode to **${auditLogChange.newValue == 2 ? '720p' : 'auto'}**');
       case 'bitrate':
        allChanges.add('Set bitrate to ${auditLogChange.newValue} kbps');
      case 'rate_limit_per_user':
        allChanges.add(auditLogChange.newValue == 0 ? '**Disabled** slowmode' : 'Set slowmode to **${auditLogChange.newValue} seconds**');
    }
  }
  return (user, '**made changes to a $channelType** ${channel?.name ?? ''}' , allChanges);
}

Future<(User, String, List<String>)> getDeleteChannelLogEntryInfo(AuditLogEntry log) async  {
  final User user = await log.user!.get();
  final List<String> allChanges = [];
  String channelName = log.changes![0].oldValue;

  final String channelDeleted = switch(log.changes![1].oldValue) {
    0 => 'text channel',
    2 => 'voice channel',
    4 => 'category',
    _ => 'channel'
  };
  return (user, '**deleted a $channelDeleted** $channelName', allChanges);
}