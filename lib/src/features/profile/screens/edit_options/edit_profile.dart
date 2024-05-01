import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:nyxx/nyxx.dart' as nyxx;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/utils.dart';

import 'package:discord/src/common/utils/cache.dart';
import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/common/utils/extensions.dart';
import 'package:discord/src/common/utils/asset_constants.dart';

import 'package:discord/src/common/components/avatar/profile_pic.dart';
import 'package:discord/src/common/components/avatar/online_status/status.dart';

import 'package:discord/src/features/home/provider/bottom_nav.dart';
import 'package:discord/src/features/profile/controller/profile_controller.dart';


class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
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

  late final ProfileController _profileController = ref.read(profileControllerProvider);

  bool saving = false;

  @override
  void initState() {
    super.initState();
    
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _descriptionController.dispose();
  }

  Future<void> _updateProfile() async {
    setState(() => saving = true);
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
      ref.read(bottomNavProvider).refresh();
      context.pop();
    } catch (e) {
      if (!context.mounted) return;
      setState(() => saving = false);
      if (e is http.ClientException) {
        showSnackBar(
          context: context, 
          leading: Icon(
            Icons.error_outline,
            color: Colors.red[800],
          ), 
          msg: 'Network error'
        );
      } else {
        showSnackBar(
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
      backgroundColor: theme['color-10'],
      appBar: AppBar(
        backgroundColor: theme['color-11'],
        leading: IconButton(
          onPressed: context.pop,
          splashRadius: 18,
          icon: Icon(
            Icons.arrow_back,
            color: theme['color-03'],
          )
        ),
        title: Text(
          "Profile",
          style: TextStyle(
            color: theme['color-01'],
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
            child: !saving 
            ? Text(
              "Save",
              style: TextStyle(
                color: hasMadeChanges
                ? theme['color-13']
                : theme['color-13'].withOpacity(0.5),
                fontSize: 16,
                fontFamily: 'GGSansSemibold'
              ),
            )
            : SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  color: theme['color-02'],
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
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          height: 20,
                          AssetIcon.editPencil,
                          colorFilter: ColorFilter.mode(
                            theme['color-02'],
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
                    color: theme['color-12'],
                    borderRadius: BorderRadius.circular(6)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _username.isEmpty ? _prevUsername : _username,
                        style: TextStyle(
                          color: theme['color-01'],
                          fontSize: 24,
                          fontFamily: 'GGSansBold'
                        )
                      ),
                      Text(
                        '$_username#${user!.discriminator}',
                        style: TextStyle(
                          color: theme['color-01'],
                          fontSize: 14,
                        )
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'USERNAME',
                        style: TextStyle(
                          color: theme['color-03'],
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
                          color: theme['color-03'],
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
                backgroundColor: theme['color-10'],
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: theme['color-10'],
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          height: 16,
                          AssetIcon.editPencil,
                          colorFilter: ColorFilter.mode(
                            theme['color-02'],
                            BlendMode.srcIn
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: theme['color-10'],
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
  final Function(String text) onChanged;

  const CustomTextField({
    required this.controller,
    required this.hintText,
    required this.minLines,
    required this.maxLines,
    required this.onChanged,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Theme(
        data: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: theme['color-03'].withOpacity(0.3),
            cursorColor: theme['color-03']
          ),
        ),
        child: TextField(
          minLines: minLines,
          maxLines: maxLines,
          controller: controller,
          style: TextStyle(
            color: theme['color-01'],
            fontSize: 14,
          ),
          onChanged: onChanged,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(
                color: theme['color-04'],
                width: 0.5
              )
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(
                color: theme['color-04'],
                width: 0.5
              )
            ),
            fillColor: Colors.transparent,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(
              color: theme['color-03'],
              fontSize: 14
            ),
          ),
        ),
      ),
    );
  }
}