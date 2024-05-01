import 'package:flutter/material.dart';

import '../../../utils/cache.dart';

class InvisibleStatus extends StatelessWidget {
  final double radius;
  const InvisibleStatus({required this.radius, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      padding: EdgeInsets.all(radius * 0.25),
      decoration: const BoxDecoration(
        color: Color(0xFF9597A4),
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        backgroundColor: theme['color-11'],
      )
    );
  }
}