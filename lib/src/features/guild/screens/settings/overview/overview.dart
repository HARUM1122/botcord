import 'package:flutter/material.dart';

import 'package:nyxx/nyxx.dart' as nyxx;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/common/utils/globals.dart';
import 'package:discord/src/common/utils/extensions.dart';
import 'package:discord/src/common/controllers/theme_controller.dart';
import 'package:discord/src/common/components/toggle_switch_indicator.dart';
import 'package:discord/src/common/components/radio_button_indicator/radio_button_indicator2.dart';

import 'components/settings_button.dart';
import 'components/bottom_sheet/system_channels.dart';
import 'components/bottom_sheet/inactive_timeout.dart';
import 'components/bottom_sheet/inactive_channels.dart';

import '../../../utils/utils.dart';


class OverViewScreen extends ConsumerStatefulWidget {
  final nyxx.Guild guild;
  final nyxx.GuildVoiceChannel? inactiveChannel;
  final nyxx.GuildTextChannel? systemChannel;
  const OverViewScreen({
    required this.guild,
    required this.inactiveChannel,
    required this.systemChannel,
    super.key
  });
  @override
  ConsumerState<OverViewScreen> createState() => _OverViewPageState();
}

class _OverViewPageState extends ConsumerState<OverViewScreen> {
  late final String _theme = ref.read(themeController);

  late final TextEditingController _controller = TextEditingController(text: widget.guild.name);


  late final Color _color1 = appTheme<Color>(_theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
  late final Color _color2 = appTheme<Color>(_theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFFA8AAB0));
  late final Color _color3 = appTheme<Color>(_theme, light: const Color(0XFF565960), dark: const Color(0XFF878A93), midnight: const Color(0XFF838594));
  late final Color _color4 = appTheme<Color>(_theme, light: const Color(0xFFFFFFFF), dark: const Color(0xFF25282F), midnight: const Color(0XFF141318));
  late final Color _color5 = appTheme<Color>(_theme, light: const Color(0XFFE1E1E1), dark: const Color(0XFF2F323A), midnight: const Color(0XFF202226));
  late final Color _color6 = appTheme<Color>(_theme, light: const Color(0XFFEBEBEB), dark: const Color(0XFF2C2D36), midnight: const Color(0XFF1C1B21));
  
  // Server name
  late String _guildName = widget.guild.name;

  // Inactive Settings
  late nyxx.GuildVoiceChannel? _afkChannel = widget.inactiveChannel;
  late Duration _afkTimeout = widget.guild.afkTimeout;

  // System Messages Settings
  late nyxx.GuildTextChannel? _systemChannel = widget.systemChannel;
  late bool _suppressJoinNotifications = widget.guild.systemChannelFlags.shouldSuppressJoinNotifications;
  late bool _suppressJoinNotificationReplies = widget.guild.systemChannelFlags.shouldSuppressJoinNotificationReplies;
  late bool _suppressPremiumSubscriptions = widget.guild.systemChannelFlags.shouldSuppressPremiumSubscriptions;
  late bool _suppressGuildReminderNotifications = widget.guild.systemChannelFlags.shouldSuppressGuildReminderNotifications;

  // Default Notification Settings
  late nyxx.MessageNotificationLevel _messageNotificationLevel = widget.guild.defaultMessageNotificationLevel;

  bool _saving = false;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  nyxx.Flags<nyxx.SystemChannelFlags> getFlags({
    bool suppressJoinNotis = false, 
    bool suppressJoinNotisReplies = false, 
    bool suppressPremiumSubscriptions = false,
    bool suppressGuildReminderNotifications = false
  }) {
    const defaultFlag =  nyxx.Flag<nyxx.SystemChannelFlags>.fromOffset(32);
    return (suppressJoinNotis ? nyxx.SystemChannelFlags.suppressJoinNotifications : defaultFlag) | 
      (suppressJoinNotisReplies ? nyxx.SystemChannelFlags.suppressJoinNotificationReplies : defaultFlag) |
      (suppressPremiumSubscriptions ? nyxx.SystemChannelFlags.suppressPremiumSubscriptions : defaultFlag) |
      (suppressGuildReminderNotifications ? nyxx.SystemChannelFlags.suppressGuildReminderNotifications : defaultFlag);
  }

  void _updateSettings() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await widget.guild.update(
        nyxx.GuildUpdateBuilder(
          name: _guildName,
          afkChannelId: _afkChannel?.id,
          afkTimeout: _afkTimeout,
          systemChannelId: _systemChannel?.id,
          systemChannelFlags: getFlags(
            suppressJoinNotis: _suppressJoinNotifications,
            suppressJoinNotisReplies: _suppressJoinNotificationReplies,
            suppressPremiumSubscriptions: _suppressPremiumSubscriptions,
            suppressGuildReminderNotifications: _suppressGuildReminderNotifications
          ),
          defaultMessageNotificationLevel: _messageNotificationLevel
        )
      );
    } catch (_) {
      if (!mounted) return;
      showSnackBar(
        context: context, 
        theme: _theme,
        leading: Icon(
          Icons.error_outline,
          color: Colors.red[800],
        ),
        msg: 'Unexpected Error, Please try again.'
      );
    }
    setState(() => _saving = false);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    bool hasMadeChanges = _guildName != widget.guild.name 
    || _afkChannel?.id != widget.guild.afkChannelId
    || _afkTimeout.inSeconds != widget.guild.afkTimeout.inSeconds
    || _systemChannel?.id != widget.guild.systemChannelId
    || _suppressJoinNotifications != widget.guild.systemChannelFlags.shouldSuppressJoinNotifications
    || _suppressJoinNotificationReplies != widget.guild.systemChannelFlags.shouldSuppressJoinNotificationReplies
    || _suppressPremiumSubscriptions != widget.guild.systemChannelFlags.shouldSuppressPremiumSubscriptions
    || _suppressGuildReminderNotifications != widget.guild.systemChannelFlags.shouldSuppressGuildReminderNotifications
    || _messageNotificationLevel != widget.guild.defaultMessageNotificationLevel;

    return Scaffold(
      backgroundColor: appTheme<Color>(_theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0xFF000000)),
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
                  return color.withOpacity(hasMadeChanges ? 1 : 0.5);
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
      body: StretchingOverscrollIndicator(
        axisDirection: AxisDirection.down,
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowIndicator();
            return true;
          },
          child: SingleChildScrollView(
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
                      onChanged: (text) => setState(() => _guildName = text),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none
                        ),
                        contentPadding: const EdgeInsets.all(16),
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
                        onPressed: () async {
                          final dynamic result = await showSheet(
                            context: context, 
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)
                            ),
                            color: appTheme<Color>(_theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0xFF000000)),
                            builder:(context, controller, offset) => InactiveChannelsSheet(
                              controller: controller,
                              selectedInactiveChannelId: _afkChannel?.id,
                            ), 
                            height: 0.5, 
                            maxHeight: 0.8
                          );
                          if (result == null) return;
                          setState(() => _afkChannel = result == 'No Inactive Channel' ? null : result);
                        },
                        child: Row(
                          children: [
                            const SizedBox(width: 14),
                            Text(
                              'Inactive Channel',
                              style: TextStyle(
                                color: _color1,
                                fontSize: 16,
                                fontFamily: 'GGSansSemibold'
                              ),
                            ),
                            Expanded(
                              child: Text(
                                _afkChannel?.name ?? 'No Inactive Channel',
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: _color2,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: _color2,
                            ),
                            const SizedBox(width: 14)
                          ],
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
                        onPressedColor: _afkChannel != null ? _color5 : null,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(16)
                        ),
                        onPressed: () async {
                          if (_afkChannel != null) {
                            final Duration? duration = await showSheet(
                              context: context, 
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16)
                              ),
                              color: appTheme<Color>(_theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0xFF000000)),
                              builder:(context, controller, offset) => InactiveChannelsDurationSheet(
                                controller: controller,
                                durationInSeconds: _afkTimeout.inSeconds,
                              ), 
                              height: 0.5, 
                              maxHeight: 0.8
                            );
                            if (duration == null) return;
                            setState(() => _afkTimeout = duration);
                          }
                        },
                        child: Row(
                          children: [
                            const SizedBox(width: 14),
                            Text(
                              'Inactive Timeout',
                              style: TextStyle(
                                color: _color1.withOpacity(_afkChannel != null ? 1 : 0.4),
                                fontSize: 16,
                                fontFamily: 'GGSansSemibold'
                              ),
                            ),
                            const Spacer(),
                            Text(
                              _afkChannel != null ? getDuration(_afkTimeout) : '5 minutes',
                              style: TextStyle(
                                color: _afkChannel != null ? _color2 : _color2.withOpacity(0.5),
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: _color2,
                            ),
                            const SizedBox(width: 14)
                          ],
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
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'System Messages Settings',
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
                        onPressed: () async {
                          final dynamic result = await showSheet(
                            context: context, 
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)
                            ),
                            color: appTheme<Color>(_theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0xFF000000)),
                            builder:(context, controller, offset) => SystemChannelsSheet(
                              controller: controller,
                              selectedSystemChannelId: _systemChannel?.id,
                              // selectedInactiveChannelId: _afkChannel?.id,
                            ), 
                            height: 0.5, 
                            maxHeight: 0.8
                          );
                          if (result == null) return;
                          setState(() => _systemChannel = result == 'No System Messages' ? null : result);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                          child: Row(
                            children: [
                              Text(
                                'Channel',
                                style: TextStyle(
                                  color: _color1,
                                  fontSize: 16,
                                  fontFamily: 'GGSansSemibold'
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  _systemChannel != null ? _systemChannel!.name : 'No System Messages',
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: _color2,
                                    fontSize: 16,
                                  ),
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
                        onPressed: () => setState(() => _suppressJoinNotifications = !_suppressJoinNotifications),
                        child: Row(
                          children: [
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                'Send a random welcome message when someone joins this server.',
                                style: TextStyle(
                                  color: _color1,
                                  fontSize: 16,
                                  fontFamily: 'GGSansSemibold'
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ToggleSwitchIndicator(
                              toggled: !_suppressJoinNotifications
                            ),
                            const SizedBox(width: 14),
                          ],
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
                        onPressed: () => setState(() => _suppressJoinNotificationReplies = !_suppressJoinNotificationReplies),
                        child: Row(
                          children: [
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                'Prompt members to reply to welcome messages with a sticker.',
                                style: TextStyle(
                                  color: _color1,
                                  fontSize: 16,
                                  fontFamily: 'GGSansSemibold'
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ToggleSwitchIndicator(
                              toggled: !_suppressJoinNotificationReplies
                            ),
                            const SizedBox(width: 14),
                          ],
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
                        onPressed: () => setState(() => _suppressPremiumSubscriptions = !_suppressPremiumSubscriptions),
                        child: Row(
                          children: [
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                'Send a message when someone boosts this server.',
                                style: TextStyle(
                                  color: _color1,
                                  fontSize: 16,
                                  fontFamily: 'GGSansSemibold'
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ToggleSwitchIndicator(
                              toggled: !_suppressPremiumSubscriptions
                            ),
                            const SizedBox(width: 14),
                          ],
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
                        onPressed: () => setState(() => _suppressGuildReminderNotifications = !_suppressGuildReminderNotifications),
                        child: Row(
                          children: [
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                'Send helpful tips for server setup.',
                                style: TextStyle(
                                  color: _color1,
                                  fontSize: 16,
                                  fontFamily: 'GGSansSemibold'
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ToggleSwitchIndicator(
                              toggled: !_suppressGuildReminderNotifications
                            ),
                            const SizedBox(width: 14),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'This is the channel we send system event messages to. These can be turned off at any time.',
                  style: TextStyle(
                    color: _color2,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Default Notification Settings',
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
                        onPressed: () => setState(() => _messageNotificationLevel = nyxx.MessageNotificationLevel.allMessages),
                        child: Row(
                          children: [
                            const SizedBox(width: 14),
                            Text(
                              'All Messages',
                              style: TextStyle(
                                color: _color1,
                                fontSize: 16,
                                fontFamily: 'GGSansSemibold'
                              ),
                            ),
                            const Spacer(),
                            RadioButtonIndicator2(
                              radius: 24,
                              selected: _messageNotificationLevel == nyxx.MessageNotificationLevel.allMessages
                            ),
                            const SizedBox(width: 14)
                          ],
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
                        onPressed: () => setState(() => _messageNotificationLevel = nyxx.MessageNotificationLevel.onlyMentions),
                        child: Row(
                          children: [
                            const SizedBox(width: 14),
                            Text(
                              'Only @mentions',
                              style: TextStyle(
                                color: _color1,
                                fontSize: 16,
                                fontFamily: 'GGSansSemibold'
                              ),
                            ),
                            const Spacer(),
                            RadioButtonIndicator2(
                              radius: 24,
                              selected: _messageNotificationLevel == nyxx.MessageNotificationLevel.onlyMentions
                            ),
                            const SizedBox(width: 14)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'This will determine whether members who have not explicity set their notification settings recieve a notification for every message sent in this server or not. We highly recommend setting this to only @mentions for a Community Server.',
                  style: TextStyle(
                    color: _color2,
                    fontSize: 14,
                  ),
                ),
                if (widget.guild.ownerId == user!.id) ...[
                  const SizedBox(height: 20),
                  SettingsButton(
                    backgroundColor: _color4,
                    onPressedColor: _color5,
                    borderRadius: BorderRadius.circular(16),
                    onPressed: () => setState(() => _messageNotificationLevel = nyxx.MessageNotificationLevel.onlyMentions),
                    child: const Row(
                      children: [
                        SizedBox(width: 14),
                        Text(
                          'Delete Server',
                          style: TextStyle(
                            color: Color(0XFFE8413A),
                            fontSize: 16,
                            fontFamily: 'GGSansSemibold'
                          ),
                        ),
                        SizedBox(width: 14),
                      ],
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}