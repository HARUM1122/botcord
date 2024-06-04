import 'package:flutter/material.dart';

import 'package:discord/src/common/controllers/theme_controller.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/utils.dart';


class CheckBoxIndicator extends ConsumerWidget {
  final bool selected;
  final bool circular;
  const CheckBoxIndicator({
    required this.selected,
    required this.circular,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.read(themeController);
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF5964F4) : Colors.transparent,
        borderRadius: BorderRadius.circular(circular ? 10 : 4),
        border: !selected 
        ? Border.all(
          color: appTheme<Color>(theme, light: const Color(0xFF31343D), dark: const Color(0xFFC5C8CF), midnight: const Color(0xFFC5C8CF)),
          width: 2
        )
        : null
      ),
      child: selected ? Center(
        child: Icon(
          Icons.check,
          color: const Color(0xFFFFFFFF),
          size: circular ? 14 : 20,
        ),
      ) : null
    );
  }
}