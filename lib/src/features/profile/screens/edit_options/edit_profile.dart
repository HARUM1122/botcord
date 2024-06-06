import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:nyxx/nyxx.dart' as nyxx;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/utils.dart';

import 'package:discord/src/common/controllers/theme_controller.dart';

import 'package:discord/src/common/utils/globals.dart';
import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/common/utils/asset_constants.dart';

import 'package:discord/src/common/components/profile_pic.dart';
import 'package:discord/src/common/components/online_status/status.dart';

import 'package:discord/src/features/auth/utils/utils.dart';
import 'package:discord/src/common/controllers/bottom_nav_controller.dart';
import 'package:discord/src/features/auth/controller/auth_controller.dart';
import 'package:discord/src/features/profile/controller/profile_controller.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final String _theme = ref.read(themeController);
  late final ProfileController _profileController = ref.read(profileControllerProvider);

  late final String _prevUsername = user!.username;
  late final String _prevDescription = application!.description;
  late final (Uint8List, String) _prevAvatar = avatar!;
  late final (Uint8List, String)? _prevBanner = banner;

  late String _username = _prevUsername;
  late String _description = _prevDescription;
  late (Uint8List, String) _avatar = _prevAvatar;
  late (Uint8List, String)? _banner = _prevBanner;

  late final TextEditingController _usernameController = TextEditingController(text: _username);
  late final TextEditingController _descriptionController = TextEditingController(text: _description);

  late final Color _color1 = appTheme<Color>(_theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
  late final Color _color2 = appTheme<Color>(_theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFFB1B1BB));
  late final Color _color3 = appTheme<Color>(_theme, light: const Color(0XFF565960), dark: const Color(0XFF878A93), midnight: const Color(0XFF838594));
  late final Color _color4 =  appTheme<Color>(_theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0XFF141318));

  bool _saving = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }


  Future<void> _updateProfile() async {
    setState(() => _saving = true);
    try {
      await _profileController.updateProfile(
        username: _username, 
        description: _description,
        avatar: nyxx.ImageBuilder(data: _avatar.$1, format: _avatar.$2),
        banner: _banner != null 
        ? nyxx.ImageBuilder(data: _banner!.$1, format: _banner!.$2)
        : null
      );
      avatar = _avatar;
      banner = _banner;
      final AuthController authController = ref.read(authControllerProvider);
      Map<String, dynamic> bots = authController.bots;
      String key = _prevUsername[0].toUpperCase();
      String newKey = _username[0].toUpperCase();
      dynamic bot = authController.getBotData(key, user!.id.toString());
      if (bot != null) {
        bot['name'] = _username;
        bot['avatar-url'] = user!.avatar.url.toString();
        authController.removeBot(key, user!.id.toString(), false);
        if (bots.containsKey(newKey)) {
          bots[newKey].add(bot);
        } else {
          bots[newKey] = [bot];
        }
        authController.bots = sort(bots);
        authController.save();
      }
      ref.read(bottomNavControler).refresh();
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      if (e is http.ClientException) {
        showSnackBar(
          theme: _theme,
          context: context, 
          leading: Icon(
            Icons.error_outline,
            color: Colors.red[800],
          ), 
          msg: 'Network error'
        );
      } else if (e.toString().contains('RATE_LIMIT')) {
        showSnackBar(
          theme: _theme,
          context: context, 
          leading: Icon(
            Icons.error_outline,
            color: Colors.red[800],
          ), 
          msg: "You're changing your profile too fast."
        );
      } else {
        showSnackBar(
          theme: _theme,
          context: context, 
          leading: Icon(
            Icons.error_outline,
            color: Colors.red[800],
          ), 
          msg: 'Unexpected error'
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasMadeChanges = _username != _prevUsername || 
      _description != _prevDescription || 
      !isSame(_avatar, _prevAvatar) ||
      !isSame(_banner ?? (Uint8List(0), ''), 
      _prevBanner ?? (Uint8List(0), '')
    );
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
          "Profile",
          style: TextStyle(
            color: _color1,
            fontFamily: 'GGSansBold',
            fontSize: 18
          ),
        ),
        actions: [
          TextButton(
            onPressed: hasMadeChanges
            ? _updateProfile
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
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 150,
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.only(right: 12, top: 12),
                  decoration: BoxDecoration(
                    image: _banner != null ? DecorationImage(
                      image: MemoryImage(_banner!.$1),
                      fit: BoxFit.cover
                    ) : null,
                    color: _banner == null ? Colors.purple : null
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      (Uint8List, String)? selectedBanner = await pickImage();
                      if (selectedBanner == null) return;
                      setState(() => _banner = selectedBanner);
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: appTheme<Color>(_theme, light: const Color(0xFFFFFFFF), dark: const Color(0xFF1A1D24), midnight: const Color(0XFF14141D)),
                        shape: BoxShape.circle
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          height: 20,
                          AssetIcon.editPencil,
                          colorFilter: ColorFilter.mode(
                            appTheme<Color>(_theme, light: const Color(0XFF565960), dark: const Color(0XFF878A93), midnight: const Color(0XFF515159)),
                            BlendMode.srcIn
                          ),
                        ),
                      ),
                    ),
                  )
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: appTheme<Color>(_theme, light: const Color(0xFFFFFFFF), dark: const Color(0XFF16151A), midnight: const Color(0XFF0B0A0D)),
                    borderRadius: BorderRadius.circular(6)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _username.isEmpty ? _prevUsername : _username,
                        style: TextStyle(
                          color: _color1,
                          fontSize: 24,
                          fontFamily: 'GGSansBold'
                        )
                      ),
                      Text(
                        '$_username#${user!.discriminator}',
                        style: TextStyle(
                          color: _color1,
                          fontSize: 14,
                        )
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'USERNAME',
                        style: TextStyle(
                          color: _color2,
                          fontSize: 12,
                          fontFamily: 'GGSansBold'
                        )
                      ),
                      const SizedBox(height: 5),
                      CustomTextField(
                        hintText: _prevUsername,
                        minLines: 1,
                        maxLines: 1,
                        controller: _usernameController,
                        theme: _theme,
                        onChanged: (currUsername) => setState(() => 
                        _username = currUsername.isEmpty 
                          ? _prevUsername 
                          : currUsername
                        )
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'DESCRIPTION',
                        style: TextStyle(
                          color: _color2,
                          fontSize: 12,
                          fontFamily: 'GGSansBold'
                        )
                      ),
                      const SizedBox(height: 5),
                      CustomTextField(
                        hintText: 'Tap to add description',
                        minLines: 4,
                        maxLines: 5,
                        controller: _descriptionController,
                        theme: _theme,
                        onChanged: (currDescription) => setState(() => 
                          _description = currDescription
                        )
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              left: 20,
              top: 95,
              child: ProfilePicWidget(
                onPressed: () async {
                  (Uint8List, String)? selectedAvatar = await pickImage();
                  if (selectedAvatar == null) return;
                  setState(() => _avatar = selectedAvatar);
                },
                radius: 90, 
                image: _avatar.$1,
                padding: const EdgeInsets.all(6),
                backgroundColor: _color4,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: _color4,
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          height: 18,
                          AssetIcon.editPencil,
                          colorFilter: ColorFilter.mode(
                            _color3,
                            BlendMode.srcIn
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: appTheme<Color>(_theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0XFF141318)),
                          shape: BoxShape.circle,
                        ),
                        child: getOnlineStatus(
                          _profileController.botActivity['current-online-status'], 
                          16
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),

    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hintText;
  final int minLines;
  final int maxLines;
  final TextEditingController controller;
  final String theme;
  final Function(String text) onChanged;

  const CustomTextField({
    required this.controller,
    required this.hintText,
    required this.minLines,
    required this.maxLines,
    required this.theme,
    required this.onChanged,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final Color color1 = appTheme<Color>(theme, light: const Color(0XFFE2E2E2), dark: const Color(0XFF333237), midnight: const Color(0XFF29282B));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Theme(
        data: ThemeData(
          textSelectionTheme: () {
            final Color color = appTheme<Color>(theme, light: const Color(0XFF565960), dark: const Color(0XFF878A93), midnight: const Color(0XFF838594));
            return TextSelectionThemeData(
              selectionColor: color.withOpacity(0.3),
              cursorColor: color
            );
          }()
        ),
        child: TextField(
          minLines: minLines,
          maxLines: maxLines,
          controller: controller,
          style: TextStyle(
            color: appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
            fontSize: 14,
          ),
          onChanged: onChanged,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(
                color: color1,
                width: 0.5
              )
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(
                color: color1,
                width: 0.5
              )
            ),
            fillColor: Colors.transparent,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(
              color: appTheme<Color>(theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFF81818D)),
              fontSize: 14
            ),
          ),
        ),
      ),
    );
  }
}