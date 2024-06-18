import 'package:discord/src/common/controllers/theme_controller.dart';
import 'package:discord/src/common/utils/asset_constants.dart';
import 'package:discord/src/common/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:nyxx/nyxx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForumChannnelButton extends ConsumerStatefulWidget {
  final ForumChannel forumChannel;
  final bool selected;
  final Function() onPressed;
  const ForumChannnelButton({required this.forumChannel,
    required this.selected,
    required this.onPressed,
    super.key
  });

  @override
  ConsumerState<ForumChannnelButton> createState() => _ForumChannelButtonState();
}

class _ForumChannelButtonState extends ConsumerState<ForumChannnelButton> {
  late final String _theme = ref.read(themeController);
  
  late final Color _color1 = appTheme<Color>(_theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
  late final Color _color2 = appTheme<Color>(_theme, light: const Color(0XFFF4F4F4), dark: const Color(0XFF25262F), midnight: const Color(0XFF16171B));
  

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: widget.selected ? _color2 : Colors.transparent,
        border: widget.selected ? Border.all(color: _color1.withOpacity(0.1)) : null,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            AssetIcon.forum,
            height: 18,
            colorFilter: ColorFilter.mode(
              widget.selected ? _color1 : _color1.withOpacity(0.5),
              BlendMode.srcIn
            )
          ),
          const SizedBox(width: 5),
          Text(
            widget.forumChannel.name,
            style: TextStyle(
              color: widget.selected ? _color1 : _color1.withOpacity(0.5),
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }
}