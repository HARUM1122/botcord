import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../util/constants.dart';

import 'package:discord/src/common/providers/theme_provider.dart';

import '../../../common/utils/globals.dart';
import '../../../common/utils/utils.dart';
import '../../../common/utils/extensions.dart';
import '../../../common/components/custom_button.dart';


class LandingScreen extends ConsumerWidget {
  const LandingScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.watch(themeProvider);
    return Scaffold(
      backgroundColor: appTheme(theme, light: const Color(0xFFFFFFFF), dark: const Color(0xFF1A1D24), midnight: const Color(0xFF000000)),
      appBar: AppBar(
        title: Text(
          "Welcome to Botcord",
          style: TextStyle(
            color: appTheme(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
            fontFamily: 'GGsansBold',
            fontSize: 24
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: StretchingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (notification) {
                    notification.disallowIndicator();
                    return true;
                  },
                  child: Markdown(
                    data: warningMessage,
                    styleSheet: MarkdownStyleSheet(
                      h2: TextStyle(
                        color: appTheme(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
                        fontFamily: 'GGSansBold',
                        fontSize: 18
                      ),
                      strong: TextStyle(
                        color: appTheme(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
                        fontFamily: 'GGSansBold',
                        fontSize: 16
                      ),
                      p: TextStyle(
                        color: appTheme(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
                        fontSize: 16
                      )
                    ),
                  ),
                ),
              )
            ),
            const SizedBox(height: 10),
            CustomButton(
              onPressed: () {
                prefs.setBool('is-landed', true);
                Navigator.pushReplacementNamed(context, '/bots-route');
              },
              width: context.getSize.width * 0.90,
              height: 50,
              backgroundColor: const Color(0xFF5964F4),
              onPressedColor: const Color(0XFF485CCF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.getSize.width / 2)
              ),
              applyClickAnimation: true,
              animationUpperBound: 0.08,
              child: const Center(
                child: Text(
                  "Agree And Continue",
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontFamily: 'GGsansSemibold',
                    fontSize: 16
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}