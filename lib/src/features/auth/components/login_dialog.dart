import 'dart:async';
import 'dart:convert';

import 'package:discord/src/common/providers/theme_provider.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' show ClientException;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/utils.dart';
import '../../../common/utils/globals.dart';
import '../../../common/utils/extensions.dart';
import '../../../common/components/custom_button.dart';
import '../../../common/components/profile_pic.dart';


import '../../../features/auth/controller/auth_controller.dart';
import '../../guild/controllers/guilds_controller.dart';
import '../../../features/profile/controller/profile_controller.dart';


class LoginDialog extends ConsumerStatefulWidget {
  final Map<String, dynamic> bot;
  const LoginDialog({required this.bot, super.key});

  @override
  ConsumerState<LoginDialog> createState() => _LoginDialogState();
}
class _LoginDialogState extends ConsumerState<LoginDialog> {
  bool _running = false;
  late final AuthController _authController = ref.read(authControllerProvider);
  late final ProfileController _profileController = ref.read(profileControllerProvider);
  late final String _theme = ref.read(themeProvider);
  
  void login() async {
    runZonedGuarded(
      () async {
        await _authController.login(widget.bot);
        _profileController.botActivity = jsonDecode(prefs.getString('bot-activity')!);
        print(_profileController.botActivity);
        _profileController.updatePresence(save: false, datetime: DateTime.now());
        ref.read(guildsControllerProvider).listenGuildEvents();
        if (mounted) {
          Navigator.pop(context);
          Navigator.pop(context);
          globalNavigatorKey.currentState!.pushReplacementNamed('/home-route');
        } else {
          _authController.logout(null);
        }
      }, 
      (error, stack) async {
        print(stack);
        print("ERROR FROM LOGIN DIALOG: $error");
        bool isMounted = true;
        if (mounted) {
          Navigator.pop(context);
        } else {
          isMounted = false;
        }
        if (error is ClientException && isMounted) {
          showSnackBar(
            context: globalNavigatorKey.currentContext!,
            theme: _theme, 
            leading: Icon(
              Icons.error_outline,
              color: Colors.red[800],
            ), 
            msg: 'Network error'
          );
        } else if (error.toString().contains('401: Unauthorized') && isMounted) {
          _authController.removeBot(widget.bot['name'][0].toUpperCase(), widget.bot['id']);
          showSnackBar(
            context: globalNavigatorKey.currentContext!,
            theme: _theme,
            leading: Icon(
              Icons.error_outline,
              color: Colors.red[800],
            ), 
            msg: 'Invalid token'
          );
        } else if (isMounted) {
          _authController.logout(globalNavigatorKey.currentContext!);
          await Future.delayed(const Duration(seconds: 1));
          showSnackBar(
            context: globalNavigatorKey.currentContext!,
            theme: _theme,
            leading: Icon(
              Icons.error_outline,
              color: Colors.red[800],
            ),
            msg: 'Unexpected error, Please login again',
          );
        }
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.getSize.height * 0.5,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: appTheme<Color>(_theme, light: const Color(0xFFFFFFFF), dark: const Color(0XFF1C1D23), midnight: const Color(0xFF000000)),
        borderRadius: BorderRadius.circular(12)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${widget.bot['name']}#${widget.bot['discriminator']}",
            style: TextStyle(
              color: appTheme<Color>(_theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
              fontSize: 16,
              fontFamily: 'GGSansBold'
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: ProfilePicWidget(
              image: widget.bot['avatar-url'],
              errorWidget: DecoratedBox(
              decoration: BoxDecoration(
                color: appTheme<Color>(_theme, light: const Color(0xFFFFFFFF), dark: const Color(0XFF25282F), midnight: const Color(0XFF151419)),
                shape: BoxShape.circle
              ),
              child: Center(
                child: Text(
                  widget.bot['name'][0],
                  style: TextStyle(
                    color: appTheme<Color>(_theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
                    fontSize: 36,
                  ),
                ),
              ),
            ),
              backgroundColor: Colors.transparent,
              radius: context.getSize.height * 0.2,
            ),
          ),
          const Spacer(),
          StatefulBuilder(
            builder: (context, setState) {
              return CustomButton(
                width: double.infinity,
                height: 45,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45 * 0.5)
                ),
                backgroundColor: const Color(0XFF536CF8),
                onPressedColor: const Color(0XFF4658CA),
                applyClickAnimation: true,
                animationUpperBound: 0.04,
                onPressed: () {
                  if (_running) return;
                  setState(() => _running = true);
                  login();
                },
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
                    "Login",
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontFamily: 'GGSansSemibold'
                    ),
                  ),
                ),
              );
            }
          ),
          const SizedBox(height: 10),
          CustomButton(
            width: double.infinity,
            height: 45,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(45 * 0.5)
            ),
            backgroundColor: appTheme<Color>(_theme, light: const Color(0XFFDFE1E3), dark: const Color(0XFF373A42), midnight: const Color(0XFF2C2D36)),
            onPressedColor: appTheme<Color>(_theme, light: const Color(0XFFC4C6C8), dark: const Color(0XFF4D505A), midnight: const Color(0XFF373A42)),
            applyClickAnimation: true,
            animationUpperBound: 0.04,
            onPressed: () => Navigator.pop(context),
            child: Center(
              child: Text(
                "Go Back",
                style: TextStyle(
                  color: appTheme<Color>(_theme, light: const Color(0XFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
                  fontFamily: 'GGSansSemibold'
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

