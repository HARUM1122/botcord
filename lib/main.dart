import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:device_preview/device_preview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'routes.dart';

import 'src/common/utils/utils.dart';
import 'src/common/utils/globals.dart';
import 'src/common/controllers/theme_controller.dart';

import 'src/features/home/screens/splash.dart';
import 'src/features/auth/controller/auth_controller.dart';

bool initialized = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  final String appData = prefs.getString('app-data') ?? '';
  if (appData.isEmpty) {
    await prefs.setString('app-data', jsonEncode(
      {
        'theme': 'dark',
        'is-landed': false,
        'trusted-domains': [],
        'selected-guild-id' : ''
      }
    ));
    await prefs.setString('bot-data', jsonEncode(
      {
        'bots': {},
        'activity': {
          'current-online-status': 'online',
          'current-activity-text': '',
          'current-activity-type': 'custom',
          'since': ';'
        },
        'current-bot': {},
      }
    ));
  }
  runApp(
    DevicePreview(
      enabled: false,
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
    String theme = ref.watch(themeController);
    if (!initialized) {
      initialized = true;
      trustedDomains.addAll(jsonDecode(prefs.getString('app-data')!)['trusted-domains']);
      ref.read(authControllerProvider).bots = jsonDecode(prefs.getString('bot-data')!)['bots'];
      ref.read(themeController.notifier).setTheme(jsonDecode(prefs.getString('app-data')!)['theme'], false, true);
    }
    final Brightness brightness = appTheme<Brightness>(
      theme, 
      light: Brightness.dark, 
      dark: Brightness.light, 
      midnight: Brightness.light
    );
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.black.withOpacity(0.002),
        statusBarIconBrightness: brightness,
        systemNavigationBarColor: Colors.black.withOpacity(0.002),
        systemNavigationBarIconBrightness: brightness
      ),
    );
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: SystemUiOverlay.values
    );

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
          selectionColor: const Color(0XFFC8D0FD).withOpacity(0.3),
          selectionHandleColor: const Color(0XFFC8D0FD)
        ),
        fontFamily: 'GGsans'
      ),
      onGenerateRoute: generateRoutes,
      builder: DevicePreview.appBuilder,
      home: const SplashScreen(),
    );
  }
}