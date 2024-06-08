import 'package:nyxx/nyxx.dart';

Future<(User, String, List<String>)> getUpdateGuildSettingsLogEntryInfo(AuditLogEntry log) async {
  final User user = await log.user!.get();
  final List<String> allChanges = [];
  final List<AuditLogChange> changes = log.changes!;

  for (int i = 0; i < changes.length; i++) {
    final AuditLogChange auditLogChange = changes[i];
    switch (auditLogChange.key) {
      case 'icon_hash':
        allChanges.add('${auditLogChange.oldValue == null ? 'Set' : 'Changed'} the **server icon**');
      case 'premium_progress_bar_enabled':
        allChanges.add('Turned **${auditLogChange.newValue ? 'on' : 'off'}** Boost progress bar');
      case 'afk_channel_id':
        allChanges.add('Set AFK channel ID to **${auditLogChange.newValue}**');
      case 'afk_timeout':
        allChanges.add('Set AFK timeout to **${auditLogChange.newValue ~/ 60} minutes**');
      case 'default_message_notifications':
        allChanges.add('Set default message notifications to **${auditLogChange.newValue == 1 ? 'All Messages' : 'Only Mentions'}**');
      case 'system_channel_id':
        allChanges.add('Set system channel ID to **${auditLogChange.newValue}**');
      case 'system_channel_flags':
        allChanges.add('Set system channel flags to **${auditLogChange.newValue}**');
      case 'name':
        allChanges.add('Changed guild name to **${auditLogChange.newValue}**');
    }
  }
  return (user, '**made changes to** server settings', allChanges);
}