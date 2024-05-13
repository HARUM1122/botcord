import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/theme_provider.dart';

import '../../../common/utils/utils.dart';
import '../../../common/utils/globals.dart';
import '../../../common/utils/extensions.dart';
import '../../../common/components/custom_button.dart';
import '../../../common/components/profile_pic.dart';
import '../../../common/components/online_status/status.dart';

import '../../../features/profile/components/status_sheet.dart';
import '../../../features/profile/controller/profile_controller.dart';


class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ProfileController controller = ref.watch(profileControllerProvider);
    final String theme = ref.watch(themeProvider);
    final Color color1 = appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
    final Color color2 = appTheme<Color>(theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFF81818D));
    final Map<String, dynamic> botActivity = controller.botActivity;
    String seconds = controller.currentSeconds.toString().formatSeconds();

    return Material(
      color: appTheme<Color>(theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0xFF000000)),
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
                    onTap: () => Navigator.pushNamed(context, '/settings-route'),
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
                          color: Colors.white,
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
                        color: appTheme<Color>(theme, light: const Color(0xFFFFFFFF), dark: const Color(0XFF25282F), midnight: const Color(0XFF151419)),
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
                              Expanded(
                                child: CustomButton(
                                  backgroundColor: appTheme<Color>(theme, light: const Color(0XFFDFE1E3), dark: const Color(0XFF373A42), midnight: const Color(0XFF2C2D36)),
                                  onPressedColor: appTheme<Color>(theme, light: const Color(0XFFC4C6C8), dark: const Color(0XFF4D505A), midnight: const Color(0XFF373A42)), 
                                  height: 40,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(context.getSize.width * 0.5)
                                  ),
                                  applyClickAnimation: true,
                                  onPressed: () =>  Navigator.pushNamed(context, '/edit-status-route'),
                                  child: Center(
                                    child: Text(
                                      "Edit Activity",
                                      style: TextStyle(
                                        color: color1,
                                        fontSize: 14,
                                        fontFamily: 'GGSansSemibold'
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomButton(
                                  height: 40,
                                  backgroundColor: appTheme<Color>(theme, light: const Color(0XFFDFE1E3), dark: const Color(0XFF373A42), midnight: const Color(0XFF2C2D36)),
                                  onPressedColor: appTheme<Color>(theme, light: const Color(0XFFC4C6C8), dark: const Color(0XFF4D505A), midnight: const Color(0XFF373A42)), 
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(context.getSize.width * 0.5)
                                  ),
                                  applyClickAnimation: true,
                                  onPressed: () => Navigator.pushNamed(context, '/edit-profile-route'),
                                  child: Center(
                                    child: Text(
                                      "Edit Profile",
                                      style: TextStyle(
                                        color: color1,
                                        fontSize: 14,
                                        fontFamily: 'GGSansSemibold'
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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
                        color: appTheme<Color>(theme, light: const Color(0xFFFFFFFF), dark: const Color(0XFF25282F), midnight: const Color(0XFF151419)),
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
                  color: appTheme<Color>(theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0xFF000000)),
                  builder: (context, controller, offset) => StatusSheet(controller: controller)
                ),
                radius: 90, 
                image: avatar?.$1 ?? (user?.avatar.url.toString() ?? ''),
                padding: const EdgeInsets.all(6),
                backgroundColor: appTheme<Color>(theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0xFF000000)),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: appTheme<Color>(theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0xFF000000)),
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