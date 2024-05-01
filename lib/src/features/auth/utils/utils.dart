import 'dart:collection';
// AI-GENERATED CODE
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
Map<String, dynamic> sort(Map<String, dynamic> map) {
  if (map.isEmpty) return map;
  var sortedKeys = map.keys.toList()..sort((a, b) {
    int aSort = customSort(a);
    int bSort = customSort(b);
    if (aSort == bSort) {
      return a.compareTo(b);
    } else {
      return aSort.compareTo(bSort);
    }
  });
  LinkedHashMap<String, dynamic> sortedMap =
      LinkedHashMap.fromIterable(sortedKeys, key: (k) => k, value: (k) => map[k]!);
  return sortedMap;
}
//----------------------------------------------------------------------------------------//

Map<String, dynamic> filter(Map<String, dynamic> map, String name) {
  Map<String, dynamic> filteredMap = {};
  for (final String k in map.keys) {
    List filteredValues = [];
    for (final value in map[k]) {
      if (value['name'].toLowerCase().contains(name.toLowerCase())) {
        filteredValues.add(value);
      }
    }
    if (filteredValues.isNotEmpty) {
      filteredMap[k] = filteredValues;
    }
  }
  return filteredMap;
}