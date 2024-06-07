import 'package:discord/src/common/utils/globals.dart';
import 'package:nyxx/nyxx.dart';

String addCommas(String number) {
  int count = 0;
  String res = "";
  for (int i = number.length - 1; i >= 0; i--) {
    res = number[i] + res;
    count++;
    if (count % 3 == 0 && i != 0) {
      res = ',$res';
    }
  }
  return res;
}

Future<(User, String, List<String>)> getCreateChannelAuditInfo(AuditLogEntry log) async {
  final User user = await log.user!.get();
  final GuildChannel channel = await client!.channels.get(log.targetId!) as GuildChannel;
  final List<String> allChanges = [];
  final List<AuditLogChange> changes = log.changes!;
  String channelCreated = '';
  for (int i = 0; i < changes.length; i++) {
    final AuditLogChange auditLogChange = changes[i];
    final String currentCount = '${i < 10 ? '0$i' : i} -';
    switch (auditLogChange.key) {
      case 'name':
        allChanges.add('`$currentCount` Set the name to **${auditLogChange.newValue}**');
      case 'type':
        allChanges.add('`$currentCount` Set type to **${() {
          String createdType = '';
          switch (auditLogChange.newValue) {
            case 0:
              createdType = 'Text Channel';
            case 2:
              createdType = 'Voice Channel';
            default:
              createdType = 'Category';
          }
          channelCreated = createdType.toLowerCase();
          return createdType;
        }()}**');
      case 'bitrate':
        allChanges.add('`$currentCount` Set bitrate to **${auditLogChange.newValue} kbps**');
      case 'user_limit':
        allChanges.add('`$currentCount` Set user limit to **${auditLogChange.newValue}**');
      case 'rate_limit_per_user':
        allChanges.add(
        switch (auditLogChange.newValue) {
            0 => '`${i < 10 ? '0$i' : i} -` **Disabled** slowmode',
            _=> '`${i < 10 ? '0$i' : i} -` Set slowmode to **${auditLogChange.newValue} seconds**'
          }
        );
    }
  }
  return (user, '**created a $channelCreated** ${channel.type == ChannelType.guildText ? '#' : ''}${channel.name}' ,allChanges);
}

Future<(User, String, List<String>)> getUpdateChannelAuditInfo(AuditLogEntry log) async {
  final User user = await log.user!.get();
  final GuildChannel channel = await client!.channels.get(log.targetId!) as GuildChannel;
  final List<String> allChanges = [];
  final List<AuditLogChange> changes = log.changes!;

  for (int i = 0; i < changes.length; i++) {
    final AuditLogChange auditLogChange = changes[i];
    final String currentCount = '${i < 10 ? '0${i + 1}' : i + 1} -';
    switch (auditLogChange.key) {
      case 'topic':
        allChanges.add(
          auditLogChange.oldValue == null
          ? '`$currentCount` Set the topic to **${auditLogChange.newValue}**' 
          : '`$currentCount` Changed the topic to **${auditLogChange.newValue}**' 
        );
      case 'name':
        allChanges.add('`$currentCount` Changed the name from **${auditLogChange.oldValue}** to **${auditLogChange.newValue}**');
      case 'nsfw':
        allChanges.add('`$currentCount` ${auditLogChange.newValue ? 'Marked' : 'Unmarked'} the channel as **age-restricted**');
      case 'default_auto_archive_duration':
        allChanges.add('`$currentCount` ${auditLogChange.oldValue == null ? 'Set' : 'Changed'} default hide duration to **${addCommas(auditLogChange.newValue.toString())} minutes**');
      case 'user_limit':
        allChanges.add('`$currentCount` Changed the user limit to **${auditLogChange.newValue}**');
      case 'rtc_region':
        allChanges.add('`$currentCount` Set the region override to **${auditLogChange.newValue}**');
      case 'video_quality_mode':
        allChanges.add('`$currentCount` Set the video quality mode to **${auditLogChange.newValue == 2 ? '720p' : 'auto'}**');
       case 'bitrate':
        allChanges.add('`${i < 10 ? '0$i' : i} -` Set bitrate to ${auditLogChange.newValue} kbps');
      case 'rate_limit_per_user':
        allChanges.add(
        switch (auditLogChange.newValue) {
            0 => '`${i < 10 ? '0$i' : i} -` **Disabled** slowmode',
            _=> '`${i < 10 ? '0$i' : i} -` Set slowmode to **${auditLogChange.newValue} seconds**'
          }
        );
    }
  }
  return (user, '**made changes to** ${channel.type == ChannelType.guildText ? '#' : ''}${channel.name}' ,allChanges);
}