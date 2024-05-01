import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import 'package:device_preview/device_preview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'routes.dart';

import 'src/themes/themes.dart';

import 'src/common/utils/cache.dart';

import 'src/features/home/screens/splash.dart';
import 'src/features/auth/controller/auth_controller.dart';
import 'src/features/profile/controller/profile_controller.dart';

bool initialized = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  if (!(prefs.getBool('is-landed') ?? false)) {
    await prefs.setString('current-bot', '{}');
    await prefs.setString('bots', '{}');
    await prefs.setStringList('trusted-domains', []);
    await prefs.setString('bot-activity', jsonEncode(
      {
        'current-online-status': 'online',
        'current-activity-text': '',
        'current-activity-type': 'custom',
        'since': ';'
      }
    ));
    await prefs.setString('app-theme', 'dark');
    await prefs.setBool('is-landed', false);
  }
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (_)=> const ProviderScope(
        child: App(),
      ),
    ),
  );
}

class App extends ConsumerWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!initialized) {
      initialized = true;
      trustedDomains = prefs.getStringList('trusted-domains')!;
      ref.read(authControllerProvider).bots = jsonDecode(prefs.getString('bots')!);
      ref.read(profileControllerProvider).botActivity = jsonDecode(prefs.getString('bot-activity')!);
      ref.watch(themeProvider.notifier).setTheme(prefs.getString('app-theme')!, false);
      SystemChrome.setSystemUIOverlayStyle(
        theme['system-ui']
      );
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
        overlays: SystemUiOverlay.values
      );
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: globalNavigatorKey,
      theme: ThemeData(
        useMaterial3: false,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0
        ),
        textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: theme['color-13']
        ),
        fontFamily: 'GGsans'
      ),
      onGenerateRoute: generateRoutes,
      builder: DevicePreview.appBuilder,
      home: const SplashScreen(),
    );
  }
}