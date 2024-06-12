import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/src/common/controllers/theme_controller.dart';

import '../../../common/utils/utils.dart';
import '../../../common/utils/globals.dart';

import '../../../features/auth/controller/auth_controller.dart';
import '../../../features/guild/controllers/guilds_controller.dart';
import '../../profile/controller/profile.dart';


class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  late final AuthController _authController = ref.read(authControllerProvider);
  late final ProfileController _profileController = ref.read(profileControllerProvider);
  late final GuildsController _guildsController = ref.read(guildsControllerProvider);
  late final String _theme = ref.read(themeController);

  late final Map<String, dynamic> _botData = jsonDecode(prefs.getString('bot-data')!);

  @override
  void initState() {
    super.initState();
    if (_botData['current-bot'].isEmpty) {
      Future.delayed(const Duration(seconds: 2), () {
        !jsonDecode(prefs.getString('app-data')!)['is-landed']
        ? Navigator.pushReplacementNamed(context, '/landing-route')
        : Navigator.pushReplacementNamed(context, '/bots-route');
      });
    } else {
      runZonedGuarded(
      () async {
          await _authController.login(_botData['current-bot']);
          _profileController.botActivity = _botData['activity'];
          _profileController.updatePresence(save: false, datetime: DateTime.now());

          _guildsController.init();
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/home-route');
          }
        }, 
        (error, stack) async {
          Navigator.pushReplacementNamed(globalNavigatorKey.currentContext!, '/bots-route');
          await Future.delayed(const Duration(seconds: 1));
          if (error is ClientException) {
            showSnackBar(
              context: globalNavigatorKey.currentContext!,
              theme: _theme, 
              leading: Icon(
                Icons.error_outline,
                color: Colors.red[800],
              ), 
              msg: 'Network error, Please login again'
            );
          } else if (error.toString().contains('401: Unauthorized')) {
            _authController.removeBot(
              _botData['current-bot']['name'][0].toUpperCase(),
              _botData['current-bot']['id']
            );
            showSnackBar(
              context: globalNavigatorKey.currentContext!,
              theme: _theme, 
              leading: Icon(
                Icons.error_outline,
                color: Colors.red[800],
              ), 
              msg: 'Invalid token, Please login again'
            );
          } else {
            _authController.logout(null);
            showSnackBar(
              context: globalNavigatorKey.currentContext!,
              theme: _theme,
              leading: Icon(
                Icons.error_outline,
                color: Colors.red[800],
              ),
              msg: 'Unexpected error, Please login again',
            );
          }
        }
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      color: appTheme<Color>(_theme, light: const Color(0xFFFFFFFF), dark: const Color(0xFF1A1D24), midnight: const Color(0xFF000000)),
      child: Center(
        child: Icon(
          Icons.discord_outlined,
          size: 140,
          color: appTheme<Color>(_theme, light: const Color(0xFF1A1D24), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF))
        )
      )
    );
  }
}