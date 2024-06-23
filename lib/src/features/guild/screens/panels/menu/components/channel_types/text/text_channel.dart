import 'package:flutter/material.dart';

import 'package:nyxx/nyxx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/common/utils/asset_constants.dart';
import 'package:discord/src/common/components/custom_button.dart';
import 'package:discord/src/common/controllers/theme_controller.dart';

class TextChannelButton extends ConsumerStatefulWidget {
  final GuildTextChannel textChannel;
  final bool selected;
  final Function() onPressed;
  final Function() onLongPress;
  const TextChannelButton({required this.textChannel,
    required this.selected,
    required this.onPressed,
    required this.onLongPress,
    super.key
  });

  @override
  ConsumerState<TextChannelButton> createState() => _TextChannelButtonState();
}

class _TextChannelButtonState extends ConsumerState<TextChannelButton> {
  late final String _theme = ref.read(themeController);
  
  late final Color _color1 = appTheme<Color>(_theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
  late final Color _color2 = appTheme<Color>(_theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFF81818D));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: CustomButton(
        width: double.infinity,
        onPressed: widget.onPressed,
        onLongPress: widget.onLongPress,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: widget.selected
        ? appTheme<Color>(_theme, light: const Color(0XFFF4F4F4), dark: const Color(0XFF25262F), midnight: const Color(0XFF16171B))
        : Colors.transparent,
        onPressedColor: appTheme<Color>(_theme, light: const Color(0xFFFFFFFF), dark: const Color(0xFF25282F), midnight: const Color(0XFF141318)),
        applyClickAnimation: false,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Row(
            children: [
              SvgPicture.asset(
                AssetIcon.hash,
                height: 18,
                colorFilter: ColorFilter.mode(
                  widget.selected ? _color1 : _color2,
                  BlendMode.srcIn
                )
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  widget.textChannel.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: widget.selected ? _color1 : _color2,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}