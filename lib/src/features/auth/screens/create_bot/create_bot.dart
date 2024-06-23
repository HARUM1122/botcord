import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/common/components/custom_button.dart';
import 'package:discord/src/common/controllers/theme_controller.dart';
import 'package:discord/src/common/components/bottom_sheet/link_options.dart';

import '../../utils/constants.dart';

class CreateBotAccountScreen extends ConsumerStatefulWidget {
  const CreateBotAccountScreen({super.key});

  @override
  ConsumerState<CreateBotAccountScreen> createState() => _CreateBotAccountScreenState();
}

class _CreateBotAccountScreenState extends ConsumerState<CreateBotAccountScreen> {
  @override
  Widget build(BuildContext context) {
    final String theme = ref.watch(themeController);
    final Color color1 = appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));

    return Scaffold(
      backgroundColor: appTheme(theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0xFF000000)),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          splashRadius: 18,
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0XFF7D818F),
          )
        ),
        title: Text(
          'Botcord',
          style: TextStyle(
            color: color1,
            fontFamily: 'GGSansBold'
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StretchingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (overscroll) {
                    overscroll.disallowIndicator();
                    return true;
                  },
                  child: Markdown(
                    data: createBotAccountSteps.trim(),
                    onTapLink: (text, href, title) => showSheet(
                      context: context,
                      height: 0.4,
                      maxHeight: 0.8,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16)
                      ),
                      color: appTheme<Color>(theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0xFF000000)),
                      builder: (context, controller, offset) => LinkOptionsSheet(
                        link: href!, 
                        controller: controller
                      )
                    ),
                    styleSheet: MarkdownStyleSheet(
                      listBullet: TextStyle(
                        color: appTheme<Color>(theme, light: const Color(0XFF939597), dark: const Color(0XFF80848A), midnight: const Color(0XFF898B98)),
                        fontSize: 16,
                        fontFamily: 'GGSansSemibold'
                      ),
                      h2: TextStyle(
                        color: color1,
                        fontFamily: 'GGSansBold'
                      ),
                      a: const TextStyle(
                        color: Colors.blue
                      ),
                      p: TextStyle(
                        color: color1,
                        fontSize: 16
                      ),
                      code: TextStyle(
                        color: color1,
                        backgroundColor: appTheme<Color>(theme, light: const Color(0XFFEBEBEB), dark: const Color(0XFF242830), midnight: const Color(0XFF151419))
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: CustomButton(
                width: double.infinity,
                height: 50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50 * 0.5)
                ),
                applyClickAnimation: true,
                animationUpperBound: 0.04,
                backgroundColor: const Color(0XFF536CF8),
                onPressedColor: const Color(0XFF4658CA),
                child: const Center(
                  child: Text(
                    "Watch Tutorial Video",
                    style: TextStyle(
                      color: Color(0XFFF0F4F7),
                      fontFamily: 'GGsansSemibold'
                    ),
                  ),
                ),
                onPressed: () {
                },
              ),
            ),
            const SizedBox(height: 12)
          ],
        ),
      ),
    );
  }
}