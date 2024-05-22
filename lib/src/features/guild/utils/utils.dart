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
List<UserGuild> sortGuilds(List<UserGuild> guilds) {
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