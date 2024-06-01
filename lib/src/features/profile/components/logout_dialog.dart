import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/src/common/controllers/theme_controller.dart';

import '../../../common/utils/utils.dart';
import '../../../common/utils/extensions.dart';
import '../../../common/components/custom_button.dart';

import '../../../features/auth/controller/auth_controller.dart';

class LogoutDialog extends ConsumerWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.read(themeController);
    final AuthController authController = ref.read(authControllerProvider);

    final Color color1 = appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));

    return Container(
      height: context.getSize.height * 0.35,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: appTheme<Color>(theme, light: const Color(0xFFFFFFFF), dark: const Color(0XFF1C1D23), midnight: const Color(0xFF000000)),
        borderRadius: BorderRadius.circular(12)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Logout',
            style: TextStyle(
              color: color1,
              fontSize: 16,
              fontFamily: 'GGSansBold'
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              color: color1,
              fontSize: 16
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: CustomButton(
              width: double.infinity,
              height: 45,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(45 * 0.5)
              ),
              backgroundColor: const Color(0XFFE8413A),
              onPressedColor: const Color(0XFFC73E33),
              applyClickAnimation: true,
              animationUpperBound: 0.04,
              child: const Center(
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontFamily: 'GGSansSemibold'
                  ),
                ),
              ),
              onPressed: () => authController.logout(context)
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: CustomButton(
              width: double.infinity,
              height: 45,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(45 * 0.5)
              ),
              backgroundColor: appTheme<Color>(theme, light: const Color(0XFFDFE1E3), dark: const Color(0XFF373A42), midnight: const Color(0XFF2C2D36)),
              onPressedColor: appTheme<Color>(theme, light: const Color(0XFFC4C6C8), dark: const Color(0XFF4D505A), midnight: const Color(0XFF373A42)),
              applyClickAnimation: true,
              animationUpperBound: 0.04,
              onPressed: () => Navigator.pop(context),
              child: Center(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: appTheme<Color>(theme, light: const Color(0xFF31343D), dark: const Color(0xFFC5C8CF), midnight: const Color(0xFFC5C8CF)),
                    fontFamily: 'GGSansSemibold'
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}