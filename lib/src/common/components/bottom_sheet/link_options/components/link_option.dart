import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../custom_button.dart';

import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/common/controllers/theme_controller.dart';

class LinkOption extends ConsumerWidget {
  final String title;
  final Function() onPressed;
  final BorderRadius borderRadius;
  const LinkOption({
    required this.title,
    required this.onPressed,
    required this.borderRadius,
    super.key
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.read(themeController);
    return CustomButton(
      backgroundColor: Colors.transparent,
      onPressedColor: appTheme<Color>(theme, light: const Color(0XFFE1E1E1), dark: const Color(0XFF2F323A), midnight: const Color(0XFF202226)),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius
      ),
      onPressed: onPressed,
      applyClickAnimation: false, 
      child: Container(
        margin: const EdgeInsets.all(20),
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
            fontSize: 16,
            fontFamily: 'GGSansSemibold'
          ),
        ),
      )
    );
  }
}