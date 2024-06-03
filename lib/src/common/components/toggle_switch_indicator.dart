import 'package:discord/src/common/controllers/theme_controller.dart';
import 'package:discord/src/common/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ToggleSwitchIndicator extends ConsumerWidget {
  final bool toggled;
  const ToggleSwitchIndicator({required this.toggled, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.read(themeController);
    final Color color1 = appTheme<Color>(theme, light: const Color(0XFFC4C9CF), dark: const Color(0XFF4C4F58), midnight: const Color(0XFF4C4F58));
    
    return Container(
      width: 45,
      height: 30,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: toggled ? const Color(0XFF485CCF) : color1,
        borderRadius: BorderRadius.circular(25),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: toggled ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              toggled ? Icons.check : Icons.close,
              color: toggled ? const Color(0XFF485CCF) : color1,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}