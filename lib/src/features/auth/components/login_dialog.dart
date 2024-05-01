import 'dart:async';

import 'package:flutter/material.dart';

import 'package:http/http.dart' show ClientException;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/utils.dart';
import '../../../common/utils/cache.dart';
import '../../../common/utils/extensions.dart';
import '../../../common/components/custom_button.dart';
import '../../../common/components/avatar/profile_pic.dart';


import '../../../features/auth/controller/auth_controller.dart';
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

  void login() async {
    runZonedGuarded(
      () async {
        await _authController.login(widget.bot);
        _profileController.updatePresence(save: false, datetime: DateTime.now());
        if (mounted) {
          context.pop();
          context.pop();
          globalNavigatorKey.currentState!.pushReplacementNamed('/home-route');
        } else {
          _authController.logout(null);
        }
      }, 
      (error, stack) async {
        bool isMounted = true;
        if (mounted) {
          context.pop();
        } else {
          isMounted = false;
        }
        if (error is ClientException && isMounted) {
          showSnackBar(
            context: globalNavigatorKey.currentContext!, 
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
            leading: Icon(
              Icons.error_outline,
              color: Colors.red[800],
            ), 
            msg: 'Invalid token'
          );
        } else {
          _authController.logout(globalNavigatorKey.currentContext!);
          await Future.delayed(const Duration(seconds: 1));
          showSnackBar(
            context: globalNavigatorKey.currentContext!,
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
        color: theme['color-11'],
        borderRadius: BorderRadius.circular(12)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${widget.bot['name']}#${widget.bot['discriminator']}",
            style: TextStyle(
              color: theme['color-01'],
              fontSize: 16,
              fontFamily: 'GGSansBold'
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: ProfilePicWidget(
              image: widget.bot['avatar-url'],
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
                backgroundColor: theme['color-14'],
                onPressedColor: theme['color-15'],
                applyClickAnimation: true,
                animationUpperBound: 0.04,
                onPressed: () {
                  if (_running) return;
                  setState(() => _running = true);
                  login();
                },
                child: Center(
                  child: _running 
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: theme['color-01'],
                        strokeWidth: 2,
                      ),
                    ) 
                  : Text(
                    "Login",
                    style: TextStyle(
                      color: theme['color-01'],
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
            backgroundColor: theme['color-07'],
            onPressedColor: theme['color-06'],
            applyClickAnimation: true,
            animationUpperBound: 0.04,
            onPressed: context.pop,
            child: Center(
              child: Text(
                "Go Back",
                style: TextStyle(
                  color: theme['color-01'],
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