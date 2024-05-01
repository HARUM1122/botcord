import 'package:flutter/material.dart';

class DragHandle extends StatelessWidget {
  final Color color;
  const DragHandle({required this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 4,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10)
      ),
    );
  }
}