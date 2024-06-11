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

String getReadableChannelType(int? value) => switch(value) {
  0 => 'Text Channel',
  2 => 'Voice Channel',
  4 => 'Category',
  5 => 'Announcement Channel',
  10 => 'Announcement Thread',
  11 => 'Public Thread',
  12 => 'Private Thread',
  13 => 'Stage Channel',
  14 => 'Directory',
  15 => 'Forum Channel',
  16 => 'Media Channel',
  _=> 'Channel'
};

Future<(User, String, List<String>)> getCreateChannelLogEntryInfo(AuditLogEntry log, Guild? guild) async {
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
          String channelCreatedType = getReadableChannelType(auditLogChange.newValue);
          channelType = channelCreatedType.toLowerCase();
          return channelCreatedType;
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

Future<(User, String, List<String>)> getUpdateChannelLogEntryInfo(AuditLogEntry log, Guild? guild) async {
  final User user = await log.user!.get();
  final GuildChannel? channel = await getChannel(log.targetId!);
  final String channelType = getReadableChannelType(channel?.type.value).toLowerCase();
  final List<String> allChanges = [];
  final List<AuditLogChange> changes = log.changes!;
  for (int i = 0; i < changes.length; i++) {
    final AuditLogChange auditLogChange = changes[i];
    switch (auditLogChange.key) {
      case 'topic':
        allChanges.add('${auditLogChange.oldValue == null ? 'Set' : 'Changed'} the topic to **${auditLogChange.newValue}**');
      case 'name':
        allChanges.add('Changed the name to **${auditLogChange.newValue}**');
      case 'nsfw':
        allChanges.add('${auditLogChange.newValue ? 'Marked' : 'Unmarked'} the channel as **age-restricted**');
      case 'default_auto_archive_duration':
        allChanges.add('Changed the default hide duration to **${addCommas(auditLogChange.newValue.toString())} minutes**');
      case 'user_limit':
        allChanges.add('Changed the user limit to **${auditLogChange.newValue == 0 ? 'no limit' : auditLogChange.newValue}**');
      case 'rtc_region':
        allChanges.add('Changed the region override to **${auditLogChange.newValue}**');
      case 'video_quality_mode':
        allChanges.add('Changed the video quality mode to **${auditLogChange.newValue == 2 ? '720p' : 'auto'}**');
       case 'bitrate':
        allChanges.add('Changed bitrate to ${auditLogChange.newValue} kbps');
      case 'rate_limit_per_user':
        allChanges.add(auditLogChange.newValue == 0 ? '**Disabled** slowmode' : 'Set slowmode to **${auditLogChange.newValue} seconds**');
      case 'type':
        allChanges.add('Changed the type to **${getReadableChannelType(auditLogChange.newValue)}**');
    }
  }
  return (user, '**made changes to ${channelType.startsWith('a') ? 'an' : 'a'} $channelType** ${channel?.name ?? ''}' , allChanges);
}

Future<(User, String, List<String>)> getDeleteChannelLogEntryInfo(AuditLogEntry log, Guild? guild) async  {
  final User user = await log.user!.get();
  final List<String> allChanges = [];
  String channelName = log.changes![0].oldValue;
  return (user, '**deleted a ${getReadableChannelType(log.changes![1].oldValue).toLowerCase()}** $channelName', allChanges);
}