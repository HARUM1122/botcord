import 'package:discord/src/common/components/custom_button.dart';
import 'package:flutter/material.dart';

class InfoTile extends StatelessWidget {
  final bool offstage;
  final Color backgroundColor;
  final Color onPressedColor;
  final BorderRadius? borderRadius;
  final Function() onPressed;
  final Widget child;

  const InfoTile({
    required this.offstage,
    required this.backgroundColor,
    required this.onPressedColor,
    this.borderRadius,
    required this.onPressed,
    required this.child,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: offstage,
      child: CustomButton(
        width: double.infinity,
        backgroundColor: backgroundColor,
        onPressedColor: onPressedColor,
        applyClickAnimation: false,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.zero
        ),
        onPressed: onPressed,
        child: child
      ),
    );
  }
}