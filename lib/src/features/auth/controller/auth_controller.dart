import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:nyxx/nyxx.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/utils.dart';
import '../utils/constants.dart';

import '../../../common/utils/globals.dart';
import '../../../common/utils/constants.dart';

final authControllerProvider = ChangeNotifierProvider<AuthController>((ref) => AuthController());

class AuthController extends ChangeNotifier {
  Map<String, dynamic> bots = {};

  Map? getBotData(String key, String id) {
    int index = indexOf(key, id);
    if (index != -1) {
        return bots[key][index];
    }
    return null;
  }

  Future<void> login(Map<String, dynamic> bot) async {
    client = await Nyxx.connectGateway(
      bot['token'], 
      GatewayIntents.all
    );
    user = await client!.user.get();
    avatar = (await user!.avatar.fetch(), user!.avatar.defaultFormat.extension);
    CdnAsset? b = user!.banner;
    if (b != null) banner = (await b.fetch(), b.defaultFormat.extension);
    application = await client!.applications.fetchCurrentApplication();
    await prefs.setString('current-bot',  jsonEncode(bot));
  }

  Future<void> logout(BuildContext? context) async {
    try {
      await client?.close();
      await prefs.setString('current-bot', '{}');
    } catch (e) {
      // 
    }
    if (context == null || !context.mounted ) return;
    Navigator.pushReplacementNamed(context, '/bots-route', arguments: true);
  }

  Future<int> addToken(String token) async {
    http.Response res = await http.get(Uri.parse("$endpoint/users/@me"), headers: {
      'Authorization': 'Bot $token'
      }
    );
    Map<String, dynamic> json = jsonDecode(res.body);
    if (res.statusCode == 200) {
      String username = json['username']!;
      final String key = username[0].toUpperCase();
      if (indexOf(key, json['id']!) != -1) {
        return -1;
      }
      Map<String, String> data = {
        'name': json['username']!,
        'discriminator': json['discriminator']!,
        'id': json['id']!, 
        'avatar-url': "$imageUrl/${json['id']}/${json['avatar']}.png",
        'token': token
      };
      if (bots.containsKey(key)) {
        bots[key]!.add(data);
      } else {
        bots[key] = [data];
      }
      bots = sort(bots);
      await save();
      refresh();
      return 200;
    }
    return res.statusCode;
  }

  Future<bool> removeBot(String key, String id, [bool logoutIfCurrent = true]) async {
    int index = indexOf(key, id);
    if (index != -1) {
      if (jsonDecode(prefs.getString('current-bot') ?? "{}")?['id'] == id && logoutIfCurrent) {
        logout(globalNavigatorKey.currentContext);
      }
      if (bots[key].length < 2) {
        bots.remove(key);
      } else {
        bots[key].removeAt(index);
      }
      bots = sort(bots);
      await save();
      refresh();
      return true;
    }
    return false;
  }

  int indexOf(String key, String id) {
    if (!bots.containsKey(key)) return -1;
    for (int i = 0; i < bots[key]!.length; i++) {
      if (bots[key]![i]['id'] == id) {
        return i;
      }
    }
    return -1;
  }


  Future<void> save() async =>
    await prefs.setString('bots', jsonEncode(bots));

  void refresh() => notifyListeners();
}