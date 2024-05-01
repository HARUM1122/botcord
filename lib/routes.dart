import 'package:flutter/material.dart';


import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/animations/bottom_to_top_faded_transition.dart';


import 'src/features/auth/screens/screens.dart';

import 'src/features/home/screens/screens.dart';

import 'src/features/profile/screens/edit_options/edit_options.dart';

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
        builder: (context) => BotsScreen(
          fromSplash: settings.arguments as bool
        ),
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
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold()
      );
  }
}