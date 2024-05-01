import 'package:nyxx/nyxx.dart';

const Map<String, CurrentUserStatus> onlineStatus = {
  'online': CurrentUserStatus.online,
  'idle': CurrentUserStatus.idle,
  'dnd': CurrentUserStatus.dnd,
  'invisible': CurrentUserStatus.invisible
};
const Map<String, ActivityType> activityTypes = {
  'playing': ActivityType.game,
  'watching': ActivityType.watching,
  'listening': ActivityType.listening,
  'competing': ActivityType.competing,
  'custom': ActivityType.custom
};