import 'package:discord/src/features/guild/screens/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:nyxx/nyxx.dart';
import 'package:page_animation_transition/animations/bottom_to_top_transition.dart';


import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/animations/bottom_to_top_faded_transition.dart';


import 'src/features/auth/screens/screens.dart';

import 'src/features/guild/screens/screens.dart';

import 'src/features/home/screens/screens.dart';

import 'src/features/profile/screens/screens.dart';

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
    case '/add-bots-route':
      return MaterialPageRoute(
        builder: (context) => const AddBotsScreen(),
      );
    case '/create-bot-account-route':
      return MaterialPageRoute(
        builder: (context) => const CreateBotAccountScreen(),
      );
    case '/tutorial-video-route':
      return MaterialPageRoute(
        builder: (context) => const TutorialVideoScreen(),
      );
    case '/settings-route':
      return MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      );
    case '/edit-status-route':
      return PageAnimationTransition(
        page: const EditActivityScreen(), 
        pageAnimationType: BottomToTopFadedTransition()
      );
    case '/edit-profile-route':
      return PageAnimationTransition(
        page: const EditProfileScreen(), 
        pageAnimationType: RightToLeftTransition()
      );
    case '/invite-bot-route':
      return MaterialPageRoute(
        builder: (context) => const InviteBotScreen(),
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