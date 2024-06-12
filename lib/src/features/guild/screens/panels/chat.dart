import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/src/common/controllers/theme_controller.dart';
import 'package:discord/src/common/utils/utils.dart';

import '../guild.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("HELLO WORLD");
    final String theme = ref.read(themeController);
    final Color color1 = appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
    return Scaffold(
      backgroundColor: appTheme<Color>(theme, light: const Color(0XFFFFFFFF), dark: const Color(0XFF1C1D23), midnight: const Color(0xFF000000)),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => GuildsScreen.of(context)?.revealLeft(),
          splashRadius: 18,
          icon: Icon(
            Icons.arrow_back,
            color: appTheme<Color>(theme, light: const Color(0XFF565960), dark: const Color(0XFF878A93), midnight: const Color(0XFF838594))
          )
        ),
        title: Text(
          "# COMMANDS",
          style: TextStyle(
            color: color1,
            fontFamily: 'GGSansBold',
            fontSize: 18
          ),
        ),
        centerTitle: false,
      ),
    );
  }
}