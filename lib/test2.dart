import 'package:http/http.dart';
import 'package:nyxx/nyxx.dart';

import 'dart:async';

Future<void> login(String token) async {
    runZonedGuarded(
      () async {
        NyxxGateway client = await Nyxx.connectGateway(token, GatewayIntents.all);
        User user = await client.user.get();
        for (UserGuild guild in await client.listGuilds()) {
          print(guild.name);
        }
      }, 
      (error, stack) {
        if (error is ClientException) {
          print("CLIENT EXCEPTION");
        }
        print(error);
      }
    );
  }

void main() {
  login('ODk4MzI4MjM3NTE4NzcwMTc4.GGwC7C.-DDGjDaDJvdP2u2aUkOhxm9ieZ8cQhx7-FhwkA');
}

// void main() {
//   // List<int> values = [1, 2, 3, 4, 5];
//   // int finalValue = values.reduce((value, element) => value + element);
//   // print(finalValue);
//   String name = 'Nuke BOT';
//   String s = [for (String i in name.split(' ')) i[0]].join();
//   print(s);
// }