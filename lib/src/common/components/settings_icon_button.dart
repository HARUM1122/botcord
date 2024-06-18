import 'package:flutter/material.dart';

class SettingsIconButton extends StatelessWidget {
  final Function() onPressed;
  final double size;
  final Color backgroundColor;
  final Color iconColor;
  const SettingsIconButton({
    required this.onPressed,
    required this.size,
    required this.backgroundColor,
    required this.iconColor,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle
        ),
        child: Center(
          child: Icon(
            Icons.settings,
            color: iconColor,
            size: size * 0.7,
          ),
        ),
      ),
    );
  }
}