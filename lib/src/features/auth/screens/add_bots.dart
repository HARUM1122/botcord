import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' show ClientException;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/auth_controller.dart';

import '../../../common/utils/utils.dart';
import '../../../common/utils/cache.dart';
import '../../../common/utils/extensions.dart';
import '../../../common/components/custom_button.dart';

class AddBotsScreen extends ConsumerStatefulWidget {
  const AddBotsScreen({super.key});

  @override
  ConsumerState<AddBotsScreen> createState() => _AddBotsScreenState();
}

class _AddBotsScreenState extends ConsumerState<AddBotsScreen> {
  final TextEditingController controller = TextEditingController();
  bool running = false;

  void addToken() async {
    if (running) return;
    setState(() => running = true);
    try {
      int value = await ref.read(authControllerProvider).addToken(controller.text.trim());
      if (context.mounted) {
        switch (value) {
          case 200:
            showSnackBar(
              context: context,
              leading: const Icon(
                Icons.done,
                color: Colors.tealAccent,
              ), 
              msg: 'Successfully added the bot', 
            );
          case 429:
            showSnackBar(
              context: context,
              leading: Icon(
                Icons.error_outline,
                color: Colors.red[800],
              ), 
              msg: 'You are being rate limited', 
            );
          case 401:
            showSnackBar(
              context: context,
              leading: Icon(
                Icons.error_outline,
                color: Colors.red[800],
              ), 
              msg: 'Invalid token', 
            );
          case -1:
            showSnackBar(
              context: context,
              leading: Icon(
                Icons.error_outline,
                color: Colors.red[800],
              ), 
              msg: 'Bot already added', 
            );
          default:
            showSnackBar(
              context: context,
              leading: Icon(
                Icons.error_outline,
                color: Colors.red[800],
              ), 
              msg: 'Unexpected error. Please retry'
            );
        }
      }
    } on ClientException {
      if (context.mounted) {
        showSnackBar(
          context: context,
          leading: Icon(
            Icons.error_outline,
            color: Colors.red[800],
          ), 
          msg: 'Network error. Please retry'
        );
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(
          context: context,
          leading: Icon(
            Icons.error_outline,
            color: Colors.red[800],
          ), 
          msg: 'Unexpected error. Please retry'
        );
      }
    }
    controller.text = '';
    setState(() => running = false);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          splashRadius: 18,
          icon: Icon(
            Icons.arrow_back,
            color: theme['color-05'],
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: theme['color-11'],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
          child: Column(
              children: [
                SizedBox(
                  height: context.getSize.height * 0.12
                ),
                Text(
                  'Add by Token',
                  style: TextStyle(
                    color: theme['color-01'],
                    fontFamily: 'GGSansBold',
                    fontSize: 26
                  )
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: TextField(
                    controller: controller,
                    style: TextStyle(
                      color: theme['color-02'],
                      fontSize: 14
                    ),
                    cursorColor: theme['color-02'],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none
                      ),
                      contentPadding: const EdgeInsets.all(16),
                      hintText: "Bot's token",
                      hintStyle: TextStyle(
                        color: theme['color-03'],
                        fontSize: 16
                      ),
                      filled: true,
                      fillColor: theme['color-12'],
                    )
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have a bot account? Click ",
                      style: TextStyle(
                        color: theme['color-03'],
                        fontSize: 12
                      ),
                      children: [
                        TextSpan(
                          text: 'here',
                          style: TextStyle(
                            color: theme['color-01'],
                            fontSize: 12,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () => Navigator.pushNamed(
                            context, 
                            '/create-bot-account-route'
                          )
                        ),
                      ]
                    ),
                  )
                ),
                const Spacer(),
                CustomButton(
                  onPressed: addToken,
                  backgroundColor: theme['color-14'],
                  onPressedColor: theme['color-15'],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.getSize.width * 0.5)
                  ),
                  animationUpperBound: 0.04,
                  applyClickAnimation: true,
                  width: double.infinity,
                  height: 50,
                  child: Center(
                    child: running
                    ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: theme['color-01'],
                        strokeWidth: 2,
                      ),
                    )
                    : Text(
                      'Add Bot',
                      style: TextStyle(
                        fontSize: 16,
                        color: theme['color-01'],
                        fontFamily: 'GGsansSemibold'
                      )
                    )
                  )
                )
              ]
            ),
        ),
      ),
    );
  }
}