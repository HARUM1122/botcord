import 'package:discord/src/common/providers/theme_provider.dart';
import 'package:discord/src/common/utils/extensions.dart';
import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/features/guild/screens/settings/overview/components/settings_button.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyxx/nyxx.dart' as nyxx;


class OverViewPage extends ConsumerStatefulWidget {
  final nyxx.Guild guild;
  const OverViewPage({required this.guild, super.key});
  @override
  ConsumerState<OverViewPage> createState() => _OverViewPageState();
}

class _OverViewPageState extends ConsumerState<OverViewPage> {
  late final String _theme = ref.read(themeProvider);

  late final TextEditingController _controller = TextEditingController(text: widget.guild.name);


  late final Color _color1 = appTheme<Color>(_theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
  late final Color _color2 = appTheme<Color>(_theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFFA8AAB0));
  
  late final Color _color3 = appTheme<Color>(_theme, light: const Color(0XFF565960), dark: const Color(0XFF878A93), midnight: const Color(0XFF838594));
  late final Color _color4 = appTheme<Color>(_theme, light: const Color(0xFFFFFFFF), dark: const Color(0xFF25282F), midnight: const Color(0XFF141318));

  late final Color _color5 = appTheme<Color>(_theme, light: const Color(0XFFE1E1E1), dark: const Color(0XFF2F323A), midnight: const Color(0XFF202226));

  late final Color _color6 = appTheme<Color>(_theme, light: const Color(0XFFEBEBEB), dark: const Color(0XFF2C2D36), midnight: const Color(0XFF1C1B21));

  // final Color color1 = appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
    // final Color color2 = appTheme<Color>(theme, light: const Color(0XFF4C4F57), dark: const Color(0XFFC8C9D1), midnight: const Color(0xFFFFFFFF));
    // final Color color3 = appTheme<Color>(theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFFA8AAB0));
    // final Color color4 = appTheme<Color>(theme, light: const Color(0XFFEBEBEB), dark: const Color(0XFF2C2D36), midnight: const Color(0XFF1C1B21));
    // final Color color5 =  appTheme<Color>(theme, light: const Color(0xFFFFFFFF), dark: const Color(0xFF25282F), midnight: const Color(0XFF141318));
    // final Color color6 = appTheme<Color>(theme, light: const Color(0XFFE1E1E1), dark: const Color(0XFF2F323A), midnight: const Color(0XFF202226));

  late String _guildName = widget.guild.name;

  // final Color color1 = appTheme<Color>(_theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
  //   final Color color2 = appTheme<Color>(_theme, light: const Color(0XFF565960), dark: const Color(0XFF878A93), midnight: const Color(0XFF838594));
  bool _saving = false;

  void _updateSettings() {}

  @override
  Widget build(BuildContext context) {
    bool hasMadeChanges = _guildName != widget.guild.name;
    return Scaffold(
      backgroundColor: appTheme<Color>(_theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0XFF141318)),
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
          'Overview',
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
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 10, left: 12, right: 12, bottom: context.padding.bottom + 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Server Name',
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
                  controller: _controller,
                  style: TextStyle(
                    color: _color1,
                    fontSize: 14
                  ),
                  onChanged: (text) {
                    if (_guildName.isEmpty || text.isEmpty) {
                      setState(() => _guildName = text);
                    } else {
                      _guildName = text;
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none
                    ),
                    contentPadding: const EdgeInsets.all(16),
                    hintText: "Bot's token",
                    hintStyle: TextStyle(
                      color: _color3,
                      fontSize: 14
                    ),
                    filled: true,
                    fillColor: appTheme<Color>(_theme, light: const Color(0XFFDDE1E4), dark: const Color(0XFF0F1316), midnight: const Color(0XFF0D1017)),
                  )
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Inactive Settings',
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
                  SettingsButton(
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
                          Text(
                            'Inactive Channel',
                            style: TextStyle(
                              color: _color1,
                              fontSize: 16,
                              fontFamily: 'GGSansSemibold'
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'No Inactive Channel',
                            style: TextStyle(
                              color: _color2,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.keyboard_arrow_right,
                            color: _color2,
                          )
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    height: 0,
                    indent: 15,
                    color: _color6,
                  ),
                  SettingsButton(
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
                          Text(
                            'Inactive Timeout',
                            style: TextStyle(
                              color: _color1,
                              fontSize: 16,
                              fontFamily: 'GGSansSemibold'
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'No Inactive Channel',
                            style: TextStyle(
                              color: _color2,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.keyboard_arrow_right,
                            color: _color2,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Automatically move members to this channel and mute then when they have been idle for longer than the inactive timeout. This does not affect browsers.',
              style: TextStyle(
                color: _color2,
                fontSize: 15,
              ),
            )
          ],
        ),
      ),
    );
  }
}



// class CustomToggleSwitch extends StatefulWidget {
//   @override
//   _CustomToggleSwitchState createState() => _CustomToggleSwitchState();
// }

// class _CustomToggleSwitchState extends State<CustomToggleSwitch> {
//   bool isToggled = false;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           isToggled = !isToggled;
//         });
//       },
//       child: Container(
//         width: 100,
//         height: 50,
//         padding: EdgeInsets.all(4),
//         decoration: BoxDecoration(
//           color: isToggled ? Colors.green : Colors.grey,
//           borderRadius: BorderRadius.circular(25),
//         ),
//         child: AnimatedAlign(
//           duration: Duration(milliseconds: 300),
//           curve: Curves.easeInOut,
//           alignment: isToggled ? Alignment.centerRight : Alignment.centerLeft,
//           child: Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               shape: BoxShape.circle,
//             ),
//             child: Center(
//               child: Icon(
//                 isToggled ? Icons.check : Icons.close,
//                 color: isToggled ? Colors.green : Colors.red,
//                 size: 24,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }