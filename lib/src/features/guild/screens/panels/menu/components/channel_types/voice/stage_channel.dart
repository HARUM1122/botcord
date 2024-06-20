import 'package:flutter/material.dart';

import 'package:nyxx/nyxx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/common/utils/asset_constants.dart';
import 'package:discord/src/common/controllers/theme_controller.dart';



class StageChannelButton extends ConsumerStatefulWidget {
  final GuildStageChannel stageChannel;
  final Function() onPressed;
  const StageChannelButton({required this.stageChannel,
    required this.onPressed,
    super.key
  });

  @override
  ConsumerState<StageChannelButton> createState() => _StageChannelButtonState();
}

class _StageChannelButtonState extends ConsumerState<StageChannelButton> {
  late final String _theme = ref.read(themeController);

  late final Color _color1 = appTheme<Color>(_theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFF81818D));
  
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            AssetIcon.signal,
            height: 16,
            colorFilter: ColorFilter.mode(
              _color1,
              BlendMode.srcIn
            )
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              widget.stageChannel.name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: _color1,
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
          )
        ],
      ),
    );
  }
}