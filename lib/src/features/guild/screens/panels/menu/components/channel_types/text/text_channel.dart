import 'package:discord/src/common/controllers/theme_controller.dart';
import 'package:discord/src/common/utils/asset_constants.dart';
import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/features/guild/screens/panels/menu/components/channel_icons/text/text_channel_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:nyxx/nyxx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextChannelButton extends ConsumerStatefulWidget {
  final GuildTextChannel textChannel;
  final bool selected;
  final Function() onPressed;
  const TextChannelButton({required this.textChannel,
    required this.selected,
    required this.onPressed,
    super.key
  });

  @override
  ConsumerState<TextChannelButton> createState() => _TextChannelButtonState();
}

class _TextChannelButtonState extends ConsumerState<TextChannelButton> {
  late final String _theme = ref.read(themeController);
  
  late final Color _color1 = appTheme<Color>(_theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
  late final Color _color2 = appTheme<Color>(_theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFF81818D));
  late final Color _color3 = appTheme<Color>(_theme, light: const Color(0XFFF4F4F4), dark: const Color(0XFF25262F), midnight: const Color(0XFF16171B));
  

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: widget.selected ? _color3 : Colors.transparent,
        border: widget.selected ? Border.all(color: _color1.withOpacity(0.1)) : null,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        children: [
          TextChannelIcon(
            isPrivate: true,
            iconColor: widget.selected ? _color1 : _color2,
            size: 18
          ),
          const SizedBox(width: 5),
          Text(
            widget.textChannel.name,
            style: TextStyle(
              color: widget.selected ? _color1 : _color2,
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }
}