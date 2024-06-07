import 'package:cached_network_image/cached_network_image.dart';
import 'package:discord/src/common/controllers/theme_controller.dart';
import 'package:discord/src/common/utils/asset_constants.dart';
import 'package:discord/src/common/utils/extensions.dart';
import 'package:discord/src/common/utils/globals.dart';
import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/features/guild/components/settings_button.dart';
import 'package:discord/src/features/guild/controllers/guilds_controller.dart';
import 'package:discord/src/features/guild/screens/settings/audit_log/audit_log.dart';
import 'package:discord/src/features/guild/screens/settings/audit_log/filter_pages/actions.dart';
import 'package:discord/src/features/guild/screens/settings/moderation/moderation.dart';
import 'package:discord/src/features/guild/screens/settings/overview/overview.dart';
import 'package:discord/src/features/guild/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyxx/nyxx.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

class GuildSettingsPage extends ConsumerWidget {
  const GuildSettingsPage({super.key});

  Future<Permissions?> computePerms(Guild? guild, User user) async {
    if (guild == null) return null;
    final Member member = await guild.members[user.id].get();
    return computePermissions(guild, member);
  }

//   CHANNEL CREATE EVENT INFO


// flutter: name : fasdfadsf
// flutter: type : 0
// flutter: permission_overwrites : []
// flutter: nsfw : false
// flutter: rate_limit_per_user : 0
// flutter: flags : 0


// VOICE CHANNEL CREATE EVENT

// flutter: name : asdfasdf
// flutter: type : 2
// flutter: bitrate : 64000
// flutter: user_limit : 0
// flutter: permission_overwrites : []
// flutter: nsfw : false
// flutter: rate_limit_per_user : 0
// flutter: flags : 0

// flutter: name : asdff
// flutter: type : 4
// flutter: permission_overwrites : []
// flutter: flags : 0


/// CHANNEL UPDATE INFO
/// flutter: nsfw : false
// flutter: name : fasdfadsfsfdasdfasdf
// flutter: default_auto_archive_duration : 10080
// flutter: topic : asdfasdfasdfasdfasfasdfasdf
// flutter: rate_limit_per_user : 120




  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.read(themeController);
    final GuildsController controller = ref.watch(guildsControllerProvider);
    final Guild? guild = controller.currentGuild;

    final Color color1 = appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
    final Color color2 = appTheme<Color>(theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFFA8AAB0));
    final Color color3 = appTheme<Color>(theme, light: const Color(0XFFEBEBEB), dark: const Color(0XFF2C2D36), midnight: const Color(0XFF1C1B21));
    final Color color4 = appTheme<Color>(theme, light: const Color(0xFFFFFFFF), dark: const Color(0xFF25282F), midnight: const Color(0XFF141318));
    final Color color5 = appTheme<Color>(theme, light: const Color(0XFFE1E1E1), dark: const Color(0XFF2F323A), midnight: const Color(0XFF202226));
    
    return Scaffold(
      appBar: AppBar(
        leading:  IconButton(
          onPressed: () => Navigator.pop(context),
          splashRadius: 18,
          icon: Icon(
            Icons.close,
            color: appTheme<Color>(theme, light: const Color(0XFF565960), dark: const Color(0XFF878A93), midnight: const Color(0XFF838594))
          )
        ),
        title: Text(
          'Server Settings',
          style: TextStyle(
            color: color1,
            fontFamily: 'GGSansBold',
            fontSize: 18
          ),
        ),
      ),
      backgroundColor: appTheme<Color>(theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0xFF000000)),
      body: FutureBuilder(
        future: computePerms(guild, user!),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0XFF536CF8),
              ),
            );
          }
          Permissions? perms = snapshot.data;
          if (perms != null) {
            final String? guildIcon = guild?.icon?.url.toString();
            return StretchingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (notification) {
                  notification.disallowIndicator();
                  return true;
                },
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(left: 12, right: 12, bottom: context.padding.bottom + 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: guildIcon == null 
                            ? const Color(0XFF536CF8)
                            : Colors.transparent,
                            image: guildIcon != null 
                            ? DecorationImage(
                              image: CachedNetworkImageProvider(
                                guildIcon,
                                errorListener: (error) {},
                              ),
                              fit: BoxFit.cover
                            )
                            : null
                          ),
                          child: guildIcon == null 
                          ? Center(
                            child: Text(
                              guild?.name[0] ?? '',
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
                          : null,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          guild?.name ?? '',
                          style: TextStyle(
                            color: color1,
                            fontSize: 14
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Settings',
                        style: TextStyle(
                          color: color2,
                          fontSize: 14,
                          fontFamily: 'GGSansSemibold'
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: color4,
                          borderRadius: BorderRadius.circular(16)
                        ),
                        child: Column(
                          children: [
                            SettingsButton(
                              enabled: perms.canManageGuild && guild != null,
                              backgroundColor: Colors.transparent,
                              onPressedColor: color5,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              title: 'Overview',
                              assetIcon: AssetIcon.info,
                              onPressed: () async {
                                if (!context.mounted) return;
                                Navigator.push(
                                  context,
                                  PageAnimationTransition(
                                    page: OverViewScreen(
                                      guild: guild!,
                                      inactiveChannel: guild.afkChannelId != null 
                                      ? (await guild.afkChannel!.get()) as GuildVoiceChannel 
                                      : null,
                                      systemChannel: guild.systemChannelId != null 
                                      ? (await guild.systemChannel?.get()) as GuildTextChannel 
                                      : null,
                                    ), 
                                    pageAnimationType: RightToLeftTransition()
                                  )
                                );
                              } 
                            ),
                            Divider(
                              thickness: 1,
                              height: 0,
                              indent: 53,
                              color: color3,
                            ),
                            SettingsButton(
                              enabled: perms.canManageGuild,
                              backgroundColor: Colors.transparent,
                              onPressedColor: color5,
                              title: 'Moderation',
                              assetIcon: AssetIcon.swords,
                              onPressed: () async {
                                if (!context.mounted) return;
                                Navigator.push(
                                  context,
                                  PageAnimationTransition(
                                    page: ModerationScreen(guild: guild!), 
                                    pageAnimationType: RightToLeftTransition()
                                  )
                                );
                              } 
                            ),
                            Divider(
                              thickness: 1,
                              height: 0,
                              indent: 53,
                              color: color3,
                            ),
                            SettingsButton(
                              enabled: perms.canViewAuditLog,
                              backgroundColor: Colors.transparent,
                              onPressedColor: color5,
                              title: 'Audit Log',
                              assetIcon: AssetIcon.document,
                              onPressed: () async {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => AuditLogPage(guild: guild)
                                //   )
                                // );

                                // MaterialPageRoute(
                                //     builder: (context) => AuditLogPage(guild: guild)
                                //   )


                                List<AuditLogEntry>? auditLogs = await guild?.auditLogs.list();
                                AuditLogEntry log = auditLogs![0];
                                print(log.actionType.name);
                                for (final change in log.changes!) {
                                  print("${change.key} : ${change.oldValue} : ${change.newValue}");
                                }
                                // final a = await createChannelAuditInfo(log);
                                // print("${a.$1.username} ${a.$2}");
                                // print("ALL CHANGES:");
                                // List<String> changes = a.$3;
                                // for (int i = 0; i < changes.length; i++) {
                                //   print("0$i ${changes[i]}");
                                // }
                                // print(log.actionType.name);
                                // for (final option in log)
                                // for (AuditLogEntry log in auditLogs ?? []) {
                                //   print(log.actionType);
                                // } 
                                // print("REASON: ${log.reason}");
                                // print(log.targetId);
                                // print((await log.user?.get())?.username);
                                // print("CHANGES\n");
                                //  for (AuditLogChange changes in log.changes?.toList() ?? []) {
                                //   print("${changes.key} : ${changes.newValue}");
                                // }
                                // print(log.)
                                // log.op
                                // for ()
                                // print(log.actionType);
                                // print(log.actionType.value);
                                // print(log.actionType.name);
                                // print(log.)
                                // for (AuditLogChange changes in log.changes!.toList()) {
                                //   print(changes.newValue);
                                // }
                                // for (final info in log.options) {
                                //   // print(info.);
                                // }
                                // print(log.actionType);
                                // print(log.actionType.name);
                                // print(log.actionType);
                                // print(log.changes);
                                // print(log.reason);
                              },    
                            ),
                            Divider(
                              thickness: 1,
                              height: 0,
                              indent: 53,
                              color: color3,
                            ),
                            SettingsButton(
                              enabled: perms.canManageChannels,
                              backgroundColor: Colors.transparent,
                              onPressedColor: color5,
                              title: 'Channels',
                              assetIcon: AssetIcon.list,
                              onPressed: () {},    
                            ),
                            Divider(
                              thickness: 1,
                              height: 0,
                              indent: 53,
                              color: color3,
                            ),
                            SettingsButton(
                              enabled: perms.canManageGuild,
                              backgroundColor: Colors.transparent,
                              onPressedColor: color5,
                              title: 'Integrations',
                              assetIcon: AssetIcon.gamingController,
                              onPressed: () {},    
                            ),
                            Divider(
                              thickness: 1,
                              height: 0,
                              indent: 53,
                              color: color3,
                            ),
                            SettingsButton(
                              enabled: perms.canManageEmojisAndStickers || perms.canCreateEmojiAndStickers,
                              backgroundColor: Colors.transparent,
                              onPressedColor: color5,
                              title: 'Emojis',
                              assetIcon: AssetIcon.emojiSmile,
                              onPressed: () {},    
                            ),
                            Divider(
                              thickness: 1,
                              height: 0,
                              indent: 53,
                              color: color3,
                            ),
                            SettingsButton(
                              enabled: perms.canManageWebhooks,
                              backgroundColor: Colors.transparent,
                              onPressedColor: color5,
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(16),
                              ),
                              title: 'Webhooks',
                              assetIcon: AssetIcon.webhook,
                              onPressed: () {},    
                            ),  
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'User Management',
                        style: TextStyle(
                          color: color2,
                          fontSize: 14,
                          fontFamily: 'GGSansSemibold'
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: color4,
                          borderRadius: BorderRadius.circular(16)
                        ),
                        child: Column(
                          children: [
                            SettingsButton(
                              enabled: perms.canBanMembers || perms.canKickMembers || perms.canManageNicknames,
                              backgroundColor: Colors.transparent,
                              onPressedColor: color5,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              title: 'Members',
                              assetIcon: AssetIcon.users,
                              onPressed: () {},    
                            ),
                            Divider(
                              thickness: 1,
                              height: 0,
                              indent: 53,
                              color: color3,
                            ),
                            SettingsButton(
                              enabled: perms.canManageRoles,
                              backgroundColor: Colors.transparent,
                              onPressedColor: color5,
                              title: 'Roles',
                              assetIcon: AssetIcon.userRole,
                              onPressed: () {},    
                            ),
                            Divider(
                              thickness: 1,
                              height: 0,
                              indent: 53,
                              color: color3,
                            ),
                            SettingsButton(
                              enabled: perms.canManageGuild,
                              backgroundColor: Colors.transparent,
                              onPressedColor: color5,
                              title: 'Invites',
                              assetIcon: AssetIcon.link,
                              onPressed: () {},    
                            ),
                            Divider(
                              thickness: 1,
                              height: 0,
                              indent: 53,
                              color: color3,
                            ),
                            SettingsButton(
                              enabled: perms.canBanMembers,
                              backgroundColor: Colors.transparent,
                              onPressedColor: color5,
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(16),
                              ),
                              title: 'Bans',
                              assetIcon: AssetIcon.hammer,
                              onPressed: () {},    
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Community',
                        style: TextStyle(
                          color: color2,
                          fontSize: 14,
                          fontFamily: 'GGSansSemibold'
                        ),
                      ),
                      const SizedBox(height: 8),
                      SettingsButton(
                        enabled: perms.canManageGuild,
                        backgroundColor: color4,
                        onPressedColor: color5,
                        borderRadius: BorderRadius.circular(16),
                        title: 'Enable Community',
                        assetIcon: AssetIcon.hammer,
                        onPressed: () {},    
                      )
                    ],
                  ),
                ),
              ),
            );
          }
          return const SizedBox();
        }
      )
    );
  }
}


/// helinity updated channel ovverides for #adfasd
/// 
/// 
/// HELINIFTY created a text channel
/// Changed the name to `name`
/// Set the type to 0 1 or 2
/// Set the channel to private
/// Allowed `length` users to access this channel