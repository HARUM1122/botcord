import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:page_animation_transition/animations/bottom_to_top_transition.dart';

import 'package:discord/src/common/controllers/theme_controller.dart';

import '../screens/screens.dart';

import '../components/online_status.dart';
import '../components/edit_option_button.dart';
import '../controller/profile_controller.dart';

import '../../../common/utils/utils.dart';
import '../../../common/utils/globals.dart';
import '../../../common/utils/extensions.dart';
import '../../../common/components/profile_pic.dart';
import '../../../common/components/online_status/status.dart';


class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ProfileController controller = ref.watch(profileControllerProvider);
    final String theme = ref.watch(themeController);
    
    final Color color1 = appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
    final Color color2 = appTheme<Color>(theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFF81818D));
    final Color color3 = appTheme<Color>(theme, light: const Color(0xFFFFFFFF), dark: const Color(0XFF25282F), midnight: const Color(0XFF151419));
    final Color color4 = appTheme<Color>(theme, light: const Color(0xFFFFFFFF), dark: const Color(0XFF25282F), midnight: const Color(0XFF151419));
    final Color color5 = appTheme<Color>(theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0xFF000000));

    final Map<String, dynamic> botActivity = controller.botActivity;
    final String seconds = controller.currentSeconds.toString().formatSeconds();

    return Material(
      color: color5,
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 150,
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(right: 12, top: context.padding.top + 4),
                  decoration: BoxDecoration(
                    image: banner != null ? DecorationImage(
                      image: MemoryImage(banner!.$1),
                      fit: BoxFit.cover
                    ) : null,
                    color: banner == null ? Colors.purple : null
                  ),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      )
                    ),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.settings,
                          color: Color(0xFFFFFFFF),
                          size: 20,
                        ),
                      ),
                    ),
                  )
                ),
                const SizedBox(height: 50),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: color3,
                        borderRadius: BorderRadius.circular(16)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user!.username,
                            style: TextStyle(
                              color: color1,
                              fontSize: 24,
                              fontFamily: 'GGSansBold'
                            )
                          ),
                          Text(
                            '${user!.username}#${user!.discriminator}',
                            style: TextStyle(
                              color: color1,
                              fontSize: 14,
                            )
                          ),
                          if (botActivity['current-activity-text'].isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 20, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${(botActivity['current-activity-type']  != 'custom' ? botActivity['current-activity-type'].toString().capitalize() : '').trim()} ${botActivity['current-activity-text']}",
                                    style: TextStyle(
                                      color: color2,
                                      fontFamily: 'GGSansSemibold'
                                    )
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      controller.timer?.cancel();
                                      controller.clearPresence();
                                      controller.updatePresence(save: true);
                                    },
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        color: appTheme<Color>(theme, light: const Color(0XFF4C4F56), dark: const Color(0XFFC5C8CF), midnight: const Color(0XFFC9C8CD)),
                                        shape: BoxShape.circle
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.close,
                                          color: appTheme<Color>(theme, light: const Color(0xFFFFFFFF), dark: const Color(0XFF31343B), midnight: const Color(0XFF201F27)),
                                          size: 12,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          const SizedBox(height: 10),
                          if (seconds.isNotEmpty) ...[
                            Text(
                              "Clears in $seconds",
                              style: TextStyle(
                                color: color2,
                                fontFamily: 'GGSansSemibold'
                              )
                            ),
                            const SizedBox(height: 10),
                          ],
                          Row(
                            children: [
                              EditOptionButton(
                                title: 'Edit Activity',
                                onPressed: () => Navigator.push(
                                  context,
                                  PageAnimationTransition(
                                    page: const EditActivityScreen(), 
                                    pageAnimationType: BottomToTopTransition()
                                  )
                                )
                              ),
                              const SizedBox(width: 10),
                              EditOptionButton(
                                title: 'Edit Profile',
                                onPressed: () => Navigator.push(
                                  context,
                                  PageAnimationTransition(
                                    page: const EditProfileScreen(), 
                                    pageAnimationType: RightToLeftTransition()
                                  )
                                )
                              )
                            ],
                          )
                        ],
                      )
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: color3,
                        borderRadius: BorderRadius.circular(16)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (application!.description.isNotEmpty)
                          ...[
                            Text(
                              'Description',
                              style: TextStyle(
                                color: color2,
                                fontFamily: 'GGSansSemibold'
                              )
                            ),
                            const SizedBox(height: 6),
                            Text(
                              application!.description,
                              style: TextStyle(
                                color: color1
                              )
                            ),
                            const SizedBox(height: 16),
                          ],
                          Text(
                            'Created At',
                            style: TextStyle(
                              color: color2,
                              fontFamily: 'GGSansSemibold'
                            )
                          ),
                          const SizedBox(height: 6),
                          Text(
                            DateFormat('MMM dd, yyyy').format(user!.id.timestamp),
                            style: TextStyle(
                              color: color1,
                              fontSize: 16
                            )
                          )
                        ],
                      )
                    ),
                    SizedBox(height: context.padding.bottom + 60)
                  ],
                )
              ],
            ),
            Positioned(
              left: 20,
              top: 105,
              child: ProfilePicWidget(
                onPressed: () => showSheet(
                  context: context,
                  height: 0.5,
                  maxHeight: 0.8,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16)
                  ),
                  color: color4,
                  builder: (context, controller, offset) => OnlineStatusSheet(controller: controller)
                ),
                radius: 90, 
                image: avatar?.$1 ?? (user?.avatar.url.toString() ?? ''),
                padding: const EdgeInsets.all(6),
                backgroundColor: color5,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: color4,
                      shape: BoxShape.circle
                    ),
                    child: getOnlineStatus(
                      controller.botActivity['current-online-status'], 
                      16
                    ),
                  ),
                ),
              )
            )
          ],
        ),
      )
    );
  }
}