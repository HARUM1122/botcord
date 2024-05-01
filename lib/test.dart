// import 'package:http/http.dart';
// import 'package:nyxx/nyxx.dart';

// import 'dart:async';

// Future<void> login(String token) async {
//     runZonedGuarded(
//       () async {
//         NyxxGateway client = await Nyxx.connectGateway(token, GatewayIntents.all);
//       }, 
//       (error, stack) {
//         if (error is ClientException) {
//           print("CLIENT EXCEPTION");
//         }
//         print(error);
//       }
//     );
//   }

// void main() {
//   login('MTAxMzcxMTEzMjIzMTQ4NzUwOA.GnzcwX.TyFxqL5qXdAHQ9hd5cTZ7sjPkh0ohIoXwA5Bnw');
// }
import 'dart:convert';

void main() {
  final Map<String, String> map = {"a":"b"};
  final Map<String, String> map1 = {...map};
  map1['a'] = 'c';
  print(map);
}