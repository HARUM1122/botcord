import 'package:discord/src/common/utils/globals.dart';
import 'package:discord/src/features/guild/components/bottom_sheet/guild_options/components/options_button.dart';
import 'package:flutter/material.dart';

import 'package:nyxx/nyxx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/common/utils/extensions.dart';
import 'package:discord/src/common/components/drag_handle.dart';
import 'package:discord/src/common/providers/theme_provider.dart';
import 'package:discord/src/common/components/online_status/online.dart';
import 'package:discord/src/common/components/online_status/invisible.dart';

import '../../badges/badges.dart';

class GuildOptionsSheet extends ConsumerWidget {
  final Guild guild;
  final ScrollController controller;

  const GuildOptionsSheet({
    required this.guild,
    required this.controller,
    super.key
  });



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.read(themeProvider);
    final Color color1 = appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
    final Color color2 = appTheme<Color>(theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFF81818D));

    final String? guildIcon = guild.icon?.url.toString();
    List<Widget> children = [
      Align(
        alignment: Alignment.topCenter,
        child: DragHandle(
          color: appTheme<Color>(theme, light: const Color(0XFFD8DADD), dark: const Color(0XFF2F3039), midnight: const Color(0XFF151518))
        )
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: guildIcon == null 
            ? const Color(0XFF536CF8)
            : Colors.transparent,
            image: guildIcon != null 
            ? DecorationImage(
              image: CachedNetworkImageProvider(
                guildIcon,
                errorListener: (error) {},
              ),
            )
            : null,
            borderRadius: BorderRadius.circular(15)
          ),
          child: guildIcon == null 
          ? Center(
            child: Text(
              guild.name[0],
              style: TextStyle(
                color: appTheme<Color>(
                  theme, 
                  light: const Color(0xFF000000),
                  dark: const Color(0xFFFFFFFF), 
                  midnight: const Color(0xFFFFFFFF)
                ),
                fontSize: 16,
              ),
            ),
          )
          : null
        ),
      ),
      const SizedBox(height: 20),
      Row(
        children: [
          if (guild.features.isVerified) ...[
            const VerifiedBadge(size: 20),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              guild.name,
              style: TextStyle(
                color: color1,
                fontSize: 20,
                fontFamily: 'GGSansBold'
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (guild.features.hasCommunity) ...[
            Container(
              width: 130,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: appTheme<Color>(theme, light: const Color(0XFFE0E3E7), dark: const Color(0XFF2A2D35), midnight: const Color(0XFF15191C))
              ),
              child: Row(
                children: [
                  const CommunityBadge(size: 14),
                  const SizedBox(width: 10),
                  Text(
                    'Community Server',
                    style: TextStyle(
                      color: color2,
                      fontSize: 12
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16)
          ],
          const OnlineStatus(radius: 8),
          const SizedBox(width: 6),
          () {
            int length = guild.approximatePresenceCount!;
            return Text(
              '$length ${length == 1 ? 'member' : 'members'}',
              style: TextStyle(
                color: color2,
                fontSize: 12
              ),
            );
          }(),
          const SizedBox(width: 16),
          const InvisibleStatus(radius: 8),
          const SizedBox(width: 6),
          () {
            int length = guild.approximateMemberCount!;
            return Text(
              '$length ${length == 1 ? 'member' : 'members'}',
              style: TextStyle(
                color: color2,
                fontSize: 12
              ),
            );
          }(),
        ],
      ),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          OptionButton(
            title: 'Invite',
            onPressed: () async {
              // print((await guild.members[user!.id].get()).permissions);

              // print((await member.roles[0].get()).permissions);
              Permissions perms = (await guild.members[user!.id].get()).permissions!;
            }
          ),
          OptionButton(
            title: 'Notifications',
            onPressed: () {}
          ),
          OptionButton(
            title: 'Settings',
            onPressed: () {}
          )
        ],
      )
    ];
    return ListView.builder(
      controller: controller,
      padding: EdgeInsets.only(top: 8, left: 16, right: 16, bottom: context.padding.bottom + 12),
      itemCount: children.length,
      itemBuilder: (context, idx) => children[idx],
    );
  }
}



// class LinkOptionsSheet extends ConsumerWidget {
//   final String link;
//   final ScrollController controller;
//   const LinkOptionsSheet({required this.link, required this.controller, super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final String theme = ref.read(themeProvider);
//     final Color color1 = appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
//     final Color color2 = appTheme<Color>(theme, light: const Color(0XFFEBEBEB), dark: const Color(0XFF2C2D36), midnight: const Color(0XFF1C1B21));
//     List<Widget> children = [
//       Align(
//         alignment: Alignment.topCenter,
//         child: DragHandle(
//           color: appTheme<Color>(theme, light: const Color(0XFFD8DADD), dark: const Color(0XFF2F3039), midnight: const Color(0XFF151518))
//         )
//       ),
//       const SizedBox(height: 8),
//       Align(
//         alignment: Alignment.topCenter,
//         child: Text(
//           "Link Options",
//           style: TextStyle(
//             color: color1,
//             fontFamily: 'GGSansBold',
//             fontSize: 18
//           ),
//         ),
//       ),
//       Align(
//         alignment: Alignment.topCenter,
//         child: Text(
//           link,
//           style: TextStyle(
//             color: appTheme<Color>(theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFF81818D)),
//             fontSize: 14,
//             fontFamily: 'GGSansSemibold'
//           ),
//         ),
//       ),
//       const SizedBox(height: 30),
//       DecoratedBox(
//         decoration: BoxDecoration(
//           color: appTheme<Color>(theme, light: const Color(0xFFFFFFFF), dark: const Color(0xFF25282F), midnight: const Color(0XFF141318)),
//           borderRadius: BorderRadius.circular(16)
//         ),
//         child: Column(
//           children: [
//             LinkOption(
//               title: 'Open Link',
//               onPressed: () async {
//                 Navigator.pop(context);
//                 Uri uri = Uri.parse(link);
//                 await launchUrl(uri);
//               },
//               borderRadius: const BorderRadius.vertical(
//                 top: Radius.circular(16)
//               ),
//               theme: theme,
//             ),
//             Divider(
//               thickness: 1,
//               height: 0,
//               indent: 50,
//               color: color2,
//             ),
//             LinkOption(
//               title: 'Copy Link',
//               onPressed: () async {
//                 await Clipboard.setData(ClipboardData(text: link));
//                 if (!context.mounted) return;
//                 showSnackBar(
//                   context: context, 
//                   theme: theme,
//                   leading: SvgPicture.asset(
//                     AssetIcon.link,
//                     colorFilter: ColorFilter.mode(color1, BlendMode.srcIn)
//                   ),
//                   msg: "Link copied"
//                 );
//               },
//               borderRadius: BorderRadius.zero,
//               theme: theme,
//             ),
//             Divider(
//               thickness: 1,
//               height: 0,
//               indent: 50,
//               color: color2,
//             ),
//             LinkOption(
//               title: 'Share Link',
//               onPressed: () => Share.share(link),
//               borderRadius: const BorderRadius.vertical(
//                 bottom: Radius.circular(16)
//               ),
//               theme: theme,
//             ),
//           ]
//         )
//       )
//     ];
//     return ListView.builder(
//       padding: EdgeInsets.only(top: 8, left: 12, right: 12, bottom: context.padding.bottom + 12),
//       controller: controller,
//       itemCount: children.length,
//       itemBuilder: (context, idx) => children[idx]
//     );
//   }
// }


// class LinkOption extends StatelessWidget {
//   final String title;
//   final Function() onPressed;
//   final BorderRadius borderRadius;
//   final String theme;
//   const LinkOption({
//     required this.title,
//     required this.onPressed,
//     required this.borderRadius,
//     required this.theme,
//     super.key
//   });
//   @override
//   Widget build(BuildContext context) {
//     return CustomButton(
//       backgroundColor: Colors.transparent,
//       onPressedColor: appTheme<Color>(theme, light: const Color(0XFFE1E1E1), dark: const Color(0XFF2F323A), midnight: const Color(0XFF202226)),
//       shape: RoundedRectangleBorder(
//         borderRadius: borderRadius
//       ),
//       onPressed: onPressed,
//       applyClickAnimation: false, 
//       child: Container(
//         margin: const EdgeInsets.all(20),
//         alignment: Alignment.centerLeft,
//         child: Text(
//           title,
//           style: TextStyle(
//             color: appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
//             fontSize: 16,
//             fontFamily: 'GGSansSemibold'
//           ),
//         ),
//       )
//     );
//   }
// }