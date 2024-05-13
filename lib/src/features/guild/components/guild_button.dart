import 'package:flutter/material.dart';

import 'package:nyxx/nyxx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/guilds_controller.dart';

class GuildButton extends ConsumerWidget {
  final UserGuild guild;
  final bool selected;
  const GuildButton({required this.guild, required this.selected, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GuildsController guildsController = ref.read(guildsControllerProvider);
    return GestureDetector(
      onTap: () => guildsController.selectGuild(guild),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        width: 55,
        height: 55,
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: 6,
              height: selected ? 55 : 10,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight:Radius.circular(10))
              ),
            ),
            const SizedBox(width: 10),
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(selected ? 20 : 25)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
