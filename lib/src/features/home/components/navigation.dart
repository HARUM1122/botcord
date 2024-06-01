import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/src/common/controllers/theme_controller.dart';

import 'navigation_button.dart';

import '../../../common/controllers/bottom_nav_controller.dart';

import '../../../common/utils/globals.dart';
import '../../../common/utils/utils.dart';
import '../../../common/utils/extensions.dart';
import '../../../common/utils/asset_constants.dart';
import '../../../common/components/profile_pic.dart';

import '../../../features/guild/controllers/guilds_controller.dart';

class BottomNavigator extends ConsumerWidget {
  final PageController controller;
  const BottomNavigator({required this.controller, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BottomNavController navProvider = ref.watch(bottomNavControler);
    final GuildsController guildsController = ref.watch(guildsControllerProvider);
    final String theme = ref.watch(themeController);
    final Color color1 = appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
    final Color color2 = appTheme<Color>(theme, light: const Color(0XFF9FA2A9), dark: const Color(0xFF777A81), midnight: const Color(0xFF777A81));

    return AnimatedSlide(
      offset: Offset(0, navProvider.leftMenuOpened || guildsController.currentGuild == null ? 0 : 1),
      duration: const Duration(milliseconds: 160),
      child: Container(
        height: 60 + context.padding.bottom,
        color: appTheme<Color>(theme, light: const Color(0XFFDFE1E3), dark: const Color(0XFF2C2F36), midnight: const Color(0XFF171A21)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NavigationButton(
              widget: SvgPicture.asset(
                AssetIcon.home,
                colorFilter: ColorFilter.mode(
                  navProvider.currentPageIndex == 0 
                  ? color1
                  : color2, 
                  BlendMode.srcIn
                )
              ),
              title: Text(
                'Servers',
                style: TextStyle(
                  color: navProvider.currentPageIndex == 0 
                  ? color1
                : color2,
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
                image: avatar?.$1 ?? (user?.avatar.url.toString() ?? ''),
                radius: 24,
                backgroundColor: Colors.transparent,
              ),
              title: Text(
                'You',
                style: TextStyle(
                  color: navProvider.currentPageIndex == 1 
                  ? color1
                  : color2,
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