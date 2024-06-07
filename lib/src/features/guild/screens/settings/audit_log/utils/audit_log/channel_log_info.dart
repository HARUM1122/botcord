import 'package:nyxx/nyxx.dart';

Future<(User, String, List<String>)> createChannelAuditInfo(AuditLogEntry log) async {
  User user = await log.user!.get();
  String channelCreated = '';
  List<String> allChanges = [];
  List<AuditLogChange> changes = log.changes!;
  for (int i = 0; i < changes.length; i++) {
    final AuditLogChange auditLogChange = changes[i];
    switch (auditLogChange.key) {
      case 'name':
        allChanges.add('`${i < 10 ? '0$i' : i} -` Set the name to **${auditLogChange.newValue}**');
      case 'type':
        allChanges.add('`${i < 10 ? '0$i' : i} -` Set type to **${() {
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
        allChanges.add('`${i < 10 ? '0$i' : i} -` Set bitrate to ${auditLogChange.newValue} kbps');
      case 'user_limit':
        allChanges.add('`${i < 10 ? '0$i' : i} -` Set user limit to ${auditLogChange.newValue}');
      case 'rate_limit_per_user':
        allChanges.add(
          switch (auditLogChange.newValue) {
            0 => '`${i < 10 ? '0$i' : i} -` **Disabled** slowmode',
            _=> '`${i < 10 ? '0$i' : i} -` Set slowmode to ${auditLogChange.newValue} seconds'
          }
        );
    }
  }
  return (user, 'created a $channelCreated' ,allChanges);
}


// TEXT CHANNEL INFO
// flutter: topic : null : channel topic
// flutter: rate_limit_per_user : 0 : 10
// flutter: name : asdfadsfasdfasdfasd : helo-world
// flutter: nsfw : false : true
// flutter: default_auto_archive_duration : null : 1008

// CATEGORY INFO
// flutter: name : Text Channelsm : Text Channelsmasdf

Future<(User, String, List<String>)> updateChannelAuditInfo(AuditLogEntry log) async {
  User user = await log.user!.get();
  String channelUpdated = '';
  List<String> allChanges = [];
  List<AuditLogChange> changes = log.changes!;
  for (int i = 0; i < changes.length; i++) {
    final AuditLogChange auditLogChange = changes[i];
    final String currentCount = '${i < 10 ? '0$i' : i} -';
    switch (auditLogChange.key) {
      case 'topic':
        allChanges.add(
          auditLogChange.oldValue == null
          ? '`$currentCount` Set the topic to **${auditLogChange.newValue}**' 
          : '`$currentCount` Changed the topic to **${auditLogChange.newValue}**' 
        );
      case 'rate_limit_per_user':
        allChanges.add('`$currentCount` ${auditLogChange.newValue == 0 ? '**Disabled** slowmode' : 'Set slowmode to **${auditLogChange.newValue}**'}');
      case 'name':
        allChanges.add('`$currentCount` Changed the name from **${auditLogChange.oldValue}** to **${auditLogChange.newValue}**');
      case 'nsfw':
        allChanges.add('`$currentCount` ${auditLogChange.newValue ? 'Marked' : 'Unmarked'} the channel as **age-restricted**');
      case 'default_auto_archive_duration':
        allChanges.add('`$currentCount` ${auditLogChange.oldValue == null ? 'Set' : 'Changed'} default hide duration to **{}**');
    }

  }
  return (user, 'made changes to $channelUpdated' ,allChanges);
}