import 'dart:typed_data';

import 'package:discord/src/common/components/avatar.dart';
import 'package:discord/src/common/utils/globals.dart';
import 'package:flutter/material.dart';

import 'package:nyxx/nyxx.dart';

import 'package:discord/src/common/utils/extensions.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../../../common/components/radio_button_indicator/radio_button_indicator2.dart';

import 'package:discord/src/common/controllers/theme_controller.dart';

import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/common/components/custom_button.dart';

import 'package:discord/src/features/profile/controller/profile.dart';

class CreateGuildScreen extends ConsumerStatefulWidget {
  const CreateGuildScreen({super.key});

  @override
  ConsumerState<CreateGuildScreen> createState() => _EditActivityScreenState();
}

class _EditActivityScreenState extends ConsumerState<CreateGuildScreen> {
  late final String _theme = ref.read(themeController);

  late final Color _color1 = appTheme<Color>(_theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
  late final Color _color2 = appTheme<Color>(_theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0xFF000000));

  late final Color _color3 = appTheme<Color>(_theme, light: const Color(0XFFDFE1E3), dark: const Color(0XFF0F1316), midnight: const Color(0XFF0F1014));
  late final Color _color4 = appTheme<Color>(_theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFFA8AAB0));

  String _serverName = '';
  (Uint8List, String)? _serverIcon;

  bool _running = false;

  void _pickImage() async {
    (Uint8List, String)? selectedIcon = await pickImage();
    if (selectedIcon == null) return;
    setState(() => _serverIcon = selectedIcon);
  }

  void _createServer() async {
    setState(() => _running = true);
    await client?.guilds.create(
      GuildBuilder(
        name: _serverName,
        icon: _serverIcon != null
        ? ImageBuilder(
          data: _serverIcon!.$1,
          format: _serverIcon!.$2
        )
        : null,
      )
    );
    setState(() => _running = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _color2,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          splashRadius: 18,
          icon: Icon(
            Icons.arrow_back,
            color: _color1.withOpacity(0.5),
          )
        )
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
          child: Column(
              children: [
                SizedBox(
                  height: context.getSize.height * 0.12
                ),
                Text(
                  'Create Your Server',
                  style: TextStyle(
                    color: _color1,
                    fontFamily: 'GGSansBold',
                    fontSize: 26
                  )
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: _pickImage,
                  child: _serverIcon == null 
                  ? Stack(
                    children: [
                      DottedBorder(
                        strokeCap: StrokeCap.square,
                        dashPattern: const [8, 12],
                        padding: const EdgeInsets.all(18),
                        borderType: BorderType.Circle,
                        color: _color1.withOpacity(0.8),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Column(
                            children: [
                              Icon(
                                Icons.camera_alt,
                                color: _color1.withOpacity(0.6),
                                size: 22,
                              ),
                              const Spacer(),
                              Text(
                                'UPLOAD',
                                style: TextStyle(
                                  color: _color1.withOpacity(0.6),
                                  fontSize: 10,
                                  fontFamily: 'GGSansSemibold'
                                ),
                              )
                            ],
                          ),
                        )
                      ),
                      Positioned(
                        right: 0,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: Color(0XFF536CF8),
                            shape: BoxShape.circle
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 18,
                          )
                        )
                      )
                    ]
                  ):
                  AvatarWidget(
                    onPressed: _pickImage,
                    image: _serverIcon!.$1,
                    radius: 76,
                    backgroundColor: Colors.transparent,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0XFF536CF8),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _color2,
                            width: 4,
                            strokeAlign: BorderSide.strokeAlignOutside
                          )
                        ),
                        child: const Icon(
                          Icons.image,
                          color: Colors.white,
                          size: 18,
                        )
                      )
                    )
                  )
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: Theme(
                    data: ThemeData(
                      textSelectionTheme: TextSelectionThemeData(
                        selectionColor: _color1.withOpacity(0.3),
                        cursorColor: _color1.withOpacity(0.5)
                      )
                    ),
                    child: TextField(
                      style: TextStyle(
                        color: _color1,
                        fontSize: 14
                      ),
                      onChanged: (text) {
                        if (_serverName.isEmpty || text.isEmpty) {
                          setState(() => _serverName = text);
                        } else {
                          _serverName = text;
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none
                        ),
                        contentPadding: const EdgeInsets.all(16),
                        hintText: 'Server name',
                        hintStyle: TextStyle(
                          color: _color1.withOpacity(0.5),
                          fontSize: 14
                        ),
                        filled: true,
                        fillColor: appTheme<Color>(_theme, light: const Color(0XFFDDE1E4), dark: const Color(0XFF0F1316), midnight: const Color(0XFF0D1017)),
                      )
                    ),
                  ),
                ),
                const Spacer(),
                CustomButton(
                  enabled: _serverName.isNotEmpty,
                  onPressed: _createServer,
                  backgroundColor: _serverName.isEmpty 
                  ? appTheme<Color>(_theme, light: const Color(0XFFA3AEF8), dark: const Color(0XFF384590), midnight: const Color(0XFF2A357D))
                  : const Color(0XFF536CF8),
                  onPressedColor: const Color(0XFF4658CA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.getSize.width * 0.5)
                  ),
                  animationUpperBound: 0.04,
                  applyClickAnimation: true,
                  width: double.infinity,
                  height: 50,
                  child: Center(
                    child: _running
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Color(0xFFFFFFFF),
                        strokeWidth: 2,
                      ),
                    )
                    : const Text(
                      'Create Server',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFFFFFFF),
                        fontFamily: 'GGsansSemibold'
                      )
                    )
                  )
                )
              ]
            ),
        ),
      ),
    );
  }
}







// AvatarWidget(
//                 onPressed: () async {
//                   (Uint8List, String)? selectedAvatar = await pickImage();
//                   if (selectedAvatar == null) return;
//                   setState(() => _avatar = selectedAvatar);
//                 },
//                 radius: 90, 
//                 image: _avatar.$1,
//                 padding: const EdgeInsets.all(6),
//                 backgroundColor: _color4,
//                 child: Align(
//                   alignment: Alignment.bottomRight,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(2),
//                         decoration: BoxDecoration(
//                           color: _color4,
//                           shape: BoxShape.circle,
//                         ),
//                         child: SvgPicture.asset(
//                           height: 18,
//                           AssetIcon.editPencil,
//                           colorFilter: ColorFilter.mode(
//                             _color3,
//                             BlendMode.srcIn
//                           ),
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.all(2),
//                         decoration: BoxDecoration(
//                           color: appTheme<Color>(_theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0XFF141318)),
//                           shape: BoxShape.circle,
//                         ),
//                         child: getOnlineStatus(
//                           _profileController.botActivity['current-online-status'], 
//                           16
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),