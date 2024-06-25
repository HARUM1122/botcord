import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:nyxx/nyxx.dart' hide ButtonStyle;
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/common/utils/extensions.dart';
import 'package:discord/src/common/utils/asset_constants.dart';
import 'package:discord/src/common/components/custom_button.dart';
import 'package:discord/src/common/controllers/theme_controller.dart';
import 'package:discord/src/common/components/toggle_switch_indicator.dart';

import 'package:discord/src/common/components/radio_button_indicator/radio_button_indicator.dart';

import '../components/delete_confirmation_dialog.dart';
import '../components/bottom_sheet/categories_sheet.dart';

import '../../../../utils/utils.dart';


class EditTextChannelScreen extends ConsumerStatefulWidget {
  final GuildTextChannel textChannel;
  final GuildCategory? parent;
  final Guild guild;

  const EditTextChannelScreen({
    required this.textChannel,
    required this.parent,
    required this.guild,
    super.key
  });

  @override
  ConsumerState<EditTextChannelScreen> createState() => _EditTextChannelScreenState();
}

class _EditTextChannelScreenState extends ConsumerState<EditTextChannelScreen> {
  late final String _theme = ref.read(themeController);

  late GuildCategory? _parent = widget.parent;

  late String _channelName = widget.textChannel.name;
  late String _channelTopic = widget.textChannel.topic ?? '';

  

  late bool _isAgeRestricted = widget.textChannel.isNsfw;

  late Duration? _rateLimitPerUser = widget.textChannel.rateLimitPerUser;
  late Duration _defaultAutoArchiveDuration = widget.textChannel.defaultAutoArchiveDuration;
  

  late final TextEditingController _channelNameController = TextEditingController(text: _channelName);
  late final TextEditingController _channelTopicController = TextEditingController(text: _channelTopic);




  late final Color _color1 = appTheme<Color>(_theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
  late final Color _color2 = appTheme<Color>(_theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFFA8AAB0));
  late final Color _color3 = appTheme<Color>(_theme, light: const Color(0XFF565960), dark: const Color(0XFF878A93), midnight: const Color(0XFF838594));
  late final Color _color4 = appTheme<Color>(_theme, light: const Color(0xFFFFFFFF), dark: const Color(0xFF25282F), midnight: const Color(0XFF141318));
  late final Color _color5 = appTheme<Color>(_theme, light: const Color(0XFFE1E1E1), dark: const Color(0XFF2F323A), midnight: const Color(0XFF202226));
  late final Color _color6 = appTheme<Color>(_theme, light: const Color(0XFFEBEBEB), dark: const Color(0XFF2C2D36), midnight: const Color(0XFF1C1B21));

  bool _saving = false;

  void _updateChannelSettings() async {
    setState(() => _saving = true);
    try {
      await widget.textChannel.update(
        GuildTextChannelUpdateBuilder(
          name: _channelName,
          topic: _channelTopic,
          isNsfw: _isAgeRestricted,
          rateLimitPerUser: _rateLimitPerUser,
          parentId: _parent?.id,
          defaultAutoArchiveDuration: _defaultAutoArchiveDuration
      ));
    } catch (e) {
      if (!mounted) return;
      showSnackBar(
        context: context, 
        theme: _theme,
        leading: Icon(
          Icons.error_outline,
          color: Colors.red[800],
        ),
        msg: () {
          if (e.toString().contains('Missing Permissions')) {
            return "Error, Missing permissions";
          }
          // TODO HANDLE ERRORS PROPERLY HERE
          return 'Unexpected error, Please retry';
        }()
      );
    }
    setState(() => _saving = false);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    bool hasMadeChanges = _channelName != widget.textChannel.name ||
    _channelTopic != (widget.textChannel.topic ?? '') || 
    _parent != widget.parent || _isAgeRestricted != widget.textChannel.isNsfw ||
    _rateLimitPerUser?.inSeconds != widget.textChannel.rateLimitPerUser?.inSeconds;

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
          'Channel Settings',
          style: TextStyle(
            color: _color1,
            fontFamily: 'GGSansBold',
            fontSize: 18
          ),
        ),
        actions: [
          TextButton(
            onPressed: hasMadeChanges
            ? _updateChannelSettings
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
                  return color.withOpacity(hasMadeChanges && _channelName.isNotEmpty ? 1 : 0.5);
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
                  'Channel Name',
                  style: TextStyle(
                    color: _color2,
                    fontSize: 14,
                    fontFamily: 'GGSansSemibold'
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: Theme(
                    data: ThemeData(
                      textSelectionTheme: () {
                        final Color color = _color3;
                        return TextSelectionThemeData(
                          selectionColor: color.withOpacity(0.3),
                          cursorColor: color
                        );
                      }()
                    ),
                    child: TextField(
                      controller: _channelNameController,
                      style: TextStyle(
                        color: _color1,
                        fontSize: 14
                      ),
                      maxLength: 100,
                      buildCounter: (context, {required currentLength, required isFocused, required maxLength}) => null,
                      onChanged: (text) => setState(() => _channelName = text),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none
                        ),
                        contentPadding: const EdgeInsets.all(16),
                        filled: true,
                        fillColor: appTheme<Color>(_theme, light: const Color(0XFFDDE1E4), dark: const Color(0XFF0F1316), midnight: const Color(0XFF0D1017)),
                      )
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Channel Topic',
                  style: TextStyle(
                    color: _color2,
                    fontSize: 14,
                    fontFamily: 'GGSansSemibold'
                  ),
                ),
                const SizedBox(height: 8),
                Theme(
                  data: ThemeData(
                    textSelectionTheme: () {
                      final Color color = _color3;
                      return TextSelectionThemeData(
                        selectionColor: color.withOpacity(0.3),
                        cursorColor: color
                      );
                    }()
                  ),
                  child: TextField(
                    minLines: 4,
                    maxLines: 10,
                    maxLength: 1024,
                    controller: _channelTopicController,
                    buildCounter: (context, {
                        required int currentLength, 
                        required bool isFocused, 
                        int? maxLength
                      }) {
                      return Container(
                        transform: Matrix4.translationValues(0, -30, 0),
                        child: Text(
                          (maxLength! - currentLength).toString(),
                          style: TextStyle(
                            color: appTheme<Color>(_theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFF858893)),
                            fontFamily: 'GGSansBold',
                            fontSize: 12
                          )
                        ),
                      );
                    },
                    onChanged: (text) => setState(() => _channelTopic = text),
                    style: TextStyle(
                      color: _color1,
                      fontSize: 14
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none
                      ),
                      contentPadding: const EdgeInsets.all(16),
                      filled: true,
                      fillColor: appTheme<Color>(_theme, light: const Color(0XFFDDE1E4), dark: const Color(0XFF0F1316), midnight: const Color(0XFF0D1017))
                    )
                  ),
                ),
                EditOptionButton(
                  onPressed: () async {
                    final dynamic result = await showSheet(
                      context: context, 
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16)
                      ),
                      color: appTheme<Color>(_theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0xFF000000)),
                      builder:(context, controller, offset) => CategoriesSheet(
                        controller: controller,
                        selectedCategoryId: _parent?.id,
                      ), 
                      height: 0.5, 
                      maxHeight: 0.8
                    );
                    if (result == null) return;
                    setState(() => _parent = result == 'Uncategorized' ? null : result);
                  },
                  backgroundColor: _color4,
                  onPressedColor: _color5,
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                    child: Row(
                      children: [
                        Icon(
                          Icons.folder,
                          color: _color1.withOpacity(0.8),
                          size: 22,
                        ),
                        const SizedBox(width: 14),
                        Text(
                          'Category',
                          style: TextStyle(
                            color: _color1,
                            fontSize: 16,
                            fontFamily: 'GGSansSemibold'
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _parent?.name ?? 'Uncategorized',
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: _color2,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: _color2,
                        ),
                      ],
                    ),
                  )
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _color4,
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: Column(
                    children: [
                      EditOptionButton(
                        backgroundColor: Colors.transparent,
                        onPressedColor: _color5,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16)
                        ),
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                AssetIcon.thumbPin,
                                height: 22,
                                colorFilter: ColorFilter.mode(
                                  _color1.withOpacity(0.8),
                                  BlendMode.srcIn
                                )
                              ),
                              const SizedBox(width: 14),
                              Text(
                                'Pinned Messages',
                                style: TextStyle(
                                  color: _color1,
                                  fontSize: 16,
                                  fontFamily: 'GGSansSemibold'
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: _color2,
                              ),
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
                      EditOptionButton(
                        backgroundColor: Colors.transparent,
                        onPressedColor: _color5,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(16)
                        ),
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                AssetIcon.link,
                                height: 22,
                                colorFilter: ColorFilter.mode(
                                  _color1.withOpacity(0.8),
                                  BlendMode.srcIn
                                )
                              ),
                              const SizedBox(width: 14),
                              Text(
                                'Invites',
                                style: TextStyle(
                                  color: _color1,
                                  fontSize: 16,
                                  fontFamily: 'GGSansSemibold'
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: _color2,
                              ),
                            ],
                          ),
                        )
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                EditOptionButton(
                  onPressed: () => setState(() => _isAgeRestricted = !_isAgeRestricted),
                  backgroundColor: _color4,
                  onPressedColor: _color5,
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                    child: Row(
                      children: [
                        Text(
                          'Age-Restricted Channel',
                          style: TextStyle(
                            color: _color1,
                            fontSize: 16,
                            fontFamily: 'GGSansSemibold'
                          ),
                        ),
                        const Spacer(),
                        ToggleSwitchIndicator(
                          toggled: _isAgeRestricted
                        ),
                      ]
                    )
                  )
                ),
                const SizedBox(height: 10),
                Text(
                  'Users will need to confirm they are of over legal age to view in the content in this channel.\nAge-restircted channels are exempt from the explicit content filter.',
                  style: TextStyle(
                    color: _color2,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                EditOptionButton(
                  onPressed: () {},
                  backgroundColor: _color4,
                  onPressedColor: _color5,
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Slowmode Cooldown',
                              style: TextStyle(
                                color: _color1,
                                fontSize: 16,
                                fontFamily: 'GGSansSemibold'
                              )
                            ),
                            const Spacer(),
                            Text(
                              _rateLimitPerUser != null ? getDuration(_rateLimitPerUser!) : 'Slowmode is off.',
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: _color2,
                                fontSize: 16,
                              ),
                            ),
                          ]
                        ),
                        const SizedBox(height: 6),
                        FlutterSlider(
                          values: switch(_rateLimitPerUser?.inSeconds ?? 1) {
                            5 => [2.0],
                            10 => [3.0],
                            15 => [4.0],
                            30 => [5.0],
                            60 => [6.0],
                            120 => [7.0],
                            300 => [8.0],
                            600 => [9.0],
                            900 => [10.0],
                            1800 => [11.0],
                            3600 => [12.0],
                            7200 => [13.0],
                            21600 => [14.0],
                            _=> [1.0]
                          },
                          handlerWidth: 14,
                          tooltip: FlutterSliderTooltip(disabled: true),
                          min: 1,
                          max: 14,
                          onDragging: (_, value,  __) => setState(() => _rateLimitPerUser = switch(value) {
                            2.0 => const Duration(seconds: 5),
                            3.0 => const Duration(seconds: 10),
                            4.0 => const Duration(seconds: 15),
                            5.0 => const Duration(seconds: 30),
                            6.0 => const Duration(seconds: 60),
                            7.0 => const Duration(seconds: 120),
                            8.0 => const Duration(seconds: 300),
                            9.0 => const Duration(seconds: 600),
                            10.0 => const Duration(seconds: 900),
                            11.0 => const Duration(seconds: 1800),
                            12.0 => const Duration(seconds: 3600),
                            13.0 => const Duration(seconds: 7200),
                            14.0 => const Duration(seconds: 21600),
                            _=> null
                          }),
                          handler: FlutterSliderHandler(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF969BF6).withOpacity(0.6),
                                shape: BoxShape.circle
                              ),
                            )
                          ),
                          trackBar: FlutterSliderTrackBar(
                            inactiveTrackBar: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: _color2.withOpacity(0.4),
                            ),
                            activeTrackBar: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: const Color(0XFF536CF8)
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ),
                const SizedBox(height: 10),
                Text(
                  'Members will be restricted to sending one message and creating one thread per this interval, unless they have Manage Channel or Manage Messages permissions.',
                  style: TextStyle(
                    color: _color2,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Hide After Inactivity',
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
                      EditOptionButton(
                        backgroundColor: Colors.transparent,
                        onPressedColor: _color5,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16)
                        ),
                        onPressed: () => setState(() => _defaultAutoArchiveDuration = const Duration(hours: 1)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                          child: Row(
                            children: [
                              Text(
                                '1 Hour',
                                style: TextStyle(
                                  color: _color1,
                                  fontSize: 16,
                                  fontFamily: 'GGSansSemibold'
                                ),
                              ),
                              const Spacer(),
                              RadioButtonIndicator(
                                radius: 24,
                                selected: _defaultAutoArchiveDuration.inHours == 1
                              )
                            ],
                          ),
                        )
                      ),
                      Divider(
                        thickness: 1,
                        height: 0,
                        indent: 15,
                        color: _color6,
                      ),
                      EditOptionButton(
                        backgroundColor: Colors.transparent,
                        onPressedColor: _color5,
                        onPressed: () => setState(() => _defaultAutoArchiveDuration = const Duration(days: 1)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                          child: Row(
                            children: [
                              Text(
                                '24 Hours',
                                style: TextStyle(
                                  color: _color1,
                                  fontSize: 16,
                                  fontFamily: 'GGSansSemibold'
                                ),
                              ),
                              const Spacer(),
                              RadioButtonIndicator(
                                radius: 24,
                                selected: _defaultAutoArchiveDuration.inHours == 24
                              )
                            ],
                          ),
                        )
                      ),
                      Divider(
                        thickness: 1,
                        height: 0,
                        indent: 15,
                        color: _color6,
                      ),
                      EditOptionButton(
                        backgroundColor: Colors.transparent,
                        onPressedColor: _color5,
                        onPressed: () => setState(() => _defaultAutoArchiveDuration = const Duration(days: 3)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                          child: Row(
                            children: [
                              Text(
                                '3 Days',
                                style: TextStyle(
                                  color: _color1,
                                  fontSize: 16,
                                  fontFamily: 'GGSansSemibold'
                                ),
                              ),
                              const Spacer(),
                              RadioButtonIndicator(
                                radius: 24,
                                selected: _defaultAutoArchiveDuration.inHours == 72
                              )
                            ],
                          ),
                        )
                      ),
                      Divider(
                        thickness: 1,
                        height: 0,
                        indent: 15,
                        color: _color6,
                      ),
                      EditOptionButton(
                        backgroundColor: Colors.transparent,
                        onPressedColor: _color5,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(16)
                        ),
                        onPressed: () => setState(() => _defaultAutoArchiveDuration = const Duration(days: 7)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                          child: Row(
                            children: [
                              Text(
                                '1 Week',
                                style: TextStyle(
                                  color: _color1,
                                  fontSize: 16,
                                  fontFamily: 'GGSansSemibold'
                                ),
                              ),
                              const Spacer(),
                              RadioButtonIndicator(
                                radius: 24,
                                selected: _defaultAutoArchiveDuration.inHours == 168
                              )
                            ]
                          )
                        )
                      )
                    ]
                  )
                ),
                const SizedBox(height: 10),
                Text(
                  'New threads will not show in the channel list after being inactive for the specified duration.',
                  style: TextStyle(
                    color: _color2,
                    fontSize: 14
                  )
                ),
                const SizedBox(height: 20),
                EditOptionButton(
                  onPressed: () {
                  },
                  backgroundColor: _color4,
                  onPressedColor: _color5,
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          AssetIcon.webhook,
                          height: 22,
                          colorFilter: ColorFilter.mode(
                            _color1.withOpacity(0.8),
                            BlendMode.srcIn
                          )
                        ),
                        const SizedBox(width: 14),
                        Text(
                          'Webhooks',
                          style: TextStyle(
                            color: _color1,
                            fontSize: 16,
                            fontFamily: 'GGSansSemibold'
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: _color2,
                        ),
                      ],
                    ),
                  )
                ),
                const SizedBox(height: 20),
                EditOptionButton(
                  backgroundColor: _color4,
                  onPressedColor: _color5,
                  borderRadius: BorderRadius.circular(16),
                  onPressed: () async {
                    bool? result = await showDialogBox<bool>(
                      context: context,
                      child: ChannelDeleteConfirmationDialog(channel: widget.textChannel)
                    );
                    if (result == null) {
                      return;
                    }
                    else if (result && context.mounted) {
                      Navigator.pop(context);
                    }
                    else if (!result && context.mounted) {
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
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                    child: Row(
                      children: [
                        Text(
                          'Delete Channel',
                          style: TextStyle(
                            color: Color(0XFFE8413A),
                            fontSize: 16,
                            fontFamily: 'GGSansSemibold'
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]
            )
          )
        )
      )
    );
  }
}


class EditOptionButton extends StatelessWidget {
  final Color backgroundColor;
  final Color? onPressedColor;
  final BorderRadius? borderRadius;
  final Function() onPressed;
  final Widget child;

  const EditOptionButton({
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