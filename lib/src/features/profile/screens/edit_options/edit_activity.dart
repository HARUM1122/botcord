import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/radio_button_indicator/radio_button_indicator2.dart';

import 'package:discord/src/common/utils/cache.dart';
import 'package:discord/src/common/components/custom_button.dart';

import 'package:discord/src/features/profile/controller/profile_controller.dart';

class EditActivityScreen extends ConsumerStatefulWidget {
  const EditActivityScreen({super.key});

  @override
  ConsumerState<EditActivityScreen> createState() => _EditStatusPageState();
}

class _EditStatusPageState extends ConsumerState<EditActivityScreen> {
  // late final ProfileController _profileController = ref.read(profileControllerProvider);

  // late final String _prevActivityText = _profileController.botActivity['current-activity-text'];
  // late final String _prevDuration = _profileController.botActivity['since'].split(';')[1];
  // late final String _prevActivityType = _profileController.botActivity['current-activity-type'];

  // late String _activityText = _prevActivityText;
  // late String _duration = _prevDuration;
  // late String _activityType = _prevActivityType;

  // late final TextEditingController _controller = TextEditingController(text: _activityText);

  // @override
  // void dispose() {
  //   super.dispose();
  //   _controller.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Container();
    // return Scaffold(
    //   backgroundColor: theme['color-11'],
    //   appBar: AppBar(
    //     leading: IconButton(
    //       onPressed: () => Navigator.pop(context),
    //       splashRadius: 18,
    //       icon: Icon(
    //         Icons.close,
    //         color: theme['color-01'],
    //       )
    //     ),
    //     title: Text(
    //       'Edit Activity',
    //       style: TextStyle(
    //         color: theme['color-01'],
    //         fontSize: 18,
    //         fontFamily: 'GGSansBold'
    //       ),
    //     ),
    //     centerTitle: true,
    //     actions: (_activityText != _prevActivityText 
    //     || _activityType != _prevActivityType 
    //     || _duration != _prevDuration) && _activityText.isNotEmpty ? [
    //       TextButton(
    //         style: const ButtonStyle(
    //           overlayColor: MaterialStatePropertyAll(Colors.transparent)
    //         ),
    //         onPressed: () {
    //           final Map<String, dynamic> botActivity = _profileController.botActivity;
    //           DateTime? now;
    //           if (_duration != _prevDuration) {
    //             now = DateTime.now();
    //             switch (_duration) {
    //               case '24':
    //                 botActivity['since'] ='${now.add(const Duration(hours: 24)).toString()};$_duration';
    //               case '4':
    //                 botActivity['since'] ='${now.add(const Duration(hours: 4)).toString()};$_duration';
    //               case '1':
    //                 botActivity['since'] ='${now.add(const Duration(hours: 1)).toString()};$_duration';
    //               case '30':
    //                 botActivity['since'] ='${now.add(const Duration(minutes: 30)).toString()};$_duration';
    //               default:
    //                 botActivity['since'] =';';
    //             }
    //           }
    //           botActivity['current-activity-text'] = _activityText;
    //           botActivity['current-activity-type'] = _activityType;
    //           _profileController.updatePresence(save: true, datetime: now);
    //           Navigator.pop(context);
    //         },
    //         child: Text(
    //           'Save',
    //           style: TextStyle(
    //             color: theme['color-01'],
    //             fontSize: 18,
    //           ),
    //         ),
    //       ),
    //       const SizedBox(width: 8)
    //     ] : null
    //   ),
    //   body: SafeArea(
    //     child: SingleChildScrollView(
    //       child: Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 12),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Padding(
    //               padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
    //               child: Theme(
    //                 data: ThemeData(
    //                   textSelectionTheme: TextSelectionThemeData(
    //                     selectionColor: theme['color-03'].withOpacity(0.3),
    //                     cursorColor: theme['color-03']
    //                   ),
    //                 ),
    //                 child: TextField(
    //                   minLines: 4,
    //                   maxLines: 10,
    //                   maxLength: 128,
    //                   controller: _controller,
    //                   buildCounter: (context, {
    //                       required int currentLength, 
    //                       required bool isFocused, 
    //                       int? maxLength
    //                     }) {
    //                     return Container(
    //                       transform: Matrix4.translationValues(0, -30, 0),
    //                       child: Text(
    //                         (maxLength! - currentLength).toString(),
    //                         style: TextStyle(
    //                           color: theme['color-03'],
    //                           fontFamily: 'GGSansBold',
    //                           fontSize: 12
    //                         )
    //                       ),
    //                     );
    //                   },
    //                   onChanged: (text) {
    //                     if (_activityText.isEmpty || text.isEmpty) {
    //                       setState(() => _activityText = text);
    //                     } else {
    //                       _activityText = text;
    //                     }
    //                   },
    //                   style: TextStyle(
    //                     color: theme['color-01']
    //                   ),
    //                   decoration: InputDecoration(
    //                     border: OutlineInputBorder(
    //                       borderRadius: BorderRadius.circular(14),
    //                       borderSide: BorderSide.none
    //                     ),
    //                     fillColor: theme['color-12'],
    //                     filled: true,
    //                     hintText: "What're you up to?",
    //                     hintStyle: TextStyle(
    //                       color: theme['color-03'],
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             const SizedBox(height: 10),
    //             Text(
    //               'Activity Type',
    //               style: TextStyle(
    //                 color: theme['color-03'],
    //                 fontFamily: 'GGSansSemibold',
    //                 fontSize: 14
    //               ),
    //             ),
    //             Container(
    //               width: double.infinity,
    //               margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
    //               decoration: BoxDecoration(
    //                 color: theme['color-12'],
    //                 borderRadius: BorderRadius.circular(16)
    //               ),
    //               child: Column(
    //                 children: [
    //                   RadioButtonTile(
    //                     title: 'Playing',
    //                     borderRadius: const BorderRadius.vertical(
    //                       top: Radius.circular(16)
    //                     ),
    //                     selected: _activityType == 'playing',
    //                     onPressed: () => setState(() => _activityType = 'playing')
    //                   ),
    //                   Divider(
    //                     color: theme['color-03'],
    //                     thickness: 0.2,
    //                     height: 0,
    //                     indent: 16,
    //                   ),
    //                   RadioButtonTile(
    //                     title: 'Watching',
    //                     borderRadius: BorderRadius.zero,
    //                     selected: _activityType == 'watching',
    //                     onPressed: () => setState(() => _activityType = 'watching')
    //                   ),
    //                   Divider(
    //                     color: theme['color-03'],
    //                     thickness: 0.2,
    //                     height: 0,
    //                     indent: 16,
    //                   ),
    //                   RadioButtonTile(
    //                     title: 'Listening',
    //                     borderRadius: BorderRadius.zero,
    //                     selected: _activityType == 'listening',
    //                     onPressed: () => setState(() => _activityType = 'listening')
    //                   ),
    //                   Divider(
    //                     color: theme['color-03'],
    //                     thickness: 0.2,
    //                     height: 0,
    //                     indent: 16,
    //                   ),
    //                   RadioButtonTile(
    //                     title: 'Competing',
    //                     borderRadius: BorderRadius.zero,
    //                     selected: _activityType == 'competing',
    //                     onPressed: () => setState(() => _activityType = 'competing')
    //                   ),
    //                   Divider(
    //                     color: theme['color-03'],
    //                     thickness: 0.2,
    //                     height: 0,
    //                     indent: 16,
    //                   ),
    //                   RadioButtonTile(
    //                     title: "Custom",
    //                     borderRadius: const BorderRadius.vertical(
    //                       bottom: Radius.circular(16)
    //                     ),
    //                     selected: _activityType == 'custom',
    //                     onPressed: () => setState(() => _activityType = 'custom')
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             const SizedBox(height: 35),
    //             Text(
    //               'Status Duration',
    //               style: TextStyle(
    //                 color: theme['color-03'],
    //                 fontFamily: 'GGSansSemibold',
    //                 fontSize: 14
    //               ),
    //             ),
    //             Container(
    //               width: double.infinity,
    //               margin: const EdgeInsets.only(left: 4, right: 4, bottom: 16, top: 5),
    //               decoration: BoxDecoration(
    //                 color: theme['color-12'],
    //                 borderRadius: BorderRadius.circular(16)
    //               ),
    //               child: Column(
    //                 children: [
    //                   RadioButtonTile(
    //                     title: 'Clear in 24 hours',
    //                     borderRadius: const BorderRadius.vertical(
    //                       top: Radius.circular(16)
    //                     ),
    //                     selected: _duration == '24',
    //                     onPressed: () => setState(() => _duration = '24')
    //                   ),
    //                   Divider(
    //                     color: theme['color-03'],
    //                     thickness: 0.2,
    //                     height: 0,
    //                     indent: 16,
    //                   ),
    //                   RadioButtonTile(
    //                     title: 'Clear in 4 hours',
    //                     borderRadius: BorderRadius.zero,
    //                     selected: _duration == '4',
    //                     onPressed: () => setState(() => _duration = '4')
    //                   ),
    //                   Divider(
    //                     color: theme['color-03'],
    //                     thickness: 0.2,
    //                     height: 0,
    //                     indent: 16,
    //                   ),
    //                   RadioButtonTile(
    //                     title: 'Clear in 1 hour',
    //                     borderRadius: BorderRadius.zero,
    //                     selected: _duration == '1',
    //                     onPressed: () => setState(() => _duration = '1')
    //                   ),
    //                   Divider(
    //                     color: theme['color-03'],
    //                     thickness: 0.2,
    //                     height: 0,
    //                     indent: 16,
    //                   ),
    //                   RadioButtonTile(
    //                     title: 'Clear in 30 minutes',
    //                     borderRadius: BorderRadius.zero,
    //                     selected: _duration == '30',
    //                     onPressed: () => setState(() => _duration = '30')
    //                   ),
    //                   Divider(
    //                     color: theme['color-03'],
    //                     thickness: 0.2,
    //                     height: 0,
    //                     indent: 16,
    //                   ),
    //                   RadioButtonTile(
    //                     title: "Don't clear",
    //                     borderRadius: const BorderRadius.vertical(
    //                       bottom: Radius.circular(16)
    //                     ),
    //                     selected: _duration.isEmpty,
    //                     onPressed: () => setState(() => _duration = '')
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //       )
    //     ),
    //   ),
    // );
  }
}

// class RadioButtonTile extends StatelessWidget {
//   final String title;
//   final BorderRadius borderRadius;
//   final bool selected;
//   final Function() onPressed;
//   const RadioButtonTile({
//     required this.title,
//     required this.borderRadius,
//     required this.selected,
//     required this.onPressed,
//     super.key
//   });

//   @override
//   Widget build(BuildContext context) {
//     return CustomButton(
//       height: 60,
//       onPressed: onPressed,
//       backgroundColor: Colors.transparent,
//       onPressedColor: theme['color-10'],
//       shape: RoundedRectangleBorder(
//         borderRadius: borderRadius
//       ),
//       applyClickAnimation: false,
//       child: Row(
//         children: [
//           const SizedBox(width: 16),
//           Text(
//             title,
//             style: TextStyle(
//               color: theme['color-01'],
//               fontSize: 16,
//               fontFamily: 'GGSansSemibold'
//             ),
//           ),
//           const Spacer(),
//           RadioButtonIndicator2(
//             radius: 20, 
//             selected: selected
//           ),
//           const SizedBox(width: 20),
//         ],
//       ),
//     );
//   }
// }

