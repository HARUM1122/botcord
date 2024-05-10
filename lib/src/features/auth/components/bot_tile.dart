import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/theme_provider.dart';

import 'bot_options_sheet.dart';

import '../../../common/utils/utils.dart';
import '../../../common/components/custom_button.dart';
import '../../../common/components/avatar/profile_pic.dart';

class BotTile extends ConsumerWidget {
  final String title;
  final dynamic bots;
  const BotTile({
    required this.title,
    required this.bots,
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.read(themeProvider);
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: appTheme<Color>(theme, light: const Color(0XFF4C4F54), dark: const Color(0XFFC8CBD2), midnight: const Color(0XFFC5C4C9)),
              fontSize: 16,
              fontFamily: 'GGSansSemibold'
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: appTheme<Color>(theme, light: const Color(0xFFFFFFFF), dark: const Color(0XFF25282F), midnight: const Color(0XFF151419)),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              for (int index = 0; index < bots.length; index++) ...[
                  BotInfo(
                    bot: bots[index],
                    isFirst: index == 0,
                    isLast: index == bots.length - 1,
                    theme: theme,
                  ),
                  Offstage(
                    offstage: bots.length == 1 || index == bots.length - 1,
                    child: Divider(
                      thickness: 0.4,
                      indent: 50,
                      height: 0,
                      color: appTheme<Color>(theme, light: const Color(0xFFC5C8CF), dark: const Color(0xFF4C4F58), midnight: const Color(0xFF4C4F58)),
                    ),
                  )
                ]
              ],
            )
          ) 
        ],
      ),
    );
  }
}

class BotInfo extends StatelessWidget {
  final Map<String, dynamic> bot;
  final bool isFirst;
  final bool isLast;
  final String theme;
  const BotInfo({
    required this.bot,
    required this.isFirst,
    required this.isLast,
    required this.theme,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: () {
        showSheet(
          context: context, 
          builder: (context, controller, offset) => BotOptionsSheet(
            controller: controller, 
            bot: bot
          ),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(16)
          ),
          height: 0.5, 
          maxHeight: 0.8,
          color: appTheme<Color>(theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0xFF000000)),
        );
      },
      backgroundColor: Colors.transparent,
      onPressedColor: appTheme<Color>(theme, light: const Color(0XFFE0E0E0), dark: const Color(0XFF32353E), midnight: const Color(0XFF232227)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(14) : Radius.zero,
          bottom: isLast ? const Radius.circular(14) : Radius.zero,
        )
      ),
      applyClickAnimation: false,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfilePicWidget(
              image: bot['avatar-url']!, 
              radius: 30, 
              backgroundColor: Colors.transparent,
              padding: const EdgeInsets.all(2),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                bot['name']!,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
                  fontSize: 16,
                  fontFamily: 'GGSansSemibold'
                ),
              ),
            ),
            Icon(
              Icons.more_vert,
              color: appTheme<Color>(theme, light: const Color(0XFF4C4F54), dark: const Color(0XFFC8CBD2), midnight: const Color(0XFFC5C4C9))
            ),
          ],
        ),
      ),
    );
  }
}