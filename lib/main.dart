import 'dart:convert';

import 'package:discord/src/common/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:device_preview/device_preview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'routes.dart';

import 'theme_provider.dart';

import 'src/common/utils/globals.dart';

import 'src/features/home/screens/splash.dart';
import 'src/features/auth/controller/auth_controller.dart';

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
      enabled: true,
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
    String theme = ref.watch(themeProvider);
    final Brightness brightness = appTheme<Brightness>(
      theme, 
      light: Brightness.light, 
      dark: Brightness.dark, 
      midnight: Brightness.dark
    );
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.black.withOpacity(0.002),
        statusBarIconBrightness: brightness,
        systemNavigationBarColor: Colors.black.withOpacity(0.002),
        systemNavigationBarIconBrightness: brightness
      ),
    );
    if (!initialized) {
      initialized = true;
      trustedDomains = prefs.getStringList('trusted-domains')!;
      ref.read(authControllerProvider).bots = jsonDecode(prefs.getString('bots')!);
      ref.read(themeProvider.notifier).setTheme(prefs.getString('app-theme')!, false, true);
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