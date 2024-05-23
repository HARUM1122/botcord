import 'package:flutter/material.dart';

import 'badges.dart';


class CommunityBadge extends StatelessWidget {
  final double size;
  const CommunityBadge({required this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: StarburstPainter(
        color: const Color(0xFFFFFFFF)
      ),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        child: Icon(
          Icons.home,
          size: size * 0.7,
          color: const Color(0xFF000000),
        ),
      ),
    );
  }
}