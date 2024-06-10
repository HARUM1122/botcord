import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/src/common/controllers/theme_controller.dart';

import '../controller/profile.dart';

import '../../../common/utils/utils.dart';
import '../../../common/utils/extensions.dart';
import '../../../common/components/drag_handle.dart';
import '../../../common/components/custom_button.dart';
import '../../../common/components/online_status/status.dart';

import '../../../common/components/radio_button_indicator/radio_button_indicator.dart';

class OnlineStatusSheet extends ConsumerWidget {
  final ScrollController controller;
  const OnlineStatusSheet({required this.controller, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.read(themeController);
    final ProfileController profileController = ref.read(profileControllerProvider);
    
    final Map<String, dynamic> botActivity = profileController.botActivity;

    final Color color1 = appTheme<Color>(theme, light: const Color(0XFFEBEBEB), dark: const Color(0XFF2C2D36), midnight: const Color(0XFF1C1B21));
    
    List<Widget> children = [
      Align(
        alignment: Alignment.topCenter,
        child: DragHandle(
          color: appTheme<Color>(theme, light: const Color(0XFFD8DADD), dark: const Color(0XFF2F3039), midnight: const Color(0XFF151518)),
        )
      ),
      const SizedBox(height: 10),
      Align(
        alignment: Alignment.topCenter,
        child: Text(
          'Change Online Status',
          style: TextStyle(
            color: appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
            fontSize: 20,
            fontFamily: 'GGSansBold'
          ),
        ),
      ),
      const SizedBox(height: 20),
      Text(
        "Online Status",
        style: TextStyle(
          color: appTheme<Color>(theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFF81818D)),
          fontSize: 14,
          fontFamily: 'GGSansSemibold'
        ),
      ),
      const SizedBox(height: 10),
      Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: appTheme<Color>(theme, light: const Color(0xFFFFFFFF), dark: const Color(0xFF25282F), midnight: const Color(0XFF141318)),
          borderRadius: BorderRadius.circular(16)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            OnlineStatusRB(
              status: 'online',
              title: 'Online',
              selected: botActivity['current-online-status'] == 'online',
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16)
              ),
            ),
            Divider(
              color: color1,
              thickness: 1,
              height: 0,
              indent: 50,
            ),
            OnlineStatusRB(
              status: 'idle',
              title: 'Idle',
              selected: botActivity['current-online-status'] == 'idle',
              borderRadius: BorderRadius.zero,
            ),
            Divider(
              color: color1,
              thickness: 1,
              height: 0,
              indent: 50,
            ),
            OnlineStatusRB(
              status: 'dnd',
              title: 'Do Not Disturb',
              selected: botActivity['current-online-status'] == 'dnd',
              borderRadius: BorderRadius.zero,
            ),
            Divider(
              color: color1,
              thickness: 1,
              height: 0,
              indent: 50,
            ),
            OnlineStatusRB(
              status: 'invisible',
              title: 'Invisible',
              selected: botActivity['current-online-status'] == 'invisible',
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16)
              ),
            )
          ],
        )
      )
    ];
    return ListView.builder(
      padding: EdgeInsets.only(top: 8, left: 12, right: 12, bottom: context.padding.bottom + 12),
      controller: controller,
      itemCount: children.length,
      itemBuilder: (context, idx) => children[idx]
    );
  }
}

class OnlineStatusRB extends ConsumerWidget {
  final String status;
  final String title;
  final BorderRadius borderRadius;
  final bool selected;
  const OnlineStatusRB({
    required this.status,
    required this.title,
    required this.borderRadius,
    required this.selected,
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ProfileController profileController = ref.read(profileControllerProvider);
    final String theme =  ref.read(themeController);
    return CustomButton(
      height: 60,
      onPressed: () {
        profileController.botActivity['current-online-status'] = status;
        profileController.updatePresence(save: true);
        Navigator.pop(context);
      },
      backgroundColor: Colors.transparent,
      onPressedColor: appTheme<Color>(theme, light: const Color(0XFFE1E1E1), dark: const Color(0XFF2F323A), midnight: const Color(0XFF202226)),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius
      ),
      applyClickAnimation: false,
      child: Row(
        children: [
          const SizedBox(width: 14),
          getOnlineStatus(
            status, 
            18
          ),
          const SizedBox(width: 18),
          Text(
            title,
            style: TextStyle(
              color: appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
              fontSize: 16,
              fontFamily: 'GGSansSemibold'
            ),
          ),
          const Spacer(),
          RadioButtonIndicator(
            radius: 24, 
            selected: selected
          ),
          const SizedBox(width: 14)
        ],
      ),
    );
  }
}