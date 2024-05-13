import 'dart:async';
import 'dart:convert';

import 'package:discord/src/features/guild/controllers/guilds_controller.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/theme_provider.dart';

import '../../../common/utils/utils.dart';
import '../../../common/utils/globals.dart';

import '../../../features/auth/controller/auth_controller.dart';
import '../../../features/profile/controller/profile_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    final Map<String, dynamic> bot = jsonDecode(prefs.getString('current-bot')!);
    final AuthController authController = ref.read(authControllerProvider);
    final String theme = ref.read(themeProvider);
    if (bot.isEmpty) {
      Future.delayed(const Duration(seconds: 2), () {
        !prefs.getBool('is-landed')!
        ? Navigator.pushReplacementNamed(context, '/landing-route')
        : Navigator.pushReplacementNamed(context, '/bots-route');
      });
    } else {
      runZonedGuarded(
      () async {
          await authController.login(bot);
          ref.read(guildsControllerProvider).listenGuildEvents();
          ref.read(profileControllerProvider).updatePresence(
            save: false, 
            datetime: DateTime.now()
          );
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/home-route');
          }
        }, 
        (error, stack) async {
          Navigator.pushReplacementNamed(globalNavigatorKey.currentContext!, '/bots-route', arguments: true);
          await Future.delayed(const Duration(seconds: 1));
          if (error is ClientException) {
            showSnackBar(
              context: globalNavigatorKey.currentContext!,
              theme: theme, 
              leading: Icon(
                Icons.error_outline,
                color: Colors.red[800],
              ), 
              msg: 'Network error, Please login again'
            );
          } else if (error.toString().contains('401: Unauthorized')) {
            authController.removeBot(bot['name'][0].toUpperCase(), bot['id']);
            showSnackBar(
              context: globalNavigatorKey.currentContext!,
              theme: theme, 
              leading: Icon(
                Icons.error_outline,
                color: Colors.red[800],
              ), 
              msg: 'Invalid token, Please login again'
            );
          } else {
            authController.logout(null);
            showSnackBar(
              context: globalNavigatorKey.currentContext!,
              theme: theme,
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
    final String theme = ref.read(themeProvider);
    return Material(
      color: appTheme<Color>(theme, light: const Color(0xFFFFFFFF), dark: const Color(0xFF1A1D24), midnight: const Color(0xFF000000)),
      child: Center(
        child: Icon(
          Icons.discord_outlined,
          size: 180,
          color: appTheme<Color>(theme, light: const Color(0xFF1A1D24), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF))
        )
      )
    );
  }
}