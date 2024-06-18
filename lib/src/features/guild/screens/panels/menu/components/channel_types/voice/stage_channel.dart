import 'package:flutter/material.dart';

import 'package:discord/src/common/controllers/theme_controller.dart';
import 'package:discord/src/common/utils/asset_constants.dart';
import 'package:discord/src/common/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:nyxx/nyxx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  
  late final Color _color1 = appTheme<Color>(_theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            AssetIcon.signal,
            height: 18,
            colorFilter: ColorFilter.mode(
              _color1.withOpacity(0.5),
              BlendMode.srcIn
            )
          ),
          const SizedBox(width: 5),
          Text(
            widget.stageChannel.name,
            style: TextStyle(
              color: _color1.withOpacity(0.5),
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }
}