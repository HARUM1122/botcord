import 'package:flutter/material.dart';

import 'bot_tile.dart';

class BotsList extends StatelessWidget {
  final Map<String, dynamic> bots;
  const BotsList({
    required this.bots,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    List<String> keys = bots.keys.toList();
    return Expanded(
      child: ListView.builder(
        itemCount: keys.length,
        itemBuilder: (context, index) => BotTile(
          title: keys[index], 
          bots: bots[keys[index]]!,
        ),
      ),
    );
  }
}