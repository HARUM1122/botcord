import 'package:discord/src/common/utils/globals.dart';
import 'package:discord/src/features/guild/utils/utils.dart';
import 'package:nyxx/nyxx.dart';


Future<(User, String, List<String>)> getCreatedChannelOverridesLogEntryInfo(AuditLogEntry log, Guild? guild) async {
  final User user = await log.user!.get();
  final GuildChannel? channel = await getChannel(log.targetId!);
  final List<String> allChanges = [];
  final List<AuditLogChange> changes = log.changes!;
  for (int i = 0; i < changes.length; i++) {
    final AuditLogChange auditLogChange = changes[i];
    switch (auditLogChange.key) {
      case 'allow':
        String permissions = '';
        for (final String permission in getAllPermissions(Permissions(int.parse(auditLogChange.newValue)))) {
          permissions += '- $permission\n';
        }
        if (permissions.isNotEmpty) {
          allChanges.add('**Granted** permissions for ${log.options!.roleName}\n\n$permissions');
        }
      case 'deny':
        String permissions = '';
        for (final String permission in getAllPermissions(Permissions(int.parse(auditLogChange.newValue)))) {
          permissions += '- $permission\n';
        }
        if (permissions.isNotEmpty) {
          allChanges.add('**Denied** permissions for ${log.options!.roleName}\n\n$permissions');
        }
    }
  }
  return (user, '**created overrides for** ${channel?.type == ChannelType.guildText ? '#' : ''}${channel?.name ?? log.targetId}' , allChanges);
}

Future<(User, String, List<String>)> getUpdatedChannelOverridesLogEntryInfo(AuditLogEntry log, Guild? guild) async {
  final User user = await log.user!.get();
  final GuildChannel? channel = await getChannel(log.targetId!);
  final List<String> allChanges = [];
  final List<AuditLogChange> changes = log.changes!;
  for (int i = 0; i < changes.length; i++) {
    final AuditLogChange auditLogChange = changes[i];
    switch (auditLogChange.key) {
      case 'allow':
        String permissions = '';
        for (final String permission in getAllPermissions(Permissions(int.parse(auditLogChange.newValue)))) {
          permissions += '- $permission\n';
        }
        if (permissions.isNotEmpty) {
          allChanges.add('**Granted** permissions for ${log.options!.roleName}\n\n$permissions');
        }
      case 'deny':
        String permissions = '';
        for (final String permission in getAllPermissions(Permissions(int.parse(auditLogChange.newValue)))) {
          permissions += '- $permission\n';
        }
        if (permissions.isNotEmpty) {
          allChanges.add('**Denied** permissions for ${log.options!.roleName}\n\n$permissions');
        }
    }
  }
  return (user, '**updated overrides** for ${channel?.type == ChannelType.guildText ? '#' : ''}${channel?.name ?? log.targetId}' , allChanges);
}