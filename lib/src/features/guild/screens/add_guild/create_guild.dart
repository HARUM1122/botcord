import 'package:discord/src/common/utils/globals.dart';
import 'package:flutter/material.dart';

import 'package:nyxx/nyxx.dart';

import 'package:discord/src/common/utils/extensions.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/components/radio_button_indicator/radio_button_indicator2.dart';

import 'package:discord/src/common/controllers/theme_controller.dart';

import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/common/components/custom_button.dart';

import 'package:discord/src/features/profile/controller/profile.dart';

class CreateGuildScreen extends ConsumerStatefulWidget {
  const CreateGuildScreen({super.key});

  @override
  ConsumerState<CreateGuildScreen> createState() => _EditActivityScreenState();
}

class _EditActivityScreenState extends ConsumerState<CreateGuildScreen> {
  late final String _theme = ref.read(themeController);

  late final Color _color1 = appTheme<Color>(_theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
  late final Color _color2 = appTheme<Color>(_theme, light: const Color(0XFF565960), dark: const Color(0XFF878A93), midnight: const Color(0XFF838594));

  late final Color _color3 = appTheme<Color>(_theme, light: const Color(0XFFDFE1E3), dark: const Color(0XFF0F1316), midnight: const Color(0XFF0F1014));
  late final Color _color4 = appTheme<Color>(_theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFFA8AAB0));

  String _serverName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme<Color>(_theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0xFF000000)),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          splashRadius: 18,
          icon: Icon(
            Icons.arrow_back,
            color: _color1.withOpacity(0.5),
          )
        ),
        title: Text(
          'Create Server',
          style: TextStyle(
            color: _color1,
            fontSize: 18,
            fontFamily: 'GGSansBold'
          ),
        ),
        centerTitle: true
      ),
      body: Column(
        children: [
          SizedBox(
            height: context.getSize.height * 0.12
          ),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: Theme(
              data: ThemeData(
                textSelectionTheme: TextSelectionThemeData(
                  selectionColor: _color1.withOpacity(0.2),
                  cursorColor: _color1.withOpacity(0.5)
                )
              ),
              child: TextField(
                style: TextStyle(
                  color: _color1,
                  fontSize: 14
                ),
                onChanged: (text) {
                  if (_serverName.isEmpty || text.isEmpty) {
                    setState(() => _serverName = text);
                  } else {
                    _serverName = text;
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
                    color: _color1.withOpacity(0.5),
                    fontSize: 14
                  ),
                  filled: true,
                  fillColor: appTheme<Color>(_theme, light: const Color(0XFFDDE1E4), dark: const Color(0XFF0F1316), midnight: const Color(0XFF0D1017)),
                )
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}