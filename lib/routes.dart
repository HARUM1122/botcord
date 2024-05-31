import 'package:discord/src/features/guild/screens/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/bottom_to_top_transition.dart';


import 'package:page_animation_transition/page_animation_transition.dart';

import 'src/features/auth/screens/screens.dart';

import 'src/features/home/screens/screens.dart';

Route<dynamic> generateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case '/landing-route':
      return MaterialPageRoute(
        builder: (context) => const LandingScreen(),
      );
    case '/home-route':
      return MaterialPageRoute(
        builder: (context) => const HomeScreen()
      );
    case '/bots-route':
      return MaterialPageRoute(
        builder: (context) => const BotsScreen(),
      );
    case '/guild-settings-route':
      return PageAnimationTransition(
        page: const GuildSettingsPage(), 
        pageAnimationType: BottomToTopTransition()
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold()
      );
  }
}