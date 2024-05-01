import 'package:flutter/material.dart';

import 'package:discord/src/common/utils/cache.dart';

class RadioButtonIndicator extends StatelessWidget {
  final double radius;
  final bool selected;
  const RadioButtonIndicator({required this.radius, required this.selected,super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      padding: selected 
      ? EdgeInsets.all(radius * 0.25) 
      : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: selected ? theme['color-15'] : Colors.transparent,
        border: !selected ? Border.all(
          color: theme['color-02'],
          width: 2
        ) : null,
        shape: BoxShape.circle
      ),
      child: selected ? const CircleAvatar(
        backgroundColor: Colors.white,
      ) : null, 

    );
  }
}