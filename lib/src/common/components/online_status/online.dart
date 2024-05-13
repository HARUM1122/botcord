import 'package:flutter/material.dart';

class OnlineStatus extends StatelessWidget {
  final double radius;
  const OnlineStatus({required this.radius, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      decoration: const BoxDecoration(
        color: Color(0xFF26A558),
        shape: BoxShape.circle
      ),
    );
  }
}