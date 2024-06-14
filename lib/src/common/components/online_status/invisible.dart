import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/src/common/controllers/theme_controller.dart';

import '../../utils/utils.dart';


class InvisibleStatus extends ConsumerWidget {
  final double radius;
  final Color? borderColor;
  const InvisibleStatus({required this.radius, required this.borderColor, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: radius,
      height: radius,
      padding: EdgeInsets.all(radius * 0.25),
      decoration: BoxDecoration(
        color: const Color(0xFF9597A4),
        shape: BoxShape.circle,
        border: borderColor != null
        ? Border.all(
          width: 4,
          color: borderColor!,
          strokeAlign: BorderSide.strokeAlignOutside
        )
        : null
      ),
      child: CircleAvatar(
        backgroundColor: appTheme<Color>(ref.read(themeController), light: const Color(0xFFFFFFFF), dark: const Color(0xFF000000), midnight: const Color(0xFF000000)),
      )
    );
  }
}