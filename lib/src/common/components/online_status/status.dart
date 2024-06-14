import 'package:flutter/material.dart';

import 'online.dart';
import 'idle.dart';
import 'dnd.dart';
import 'invisible.dart';

Widget getOnlineStatus(String status, double radius, {Color? borderColor}) {
  switch(status) {
    case 'online':
      return OnlineStatus(radius: radius, borderColor: borderColor);
    case 'idle':
      return IdleStatus(radius: radius, borderColor: borderColor,);
    case 'dnd':
      return DoNotDisturbStatus(radius: radius, borderColor: borderColor,);
    default:
      return InvisibleStatus(radius: radius, borderColor: borderColor);
  }
}