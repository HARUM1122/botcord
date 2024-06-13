import 'package:discord/src/features/auth/screens/screens.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' show ClientException;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/src/common/controllers/theme_controller.dart';

import '../controller/auth_controller.dart';

import '../../../common/utils/utils.dart';
import '../../../common/utils/extensions.dart';
import '../../../common/components/custom_button.dart';

class AddBotsScreen extends ConsumerStatefulWidget {
  const AddBotsScreen({super.key});

  @override
  ConsumerState<AddBotsScreen> createState() => _AddBotsScreenState();
}

class _AddBotsScreenState extends ConsumerState<AddBotsScreen> {
  final TextEditingController _controller = TextEditingController();
  late final String _theme = ref.read(themeController);
  bool _running = false;

  String _text = '';

  void addToken() async {
    if (_running) return;
    setState(() => _running = true);
    try {
      int value = await ref.read(authControllerProvider).addToken(_text.trim());
      if (mounted) {
        switch (value) {
          case 200:
            showSnackBar(
              context: context,
              leading: const Icon(
                Icons.done,
                color: Colors.tealAccent,
              ), 
              msg: 'Successfully added the bot',
              theme: _theme 
            );
          case 429:
            showSnackBar(
              context: context,
              leading: Icon(
                Icons.error_outline,
                color: Colors.red[800],
              ), 
              msg: 'You are being rate limited',
              theme: _theme 
            );
          case 401:
            showSnackBar(
              context: context,
              leading: Icon(
                Icons.error_outline,
                color: Colors.red[800],
              ), 
              msg: 'Invalid token',
              theme: _theme 
            );
          case -1:
            showSnackBar(
              context: context,
              leading: Icon(
                Icons.error_outline,
                color: Colors.red[800],
              ), 
              msg: 'Bot already added',
              theme: _theme 
            );
          default:
            showSnackBar(
              context: context,
              leading: Icon(
                Icons.error_outline,
                color: Colors.red[800],
              ), 
              msg: 'Unexpected error. Please retry',
              theme: _theme
            );
        }
      }
    } on ClientException {
      if (mounted) {
        showSnackBar(
          context: context,
          leading: Icon(
            Icons.error_outline,
            color: Colors.red[800],
          ), 
          msg: 'Network error. Please retry',
          theme: _theme
        );
      }
    } catch (_) {
      if (mounted) {
        showSnackBar(
          context: context,
          leading: Icon(
            Icons.error_outline,
            color: Colors.red[800],
          ), 
          msg: 'Unexpected error. Please retry',
          theme: _theme
        );
      }
    }
    _controller.text = '';
    setState(() => _running = false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color1 = appTheme<Color>(_theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
    final Color color2 = appTheme<Color>(_theme, light: const Color(0XFF565960), dark: const Color(0XFF878A93), midnight: const Color(0XFF838594));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          splashRadius: 18,
          icon: Icon(
            Icons.arrow_back,
            color: color2,
          ),
        )
      ),
      backgroundColor: appTheme<Color>(_theme, light: const Color(0XFFF0F4F7), dark: const Color(0XFF1A1D24), midnight: const Color(0XFF000000)),
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
                    color: color1,
                    fontFamily: 'GGSansBold',
                    fontSize: 26
                  )
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: Theme(
                    data: ThemeData(
                      textSelectionTheme: () {
                        final Color color = color2;
                        return TextSelectionThemeData(
                          selectionColor: color.withOpacity(0.3),
                          cursorColor: color
                        );
                      }()
                    ),
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(
                        color: color1,
                        fontSize: 14
                      ),
                      onChanged: (text) {
                        if (_text.isEmpty || text.isEmpty) {
                          setState(() => _text = text);
                        } else {
                          _text = text;
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none
                        ),
                        contentPadding: const EdgeInsets.all(16),
                        hintText: "Bot's token",
                        hintStyle: TextStyle(
                          color: color2,
                          fontSize: 14
                        ),
                        filled: true,
                        fillColor: appTheme<Color>(_theme, light: const Color(0XFFDDE1E4), dark: const Color(0XFF0F1316), midnight: const Color(0XFF0D1017)),
                      )
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have a bot account? Click ",
                      style: TextStyle(
                        color: color2,
                        fontSize: 12
                      ),
                      children: [
                        TextSpan(
                          text: 'here',
                          style: TextStyle(
                            color: appTheme<Color>(_theme, light: const Color(0xFF000000), dark: const Color(0XFFC7CAD1), midnight: const Color(0xFFFFFFFF)),
                            fontSize: 12,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () => Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context) => const CreateBotAccountScreen(),
                            )
                          )
                        ),
                      ]
                    ),
                  )
                ),
                const Spacer(),
                CustomButton(
                  enabled: _text.isNotEmpty,
                  onPressed: addToken,
                  backgroundColor: _text.isEmpty 
                  ? appTheme<Color>(_theme, light: const Color(0XFFA3AEF8), dark: const Color(0XFF384590), midnight: const Color(0XFF2A357D))
                  : const Color(0XFF536CF8),
                  onPressedColor: const Color(0XFF4658CA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.getSize.width * 0.5)
                  ),
                  animationUpperBound: 0.04,
                  applyClickAnimation: true,
                  width: double.infinity,
                  height: 50,
                  child: Center(
                    child: _running
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Color(0xFFFFFFFF),
                        strokeWidth: 2,
                      ),
                    )
                    : const Text(
                      'Add Bot',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFFFFFFF),
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