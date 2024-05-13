import 'package:flutter/material.dart';

class IdleStatus extends StatelessWidget {
  final double radius;
  const IdleStatus({required this.radius, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      decoration: const BoxDecoration(
        color: Color(0xFFEFB232),
        shape: BoxShape.circle
      ),
    );
  }
}