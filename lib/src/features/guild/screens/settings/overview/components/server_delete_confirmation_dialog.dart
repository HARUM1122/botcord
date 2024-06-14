import 'package:discord/src/common/components/custom_button.dart';
import 'package:discord/src/common/utils/extensions.dart';
import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/src/common/controllers/theme_controller.dart';
import 'package:nyxx/nyxx.dart';

class ServerDeleteConfirmationDialog extends ConsumerStatefulWidget {
  final Guild guild;
  const ServerDeleteConfirmationDialog({required this.guild, super.key});

  @override
  ConsumerState<ServerDeleteConfirmationDialog> createState() => _ServerDeleteConfirmationDialogState();
}

class _ServerDeleteConfirmationDialogState extends ConsumerState<ServerDeleteConfirmationDialog> {
  late final String _theme = ref.read(themeController);

  late final Color color1 = appTheme<Color>(_theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));

  bool _running = false;

  Future<bool> _deleteServer() async {
    setState(() => _running = true);
    try {
      await widget.guild.delete();
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.getSize.height * 0.35,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: appTheme<Color>(_theme, light: const Color(0xFFFFFFFF), dark: const Color(0XFF1C1D23), midnight: const Color(0xFF000000)),
        borderRadius: BorderRadius.circular(12)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delete Server',
            style: TextStyle(
              color: color1,
              fontSize: 16,
              fontFamily: 'GGSansBold'
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Are you sure you want to delete this server? This action cannot be undone.',
            style: TextStyle(
              color: color1,
              fontSize: 16
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: CustomButton(
              width: double.infinity,
              height: 45,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(45 * 0.5)
              ),
              backgroundColor: const Color(0XFFE8413A),
              onPressedColor: const Color(0XFFC73E33),
              applyClickAnimation: true,
              animationUpperBound: 0.04,
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
                  'Delete Server',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFFFFFFF),
                    fontFamily: 'GGsansSemibold'
                  )
                )
              ),
              onPressed: () async {
                if (_running) return;
                bool result = await _deleteServer();
                if (!context.mounted) return;
                Navigator.pop(context, result);
              }
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: CustomButton(
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
                  'Cancel',
                  style: TextStyle(
                    color: appTheme<Color>(_theme, light: const Color(0xFF31343D), dark: const Color(0xFFC5C8CF), midnight: const Color(0xFFC5C8CF)),
                    fontFamily: 'GGSansSemibold'
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}