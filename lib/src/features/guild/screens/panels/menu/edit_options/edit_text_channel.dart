import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/common/utils/extensions.dart';
import 'package:discord/src/common/components/custom_button.dart';
import 'package:discord/src/common/controllers/theme_controller.dart';

import 'package:nyxx/nyxx.dart' hide ButtonStyle;

class EditTextChannelScreen extends ConsumerStatefulWidget {
  final GuildTextChannel textChannel;
  final Channel? parent;
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

  late String _channelName = widget.textChannel.name;
  late String _channelTopic = widget.textChannel.topic ?? '';

  late Channel? _parent = widget.parent;

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
  }

  @override
  Widget build(BuildContext context) {
    bool hasMadeChanges = _channelName != widget.textChannel.name ||
    _channelTopic != (widget.textChannel.topic ?? '') || 
    _parent != widget.parent;
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
                const SizedBox(height: 10),
                // SettingsButton(
                //   backgroundColor: backgroundColor,
                //   onPressed: onPressed,
                //   child: child
                // )
              ]
            )
          )
        )
      )
    );
  }
}


class SettingsButton extends StatelessWidget {
  final Color backgroundColor;
  final Color? onPressedColor;
  final BorderRadius? borderRadius;
  final Function() onPressed;
  final Widget child;

  const SettingsButton({
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
      height: 60,
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