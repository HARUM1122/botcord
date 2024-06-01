import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/common/controllers/theme_controller.dart';

class RadioButtonIndicator extends ConsumerWidget {
  final double radius;
  final bool selected;
  const RadioButtonIndicator({required this.radius, required this.selected,super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.read(themeController);
    return Container(
      width: radius,
      height: radius,
      padding: selected 
      ? EdgeInsets.all(radius * 0.25) 
      : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: selected ? const Color(0XFF485CCF) : Colors.transparent,
        border: !selected ? Border.all(
          color: appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
          width: 2
        ) : null,
        shape: BoxShape.circle
      ),
      child: selected ? const CircleAvatar(
        backgroundColor: Color(0xFFFFFFFF),
      ) : null, 

    );
  }
}