import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/radio_button_indicator/radio_button_indicator2.dart';

import 'package:discord/theme_provider.dart';

import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/common/components/custom_button.dart';

import 'package:discord/src/features/profile/controller/profile_controller.dart';

class EditActivityScreen extends ConsumerStatefulWidget {
  const EditActivityScreen({super.key});

  @override
  ConsumerState<EditActivityScreen> createState() => _EditStatusPageState();
}

class _EditStatusPageState extends ConsumerState<EditActivityScreen> {
  late final String _theme = ref.read(themeProvider);
  late final ProfileController _profileController = ref.read(profileControllerProvider);

  late final String _prevActivityText = _profileController.botActivity['current-activity-text'];
  late final String _prevDuration = _profileController.botActivity['since'].split(';')[1];
  late final String _prevActivityType = _profileController.botActivity['current-activity-type'];

  late String _activityText = _prevActivityText;
  late String _duration = _prevDuration;
  late String _activityType = _prevActivityType;

  late final TextEditingController _controller = TextEditingController(text: _activityText);

  late final Color _color1 = appTheme<Color>(_theme, light: const Color(0XFFCCCED3), dark: const Color(0XFF1A1C20), midnight: const Color(0XFF1A1C22));

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme<Color>(_theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0xFF000000)),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          splashRadius: 18,
          icon: Icon(
            Icons.close,
            color: appTheme<Color>(_theme, light: const Color(0XFF50515B), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
          )
        ),
        title: Text(
          'Edit Activity',
          style: TextStyle(
            color: appTheme<Color>(_theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
            fontSize: 18,
            fontFamily: 'GGSansBold'
          ),
        ),
        centerTitle: true,
        actions: (_activityText != _prevActivityText 
        || _activityType != _prevActivityType 
        || _duration != _prevDuration) && _activityText.isNotEmpty ? [
          TextButton(
            style: const ButtonStyle(
              overlayColor: MaterialStatePropertyAll(Colors.transparent)
            ),
            onPressed: () {
              final Map<String, dynamic> botActivity = _profileController.botActivity;
              DateTime? now;
              if (_duration != _prevDuration) {
                now = DateTime.now();
                switch (_duration) {
                  case '24':
                    botActivity['since'] ='${now.add(const Duration(hours: 24)).toString()};$_duration';
                  case '4':
                    botActivity['since'] ='${now.add(const Duration(hours: 4)).toString()};$_duration';
                  case '1':
                    botActivity['since'] ='${now.add(const Duration(hours: 1)).toString()};$_duration';
                  case '30':
                    botActivity['since'] ='${now.add(const Duration(minutes: 30)).toString()};$_duration';
                  default:
                    botActivity['since'] =';';
                }
              }
              botActivity['current-activity-text'] = _activityText;
              botActivity['current-activity-type'] = _activityType;
              _profileController.updatePresence(save: true, datetime: now);
              Navigator.pop(context);
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: appTheme<Color>(_theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 8)
        ] : null
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                  child: Theme(
                    data: ThemeData(
                      textSelectionTheme: () {
                        final Color color = appTheme<Color>(_theme, light: const Color(0XFF565960), dark: const Color(0XFF878A93), midnight: const Color(0XFF838594));
                        return TextSelectionThemeData(
                          selectionColor: color.withOpacity(0.3),
                          cursorColor: color
                        );
                      }()
                    ),
                    child: TextField(
                      minLines: 4,
                      maxLines: 10,
                      maxLength: 128,
                      controller: _controller,
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
                      onChanged: (text) {
                        if (_activityText.isEmpty || text.isEmpty) {
                          setState(() => _activityText = text);
                        } else {
                          _activityText = text;
                        }
                      },
                      style: TextStyle(
                        color: appTheme<Color>(_theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
                        fontSize: 14
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none
                        ),
                        contentPadding: const EdgeInsets.all(16),
                        hintText: "What you're up to?",
                        hintStyle: TextStyle(
                          color: appTheme<Color>(_theme, light: const Color(0XFF565960), dark: const Color(0XFF878A93), midnight: const Color(0XFF838594)),
                          fontSize: 16
                        ),
                        filled: true,
                        fillColor: appTheme<Color>(_theme, light: const Color(0XFFDDE1E4), dark: const Color(0XFF0F1316), midnight: const Color(0XFF0D1017))
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Activity Type',
                  style: TextStyle(
                    color: appTheme<Color>(_theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFFA8AAB0)),
                    fontFamily: 'GGSansSemibold',
                    fontSize: 14
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                  decoration: BoxDecoration(
                    color: appTheme<Color>(_theme, light: const Color(0XFFDFE1E3), dark: const Color(0XFF0F1316), midnight: const Color(0XFF0F1014)),
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: Column(
                    children: [
                      RadioButtonTile(
                        title: 'Playing',
                        theme: _theme,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16)
                        ),
                        selected: _activityType == 'playing',
                        onPressed: () => setState(() => _activityType = 'playing')
                      ),
                      Divider(
                        color: _color1,
                        thickness: 1,
                        height: 0,
                        indent: 16,
                      ),
                      RadioButtonTile(
                        title: 'Watching',
                        theme: _theme,
                        borderRadius: BorderRadius.zero,
                        selected: _activityType == 'watching',
                        onPressed: () => setState(() => _activityType = 'watching')
                      ),
                      Divider(
                        color: _color1,
                        thickness: 1,
                        height: 0,
                        indent: 16,
                      ),
                      RadioButtonTile(
                        title: 'Listening',
                        theme: _theme,
                        borderRadius: BorderRadius.zero,
                        selected: _activityType == 'listening',
                        onPressed: () => setState(() => _activityType = 'listening')
                      ),
                      Divider(
                        color: _color1,
                        thickness: 1,
                        height: 0,
                        indent: 16,
                      ),
                      RadioButtonTile(
                        title: 'Competing',
                        theme: _theme,
                        borderRadius: BorderRadius.zero,
                        selected: _activityType == 'competing',
                        onPressed: () => setState(() => _activityType = 'competing')
                      ),
                      Divider(
                        color: _color1,
                        thickness: 1,
                        height: 0,
                        indent: 16,
                      ),
                      RadioButtonTile(
                        title: "Custom",
                        theme: _theme,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(16)
                        ),
                        selected: _activityType == 'custom',
                        onPressed: () => setState(() => _activityType = 'custom')
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35),
                Text(
                  'Status Duration',
                  style: TextStyle(
                    color: appTheme<Color>(_theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFFA8AAB0)),
                    fontFamily: 'GGSansSemibold',
                    fontSize: 14
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 4, right: 4, bottom: 16, top: 5),
                  decoration: BoxDecoration(
                    color: appTheme<Color>(_theme, light: const Color(0XFFDFE1E3), dark: const Color(0XFF0F1316), midnight: const Color(0XFF0F1014)),
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: Column(
                    children: [
                      RadioButtonTile(
                        title: 'Clear in 24 hours',
                        theme: _theme,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16)
                        ),
                        selected: _duration == '24',
                        onPressed: () => setState(() => _duration = '24')
                      ),
                      Divider(
                        color: _color1,
                        thickness: 1,
                        height: 0,
                        indent: 16,
                      ),
                      RadioButtonTile(
                        title: 'Clear in 4 hours',
                        theme: _theme,
                        borderRadius: BorderRadius.zero,
                        selected: _duration == '4',
                        onPressed: () => setState(() => _duration = '4')
                      ),
                      Divider(
                        color: _color1,
                        thickness: 1,
                        height: 0,
                        indent: 16,
                      ),
                      RadioButtonTile(
                        title: 'Clear in 1 hour',
                        theme: _theme,
                        borderRadius: BorderRadius.zero,
                        selected: _duration == '1',
                        onPressed: () => setState(() => _duration = '1')
                      ),
                      Divider(
                        color: _color1,
                        thickness: 1,
                        height: 0,
                        indent: 16,
                      ),
                      RadioButtonTile(
                        title: 'Clear in 30 minutes',
                        theme: _theme,
                        borderRadius: BorderRadius.zero,
                        selected: _duration == '30',
                        onPressed: () => setState(() => _duration = '30')
                      ),
                      Divider(
                        color: _color1,
                        thickness: 1,
                        height: 0,
                        indent: 16,
                      ),
                      RadioButtonTile(
                        title: "Don't clear",
                        theme: _theme,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(16)
                        ),
                        selected: _duration.isEmpty,
                        onPressed: () => setState(() => _duration = '')
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}

class RadioButtonTile extends StatelessWidget {
  final String title;
  final String theme;
  final BorderRadius borderRadius;
  final bool selected;
  final Function() onPressed;
  const RadioButtonTile({
    required this.title,
    required this.theme,
    required this.borderRadius,
    required this.selected,
    required this.onPressed,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      height: 60,
      onPressed: onPressed,
      backgroundColor: Colors.transparent,
      onPressedColor: appTheme<Color>(theme, light: const Color(0XFFC4C6C8), dark: const Color(0XFF212327), midnight: const Color(0XFF373A42)),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius
      ),
      applyClickAnimation: false,
      child: Row(
        children: [
          const SizedBox(width: 16),
          Text(
            title,
            style: TextStyle(
              color: appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
              fontSize: 16,
              fontFamily: 'GGSansSemibold'
            ),
          ),
          const Spacer(),
          RadioButtonIndicator2(
            radius: 20, 
            selected: selected
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}

