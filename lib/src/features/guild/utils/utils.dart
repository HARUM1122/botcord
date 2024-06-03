import 'package:nyxx/nyxx.dart';

int customSort(String key) {
  if (key.contains(RegExp(r'^[\W_]+$'))) {
    return 1;
  } else if (key.contains(RegExp(r'^\d+$'))) {
    return 2;
  } else if (key.contains(RegExp(r'^[A-Z]+$'))) {
    return 3;
  } else {
    return 4;
  }
}
List<Guild> sortGuilds(List<Guild> guilds) {
  if (guilds.isEmpty) return guilds;
  return guilds..sort((a, b) {
    int aSort = customSort(a.name[0].toUpperCase());
    int bSort = customSort(b.name[0].toUpperCase());
    if (aSort == bSort) {
      return a.name[0].toUpperCase().compareTo(b.name[0].toUpperCase());
    } else {
      return aSort.compareTo(bSort);
    }
  });
}

Future<Permissions> computePermissions(Guild guild, Member member) async {
  if (guild.ownerId == member.id) {
    return Permissions.allPermissions;
  }
  Flags<Permissions> permissions = (await guild.roles[guild.id].get()).permissions;
  for (final PartialRole role in member.roles) {
    permissions |= (await role.get()).permissions;
  }
  permissions = Permissions(permissions.value);
  permissions as Permissions;
  return permissions.isAdministrator ? Permissions.allPermissions : permissions;
}

String getDuration(Duration duration) => switch(duration.inSeconds) {
    60 => '1 minute',
    300 => '5 minutes',
    900 => '15 minutes',
    1800 => '30 minutes',
    3600 => '1 hour',
    _=> ''
  };
  