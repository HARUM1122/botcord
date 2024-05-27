import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/common/utils/extensions.dart';
import 'package:discord/src/common/components/custom_button.dart';
import 'package:discord/src/common/providers/theme_provider.dart';

class OptionButton extends ConsumerWidget {
  final String title;
  final Function() onPressed;
  const OptionButton({
    required this.title,
    required this.onPressed,
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.read(themeProvider);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: CustomButton(
          height: 40,
          backgroundColor: appTheme<Color>(theme, light: const Color(0XFFDFE1E3), dark: const Color(0XFF373A42), midnight: const Color(0XFF2C2D36)),
          onPressedColor: appTheme<Color>(theme, light: const Color(0XFFC4C6C8), dark: const Color(0XFF4D505A), midnight: const Color(0XFF373A42)), 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.getSize.width * 0.5)
          ),
          applyClickAnimation: true,
          animationUpperBound: 0.06,
          onPressed: onPressed,
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
                fontSize: 14,
                fontFamily: 'GGSansSemibold'
              ),
            ),
          ),
        ),
      ),
    );
  }
}