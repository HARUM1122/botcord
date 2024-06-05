import 'package:flutter/material.dart';
import 'package:nyxx/nyxx.dart';

const Map<int, (String, String, AuditLogEvent)> actions = {
  0 : ('Update Server', 'UPDATE', AuditLogEvent.guildUpdate),
  1 : ('Create Channel', 'ADD', AuditLogEvent.channelCreate),
  2 : ('Update Channel', 'UPDATE', AuditLogEvent.channelUpdate),
  3 : ('Delete Channel', 'REMOVE', AuditLogEvent.channelDelete),
  4 : ('Create Channel Permissions', 'ADD', AuditLogEvent.channelOverwriteCreate),
  5 : ('Update Channel Permissions', 'UPDATE', AuditLogEvent.channelOverwriteUpdate),
  6 : ('Delete Channel Permissions', 'REMOVE', AuditLogEvent.channelOverwriteDelete),
  7 : ('Kick Member', 'REMOVE', AuditLogEvent.memberKick),
  8 : ('Prune Members', 'REMOVE', AuditLogEvent.memberPrune),
  9 : ('Ban Member', 'REMOVE', AuditLogEvent.memberBanAdd),
  10 : ('Unban Member', 'ADD', AuditLogEvent.memberBanRemove),
  11 : ('Update Member', 'UPDATE', AuditLogEvent.memberUpdate),
  12 : ('Update Member Roles', 'UPDATE', AuditLogEvent.memberRoleUpdate),
  13 : ('Move Member', 'UPDATE', AuditLogEvent.memberMove),
  14 : ('Disconnect Member', 'REMOVE', AuditLogEvent.memberDisconnect),
  15 : ('Add Bot', 'ADD', AuditLogEvent.botAdd),
  16 : ('Create Thread', 'ADD', AuditLogEvent.threadCreate),
  17 : ('Update Thread', 'UPDATE', AuditLogEvent.threadUpdate),
  18 : ('Delete Thread', 'REMOVE', AuditLogEvent.threadDelete),
  19 : ('Create Role', 'ADD', AuditLogEvent.roleCreate),
  20 : ('Update Role', 'UPDATE', AuditLogEvent.roleUpdate),
  21 : ('Delete Role', 'DELETE', AuditLogEvent.roleDelete),
  21 : ('Create Customization Question', 'ADD', AuditLogEvent.q),
  21 : ('Delete Role', 'DELETE', AuditLogEvent.roleDelete),
  21 : ('Delete Role', 'DELETE', AuditLogEvent.roleDelete),
};