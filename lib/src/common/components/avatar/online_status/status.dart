import 'package:flutter/material.dart';

import 'online.dart';
import 'idle.dart';
import 'dnd.dart';
import 'invisible.dart';

Widget getOnlineStatus(String status,double radius) {
  switch(status) {
    case 'online':
      return OnlineStatus(radius: radius);
    case 'idle':
      return IdleStatus(radius: radius);
    case 'dnd':
      return DoNotDisturbStatus(radius: radius);
    default:
      return InvisibleStatus(radius: radius);
  }
}