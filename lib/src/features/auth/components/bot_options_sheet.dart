import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'login_dialog.dart';

import '../../../common/utils/utils.dart';
import '../../../common/utils/cache.dart';
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
    List<Widget> children = [
      Align(
        alignment: Alignment.topCenter,
        child: DragHandle(
          color: theme['color-06'],
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
              color: theme['color-01'],
              fontFamily: 'GGSansSemibold'
            ),
          ),
          SizedBox.fromSize(
            size: const Size(30, 30),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.close,
                color: theme['color-01'],
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
          color: theme['color-10'],
          borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          children: [
            BotOption(
              title: 'Login', 
              titleColor: theme['color-01'], 
              onPressed: () {
                showDialogBox(
                  context: context,
                  child: LoginDialog(bot: bot)
                );
              }, 
              currPos: 'top'
            ),
            Divider(
              thickness: 0.2,
              height: 0,
              indent: 50,
              color: theme['color-04'],
            ),
            BotOption(
              title: 'Copy Bot Name', 
              titleColor: theme['color-01'], 
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: "${bot['name']}#${bot['discriminator']}"));
                if (!context.mounted) return;
                showSnackBar(
                  context: context, 
                  leading: Icon(
                    Icons.copy,
                    color: theme['color-01'],
                  ),
                  msg: "Copied Bot Name"
                );
              }, 
              currPos: ''
            ),
            Divider(
              thickness: 0.2,
              height: 0,
              indent: 50,
              color: theme['color-04'],
            ),
            BotOption(
              title: 'Copy Bot ID', 
              titleColor: theme['color-01'], 
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: bot['id']));
                if (!context.mounted) return;
                showSnackBar(
                  context: context, 
                  leading: Icon(
                    Icons.copy,
                    color: theme['color-01'],
                  ),
                  msg: "Copied Bot ID"
                );
              }, 
              currPos: ''
            ),
            Divider(
              thickness: 0.2,
              height: 0,
              indent: 50,
              color: theme['color-04'],
            ),
            BotOption(
              title: 'Copy Bot Token', 
              titleColor: theme['color-01'], 
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: bot['token']));
                if (!context.mounted) return;
                showSnackBar(
                  context: context, 
                  leading: Icon(
                    Icons.copy,
                    color: theme['color-01'],
                  ),
                  msg: 'Copied token'
                );
              }, 
              currPos: ''
            ),
            Divider(
              thickness: 0.2,
              height: 0,
              indent: 50,
              color: theme['color-04'],
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
              currPos: 'bottom'
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
  const BotOption({
    required this.title,
    required this.titleColor,
    required this.onPressed,
    required this.currPos,
    super.key
  });
  @override
  Widget build(BuildContext context) {
    return CustomButton(
      backgroundColor: Colors.transparent,
      onPressedColor: theme['color-12'],
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