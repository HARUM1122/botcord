import 'package:discord/src/common/components/custom_button.dart';
import 'package:discord/src/common/utils/cache.dart';
import 'package:discord/src/features/profile/components/radio_button_indicator/radio_button_indicator.dart';
import 'package:discord/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold();
    // return Scaffold(
    //   backgroundColor: theme['color-11'],
    //   appBar: AppBar(
    //     leading: IconButton(
    //       onPressed: () => Navigator.pop(context),
    //       splashRadius: 18,
    //       icon: Icon(
    //         Icons.arrow_back,
    //         color: theme['color-03'],
    //       )
    //     ),
    //     title: Text(
    //       "Settings",
    //       style: TextStyle(
    //         color: theme['color-01'],
    //         fontFamily: 'GGSansBold',
    //         fontSize: 18
    //       ),
    //     ),
    //     centerTitle: true,
    //   ),
    //   body: SingleChildScrollView(
    //     child: Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 12),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           const SizedBox(height: 30),
    //           Text(
    //             "App Theme",
    //             style: TextStyle(
    //               color: theme['color-02'],
    //               fontSize: 14,
    //               fontFamily: 'GGSansSemibold'
    //             ),
    //           ),
    //           const SizedBox(height: 8),
    //           Consumer(
    //             builder: (_, ref, __) {
    //               String currentTheme = ref.watch(themeProvider);
    //               return Container(
    //                 width: double.infinity,
    //                 margin: const EdgeInsets.symmetric(horizontal: 2),
    //                 decoration: BoxDecoration(
    //                   color: theme['color-10'],
    //                   borderRadius: BorderRadius.circular(16)
    //                 ),
    //                 child: Column(
    //                   children: [
    //                     OptionTile(
    //                       borderRadius: const BorderRadius.vertical(
    //                         top: Radius.circular(16)
    //                       ),
    //                       onPressed: () => ref.read(
    //                         themeProvider.notifier
    //                       ).setTheme('light', true),
    //                       child: Row(
    //                         children: [
    //                           const SizedBox(width: 10),
    //                           Icon(
    //                             Icons.light_mode,
    //                             color: theme['color-01'],
    //                           ),
    //                           const SizedBox(width: 18),
    //                           Text(
    //                             'Light',
    //                             style: TextStyle(
    //                               color: theme['color-01'],
    //                               fontSize: 16,
    //                               fontFamily: 'GGSansSemibold'
    //                             ),
    //                           ),
    //                           const Spacer(),
    //                           RadioButtonIndicator(
    //                             radius: 20, 
    //                             selected: currentTheme == 'light'
    //                           ),
    //                           const SizedBox(width: 10,)
    //                         ],
    //                       )
    //                     ),
    //                     Divider(
    //                       color: theme['color-04'],
    //                       thickness: 0.2,
    //                       height: 0,
    //                       indent: 50,
    //                     ),
    //                     OptionTile(
    //                       borderRadius: BorderRadius.zero,
    //                       onPressed: () => ref.read(
    //                         themeProvider.notifier
    //                       ).setTheme('dark', true),
    //                       child: Row(
    //                         children: [
    //                           const SizedBox(width: 10),
    //                           Icon(
    //                             Icons.dark_mode,
    //                             color: theme['color-01'],
    //                           ),
    //                           const SizedBox(width: 18),
    //                           Text(
    //                             'Dark',
    //                             style: TextStyle(
    //                               color: theme['color-01'],
    //                               fontSize: 16,
    //                               fontFamily: 'GGSansSemibold'
    //                             ),
    //                           ),
    //                           const Spacer(),
    //                           RadioButtonIndicator(
    //                             radius: 20, 
    //                             selected: currentTheme == 'dark'
    //                           ),
    //                           const SizedBox(width: 10,)
    //                         ],
    //                       )
    //                     ),
    //                     Divider(
    //                       color: theme['color-04'],
    //                       thickness: 0.2,
    //                       height: 0,
    //                       indent: 50,
    //                     ),
    //                     OptionTile(
    //                       borderRadius: const BorderRadius.vertical(
    //                         bottom: Radius.circular(16)
    //                       ),
    //                       onPressed: () => ref.read(
    //                         themeProvider.notifier
    //                       ).setTheme('midnight', true),
    //                       child: Row(
    //                         children: [
    //                           const SizedBox(width: 10),
    //                           Icon(
    //                             Icons.nightlight,
    //                             color: theme['color-01'],
    //                           ),
    //                           const SizedBox(width: 18),
    //                           Text(
    //                             'Midnight',
    //                             style: TextStyle(
    //                               color: theme['color-01'],
    //                               fontSize: 16,
    //                               fontFamily: 'GGSansSemibold'
    //                             ),
    //                           ),
    //                           const Spacer(),
    //                           RadioButtonIndicator(
    //                             radius: 20, 
    //                             selected: currentTheme == 'midnight'
    //                           ),
    //                           const SizedBox(width: 10,)
    //                         ],
    //                       )
    //                     ),
    //                   ],
    //                 )
    //               );
    //             }
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}

// class OptionTile extends StatelessWidget {
//   final BorderRadius borderRadius;
//   final Function() onPressed;
//   final Widget child;

//   const OptionTile({
//     required this.borderRadius,
//     required this.onPressed,
//     required this.child,
//     super.key
//   });

//   @override
//   Widget build(BuildContext context) {
//     return CustomButton(
//       height: 60,
//       onPressed: onPressed,
//       backgroundColor: Colors.transparent,
//       onPressedColor: theme['color-07'],
//       shape: RoundedRectangleBorder(
//         borderRadius: borderRadius
//       ),
//       applyClickAnimation: false,
//       child: child,
//     );
//   }
// }