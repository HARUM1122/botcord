import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:discord/src/common/utils/asset_constants.dart';

class TextChannelIcon extends StatelessWidget {
  final bool isPrivate;
  final Color iconColor;
  final double size;
  const TextChannelIcon({
    required this.isPrivate,
    required this.iconColor,
    required this.size,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (isPrivate)  Positioned(
          right: 0,
          child: Icon(
            Icons.lock,
            color: iconColor,
            size: size * 0.5
          ),
        ),
        SvgPicture.asset(
          AssetIcon.hash,
          height: size,
          colorFilter: ColorFilter.mode(
            iconColor,
            BlendMode.srcIn
          )
        )
      ],
    );
  }
}