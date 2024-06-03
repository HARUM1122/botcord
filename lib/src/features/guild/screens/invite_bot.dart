import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/src/common/controllers/theme_controller.dart';

import '../utils/constants.dart';

import '../../../common/utils/utils.dart';
import '../../../common/utils/globals.dart';
import '../../../common/utils/extensions.dart';
import '../../../common/utils/asset_constants.dart';
import '../../../common/components/custom_button.dart';
import '../../../common/components/checkbox_indicator.dart';

class InviteBotScreen extends ConsumerStatefulWidget {
  const InviteBotScreen({super.key});

  @override
  ConsumerState<InviteBotScreen> createState() => _InviteBotScreenState();
}

class _InviteBotScreenState extends ConsumerState<InviteBotScreen> {
  final List<int> permissions = [];
  String getLink() {
    int perms = 0;
    for (int perm in permissions) {
      perms += perm;
    }
    return 'https://discord.com/oauth2/authorize?client_id=${user?.id ?? ''}&permissions=$perms&scope=bot';
  }
  @override
  Widget build(BuildContext contextf) {
    final String theme = ref.watch(themeController);
    final Color color1 = appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
    final Color color2 = appTheme<Color>(theme, light: const Color(0XFF4C4F57), dark: const Color(0XFFC8C9D1), midnight: const Color(0xFFFFFFFF));
    final Color color3 = appTheme<Color>(theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFFA8AAB0));
    final Color color4 = appTheme<Color>(theme, light: const Color(0XFFEBEBEB), dark: const Color(0XFF2C2D36), midnight: const Color(0XFF1C1B21));

    return Scaffold(
      backgroundColor: appTheme<Color>(theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0xFF000000)),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          splashRadius: 18,
          icon: Icon(
            Icons.arrow_back,
            color: appTheme<Color>(theme, light: const Color(0XFF565960), dark: const Color(0XFF878A93), midnight: const Color(0XFF838594))
          )
        ),
        title: Text(
          "Invite Bot",
          style: TextStyle(
            color: color1,
            fontFamily: 'GGSansBold',
            fontSize: 18
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 12, right: 12, bottom: context.padding.bottom + 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'General Permissions',
              style: TextStyle(
                color: color3,
                fontSize: 14,
                fontFamily: 'GGSansSemibold'
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: appTheme<Color>(
                  theme, light: const Color(0xFFFFFFFF), 
                  dark: const Color(0xFF25282F), 
                  midnight: const Color(0XFF141318)
                ),
                borderRadius: BorderRadius.circular(16)
              ),
              child: Column(
                children: () {
                  List<Widget> general = [];
                  for (int i = 0; i < generalPerms.length; i++) {
                    (String, int) perm = generalPerms[i];
                    final bool selected = permissions.contains(perm.$2);
                    general.add(
                      PermissionsButton(
                        borderRadius: BorderRadius.vertical(
                          top: i == 0 
                          ? const Radius.circular(16) 
                          : Radius.zero,
                          bottom: i == generalPerms.length - 1 
                          ? const Radius.circular(16) 
                          : Radius.zero
                        ),
                        backgroundColor: Colors.transparent,
                        onPressedColor: appTheme<Color>(theme, light: const Color(0XFFE1E1E1), dark: const Color(0XFF2F323A), midnight: const Color(0XFF202226)),
                        onPressed: () => setState(
                          () => selected 
                          ? permissions.remove(perm.$2) 
                          : permissions.add(perm.$2)
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 14),
                            Text(
                              perm.$1,
                              style: TextStyle(
                                color: color1,
                                fontSize: 16,
                                fontFamily: 'GGSansSemibold'
                              ),
                            ),
                            const Spacer(),
                            CheckBoxIndicator(selected: selected),
                            const SizedBox(width: 14)
                          ],
                        )
                      )
                    );
                    if (i < generalPerms.length - 1) {
                      general.add(
                        Divider(
                          color: color4,
                          thickness: 1,
                          height: 0,
                          indent: 15,
                        ),
                      );
                    }
                  }
                  return general;
                }(),
              )
            ),
            const SizedBox(height: 30),
            Text(
              'Text Permissions',
              style: TextStyle(
                color: color3,
                fontSize: 14,
                fontFamily: 'GGSansSemibold'
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: appTheme<Color>(
                  theme, light: const Color(0xFFFFFFFF), 
                  dark: const Color(0xFF25282F), 
                  midnight: const Color(0XFF141318)
                ),
                borderRadius: BorderRadius.circular(16)
              ),
              child: Column(
                children: () {
                  List<Widget> text = [];
                  for (int i = 0; i < textPerms.length; i++) {
                    (String, int) perm = textPerms[i];
                    final bool selected = permissions.contains(perm.$2);
                    text.add(
                      PermissionsButton(
                        borderRadius: BorderRadius.vertical(
                          top: i == 0 
                          ? const Radius.circular(16) 
                          : Radius.zero,
                          bottom: i == textPerms.length - 1 
                          ? const Radius.circular(16) 
                          : Radius.zero
                        ),
                        backgroundColor: Colors.transparent,
                        onPressedColor: appTheme<Color>(theme, light: const Color(0XFFE1E1E1), dark: const Color(0XFF2F323A), midnight: const Color(0XFF202226)),
                        onPressed: () => setState(
                          () => selected 
                          ? permissions.remove(perm.$2) 
                          : permissions.add(perm.$2)
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 14),
                            Text(
                              perm.$1,
                              style: TextStyle(
                                color: color1,
                                fontSize: 16,
                                fontFamily: 'GGSansSemibold'
                              ),
                            ),
                            const Spacer(),
                            CheckBoxIndicator(selected: selected),
                            const SizedBox(width: 14)
                          ],
                        )
                      )
                    );
                    if (i < generalPerms.length - 1) {
                      text.add(
                        Divider(
                          color: color4,
                          thickness: 1,
                          height: 0,
                          indent: 15,
                        ),
                      );
                    }
                  }
                  return text;
                }(),
              )
            ),
            const SizedBox(height: 30),
            Text(
              'Voice Permissions',
              style: TextStyle(
                color: color3,
                fontSize: 14,
                fontFamily: 'GGSansSemibold'
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: appTheme<Color>(
                  theme, light: const Color(0xFFFFFFFF), 
                  dark: const Color(0xFF25282F), 
                  midnight: const Color(0XFF141318)
                ),
                borderRadius: BorderRadius.circular(16)
              ),
              child: Column(
                children: () {
                  List<Widget> voice = [];
                  for (int i = 0; i < voicePerms.length; i++) {
                    (String, int) perm = voicePerms[i];
                    final bool selected = permissions.contains(perm.$2);
                    voice.add(
                      PermissionsButton(
                        borderRadius: BorderRadius.vertical(
                          top: i == 0 
                          ? const Radius.circular(16) 
                          : Radius.zero,
                          bottom: i == voicePerms.length - 1 
                          ? const Radius.circular(16) 
                          : Radius.zero
                        ),
                        backgroundColor: Colors.transparent,
                        onPressedColor: appTheme<Color>(theme, light: const Color(0XFFE1E1E1), dark: const Color(0XFF2F323A), midnight: const Color(0XFF202226)),
                        onPressed: () => setState(
                          () => selected 
                          ? permissions.remove(perm.$2) 
                          : permissions.add(perm.$2)
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 14),
                            Text(
                              perm.$1,
                              style: TextStyle(
                                color: color1,
                                fontSize: 16,
                                fontFamily: 'GGSansSemibold'
                              ),
                            ),
                            const Spacer(),
                            CheckBoxIndicator(selected: selected),
                            const SizedBox(width: 14)
                          ],
                        )
                      )
                    );
                    if (i < generalPerms.length - 1) {
                      voice.add(
                        Divider(
                          color: color4,
                          thickness: 1,
                          height: 0,
                          indent: 15,
                        ),
                      );
                    }
                  }
                  return voice;
                }(),
              )
            ),
            const SizedBox(height: 30),
            PermissionsButton(
              borderRadius: BorderRadius.circular(16),
              backgroundColor: appTheme<Color>(
                theme, light: const Color(0xFFFFFFFF), 
                dark: const Color(0xFF25282F), 
                midnight: const Color(0XFF141318)
              ),
              onPressedColor: appTheme<Color>(theme, light: const Color(0XFFE1E1E1), dark: const Color(0XFF2F323A), midnight: const Color(0XFF202226)),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: getLink()));
                if (!mounted) return;
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
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  SvgPicture.asset(
                    AssetIcon.link,
                    colorFilter: ColorFilter.mode(color2, BlendMode.srcIn)
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'Copy Link',
                    style: TextStyle(
                      color: color1,
                      fontSize: 16,
                      fontFamily: 'GGSansSemibold'
                    ),
                  ),
                  const SizedBox(width: 14)
                ],
              )
            ),
            const SizedBox(height: 20),
            PermissionsButton(
              borderRadius: BorderRadius.circular(16),
              backgroundColor: appTheme<Color>(
                theme, light: const Color(0xFFFFFFFF), 
                dark: const Color(0xFF25282F), 
                midnight: const Color(0XFF141318)
              ),
              onPressedColor: appTheme<Color>(theme, light: const Color(0XFFE1E1E1), dark: const Color(0XFF2F323A), midnight: const Color(0XFF202226)),
              onPressed: () async => await launchUrl(Uri.parse(getLink())),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  Icon(
                    Icons.mail,
                    color: color2,
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'Invite Bot',
                    style: TextStyle(
                      color: color1,
                      fontSize: 16,
                      fontFamily: 'GGSansSemibold'
                    ),
                  ),
                  const SizedBox(width: 14)
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}

class PermissionsButton extends StatelessWidget {
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final Color onPressedColor;
  final Function() onPressed;
  final Widget child;

  const PermissionsButton({
    required this.borderRadius,
    required this.backgroundColor,
    required this.onPressedColor,
    required this.onPressed,
    required this.child,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      height: 60,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      onPressedColor: onPressedColor,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius
      ),
      applyClickAnimation: false,
      child: child,
    );
  }
}