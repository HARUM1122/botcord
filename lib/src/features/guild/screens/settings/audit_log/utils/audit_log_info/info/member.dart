import 'package:nyxx/nyxx.dart';
import 'package:intl/intl.dart';
String convertToReadableFormat(String isoString) {
  // Parse the ISO 8601 date string
  DateTime dateTime = DateTime.parse(isoString);
  DateTime localDateTime = dateTime.toLocal();
  DateTime now = DateTime.now();
  DateTime tomorrow = now.add(const Duration(days: 1));

  String formattedTime = DateFormat('h:mm a').format(localDateTime);

  if (localDateTime.year == tomorrow.year &&
      localDateTime.month == tomorrow.month &&
      localDateTime.day == tomorrow.day) {
    return 'Tomorrow at $formattedTime';
  } else if (localDateTime.year == now.year &&
      localDateTime.month == now.month &&
      localDateTime.day == now.day) {
    return 'Today at $formattedTime';
    }
  else {
    return DateFormat('MMMM d \'at\' h:mm a').format(localDateTime);
  }
}

Future<(User, String, List<String>)> getMemberKickedLogEntryInfo(AuditLogEntry log, Guild? guild) async {
  final User user = await log.user!.get();
  final List<String> allChanges = [];
  if (log.reason != null) {
    allChanges.add('With reason **${log.reason}**');
  }
  return (user, 'kicked **${log.targetId}**' , allChanges);
}

Future<(User, String, List<String>)> getMemberBannedLogEntryInfo(AuditLogEntry log, Guild? guild) async {
  final User user = await log.user!.get();
  final List<String> allChanges = [];
  if (log.reason != null) {
    allChanges.add('With reason **${log.reason}**');
  }
  return (user, 'Banned **${log.targetId}**' , allChanges);
}

Future<(User, String, List<String>)> getMemberPrunedLogEntryInfo(AuditLogEntry log, Guild? guild) async {
  final User user = await log.user!.get();
  final int totalMemberPrunned = int.parse(log.options!.membersRemoved.toString());
  return (user, 'Pruned $totalMemberPrunned **${totalMemberPrunned == 1 ? 'member' : 'members'}**' , ['For **${log.options!.deleteMemberDays} of inactivity**']);
}

Future<(User, String, List<String>)> getMemberUnbannedLogEntryInfo(AuditLogEntry log, Guild? guild) async {
  final User user = await log.user!.get();
  final List<String> allChanges = [];
  return (user, 'Unbanned **${log.targetId}**' , allChanges);
}

Future<(User, String, List<String>)> getMemberUpdatedLogEntryInfo(AuditLogEntry log, Guild? guild) async {
  final User user = await log.user!.get();
  final Member? member = await guild?.members.get(log.targetId!);
  final List<String> allChanges = [];
  final List<AuditLogChange> changes = log.changes ?? [];
  for (int i = 0; i < changes.length; i++) {
    final AuditLogChange auditLogChange = changes[i];
    switch (auditLogChange.key) {
      case 'nick':
        allChanges.add('${auditLogChange.oldValue != null ? 'Changed' : 'Set'} nickname to **${auditLogChange.newValue}**');
      case 'communication_disabled_until':
        allChanges.add(
          auditLogChange.newValue == null
          ? 'Removed **timeout**'
          : 'Set timeout for user until ${convertToReadableFormat(auditLogChange.newValue)}'
        );
    }
  }
  if (log.reason != null) {
    allChanges.add('With reason **${log.reason}**');
  }
  return (user, 'Updated **${member?.user?.username ?? log.targetId}**' , allChanges);
}

Future<(User, String, List<String>)> getMemberRolesUpdateLogEntryInfo(AuditLogEntry log, Guild? guild) async {
  final User user = await log.user!.get();
  final Member? member = await guild?.members.get(log.targetId!);
  final List<String> allChanges = [];
  final List<AuditLogChange> changes = log.changes ?? [];
  for (int i = 0; i < changes.length; i++) {
    final AuditLogChange auditLogChange = changes[i];
    switch (auditLogChange.key) {
      case r'$add':
        allChanges.add('Added a role **${auditLogChange.newValue[0]['name']}**');
      case r'$remove':
        allChanges.add('Removed a role **${auditLogChange.newValue[0]['name']}**');
    }
  }
  return (user, 'Updated roles for **${member?.user?.username ?? log.targetId}**' , allChanges);
}

