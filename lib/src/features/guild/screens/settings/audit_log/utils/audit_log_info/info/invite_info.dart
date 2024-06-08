
import 'package:discord/src/common/utils/globals.dart';
import 'package:discord/src/common/utils/utils.dart';
import 'package:nyxx/nyxx.dart';

Future<(User, String, List<String>)> getCreateInviteLogEntryInfo(AuditLogEntry log) async {
  final User user = await log.user!.get();
  final List<String> allChanges = [];
  final List<AuditLogChange> changes = log.changes!;

  for (int i = 0; i < changes.length; i++) {
    final AuditLogChange auditLogChange = changes[i];
    switch (auditLogChange.key) {
      case 'code':
        allChanges.add('With code **${auditLogChange.newValue}**');
      case 'channel_id':
        allChanges.add('For channel ID **${auditLogChange.newValue}**');
      case 'max_uses':
        int uses = auditLogChange.newValue;
        allChanges.add('Which has ${uses == 1 ? 'only' : ''}**${uses == 0 ? 'unlimited' : uses}** ${uses == 1 ? 'use' : 'uses'}');
      case 'max_age':
        int maxAge = auditLogChange.newValue;
        allChanges.add(maxAge == 0 ? 'Which will **never expire**' : 'Which will expire in ${formatDuration(maxAge)}');
      case 'temporary':
        allChanges.add('With temporary **${auditLogChange.newValue ? 'on' : 'off'}**');
    }
  }
  return (user, '**created an invite**', allChanges);
}