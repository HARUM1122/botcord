import 'package:discord/src/common/controllers/theme_controller.dart';
import 'package:discord/src/common/utils/utils.dart';
import 'package:flutter/material.dart';


import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nyxx/nyxx.dart';

class AuditLogTile extends ConsumerStatefulWidget {
  // final (String, String, AuditLogEvent, Future<(User, String, List<String>)> Function(AuditLogEntry)) auditLogInfo;
  const AuditLogTile({super.key});

  @override
  ConsumerState<AuditLogTile> createState() => _AuditLogTileState();
}

class _AuditLogTileState extends ConsumerState<AuditLogTile> {
  late final String _theme = ref.read(themeController);

  late final Color _color1 = appTheme<Color>(_theme, light: const Color(0XFFFFFFFF), dark: const Color(0XFF1F2229), midnight: const Color(0XFF0D0C11));
  // late final Color _color2 = appTheme<Color>(_theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFFA8AAB0));

  final bool _showAdditionalInfo = false;

  Future<int> example() async {
    await Future.delayed(const Duration(seconds: 2));
    return 0;
  }
  @override
  Widget build(BuildContext context) {
    
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: appTheme<Color>(_theme, light: const Color(0XFFFFFFFF), dark: const Color(0XFF1F2229), midnight: const Color(0XFF0D0C11)),
      ),
      child: 
    );
  }
}