import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/theme_provider.dart';

import '../../../utils/utils.dart';

class DoNotDisturbStatus extends ConsumerWidget {
  final double radius;
  const DoNotDisturbStatus({required this.radius, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: radius,
      height: radius,
      padding: EdgeInsets.all(radius * 0.25),
      decoration: const BoxDecoration(
        color: Color(0xFFE94249),
        shape: BoxShape.circle
      ),
      child: CircleAvatar(
        backgroundColor: appTheme<Color>(ref.read(themeProvider), light: const Color(0xFFFFFFFF), dark: const Color(0xFF000000), midnight: const Color(0xFF000000))
      )
    );
  }
}