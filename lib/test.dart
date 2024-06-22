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
// import 'dart:convert';

// void main() {
//   final Map<String, String> map = {"a":"b"};
//   final Map<String, String> map1 = {...map};
//   map1['a'] = 'c';
//   print(map);
// }

// class A {
//   int val = 213;
// }

// A? a;

// void main() {
//   List b = [
//     if (a?.val case final val?) val
//   ];
//   print(b);
// }


// int fact(int n) => n == 1 ? 1 : n * fact(n - 1);
// int sum(int n) => n == 1 ? 1 : n + sum(n - 1);

// import 'package:nyxx/nyxx.dart';

// void main() async {
//     NyxxGateway client = await Nyxx.connectGateway('MTAxMzcxMTEzMjIzMTQ4NzUwOA.GhWLfT.nwTYxR6199t2inN84-0luh7V_2oYwxcjQi6cCw', GatewayIntents.all);
//     client.onGuildCreate.listen((event) {
//       print("HELLO WORLD");
//     });
// }

// void main() {
//   List<int> lst = [];
//   print("abcdef".compareTo('abcd'));
// }

// String addCommas(String number) {
//   int count = 0;
//   String res = "";
//   for (int i = number.length - 1; i >= 0; i--) {
//     res = number[i] + res;
//     count++;
//     if (count % 3 == 0 && i != 0) {
//       res = ',$res';
//     }
//   }
//   return res;
// }

// void main() {
//   print(addCommas('1000'));
//   print(addCommas('100'));
//   print(addCommas('10'));
//   print(addCommas('60'));
//   print(addCommas('60100'));
//   print(addCommas('60100120310'));
//   print(addCommas('1230123'));
// }


// enum RichestPeople {
//   elon._(40000000000000000),
//   billgates._(69);
//   final int worth;
//   const RichestPeople._(this.worth);
// }

// void main() {
//   print(RichestPeople.elon.worth);
// }


