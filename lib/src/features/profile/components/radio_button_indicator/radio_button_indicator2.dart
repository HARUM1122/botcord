import 'package:flutter/material.dart';

import 'package:discord/src/common/utils/cache.dart';

class RadioButtonIndicator2 extends StatelessWidget {
  final double radius;
  final bool selected;
  const RadioButtonIndicator2({required this.radius, required this.selected,super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      padding: selected 
      ? EdgeInsets.all(radius * 0.15) 
      : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: theme[selected ? 'color-01' : 'color-03'],
          width: 2
        ),
        shape: BoxShape.circle
      ),
      child: selected ? CircleAvatar(
        backgroundColor: theme['color-13'],
      ) : null, 

    );
  }
}