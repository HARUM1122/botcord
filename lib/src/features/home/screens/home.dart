import 'package:flutter/material.dart';

import '../components/navigation.dart';

import '../../../common/utils/cache.dart';

import '../../../features/profile/screens/profile.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _controller = PageController(initialPage: 0);

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      color: theme['color-11'],
      child: Stack(
        children: [
          PageView(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              GuildScreen(),
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

class GuildScreen extends StatelessWidget {
  const GuildScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("GUILD SCREEN"),
    );
  }
}