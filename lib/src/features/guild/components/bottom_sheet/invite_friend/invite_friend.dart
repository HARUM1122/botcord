import 'package:discord/src/common/components/drag_handle.dart';
import 'package:discord/src/common/controllers/theme_controller.dart';
import 'package:discord/src/common/utils/asset_constants.dart';
import 'package:discord/src/common/utils/extensions.dart';
import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/features/guild/components/bottom_sheet/invite_friend/component/invite_link_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';


class LinkOptionsSheet extends ConsumerWidget {
  final String inviteLink;
  final ScrollController controller;
  const LinkOptionsSheet({required this.inviteLink, required this.controller, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.read(themeController);
    final Color color1 = appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
    final Color color2 = appTheme<Color>(theme, light: const Color(0XFFEBEBEB), dark: const Color(0XFF2C2D36), midnight: const Color(0XFF1C1B21));

    List<Widget> children = [
      Align(
        alignment: Alignment.topCenter,
        child: DragHandle(
          color: appTheme<Color>(theme, light: const Color(0XFFD8DADD), dark: const Color(0XFF2F3039), midnight: const Color(0XFF151518))
        )
      ),
      const SizedBox(height: 8),
      Align(
        alignment: Alignment.topCenter,
        child: Text(
          'Invite a friend',
          style: TextStyle(
            color: color1,
            fontFamily: 'GGSansBold',
            fontSize: 18
          ),
        ),
      ),
      Align(
        alignment: Alignment.topCenter,
        child: Text(
          inviteLink,
          style: TextStyle(
            color: appTheme<Color>(theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFF81818D)),
            fontSize: 14,
            fontFamily: 'GGSansSemibold'
          ),
        ),
      ),
      const SizedBox(height: 30),
      DecoratedBox(
        decoration: BoxDecoration(
          color: appTheme<Color>(theme, light: const Color(0xFFFFFFFF), dark: const Color(0xFF25282F), midnight: const Color(0XFF141318)),
          borderRadius: BorderRadius.circular(16)
        ),
        child: Column(
          children: [
            InviteLinkOption(
              title: 'Edit Link',
              onPressed: () async {
              },
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16)
              ),
              theme: theme,
            ),
            Divider(
              thickness: 1,
              height: 0,
              indent: 50,
              color: color2,
            ),
            InviteLinkOption(
              title: 'Copy Link',
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: inviteLink));
                if (!context.mounted) return;
                showSnackBar(
                  context: context, 
                  theme: theme,
                  leading: SvgPicture.asset(
                    AssetIcon.link,
                    colorFilter: ColorFilter.mode(color1, BlendMode.srcIn)
                  ),
                  msg: "Link copied"
                );
              },
              borderRadius: BorderRadius.zero,
              theme: theme,
            ),
            Divider(
              thickness: 1,
              height: 0,
              indent: 50,
              color: color2,
            ),
            InviteLinkOption(
              title: 'Share Invite',
              onPressed: () => Share.share(inviteLink),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16)
              ),
              theme: theme,
            ),
          ]
        )
      )
    ];
    return ListView.builder(
      padding: EdgeInsets.only(top: 8, left: 12, right: 12, bottom: context.padding.bottom + 12),
      controller: controller,
      itemCount: children.length,
      itemBuilder: (context, idx) => children[idx]
    );
  }
}