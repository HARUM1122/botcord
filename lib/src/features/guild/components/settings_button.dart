import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/utils.dart';
import '../../../common/components/custom_button.dart';
import '../../../common/controllers/theme_controller.dart';


class SettingsButton extends ConsumerWidget {
  final bool enabled;
  final Color backgroundColor;
  final Color onPressedColor;
  final BorderRadius? borderRadius;
  final Function() onPressed;
  final String assetIcon;
  final String title;

  const SettingsButton({
    required this.enabled,
    required this.backgroundColor,
    required this.onPressedColor,
    this.borderRadius,
    required this.onPressed,
    required this.assetIcon,
    required this.title,
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.read(themeController);
    return CustomButton(
      enabled: enabled,
      width: double.infinity,
      backgroundColor: backgroundColor,
      onPressedColor: onPressedColor,
      applyClickAnimation: false,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.zero
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              height: 20,
              assetIcon,
              colorFilter: ColorFilter.mode(
                appTheme<Color>(
                  theme, 
                  light: Color(enabled ? 0xFF000000 : 0XFF818181),
                  dark: Color(enabled ? 0xFFFFFFFF : 0XFF868990),
                  midnight: Color(enabled ? 0xFFFFFFFF : 0XFF7F7E83)
                ),
                BlendMode.srcIn
              ),
            ),
            const SizedBox(width: 18),
            Text(
              title,
              style: TextStyle(
                color: appTheme<Color>(
                  theme, 
                  light: enabled ? const Color(0xFF000000) : const Color(0XFF818181).withOpacity(0.5),
                  dark: enabled ? const Color(0xFFFFFFFF) : const Color(0XFF868990).withOpacity(0.5),
                  midnight: enabled ? const Color(0xFFFFFFFF) : const Color(0XFF7F7E83).withOpacity(0.5)
                ),
                fontSize: 16,
                fontFamily: 'GGSansSemibold'
              ),
            ),
          ],
        ),
      ),
    );
  }
}