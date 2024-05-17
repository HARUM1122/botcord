// import 'package:http/http.dart';
// import 'package:nyxx/nyxx.dart';

// import 'dart:async';

// Future<void> login(String token) async {
//     runZonedGuarded(
//       () async {
//         NyxxGateway client = await Nyxx.connectGateway(token, GatewayIntents.all);
//         User user = await client.user.get();
//         for (UserGuild guild in await client.listGuilds()) {
//           print(guild.name);
//         }
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
//   login('ODk4MzI4MjM3NTE4NzcwMTc4.GGwC7C.-DDGjDaDJvdP2u2aUkOhxm9ieZ8cQhx7-FhwkA');
// }

// void main() {
//   // List<int> values = [1, 2, 3, 4, 5];
//   // int finalValue = values.reduce((value, element) => value + element);
//   // print(finalValue);
//   String name = 'Nuke BOT';
//   String s = [for (String i in name.split(' ')) i[0]].join();
//   print(s);
// }

// import 'dart:collection';

// class Solution {
//   int findKthSmallest(List<int> coins, int k) {
//     // Create a min-heap (PriorityQueue in Dart)
//     PriorityQueue<List<int>> heap = PriorityQueue((a, b) => a[0].compareTo(b[0]));

//     // Initialize the heap with the first multiples of each coin
//     for (int coin in coins) {
//       heap.add([coin, coin]);
//     }

//     // Extract k elements from the heap
//     int count = 0;
//     int value = 0;
//     while (count < k) {
//       List<int> current = heap.removeFirst();
//       value = current[0];
//       int coin = current[1];
//       heap.add([value + coin, coin]);
//       count++;
//     }

//     return value;
//   }
// }

// // Example usage
// void main() {
//   Solution solution = Solution();

//   List<int> coins1 = [3, 6, 9];
//   int k1 = 3;
//   print(solution.findKthSmallest(coins1, k1)); // Output: 9

//   List<int> coins2 = [5, 2];
//   int k2 = 7;
//   print(solution.findKthSmallest(coins2, k2)); // Output: 12
// }

