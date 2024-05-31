import 'package:discord/src/common/components/custom_button.dart';
import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  final Color backgroundColor;
  final Color onPressedColor;
  final BorderRadius? borderRadius;
  final Function() onPressed;
  final Widget child;

  const SettingsButton({
    required this.backgroundColor,
    required this.onPressedColor,
    this.borderRadius,
    required this.onPressed,
    required this.child,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      onPressedColor: onPressedColor,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.zero
      ),
      applyClickAnimation: false,
      child: child,
    );
  }
}