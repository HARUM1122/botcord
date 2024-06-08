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
  String channelCreated = '';
  String channelType = '';
  for (int i = 0; i < changes.length; i++) {
    final AuditLogChange auditLogChange = changes[i];
    switch (auditLogChange.key) {
      case 'name':
        allChanges.add('Set the name to **${auditLogChange.newValue}**');
      case 'type':
        allChanges.add('Set type to **${() {
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
        allChanges.add('Set bitrate to **${auditLogChange.newValue} kbps**');
      case 'user_limit':
        allChanges.add('Set user limit to **${auditLogChange.newValue}**');
      case 'rate_limit_per_user':
        allChanges.add(
        switch (auditLogChange.newValue) {
            0 => '**Disabled** slowmode',
            _=> 'Set slowmode to **${auditLogChange.newValue} seconds**'
          }
        );
    }
  }
  return (user, '**created a** $channelType ${channelType == 'Text Channel' ? '#' : ''}$channelCreated' ,allChanges);
}

Future<(User, String, List<String>)> getUpdateChannelLogEntryInfo(AuditLogEntry log) async {
  final User user = await log.user!.get();
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
        allChanges.add(
        switch (auditLogChange.newValue) {
            0 => '**Disabled** slowmode',
            _=> 'Set slowmode to **${auditLogChange.newValue} seconds**'
          }
        );
    }
  }
  return (user, '**made changes to** a channel' , allChanges);
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