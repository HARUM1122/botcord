import 'package:flutter/material.dart';

import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/common/components/custom_button.dart';


class InviteLinkOption extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final BorderRadius borderRadius;
  final String theme;
  const InviteLinkOption({
    required this.title,
    required this.onPressed,
    required this.borderRadius,
    required this.theme,
    super.key
  });
  @override
  Widget build(BuildContext context) {
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