import 'package:http/http.dart';
import 'package:nyxx/nyxx.dart';

import 'dart:async';

Future<void> login(String token) async {
    runZonedGuarded(
      () async {
        NyxxGateway client = await Nyxx.connectGateway(token, GatewayIntents.all);
        User user = await client.user.get();
        print(user.avatar.url);
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
  login('ODkzNTcyNTk1NTQ1NDIzODgy.G9XCKt.mMwVRQ5WrmLx-kCBgLdo0nmAewtGPF7hFT2soE');
}

// void main() {
//   // List<int> values = [1, 2, 3, 4, 5];
//   // int finalValue = values.reduce((value, element) => value + element);
//   // print(finalValue);
//   String name = 'Nuke BOT';
//   String s = [for (String i in name.split(' ')) i[0]].join();
//   print(s);
// }