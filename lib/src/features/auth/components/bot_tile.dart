import 'package:flutter/material.dart';

import 'bot_options_sheet.dart';

import '../../../common/utils/utils.dart';
import '../../../common/utils/cache.dart';
import '../../../common/components/custom_button.dart';
import '../../../common/components/avatar/profile_pic.dart';

class BotTile extends StatelessWidget {
  final String title;
  final dynamic bots;
  const BotTile({
    required this.title,
    required this.bots,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: theme['color-03'],
              fontSize: 16,
              fontFamily: 'GGSansSemibold'
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: theme['color-10'],
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              for (int index = 0; index < bots.length; index++) ...[
                  BotInfo(
                    bot: bots[index],
                    isFirst: index == 0,
                    isLast: index == bots.length - 1,
                  ),
                  Offstage(
                    offstage: bots.length == 1 || index == bots.length - 1,
                    child: Divider(
                      thickness: 0.2,
                      indent: 50,
                      height: 0,
                      color: theme['color-04'],
                    ),
                  )
                ]
              ],
            )
          ) 
        ],
      ),
    );
  }
}

class BotInfo extends StatelessWidget {
  final Map<String, dynamic> bot;
  final bool isFirst;
  final bool isLast;
  const BotInfo({
    required this.bot,
    required this.isFirst,
    required this.isLast,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: () {
        showSheet(
          context: context, 
          builder: (context, controller, offset) => BotOptionsSheet(
            controller: controller, 
            bot: bot
          ),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(16)
          ),
          height: 0.5, 
          maxHeight: 0.8,
          color: theme['color-11']
        );
      },
      backgroundColor: Colors.transparent,
      onPressedColor: theme['color-12'],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(14) : Radius.zero,
          bottom: isLast ? const Radius.circular(14) : Radius.zero,
        )
      ),
      applyClickAnimation: false,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfilePicWidget(
              image: bot['avatar-url']!, 
              radius: 30, 
              backgroundColor: Colors.transparent,
              padding: const EdgeInsets.all(2),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                bot['name']!,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: theme['color-01'],
                  fontSize: 16,
                  fontFamily: 'GGSansSemibold'
                ),
              ),
            ),
            Icon(
              Icons.more_vert,
              color: theme['color-01']
            ),
          ],
        ),
      ),
    );
  }
}