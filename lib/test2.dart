// import 'package:http/http.dart';
// import 'package:nyxx/nyxx.dart';

// import 'dart:async';

// Future<void> login(String token) async {
//         NyxxGateway client = await Nyxx.connectGateway(token, GatewayIntents.all);
//         User user = await client.user.get();
//         List<Guild> guilds = [];
//         client.onGuildCreate.listen((event) async {
//           Guild guild = await event.guild.fetch(withCounts: true);

//           print(guild.currentUserPermissions);
//         });
//         // print(guilds[0].approximateMemberCount);
//   }

// void main() {
//   login('MTAxNDkwOTkyMTYwMDQ3NTIxOA.G3R5vy.__YiSq_aIqmujOxXjiidtaqNNVJDYU-rUeTvzk');
//   int a = 12;
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
// class A {}

// void main() {
//   const a = [#a, #b];
//   const b = #hello;
// }

void main() {
  int a = 12;
  switch (a) {
    case 12 || 45 || 23:
      print('helllo world');
    default:
      print('aslfd');
  }
}

// import 'dart:math';

// class GuildChannel {
//   String name;
//   String type; // 'text', 'voice', 'category'
//   int position;

//   GuildChannel(this.name, this.type, this.position);

//   @override
//   String toString() => 'GuildChannel(name: $name, type: $type, position: $position)';
// }

// List<GuildChannel> sortChannels(List<GuildChannel> channels) {
//   channels.sort((a, b) {
//     // First, compare by type priority
//     int typeComparison = getTypePriority(a.type).compareTo(getTypePriority(b.type));
//     if (typeComparison != 0) {
//       return typeComparison;
//     }

//     // If types are the same, compare by position
//     return a.position.compareTo(b.position);
//   });
//   return channels;
// }

// int getTypePriority(String type) {
//   switch (type) {
//     case 'text':
//       return 0;
//     case 'voice':
//       return 1;
//     case 'category':
//       return 2;
//     default:
//       return 3; 
//   }
// }

// void main() {
//   List<GuildChannel> channels = List.generate(500, (int index) {
//     final Random r = Random();
//     List<String> types = ['text', 'voice', 'category'];
//     int randomPostion = r.nextInt(120) + 1;
//     String randomType = types[r.nextInt(types.length)];
//     return GuildChannel('channel', randomType, randomPostion);
//   });
//   print("BEFORE");
//   print(channels);

  
//   // List<GuildChannel> channels = [
//   //   GuildChannel('category-2', 'category', 1),
//   //   GuildChannel('voice-channel-2', 'voice', 1),
//   //   GuildChannel('voice-channel-1', 'voice', 0),
//   //   GuildChannel('text-channel-2', 'text', 1),
//   //   GuildChannel('category-1', 'category', 0),
//   //   GuildChannel('text-channel-1', 'text', 0),
//   // ];

//   List<GuildChannel> sortedChannels = sortChannels(channels);
//   print("AFTER");
//   for (var channel in sortedChannels) {
//     print(channel);
//   }
// }
