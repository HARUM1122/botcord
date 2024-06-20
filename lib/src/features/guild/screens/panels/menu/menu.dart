import 'package:discord/src/features/guild/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:nyxx/nyxx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/common/utils/globals.dart';
import 'package:discord/src/common/utils/extensions.dart';
import 'package:discord/src/common/components/custom_button.dart';
import 'package:discord/src/common/controllers/theme_controller.dart';

import 'package:discord/src/features/guild/controllers/channels_controller.dart';
import 'package:discord/src/features/guild/screens/panels/menu/components/channels_list.dart';

import '../../../components/guild/list.dart';
import '../../../components/badges/badges.dart';
import '../../../components/bottom_sheet/guild_options/guild_options.dart';



class MenuScreen extends ConsumerStatefulWidget {
  final List<UserGuild> guilds;
  final Guild currentGuild;
  const MenuScreen({required this.guilds, required this.currentGuild, super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  late final String _theme = ref.read(themeController);
  
  late final Color _color1 = appTheme<Color>(_theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
  late final Color _color2 = appTheme<Color>(_theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFFA8AAB0));

  bool _running = false;
  Member? _member;
  Guild? _prevGuild;

  Future<Member?> _getMember(Guild guild) async {
    if (_member != null) return _member;
    _member =  await getMember(guild, user!.id);
    return _member;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: appTheme<Color>(
        _theme, light: const Color(0XFFECEEF0),
        dark: const Color(0XFF141318),
        midnight: const Color(0xFF000000)
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            color: Colors.transparent,
            child: GuildsList(
              guilds: widget.guilds,
              currentGuild: widget.currentGuild,
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: context.padding.top, right: 40),
              padding: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: appTheme<Color>(_theme, light: const Color(0XFFECEEF0), dark: const Color(0XFF1C1D23), midnight: const Color(0xFF000000)),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(26),
                  topRight: Radius.circular(6)
                )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.currentGuild.banner != null) Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(26),
                        topRight: Radius.circular(6)
                      ),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          widget.currentGuild.banner!.url.toString(),
                          errorListener: (error) {},
                        ),
                      )
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (_running) return;
                      _running = true;
                      try {
                        Guild guild = await widget.currentGuild.fetch(withCounts: true);
                        _running = false;
                        if (!context.mounted) return;
                        showSheet(
                          context: context,
                          height: 0.7,
                          maxHeight: 0.8,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)
                          ),
                          color: appTheme<Color>(_theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0xFF000000)),
                          builder: (context, controller, offset) => GuildOptionsSheet(
                            guild: guild, 
                            controller: controller
                          )
                        );
                      } catch (_) {
                        showSnackBar(
                          theme: _theme,
                          context: context, 
                          leading: Icon(
                            Icons.error_outline,
                            color: Colors.red[800],
                          ), 
                          msg: 'Unexpected error, Please retry.'
                        );
                      }
                    },
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        if (widget.currentGuild.features.hasCommunity) 
                          const CommunityBadge(size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.currentGuild.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: _color1,
                              fontSize: 20,
                              fontFamily: 'GGSansBold'
                            ),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: _color1.withOpacity(0.5),
                        ),
                        const SizedBox(width: 30)
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  StatefulBuilder(
                    builder: (_, setState) => Consumer(
                      builder: (_, ref, __) {
                        final GuildChannelsController channelsController = ref.watch(guildChannelsControllerProvider);
                        final List<GuildChannel> channels = channelsController.channels;
                        if (channels.isEmpty) {
                          return Expanded(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 18, right: 18),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'No channels here',
                                      style: TextStyle(
                                        color: _color1,
                                        fontSize: 18,
                                        fontFamily: 'GGSansBold'
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "This server might be empty or you don't have access to any channels.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: _color2,
                                        fontSize: 16,
                                        fontFamily: 'GGSansSemibold'
                                      ),
                                    ),
                                  ]
                                ),
                              )
                            ),
                          );
                        } else if (_member != null && _prevGuild?.id == widget.currentGuild.id) {
                          return Expanded(
                            child: ChannelsList(
                              channels: channels,
                              currentChannelId: channelsController.currentChannel?.id,
                              member: _member!
                            ),
                          );
                        }
                        _member = null;
                        _prevGuild = widget.currentGuild;
                        return FutureBuilder(
                          future: _getMember(widget.currentGuild),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Expanded(
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0XFF536CF8),
                                  ),
                                ),
                              );
                            }
                            else if (snapshot.hasError) {
                              return Expanded(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10, right: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Unexpected error, Please retry',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: _color1,
                                            fontSize: 16,
                                            fontFamily: 'GGSansSemibold'
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        CustomButton(
                                          width: 160,
                                          height: 40,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(45 * 0.5)
                                          ),
                                          backgroundColor: const Color(0XFF536CF8),
                                          onPressedColor: const Color(0XFF4658CA),
                                          applyClickAnimation: true,
                                          animationUpperBound: 0.04,
                                          child: const Center(
                                            child: Text(
                                              'Retry',
                                              style: TextStyle(
                                                color: Color(0xFFFFFFFF),
                                                fontFamily: 'GGSansSemibold'
                                              ),
                                            ),
                                          ),
                                          onPressed: () => setState(() {})
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else if (snapshot.data != null) {
                              return Expanded(
                                child: ChannelsList(
                                  channels: channels,
                                  currentChannelId: channelsController.currentChannel?.id,
                                  member: snapshot.data as Member,
                                ),
                              );
                            }
                            return const SizedBox();
                          }
                        );
                      }
                    ),
                  )
                ]
              ),
            ),
          )
        ],
      ),
    );
  }
}