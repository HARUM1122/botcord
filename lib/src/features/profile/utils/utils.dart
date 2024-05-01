import 'package:flutter/services.dart';

bool isSame((Uint8List, String) r1, (Uint8List, String) r2) {
  if (r1.$1.length != r2.$1.length || r1.$2 != r2.$2) return false;
  for (int i = 0; i <  r1.$1.length; i++) {
    if (r1.$1[i] != r2.$1[i]) return false;
  }
  return true;
}