import 'package:discord/src/common/components/avatar/online_status/status.dart';
import 'package:discord/src/common/components/avatar/profile_pic.dart';
import 'package:discord/src/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'navigation_button.dart';

import '../provider/bottom_nav.dart';

import '../../../common/utils/cache.dart';
import '../../../common/utils/extensions.dart';

class BottomNavigator extends ConsumerWidget {
  final PageController controller;
  const BottomNavigator({required this.controller, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BottomNavProvider navProvider = ref.watch(bottomNavProvider);
    return AnimatedSlide(
      offset: Offset(0, navProvider.leftMenuOpened ? 1 : 0),
      duration: const Duration(milliseconds: 160),
      child: Container(
        height: 60 + context.padding.bottom,
        color: theme['color-09'],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NavigationButton(
              widget: Icon(
                Icons.home_filled,
                color: navProvider.currentPageIndex == 0 
                ? theme['color-02']
                : theme['color-05']
              ),
              title: Text(
                'Servers',
                style: TextStyle(
                  color: navProvider.currentPageIndex == 0 
                  ? theme['color-02']
                  : theme['color-05'],
                  fontSize: 12
                )
              ),
              onPressed: () {
                controller.jumpToPage(0);
                navProvider.changeCurrentPage(0);
              }
            ),
            NavigationButton(
              widget: ProfilePicWidget(
                image: avatar == null ? user!.avatar.url.toString() : avatar!.$1,
                radius: 24,
                backgroundColor: Colors.transparent,
              ),
              title: Text(
                'You',
                style: TextStyle(
                  color: navProvider.currentPageIndex == 1 
                  ? theme['color-02']
                  : theme['color-05'],
                  fontSize: 12
                )
              ),

              onPressed: () {
                controller.jumpToPage(1);
                navProvider.changeCurrentPage(1);
              }
            ),
          ],
        ),
      )
    );
  }
}