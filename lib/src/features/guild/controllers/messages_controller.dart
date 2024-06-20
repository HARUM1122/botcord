import 'dart:async';

import 'package:discord/src/common/utils/globals.dart';
import 'package:flutter/foundation.dart';

import 'package:nyxx/nyxx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessagesController extends ChangeNotifier {
  final List<Message> messages = [];
  bool fetchedAllMessages = false;

  StreamSubscription<MessageCreateEvent>? messageCreateEvent;
  StreamSubscription<MessageUpdateEvent>? messageUpdateEvent;
  StreamSubscription<MessageDeleteEvent>? messageDeleteEvent;
  StreamSubscription<MessageBulkDeleteEvent>? messageBulkDeleteEvent;
  StreamSubscription<InteractionCreateEvent<MessageComponentInteraction>>? interactionCreateEvent;

  StreamSubscription<MessageReactionAddEvent>? reactionAddEvent;
  StreamSubscription<MessageReactionRemoveEvent>? reactionRemoveEvent;
  StreamSubscription<MessageReactionRemoveEmojiEvent>? reactionRemoveEmojiEvent;
  StreamSubscription<MessageReactionRemoveAllEvent>? reactionRemoveAllEvent;

  Future<void> stopListeningEvents() async {
    await messageCreateEvent?.cancel();
    await messageUpdateEvent?.cancel();
    await messageDeleteEvent?.cancel();
    await messageBulkDeleteEvent?.cancel();
    await interactionCreateEvent?.cancel();
  }

  Future <void> listenMessagesEvents(GuildChannel channel) async {
    messages.clear();
    fetchedAllMessages = false;
    await stopListeningEvents();
    
    messageCreateEvent = client?.onMessageCreate.listen((event) {
      
    });
    messageUpdateEvent = client?.onMessageUpdate.listen((event) {

    });
    messageDeleteEvent = client?.onMessageDelete.listen((event) {

    });
    messageBulkDeleteEvent = client?.onMessageBulkDelete.listen((event) {

    });

    interactionCreateEvent = client?.onMessageComponentInteraction.listen((event) {

    });

    reactionAddEvent = client?.onMessageReactionAdd.listen((event) {

    });
  }

  Future<void> fetchMessages(GuildChannel channel) async {
    late final List<Message> allMessages;
    if (channel.type == ChannelType.guildText) {
      allMessages = await (channel as GuildTextChannel).messages.fetchMany(
        before: messages.isNotEmpty ? messages.first.id : null,
        limit: 50
      );
    } else {
      allMessages = await (channel as GuildVoiceChannel).messages.fetchMany(
        before: messages.isNotEmpty ? messages.first.id : null,
        limit: 50
      );
    }
    if (allMessages.length < 50) {
      fetchedAllMessages = true;
    }
    messages.insertAll(0, allMessages.reversed.toList());
    notifyListeners();
  }
}