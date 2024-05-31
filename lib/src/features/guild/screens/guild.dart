import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/src/common/providers/theme_provider.dart';

import 'panels/panels.dart';

import '../screens/screens.dart';
import '../../../common/utils/utils.dart';
import '../../../common/components/custom_button.dart';

import '../../../common/providers/bottom_nav.dart';
import '../../../features/guild/controllers/guilds_controller.dart';

double translate = 0;

class GuildsScreen extends ConsumerStatefulWidget {
  const GuildsScreen({super.key});

  static GuildsScreenState? of(BuildContext context) =>
    context.findAncestorStateOfType<GuildsScreenState>();
    
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return GuildsScreenState();
  }
}

class GuildsScreenState extends ConsumerState<GuildsScreen> with TickerProviderStateMixin {

  late final String _theme = ref.read(themeProvider);
  late final BottomNavProvider _bottomNavProv = ref.read(bottomNavProvider);

  double _calculateGoal(double width, int multiplier) => 
    (multiplier * width) + (-multiplier * 20);

  void _onApplyTranslation() {
    final double width = MediaQuery.of(context).size.width;

    final AnimationController animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    animationController.addStatusListener((status) { 
      if (status == AnimationStatus.completed) {
        _bottomNavProv
        ..leftMenuOpened = translate > 0
        ..refresh();
      }
    });
    if (translate.abs() >= width / 2) {
      final goal = _calculateGoal(width, 1);

      final Tween<double> tween = Tween(begin: translate, end: goal);

      final Animation animation = tween.animate(animationController);

      animation.addListener(() {
        setState(() {
          translate = animation.value;
        });
      });
    } else {
      final Animation<double> animation = Tween<double>(begin: translate, end: 0).animate(animationController);

      animation.addListener(() {
        setState(() => translate = animation.value);
      });
    }
    animationController.forward();
  }

   void _onTranslate(double delta) {
    setState(() {
      final double trns = translate + delta;
      translate = trns > 0 ? trns : translate;
    });
  }

  void revealLeft() {
    if (translate != 0) return;

    final AnimationController animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    
    final Animation<double> animation = Tween<double>(begin: translate, end: _calculateGoal(MediaQuery.of(context).size.width, 1)).animate(animationController);

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onApplyTranslation();
        animationController.dispose();
      }
    });

    animation.addListener(() {
      setState(() {
        translate = animation.value;
      });
    });
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final GuildsController controller = ref.watch(guildsControllerProvider);

    if (controller.guildsCache.isEmpty) {
      return Container(
        color: appTheme<Color>(_theme, light: const Color(0XFFECEEF0), dark: const Color(0XFF141318), midnight: const Color(0xFF000000)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "NO SERVERS",
              style: TextStyle(
                color: appTheme<Color>(_theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
                fontSize: 20,
                fontFamily: 'GGSansBold'
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Text(
                "Your bot currently hasn't joined any server yet. Invite your bot to a server",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: appTheme<Color>(_theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFF81818D)),
                  fontSize: 16,
                  fontFamily: 'GGSansSemibold'
                ),
              ),
            ),
            const SizedBox(height: 30),
            CustomButton(
              width: 200,
              height: 45,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(45 * 0.5)
              ),
              backgroundColor: const Color(0XFF536CF8),
              onPressedColor: const Color(0XFF4658CA),
              applyClickAnimation: true,
              animationUpperBound: 0.04,
              child: const Center(
                child: Text(
                  "Invite Bot",
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontFamily: 'GGSansSemibold'
                  ),
                ),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InviteBotScreen(),
                )
              )
            ),
          ],
        )
      );
    }
    return Stack(children: [
      Offstage(
        offstage: translate < 0,
        child: controller.currentGuild != null ? MenuScreen(
          guilds: controller.guildsCache,
          currentGuild: controller.currentGuild!,
        ) : null
      ),
      Transform.translate(
        offset: Offset(translate, 0),
        child: const ChatScreen(),
      ),
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragUpdate: (details) => _onTranslate(details.delta.dx),
        onHorizontalDragEnd: (details) => _onApplyTranslation()
      ),
    ]);
  }
}