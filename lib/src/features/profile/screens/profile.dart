import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/utils.dart';
import '../../../common/utils/cache.dart';
import '../../../common/utils/extensions.dart';
import '../../../common/components/custom_button.dart';
import '../../../common/components/avatar/profile_pic.dart';
import '../../../common/components/avatar/online_status/status.dart';

import '../../../features/profile/components/status_sheet.dart';
import '../../../features/profile/controller/profile_controller.dart';


class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ProfileController profileController = ref.watch(profileControllerProvider);
    return Material(
      color: theme['color-11'],
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
                    onTap: () {
                      
                    },
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
               () {
                  final Map<String, dynamic> botActivity = profileController.botActivity;
                  String seconds = profileController.currentSeconds.toString().formatSeconds();
                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme['color-10'],
                          borderRadius: BorderRadius.circular(16)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user!.username,
                              style: TextStyle(
                                color: theme['color-01'],
                                fontSize: 24,
                                fontFamily: 'GGSansBold'
                              )
                            ),
                            Text(
                              '${user!.username}#${user!.discriminator}',
                              style: TextStyle(
                                color: theme['color-01'],
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
                                        color: theme['color-03'],
                                        fontFamily: 'GGSansSemibold'
                                      )
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        profileController.timer?.cancel();
                                        profileController.clearPresence();
                                        profileController.updatePresence(save: true);
                                      },
                                      child: Container(
                                        width: 15,
                                        height: 15,
                                        decoration: BoxDecoration(
                                          color: theme['color-02'],
                                          shape: BoxShape.circle
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.close,
                                            color: theme['color-11'],
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
                                  color: theme['color-03'],
                                  fontFamily: 'GGSansSemibold'
                                )
                              ),
                              const SizedBox(height: 10),
                            ],
                            Row(
                              children: [
                                Expanded(
                                  child: CustomButton(
                                    backgroundColor: theme['color-06'], 
                                    onPressedColor: theme['color-07'], 
                                    height: 40,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(context.getSize.width * 0.5)
                                    ),
                                    applyClickAnimation: true,
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/edit-status-route');
                                    },
                                    child: Center(
                                      child: Text(
                                        "Edit Activity",
                                        style: TextStyle(
                                          color: theme['color-01'],
                                          fontSize: 14
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: CustomButton(
                                    height: 40,
                                    backgroundColor: theme['color-06'], 
                                    onPressedColor: theme['color-07'], 
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(context.getSize.width * 0.5)
                                    ),
                                    applyClickAnimation: true,
                                    onPressed: () {
                                      // Navigator.pushNamed(context, '/edit-profile-route');
                                    },
                                    child: Center(
                                      child: Text(
                                        "Edit Profile",
                                        style: TextStyle(
                                          color: theme['color-01'],
                                          fontSize: 14
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme['color-10'],
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
                                  color: theme['color-03'],
                                  fontFamily: 'GGSansSemibold'
                                )
                              ),
                              const SizedBox(height: 6),
                              Text(
                                application!.description,
                                style: TextStyle(
                                  color: theme['color-02']
                                )
                              ),
                              const SizedBox(height: 16),
                            ],
                            Text(
                              'Discord Member Since',
                              style: TextStyle(
                                color: theme['color-03'],
                                fontFamily: 'GGSansSemibold'
                              )
                            ),
                            const SizedBox(height: 6),
                            Text(
                              DateFormat('MMM dd, yyyy').format(user!.id.timestamp),
                              style: TextStyle(
                                color: theme['color-02'],
                                fontSize: 16
                              )
                            )
                          ],
                        )
                      ),
                      SizedBox(height: context.padding.bottom + 60)
                    ],
                  );
                }()
              ],
            ),
            Positioned(
              left: 20,
              top: 105,
              child: () {
                return ProfilePicWidget(
                  onPressed: () => showSheet(
                    context: context,
                    height: 0.5,
                    maxHeight: 0.8,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16)
                    ),
                    color: theme['color-11'],
                    builder: (context, controller, offset) => StatusSheet(controller: controller)
                  ),
                  radius: 90, 
                  image: avatar?.$1 ?? user!.avatar.url.toString(),
                  padding: const EdgeInsets.all(6),
                  backgroundColor: theme['color-11'],
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme['color-11'],
                        shape: BoxShape.circle
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: getOnlineStatus(
                          profileController.botActivity['current-online-status'], 
                          16
                        ),
                      ),
                    ),
                  ),
                );
              }()
            )
          ],
        ),
      )
    );
  }
}