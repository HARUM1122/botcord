import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/theme_provider.dart';

import '../../../common/components/custom_button.dart';
import '../components/radio_button_indicator/radio_button_indicator.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
    final String theme = ref.watch(themeProvider);
    final AuthController authController = ref.read(authControllerProvider);
    final Color color1 = appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
    final Color color2 = appTheme<Color>(theme, light: const Color(0XFF4C4F57), dark: const Color(0XFFC8C9D1), midnight: const Color(0xFFFFFFFF));
    final Color color3 = appTheme<Color>(theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFFA8AAB0));
    final Color color4 = appTheme<Color>(theme, light: const Color(0XFFEBEBEB), dark: const Color(0XFF2C2D36), midnight: const Color(0XFF1C1B21));

    return Scaffold(
      backgroundColor: appTheme<Color>(theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0xFF000000)),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          splashRadius: 18,
          icon: Icon(
            Icons.arrow_back,
            color: appTheme<Color>(theme, light: const Color(0XFF565960), dark: const Color(0XFF878A93), midnight: const Color(0XFF838594))
          )
        ),
        title: Text(
          "Settings",
          style: TextStyle(
            color: color1,
            fontFamily: 'GGSansBold',
            fontSize: 18
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text(
                "App Theme",
                style: TextStyle(
                  color: color3,
                  fontSize: 14,
                  fontFamily: 'GGSansSemibold'
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: appTheme<Color>(theme, light: const Color(0xFFFFFFFF), dark: const Color(0xFF25282F), midnight: const Color(0XFF141318)),
                  borderRadius: BorderRadius.circular(16)
                ),
                child: Column(
                  children: [
                    OptionTile(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16)
                      ),
                      backgroundColor: Colors.transparent,
                      onPressedColor: appTheme<Color>(theme, light: const Color(0XFFE1E1E1), dark: const Color(0XFF2F323A), midnight: const Color(0XFF202226)),
                      onPressed: () => ref.read(
                        themeProvider.notifier
                      ).setTheme('light', true, false),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          Icon(
                            Icons.light_mode,
                            color: color2,
                          ),
                          const SizedBox(width: 18),
                          Text(
                            'Light',
                            style: TextStyle(
                              color: color1,
                              fontSize: 16,
                              fontFamily: 'GGSansSemibold'
                            ),
                          ),
                          const Spacer(),
                          RadioButtonIndicator(
                            radius: 20, 
                            selected: theme == 'light'
                          ),
                          const SizedBox(width: 10)
                        ],
                      )
                    ),
                    Divider(
                      color: color4,
                      thickness: 0.2,
                      height: 0,
                      indent: 50,
                    ),
                    OptionTile(
                      borderRadius: BorderRadius.zero,
                      backgroundColor: Colors.transparent,
                      onPressedColor: appTheme<Color>(theme, light: const Color(0XFFE1E1E1), dark: const Color(0XFF2F323A), midnight: const Color(0XFF202226)),
                      onPressed: () => ref.read(
                        themeProvider.notifier
                      ).setTheme('dark', true, false),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          Icon(
                            Icons.light_mode,
                            color: color2,
                          ),
                          const SizedBox(width: 18),
                          Text(
                            'Dark',
                            style: TextStyle(
                              color: color1,
                              fontSize: 16,
                              fontFamily: 'GGSansSemibold'
                            ),
                          ),
                          const Spacer(),
                          RadioButtonIndicator(
                            radius: 20, 
                            selected: theme == 'dark'
                          ),
                          const SizedBox(width: 10)
                        ],
                      )
                    ),
                    Divider(
                      color: color4,
                      thickness: 0.2,
                      height: 0,
                      indent: 50,
                    ),
                    OptionTile(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(16)
                      ),
                      backgroundColor: Colors.transparent,
                      onPressedColor: appTheme<Color>(theme, light: const Color(0XFFE1E1E1), dark: const Color(0XFF2F323A), midnight: const Color(0XFF202226)),
                      onPressed: () => ref.read(
                        themeProvider.notifier
                      ).setTheme('midnight', true, false),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          Icon(
                            Icons.light_mode,
                            color: color2,
                          ),
                          const SizedBox(width: 18),
                          Text(
                            'Midnight',
                            style: TextStyle(
                              color: color1,
                              fontSize: 16,
                              fontFamily: 'GGSansSemibold'
                            ),
                          ),
                          const Spacer(),
                          RadioButtonIndicator(
                            radius: 20, 
                            selected: theme == 'midnight'
                          ),
                          const SizedBox(width: 10)
                        ],
                      )
                    ),
                  ],
                )
              ),
              const SizedBox(height: 30),
              OptionTile(
                borderRadius: BorderRadius.circular(16),
                backgroundColor: appTheme<Color>(theme, light: const Color(0xFFFFFFFF), dark: const Color(0xFF25282F), midnight: const Color(0XFF141318)),
                onPressedColor: appTheme<Color>(theme, light: const Color(0XFFE1E1E1), dark: const Color(0XFF2F323A), midnight: const Color(0XFF202226)),
                onPressed: () => authController.logout(context),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Icon(
                      Icons.logout,
                      color: color2,
                    ),
                    const SizedBox(width: 18),
                    const Text(
                      'Log Out',
                      style: TextStyle(
                        color: Color(0XFFFF5340),
                        fontSize: 16,
                        fontFamily: 'GGSansSemibold'
                      ),
                    ),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OptionTile extends StatelessWidget {
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final Color onPressedColor;
  final Function() onPressed;
  final Widget child;

  const OptionTile({
    required this.borderRadius,
    required this.backgroundColor,
    required this.onPressedColor,
    required this.onPressed,
    required this.child,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      height: 60,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      onPressedColor: onPressedColor,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius
      ),
      applyClickAnimation: false,
      child: child,
    );
  }
}