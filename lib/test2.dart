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

// void main() {
//   List<int> messages = [];
//   messages.first;
// }

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



// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:http/http.dart' as http;

// // Define constants
// const int chunkSize = 25 * 1024 * 1024; // 25 MB in bytes

// Future<void> uploadFile(File file, String path) async {

//   final fileLength = await file.length();
//   final totalChunks = (fileLength / chunkSize).ceil();
//   print("UPLOADING");
//   for (int i = 0; i < totalChunks; i++) {
//     final start = i * chunkSize;
//     final end = start + chunkSize > fileLength ? fileLength : start + chunkSize;
//     final chunk = await file.openRead(start, end).toList();
//     final chunkBytes = chunk.expand((bytes) => bytes).toList();
//     final base64Chunk = base64Encode(chunkBytes);
//     final String newFileName = '$i.chunk';
//     File newFile = File('$path\\$newFileName');
//     await newFile.writeAsString(base64Chunk);

//   }
//   print('File upload complete.');
// }

// // Future<File> retrieveFile(Uri downloadUri, String outputPath) async {
// //   final response = await http.get(downloadUri);

// //   if (response.statusCode != 200) {
// //     throw Exception('Failed to retrieve file');
// //   }

// //   final data = response.bodyBytes;
// //   final file = File(outputPath);
// //   await file.writeAsBytes(data);

// //   return file;
// // }

// void main() async {
//   final file = File(r"D:\harum\Desktop\New folder (16)\Discord.exe");
//   // final uploadUri = Uri.parse('https://discord.com/api/webhooks/1255608225907216434/Uc2ijXyVcoVaS1v_PYOlc7g1HYs_kGvmzKS3Tb1n6tIc5CXFDHlUJYih1Oo3l4pHBdsk');

//   // Upload the file
//   await uploadFile(file, r'D:\harum\Desktop\New folder (17)');
//   // List<List<int>> a = [[1, 2, 3], [4, 5, 6]];
//   // print(a.expand((e) {
//   //   print(e);
//   //   return e;
//   // }).toList());
//   // File f = File(r'D:\harum\Desktop\New folder (17)\newFile.txt');
//   // await f.writeAsString('hello world');


//   // Retrieve the file
//   // final downloadedFile = await retrieveFile(downloadUri, 'path/to/save/downloaded/file');
//   // print('Downloaded file saved to ${downloadedFile.path}');
// }




// import 'dart:io';
// import 'package:http/http.dart' as http;

// void main() async {
//   // https://discord.com/api/webhooks/1255608225907216434/Uc2ijXyVcoVaS1v_PYOlc7g1HYs_kGvmzKS3Tb1n6tIc5CXFDHlUJYih1Oo3l4pHBdsk
//   final res = await http.post(Uri.parse('https://discord.com/api/webhooks/1255608225907216434/Uc2ijXyVcoVaS1v_PYOlc7g1HYs_kGvmzKS3Tb1n6tIc5CXFDHlUJYih1Oo3l4pHBdsk'), body: {'content': 'hello'}, headers: {'Content-Type': 'application/json'});
//   print(res.body);
// }

// const int chunkSize = 25 * 1024 * 1024; // 25 MB in bytes

// // Function to divide file into chunks
// Future<void> divideFile(String filePath, String outputFolderPath) async {
//   final file = File(filePath);
//   // final fileSize = await file.length();
//   final directory = Directory(outputFolderPath);
//   if (!await directory.exists()) {
//     await directory.create(recursive: true);
//   }

//   final fileStream = file.openRead();
//   int chunkIndex = 0;
//   // int bytesRead = 0;
//   List<int> buffer = [];

//   await for (List<int> chunk in fileStream) {
//     buffer.addAll(chunk);
//     while (buffer.length >= chunkSize) {
//       final chunkFile = File('${directory.path}/chunk_$chunkIndex');
//       await chunkFile.writeAsBytes(buffer.sublist(0, chunkSize));
//       buffer = buffer.sublist(chunkSize);
//       chunkIndex++;
//     }
//     // bytesRead += chunk.length;
//   }

//   // Write remaining data to a final chunk if any
//   if (buffer.isNotEmpty) {
//     final chunkFile = File('${directory.path}/chunk_$chunkIndex');
//     await chunkFile.writeAsBytes(buffer);
//   }
// }

// // Function to combine chunks into a single file
// Future<void> combineChunks(String inputFolderPath, String outputFilePath) async {
//   final directory = Directory(inputFolderPath);
//   final outputFile = File(outputFilePath);

//   final chunks = directory
//       .listSync()
//       .whereType<File>()
//       .toList()
//     ..sort((a, b) => a.path.compareTo(b.path)); // Sort files by their path

//   final outputFileStream = outputFile.openWrite();

//   for (var chunk in chunks) {
//     final chunkBytes = await chunk.readAsBytes();
//     outputFileStream.add(chunkBytes);
//   }

//   await outputFileStream.close();
// }

// void main() async {
//   // Example usage:

//   // Split file into chunks
//   print('Enter the path of the file to be divided:');
//   String filePath = stdin.readLineSync()!;
//   print('Enter the folder path where chunks will be stored:');
//   String outputFolderPath = stdin.readLineSync()!;
//   await divideFile(filePath, outputFolderPath);
//   print('File has been divided into chunks.');

//   // Combine chunks into a single file
//   print('Enter the path of the folder containing the chunks:');
//   String inputFolderPath = stdin.readLineSync()!;
//   print('Enter the path of the output file:');
//   String outputFilePath = stdin.readLineSync()!;
//   await combineChunks(inputFolderPath, outputFilePath);
//   print('Chunks have been combined into the output file.');
// }

// import 'dart:io';

// const int chunkSize = 25 * 1024 * 1024; // 25 MB in bytes

// // Function to divide file into chunks
// Future<void> divideFile(String filePath, String outputFolderPath) async {
//   final file = File(filePath);
//   final directory = Directory(outputFolderPath);

//   if (!await directory.exists()) {
//     await directory.create(recursive: true);
//   }

//   final fileStream = file.openRead();
//   int chunkIndex = 0;
//   List<int> buffer = [];

//   await for (List<int> chunk in fileStream) {
//     buffer.addAll(chunk);
//     while (buffer.length >= chunkSize) {
//       final chunkFile = File('${directory.path}/chunk_$chunkIndex');
//       await chunkFile.writeAsBytes(buffer.sublist(0, chunkSize));
//       buffer = buffer.sublist(chunkSize);
//       chunkIndex++;
//     }
//   }

//   // Write remaining data to a final chunk if any
//   if (buffer.isNotEmpty) {
//     final chunkFile = File('${directory.path}/chunk_$chunkIndex');
//     await chunkFile.writeAsBytes(buffer);
//   }
// }

// // Function to combine chunks into a single file
// Future<void> combineChunks(String inputFolderPath, String outputFilePath) async {
//   final directory = Directory(inputFolderPath);
//   final outputFile = File(outputFilePath);

//   final chunks = directory
//     .listSync()
//     .whereType<File>()
//     .toList()
//     ..sort((a, b) => a.path.compareTo(b.path)); // Sort files by their path

//   final outputFileStream = outputFile.openWrite();

//   for (var chunk in chunks) {
//     final chunkBytes = await chunk.readAsBytes();
//     outputFileStream.add(chunkBytes);
//   }

//   await outputFileStream.close();
// }

// void main() async {


//   // Example usage:

//   // Split file into chunks



//   // print(bytes);
//   // file.openRead().listen((event) {
//   //   print(event.length);
//   // });
//   // print('Enter the path of the file to be divided:');
//   // String filePath = stdin.readLineSync()!;
//   // print('Enter the folder path where chunks will be stored:');
//   // String outputFolderPath = stdin.readLineSync()!;
//   // await divideFile(filePath, outputFolderPath);
//   // print('File has been divided into chunks.');

//   // // Combine chunks into a single file
//   // print('Enter the path of the folder containing the chunks:');
//   // String inputFolderPath = stdin.readLineSync()!;
//   // print('Enter the path of the output file:');
//   // String outputFilePath = stdin.readLineSync()!;
//   // await combineChunks(inputFolderPath, outputFilePath);
//   // print('Chunks have been combined into the output file.');
// }


// D:\harum\Desktop\New folder (16)\Discord.exe

// Enter the path of the file to be divided:
// D:\harum\Desktop\New folder (16)\Discord.exe  
// Enter the folder path where chunks will be stored:
// D:\harum\Desktop\New folder (17)
// File has been divided into chunks.
// Enter the path of the folder containing the chunks:

// import 'dart:io';
// import 'package:http/http.dart';


// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
// import 'package:nyxx/nyxx.dart';

// const String botToken = 'OTU1MTkzNTI0ODA5MjY5MzI4.G4jalL.TR0m0pjZjlJkZady9rbORJO1wBA_OJEIOvyH2c';
// const String channelId = '1256033100882903241';
// const int chunkSize = 25 * 1024 * 1024;

// Future<String> uploadChunksToDiscord(List<http.MultipartFile> files, int tries) async {
//   final uri = Uri.parse('https://discord.com/api/v10/channels/$channelId/messages');
//   final request = http.MultipartRequest('POST', uri)
//     ..headers['Authorization'] = 'Bot $botToken'
//     ..fields['content'] = 'here'
//     ..files.addAll(files);
//   final streamedResponse = await request.send();
//   final response = await http.Response.fromStream(streamedResponse);
//   // JUST ADD RETRY MECHANISM
//   return json.decode(response.body)['id'];
// }


// Future<List<String>> uploadFileToDiscord(String filePath) async {
//   final File file = File(filePath);
//   final List<String> messageIds = [];
//   final Stream<List<int>> fileStream = file.openRead();

//   List<int> buffer = [];
//   List<http.MultipartFile> files = [];
//   int chunkId = 0;

//   await for (final List<int> chunk in fileStream) {
//     buffer.addAll(chunk);
//     while (buffer.length >= chunkSize) {
//       files.add(http.MultipartFile.fromBytes('file$chunkId', buffer.sublist(0, chunkSize), filename: 'chunk no ${chunkId + 1}'));
//       buffer = buffer.sublist(chunkSize);
//       chunkId++;
//     }
//   }
//   if (buffer.isNotEmpty) {
//     if (files.length == 1) chunkId++;
//     files.add(http.MultipartFile.fromBytes('file$chunkId', buffer, filename: 'chunk no ${chunkId + 1}'));
//   }
//   while (files.isNotEmpty) {
//     final int n = files.length;
//     messageIds.add(await uploadChunksToDiscord(files.sublist(0, n < 10 ? n : 10), 0));
//     files = files.sublist(n < 10 ? n : 10);
//   }
//   return messageIds;
// }

// Future<void> downloadFile(Map<String, Object> data, String outputPath) async {
//   List<String> attachmentUrls = [];
//   for (final String id in data['file-chunks'] as List<String>) {
//     final res = await http.get(Uri.parse('https://discord.com/api/v10/channels/$channelId/messages/$id'), headers: {'Authorization': 'Bot $botToken'});
//     if (res.statusCode == 200) {
//       for (final Map attacment in jsonDecode(res.body)['attachments']) {
//         attachmentUrls.add(attacment['url']);
//       }
//     }
//   }
//   List<Future<http.Response>> tasks = [];
//   for (String url in attachmentUrls) {
//     tasks.add(http.get(Uri.parse(url)));
//   }
//   List<http.Response> res = await Future.wait(tasks);
//   File file = File('$outputPath\\${data['file-name']}.${data['file-extension']}');
//   final outputFileStream = file.openWrite();
//   for (final http.Response r in res) {
//     outputFileStream.add(r.bodyBytes);
//   }
//   outputFileStream.close();
// }


// void main() async {
//   // var stopwatch = Stopwatch();
//   // stopwatch.start();
//   // await uploadFileToDiscord(filePath)
//   // stopwatch.stop();
//   // print('TOTAL TIME TOOK: ${stopwatch.elapsedMilliseconds}');
//   // // print("UPLOADING FILE");
//   // // var stopwatch = Stopwatch();
//   // // stopwatch.start();
//   // // print(await uploadFileToDiscord(r"D:\harum\Desktop\New folder (16)\Discord.exe"));
//   // // stopwatch.stop();
//   // // print('Elapsed time: ${stopwatch.elapsedMilliseconds} milliseconds');
//   // // 1256039457803472926
//   // // final res = await http.get(Uri.parse('https://discord.com/api/v10/channels/$channelId/messages/1256039457803472926'), headers: {"Authorization": 'Bot $botToken'});
//   // // print(res.body);
//   // final res = await http.get(Uri.parse('https://cdn.discordapp.com/attachments/1256033100882903241/1256039451050643506/chunk_no_4?ex=667f5165&is=667dffe5&hm=667b97170d8ee283cb769d51fbc0232b59919f96685ae5e7623a9a9980687373&'));
  
//   // File file = File(r'D:\harum\Desktop\New folder (16)\newFile.exe');

//   // file.writeAsBytesSync(res.bodyBytes);
//   // print("DONE UPLOADING $id");
//   // final stopwatch = Stopwatch();
//   // stopwatch.start();
//   // await uploadFileToDiscord(r"D:\harum\Desktop\New folder (16)\Discord.exe");
//   // stopwatch.stop();
//   // print("ELAPSED TIME: ${stopwatch.elapsedMilliseconds}");
// }


// // 1255960520457064582


// // import 'dart:core';


// // SOME CALCULATIONS
// // THERE SHOULD BE 4 MESSAGES FOR A 1 GB FILE.
// // FOR 4 GB FILE, THERE SHOULD BE 16 MESSAGES. and 

// // EACH DATA FOR FILE IN DATA BASE SHOULD LOOK SOMETHING LIKE THIS
// /// {
// ///   file-name: yourfilename
// ///   file-extension: .py or anything,
// ///   chunks: [10000, 1000, 100] - LIST OF MESSAGE IDS
// /// }
// /// 
// /// UI: https://excalidraw.com/
// ///  

// import 'dart:io';

// int chunkSize = 25 * 1024 * 1024;


// Future<void> divideFile(String filePath, String outputFolderPath) async {
//   final file = File(filePath);
//   final directory = Directory(outputFolderPath);

//   if (!await directory.exists()) {
//     await directory.create(recursive: true);
//   }

//   final fileStream = file.openRead();
//   int chunkIndex = 0;
//   List<int> buffer = [];

//   await for (List<int> chunk in fileStream) {
//     buffer.addAll(chunk);
//     while (buffer.length >= chunkSize) {
//       final chunkFile = File('${directory.path}/chunk_$chunkIndex');
//       await chunkFile.writeAsBytes(buffer.sublist(0, chunkSize));
//       buffer = buffer.sublist(chunkSize);
//       chunkIndex++;
//     }
//   }

//   // Write remaining data to a final chunk if any
//   if (buffer.isNotEmpty) {
//     final chunkFile = File('${directory.path}/chunk_$chunkIndex');
//     await chunkFile.writeAsBytes(buffer);
//   }
// }

// // Function to combine chunks into a single file
// Future<void> combineChunks(String inputFolderPath, String outputFilePath) async {
//   final directory = Directory(inputFolderPath);
//   final outputFile = File(outputFilePath);

//   final chunks = directory
//       .listSync()
//       .whereType<File>()
//       .toList()
//     ..sort((a, b) {
//       print(a.path);
//       return a.path.compareTo(b.path);
//     }); // Sort files by their path

//   final outputFileStream = outputFile.openWrite();

//   for (var chunk in chunks) {
//     final chunkBytes = await chunk.readAsBytes();
//     outputFileStream.add(chunkBytes);
//   }

//   await outputFileStream.close();
// }

// // void main() {
// //   divideFile(r'D:\harum\Desktop\New folder (19)', r'D:\harum\Desktop\New folder (19)')
// // }
import 'dart:io';
import 'package:nyxx/nyxx.dart';
const String botToken = 'OTU1MTkzNTI0ODA5MjY5MzI4.G4jalL.TR0m0pjZjlJkZady9rbORJO1wBA_OJEIOvyH2c';
const String channelId = '1256033100882903241';
void main() async {
  NyxxGateway client = await Nyxx.connectGateway(botToken, GatewayIntents.all);
  GuildTextChannel channel = (await client.channels.fetch(const Snowflake(1256033100882903241))) as GuildTextChannel;
  try {
                                  print("SENDING MESSAGE");
                                  Stopwatch w = Stopwatch();
                                  w.start();
                                  await channel.sendMessage(
                                    MessageBuilder(
                                      attachments: [
                                        AttachmentBuilder(
                                          data: await File(r"D:\harum\Desktop\New folder (16)\newFile.exe").readAsBytes(),
                                          fileName: 'one.txt'
                                        ),
                                        AttachmentBuilder(
                                          data: await File(r"D:\harum\Desktop\New folder (16)\newFile.exe").readAsBytes(),
                                          fileName: 'two.txt'
                                        )
                                      ]
                                    )
                                  );
                                  w.stop();
                                  print(w.elapsedMilliseconds);
                                } catch (e) {
                                  print(e);
                                }
}