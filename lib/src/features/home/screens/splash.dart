import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/theme_provider.dart';

import '../../../common/utils/utils.dart';
import '../../../common/utils/globals.dart';

import '../../../features/auth/controller/auth_controller.dart';
import '../../../features/guild/controllers/guilds_controller.dart';
import '../../../features/profile/controller/profile_controller.dart';


class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  late final Map<String, dynamic> _bot = jsonDecode(prefs.getString('current-bot')!);
  late final AuthController _authController = ref.read(authControllerProvider);
  late final ProfileController _profileController = ref.read(profileControllerProvider);
  late final String _theme = ref.read(themeProvider);

  @override
  void initState() {
    super.initState();
    if (_bot.isEmpty) {
      Future.delayed(const Duration(seconds: 2), () {
        !prefs.getBool('is-landed')!
        ? Navigator.pushReplacementNamed(context, '/landing-route')
        : Navigator.pushReplacementNamed(context, '/bots-route');
      });
    } else {
      runZonedGuarded(
      () async {
          await _authController.login(_bot);
          _profileController.botActivity = jsonDecode(prefs.getString('bot-activity')!);
          print(_profileController.botActivity);
          _profileController.updatePresence(save: false, datetime: DateTime.now());

          ref.read(guildsControllerProvider).listenGuildEvents();
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/home-route');
          }
        }, 
        (error, stack) async {
          print("ERROR FROM SPLASH SCREEN: $error");
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
            _authController.removeBot(_bot['name'][0].toUpperCase(), _bot['id']);
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