import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/theme_provider.dart';

import 'login_dialog.dart';
import '../../../common/utils/utils.dart';
import '../../../common/utils/extensions.dart';
import '../../../common/components/drag_handle.dart';
import '../../../common/components/custom_button.dart';
import '../../../common/components/avatar/profile_pic.dart';

import '../../../features/auth/controller/auth_controller.dart';

class BotOptionsSheet extends ConsumerWidget {
  final ScrollController controller;
  final Map<String, dynamic> bot;
  const BotOptionsSheet({required this.controller, required this.bot, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.read(themeProvider);
    final Color color = appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
    final Color dividerColor = appTheme<Color>(theme, light: const Color(0xFFC5C8CF), dark: const Color(0xFF4C4F58), midnight: const Color(0xFF4C4F58));
    List<Widget> children = [
      Align(
        alignment: Alignment.topCenter,
        child: DragHandle(
          color: appTheme<Color>(theme, light: const Color(0XFFD8DADD), dark: const Color(0XFF2F3039), midnight: const Color(0XFF151518))
        )
      ),
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ProfilePicWidget(
            image: bot['avatar-url']!, 
            radius: 30, 
            backgroundColor: Colors.transparent
          ),
          Text(
            bot['name']!,
            style: TextStyle(
              fontSize: 18,
              color: color,
              fontFamily: 'GGSansSemibold'
            ),
          ),
        //   IconButton(
        //   onPressed: () => Navigator.pop(context),
        //   splashRadius: 18,
        //   icon: Icon(
        //     Icons.arrow_back,
        //     color: appTheme(_theme, light: const Color(0XFF565960), dark: const Color(0XFF878A93), midnight: const Color(0XFF838594)),
        //   ),
        // ),
          SizedBox.fromSize(
            size: const Size(30, 30),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.close,
                color: appTheme<Color>(theme, light: const Color(0XFF4C4F54), dark: const Color(0XFFC8CBD2), midnight: const Color(0XFFC5C4C9)),
              ),
              onPressed: () => Navigator.pop(context)
            ),
          )
        ],
      ),
      const SizedBox(height: 20),
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: appTheme<Color>(theme, light: const Color(0xFFFFFFFF), dark: const Color(0XFF25282F), midnight: const Color(0XFF151419)),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          children: [
            BotOption(
              title: 'Login', 
              titleColor: color, 
              onPressed: () {
                showDialogBox(
                  context: context,
                  child: LoginDialog(bot: bot)
                );
              }, 
              currPos: 'top',
              theme: theme
            ),
            Divider(
              thickness: 0.2,
              height: 0,
              indent: 50,
              color:  dividerColor,
            ),
            BotOption(
              title: 'Copy Bot Name', 
              titleColor: color, 
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: "${bot['name']}#${bot['discriminator']}"));
                if (!context.mounted) return;
                showSnackBar(
                  context: context,
                  theme: theme,
                  leading: Icon(
                    Icons.copy,
                    color: appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
                  ),
                  msg: "Copied Bot Name"
                );
              }, 
              currPos: '',
              theme: theme
            ),
            Divider(
              thickness: 0.2,
              height: 0,
              indent: 50,
              color:  dividerColor,
            ),
            BotOption(
              title: 'Copy Bot ID', 
              titleColor: color, 
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: bot['id']));
                if (!context.mounted) return;
                showSnackBar(
                  context: context, 
                  theme: theme,
                  leading: Icon(
                    Icons.copy,
                    color: appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
                  ),
                  msg: "Copied Bot ID"
                );
              }, 
              currPos: '',
              theme: theme
            ),
            Divider(
              thickness: 0.2,
              height: 0,
              indent: 50,
              color:  dividerColor,
            ),
            BotOption(
              title: 'Copy Bot Token', 
              titleColor: color, 
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: bot['token']));
                if (!context.mounted) return;
                showSnackBar(
                  context: context,
                  theme: theme,
                  leading: Icon(
                    Icons.copy,
                    color: appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
                  ),
                  msg: 'Copied token'
                );
              }, 
              currPos: '',
              theme: theme
            ),
            Divider(
              thickness: 0.2,
              height: 0,
              indent: 50,
              color:  dividerColor,
            ),
            BotOption(
              title: 'Remove Bot', 
              titleColor: Colors.red, 
              onPressed: () async {
                await ref.read(authControllerProvider).removeBot(
                  bot['name']![0].toUpperCase(), 
                  bot['id']!
                );
                if (!context.mounted) return;
                Navigator.pop(context);  
              },
              currPos: 'bottom',
              theme: theme
            ),
          ],
        ),
      ),
    ];
    return ListView.builder(
      controller: controller,
      padding: EdgeInsets.only(
        left: 12, 
        right: 12, 
        top: 8, 
        bottom: context.padding.bottom + 10
      ),
      itemCount: children.length,
      itemBuilder: (context, idx) => children[idx]
    );
  }
}

class BotOption extends StatelessWidget {
  final String title;
  final Color titleColor;
  final Function() onPressed;
  final String currPos;
  final String theme;
  const BotOption({
    required this.title,
    required this.titleColor,
    required this.onPressed,
    required this.currPos,
    required this.theme,
    super.key
  });
  @override
  Widget build(BuildContext context) {
    return CustomButton(
      backgroundColor: Colors.transparent,
      onPressedColor: appTheme<Color>(theme, light: const Color(0XFFE0E0E0), dark: const Color(0XFF32353E), midnight: const Color(0XFF232227)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: currPos == "top" ? const Radius.circular(20) : Radius.zero,
          bottom: currPos == "bottom" ? const Radius.circular(20) : Radius.zero,
        ),
      ),
      onPressed: onPressed,
      applyClickAnimation: false, 
      child: Container(
        margin: const EdgeInsets.all(20),
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontSize: 16,
            fontFamily: 'GGSansSemibold'
          ),
        ),
      )
    );
  }
}