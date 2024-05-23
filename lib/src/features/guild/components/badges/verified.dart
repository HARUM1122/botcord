import 'package:flutter/material.dart';

import 'badges.dart';


class VerifiedBadge extends StatelessWidget {
  final double size;
  const VerifiedBadge({required this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: StarburstPainter(
        color: const Color(0xFF26A558)
      ),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        child: Icon(
          Icons.check,
          size: size * 0.7,
          color: const Color(0xFFFFFFFF),
        ),
      ),
    );
  }
}