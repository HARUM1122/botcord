import 'package:flutter/material.dart';

import 'package:nyxx/nyxx.dart' as nyxx;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/common/utils/extensions.dart';
import 'package:discord/src/common/components/custom_button.dart';
import 'package:discord/src/common/controllers/theme_controller.dart';
import 'package:discord/src/common/components/checkbox_indicator.dart';

class ModerationScreen extends ConsumerStatefulWidget {
  final nyxx.Guild guild;
  const ModerationScreen({required this.guild, super.key});
  @override
  ConsumerState<ModerationScreen> createState() => _OverViewPageState();
}

class _OverViewPageState extends ConsumerState<ModerationScreen> {
  late final String _theme = ref.read(themeController);

  late final Color _color1 = appTheme<Color>(_theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
  late final Color _color2 = appTheme<Color>(_theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFFA8AAB0));
  late final Color _color3 = appTheme<Color>(_theme, light: const Color(0XFF565960), dark: const Color(0XFF878A93), midnight: const Color(0XFF838594));
  late final Color _color4 = appTheme<Color>(_theme, light: const Color(0xFFFFFFFF), dark: const Color(0xFF25282F), midnight: const Color(0XFF141318));
  late final Color _color5 = appTheme<Color>(_theme, light: const Color(0XFFE1E1E1), dark: const Color(0XFF2F323A), midnight: const Color(0XFF202226));
  late final Color _color6 = appTheme<Color>(_theme, light: const Color(0XFFEBEBEB), dark: const Color(0XFF2C2D36), midnight: const Color(0XFF1C1B21));


  late nyxx.VerificationLevel _verificationLevel = widget.guild.verificationLevel;
  late nyxx.ExplicitContentFilterLevel _explicitContentFilterLevel = widget.guild.explicitContentFilterLevel;
  
  bool _saving = false;


  void _updateSettings() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await widget.guild.update(
        nyxx.GuildUpdateBuilder(
          verificationLevel: _verificationLevel,
          explicitContentFilterLevel: _explicitContentFilterLevel
        )
      );
    } catch (_) {
      if (!mounted) return;
      showSnackBar(
        context: context, 
        theme: _theme,
        leading: Icon(
          Icons.error_outline,
          color: Colors.red[800],
        ),
        msg: 'Unexpected Error, Please try again.'
      );
    }
    setState(() => _saving = false);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    bool hasMadeChanges = _verificationLevel != widget.guild.verificationLevel || _explicitContentFilterLevel != widget.guild.explicitContentFilterLevel;
    return Scaffold(
      backgroundColor: appTheme<Color>(_theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0xFF000000)),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          splashRadius: 18,
          icon: Icon(
            Icons.arrow_back,
            color: _color3
          )
        ),
        title: Text(
          'Moderation',
          style: TextStyle(
            color: _color1,
            fontFamily: 'GGSansBold',
            fontSize: 18
          ),
        ),
        actions: [
          TextButton(
            onPressed: hasMadeChanges
            ? _updateSettings
            : null,
             style: const ButtonStyle(
              overlayColor: MaterialStatePropertyAll(Colors.transparent)
            ),
            child: !_saving 
            ? Text(
              "Save",
              style: TextStyle(
                color: () {
                  Color color = appTheme<Color>(_theme, light: const Color(0xFF5964F4), dark: const Color(0xFF969BF6), midnight: const Color(0XFF6E82F4));
                  return hasMadeChanges ? color : color.withOpacity(0.5);
                }(),
                fontSize: 16,
                fontFamily: 'GGSansSemibold'
              ),
            )
            : SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  color: _color3,
                  strokeWidth: 2,
                ),
              ),
          ),
          const SizedBox(width: 8)
        ],
        centerTitle: true,
      ),
      body: StretchingOverscrollIndicator(
        axisDirection: AxisDirection.down,
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowIndicator();
            return true;
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 10, left: 12, right: 12, bottom: context.padding.bottom + 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verification Level',
                  style: TextStyle(
                    color: _color2,
                    fontSize: 14,
                    fontFamily: 'GGSansSemibold'
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: _color4,
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: Column(
                    children: [
                      ModerationOptionButton(
                        backgroundColor: Colors.transparent,
                        onPressedColor: _color5,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16)
                        ),
                        onPressed: () => setState(() => _verificationLevel = nyxx.VerificationLevel.none),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          child: Row(
                            children: [
                              CheckBoxIndicator(
                                selected: _verificationLevel == nyxx.VerificationLevel.none,
                                circular: true
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'None',
                                      style: TextStyle(
                                        color: _color1,
                                        fontSize: 16,
                                        fontFamily: 'GGSansSemibold'
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Unrestricted.',
                                      style: TextStyle(
                                        color: _color2,
                                        fontSize: 12
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ),
                      Divider(
                        thickness: 1,
                        height: 0,
                        indent: 50,
                        color: _color6,
                      ),
                      ModerationOptionButton(
                        backgroundColor: Colors.transparent,
                        onPressedColor: _color5,
                        onPressed: () => setState(() => _verificationLevel = nyxx.VerificationLevel.low),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          child: Row(
                            children: [
                              CheckBoxIndicator(
                                selected: _verificationLevel == nyxx.VerificationLevel.low,
                                circular: true
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Low',
                                      style: TextStyle(
                                        color: Colors.greenAccent[700],
                                        fontSize: 16,
                                        fontFamily: 'GGSansSemibold'
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Must have a verified email on their Discord account.',
                                      style: TextStyle(
                                        color: _color2,
                                        fontSize: 12
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ),
                      Divider(
                        thickness: 1,
                        height: 0,
                        indent: 50,
                        color: _color6,
                      ),
                      ModerationOptionButton(
                        backgroundColor: Colors.transparent,
                        onPressedColor: _color5,
                        onPressed: () => setState(() => _verificationLevel = nyxx.VerificationLevel.medium),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          child: Row(
                            children: [
                              CheckBoxIndicator(
                                selected: _verificationLevel == nyxx.VerificationLevel.medium,
                                circular: true
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Medium',
                                      style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 16,
                                        fontFamily: 'GGSansSemibold'
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Must also be registered on Discord for longer than 5 minutes.',
                                      style: TextStyle(
                                        color: _color2,
                                        fontSize: 12
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ),
                      Divider(
                        thickness: 1,
                        height: 0,
                        indent: 50,
                        color: _color6,
                      ),
                      ModerationOptionButton(
                        backgroundColor: Colors.transparent,
                        onPressedColor: _color5,
                        onPressed: () => setState(() => _verificationLevel = nyxx.VerificationLevel.high),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          child: Row(
                            children: [
                              CheckBoxIndicator(
                                selected: _verificationLevel == nyxx.VerificationLevel.high,
                                circular: true
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'High',
                                      style: TextStyle(
                                        color: Colors.yellow[900],
                                        fontSize: 16,
                                        fontFamily: 'GGSansSemibold'
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Must also be a member of this server for longer than 10 minutes.',
                                      style: TextStyle(
                                        color: _color2,
                                        fontSize: 12
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ),
                      Divider(
                        thickness: 1,
                        height: 0,
                        indent: 50,
                        color: _color6,
                      ),
                      ModerationOptionButton(
                        backgroundColor: Colors.transparent,
                        onPressedColor: _color5,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(16)
                        ),
                        onPressed: () => setState(() => _verificationLevel = nyxx.VerificationLevel.veryHigh),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          child: Row(
                            children: [
                              CheckBoxIndicator(
                                selected: _verificationLevel == nyxx.VerificationLevel.veryHigh,
                                circular: true
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Highest',
                                      style: TextStyle(
                                        color: Colors.red[600],
                                        fontSize: 16,
                                        fontFamily: 'GGSansSemibold'
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Must have a verified phone on their Discord',
                                      style: TextStyle(
                                        color: _color2,
                                        fontSize: 12
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Members of the server must meet the following criteria before they can send messages in text channels or initiate a direct message conversation. If a member has an assigned role and server onboarding is not enabled, this does not aply. We recommend setting a verification level for a Community Server.',
                  style: TextStyle(
                    color: _color2,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Explicit image filter',
                  style: TextStyle(
                    color: _color2,
                    fontSize: 14,
                    fontFamily: 'GGSansSemibold'
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: _color4,
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: Column(
                    children: [
                      ModerationOptionButton(
                        backgroundColor: Colors.transparent,
                        onPressedColor: _color5,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16)
                        ),
                        onPressed: () => setState(() => _explicitContentFilterLevel = nyxx.ExplicitContentFilterLevel.allMembers),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          child: Row(
                            children: [
                              CheckBoxIndicator(
                                selected: _explicitContentFilterLevel == nyxx.ExplicitContentFilterLevel.allMembers,
                                circular: true
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Filter messages from all members',
                                      style: TextStyle(
                                        color: _color1,
                                        fontSize: 16,
                                        fontFamily: 'GGSansSemibold'
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'All messages will be filtered for explicit images.',
                                      style: TextStyle(
                                        color: _color2,
                                        fontSize: 12
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ),
                      Divider(
                        thickness: 1,
                        height: 0,
                        indent: 50,
                        color: _color6,
                      ),
                      ModerationOptionButton(
                        backgroundColor: Colors.transparent,
                        onPressedColor: _color5,
                        onPressed: () => setState(() => _explicitContentFilterLevel = nyxx.ExplicitContentFilterLevel.membersWithoutRoles),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          child: Row(
                            children: [
                              CheckBoxIndicator(
                                selected: _explicitContentFilterLevel == nyxx.ExplicitContentFilterLevel.membersWithoutRoles,
                                circular: true
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Filter messages from server members without roles',
                                      style: TextStyle(
                                        color: _color1,
                                        fontSize: 16,
                                        fontFamily: 'GGSansSemibold'
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Messages from server members without a role will be filtered for explicit images.',
                                      style: TextStyle(
                                        color: _color2,
                                        fontSize: 12
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ),
                      Divider(
                        thickness: 1,
                        height: 0,
                        indent: 50,
                        color: _color6,
                      ),
                      ModerationOptionButton(
                        backgroundColor: Colors.transparent,
                        onPressedColor: _color5,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(16)
                        ),
                        onPressed: () => setState(() => _explicitContentFilterLevel = nyxx.ExplicitContentFilterLevel.disabled),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          child: Row(
                            children: [
                              CheckBoxIndicator(
                                selected: _explicitContentFilterLevel == nyxx.ExplicitContentFilterLevel.disabled,
                                circular: true
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Do not filter',
                                      style: TextStyle(
                                        color: _color1,
                                        fontSize: 16,
                                        fontFamily: 'GGSansSemibold'
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Messages will not be filtered for explicit images.',
                                      style: TextStyle(
                                        color: _color2,
                                        fontSize: 12
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Automatically block messages in this server that my contain explicit images in channels not marked as Age-restricted. Please choose how this filter will apply to members in your server. We recommend enabling this.',
                  style: TextStyle(
                    color: _color2,
                    fontSize: 14,
                  ),
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}

class ModerationOptionButton extends StatelessWidget {
  final Color backgroundColor;
  final Color? onPressedColor;
  final BorderRadius? borderRadius;
  final Function() onPressed;
  final Widget child;

  const ModerationOptionButton({
    required this.backgroundColor,
    this.onPressedColor,
    this.borderRadius,
    required this.onPressed,
    required this.child,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      onPressedColor: onPressedColor,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.zero
      ),
      applyClickAnimation: false,
      child: child,
    );
  }
}