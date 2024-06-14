import 'package:flutter/material.dart';

class OnlineStatus extends StatelessWidget {
  final double radius;
  final Color? borderColor;
  const OnlineStatus({required this.radius, required this.borderColor, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        color: const Color(0xFF26A558),
        shape: BoxShape.circle,
        border: borderColor != null
        ? Border.all(
          width: 4,
          color: borderColor!,
          strokeAlign: BorderSide.strokeAlignOutside
        )
        : null
      ),
    );
  }
}