import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:nyxx/nyxx.dart';
import 'package:shared_preferences/shared_preferences.dart';

User? user;
NyxxGateway? client;
Application? application;
(Uint8List, String)? avatar;
(Uint8List, String)? banner;

final globalNavigatorKey = GlobalKey<NavigatorState>();
final List<dynamic> trustedDomains = [];
late final SharedPreferences prefs;