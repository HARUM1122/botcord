import 'package:discord/src/features/guild/screens/guild.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/theme_provider.dart';

import '../components/navigation.dart';

import '../../../common/utils/utils.dart';

import '../../../features/profile/screens/profile.dart';

class HomeScreen extends ConsumerStatefulWidget {

  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController _controller = PageController(initialPage: 0);

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final String theme = ref.watch(themeProvider);
    return Material(
      color: appTheme<Color>(theme, light: const Color(0xFFFFFFFF), dark: const Color(0xFF1A1D24), midnight: const Color(0xFF000000)),
      child: Stack(
        children: [
          PageView(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              GuildsScreen(),
              ProfileScreen()
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavigator(
              controller: _controller,
            ),
          )
        ],
      ),
    );
  }
}

// class GuildScreen extends ConsumerWidget {
//   const GuildScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               ref.read(themeProvider.notifier).setTheme('light', true, false);
//             },
//             child: Text("LIGHT"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               ref.read(themeProvider.notifier).setTheme('dark', true, false);
//             },
//             child: Text("DARK"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               ref.read(themeProvider.notifier).setTheme('midnight', true, false);
//             },
//             child: Text("MIDNIGHT"),
//           )
//         ],
//       ),
//     );
//   }
// }