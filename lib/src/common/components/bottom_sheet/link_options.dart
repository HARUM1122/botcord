import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:share_plus/share_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/src/common/controllers/theme_controller.dart';

import '../drag_handle.dart';
import '../custom_button.dart';

import '../../utils/utils.dart';
import '../../utils/extensions.dart';
import '../../utils/asset_constants.dart';

class LinkOptionsSheet extends ConsumerWidget {
  final String link;
  final ScrollController controller;
  const LinkOptionsSheet({required this.link, required this.controller, super.key});

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
      const SizedBox(height: 10),
      Align(
        alignment: Alignment.topCenter,
        child: Text(
          "Link Options",
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
          link,
          style: TextStyle(
            color: appTheme<Color>(theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFF81818D)),
            fontSize: 14,
            fontFamily: 'GGSansSemibold'
          ),
        ),
      ),
      const SizedBox(height: 20),
      DecoratedBox(
        decoration: BoxDecoration(
          color: appTheme<Color>(theme, light: const Color(0xFFFFFFFF), dark: const Color(0xFF25282F), midnight: const Color(0XFF141318)),
          borderRadius: BorderRadius.circular(16)
        ),
        child: Column(
          children: [
            LinkOption(
              title: 'Open Link',
              onPressed: () async {
                Navigator.pop(context);
                Uri uri = Uri.parse(link);
                await launchUrl(uri);
              },
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16)
              )
            ),
            Divider(
              thickness: 1,
              height: 0,
              indent: 50,
              color: color2,
            ),
            LinkOption(
              title: 'Copy Link',
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: link));
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
              borderRadius: BorderRadius.zero
            ),
            Divider(
              thickness: 1,
              height: 0,
              indent: 50,
              color: color2,
            ),
            LinkOption(
              title: 'Share Link',
              onPressed: () => Share.share(link),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16)
              ),
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

class LinkOption extends ConsumerWidget {
  final String title;
  final Function() onPressed;
  final BorderRadius borderRadius;
  const LinkOption({
    required this.title,
    required this.onPressed,
    required this.borderRadius,
    super.key
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.read(themeController);
    return CustomButton(
      backgroundColor: Colors.transparent,
      onPressedColor: appTheme<Color>(theme, light: const Color(0XFFE1E1E1), dark: const Color(0XFF2F323A), midnight: const Color(0XFF202226)),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius
      ),
      onPressed: onPressed,
      applyClickAnimation: false, 
      child: Container(
        margin: const EdgeInsets.all(20),
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
            fontSize: 16,
            fontFamily: 'GGSansSemibold'
          ),
        ),
      )
    );
  }
}