import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/src/common/providers/theme_provider.dart';
import 'package:discord/src/common/utils/utils.dart';

class RadioButtonIndicator2 extends ConsumerWidget {
  final double radius;
  final bool selected;
  const RadioButtonIndicator2({required this.radius, required this.selected,super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.read(themeProvider);
    return Container(
      width: radius,
      height: radius,
      padding: selected 
      ? EdgeInsets.all(radius * 0.15) 
      : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: appTheme<Color>(
            theme, 
            light: selected ? const Color(0xFF373A43) : const Color(0XFF50515A),
            dark: selected ? const Color(0XFFFFFFFF) : const Color(0xFF91949D), 
            midnight: selected ? const Color(0XFFFFFFFF) : const Color(0XFF838591)
          ),
          width: 2
        ),
        shape: BoxShape.circle
      ),
      child: selected ? const CircleAvatar(
        backgroundColor: Color(0xFF969BF6),
      ) : null, 

    );
  }
}