import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';

import '../../utils/constants.dart';

import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/common/utils/cache.dart';
import 'package:discord/src/common/utils/extensions.dart';
import 'package:discord/src/common/components/custom_button.dart';
import 'package:discord/src/common/components/bottomsheet_contents/link_options.dart';

class CreateBotAccountScreen extends StatefulWidget {
  const CreateBotAccountScreen({super.key});

  @override
  State<CreateBotAccountScreen> createState() => _CreateBotAccountScreenState();
}

class _CreateBotAccountScreenState extends State<CreateBotAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme['color-11'],
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          splashRadius: 18,
          icon: Icon(
            Icons.arrow_back,
            color: theme['color-05'],
          )
        ),
        title: Text(
          'Botcord',
          style: TextStyle(
            color: theme['color-01'],
            fontFamily: 'GGSansBold'
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GlowingOverscrollIndicator(
                color: theme['color-15'],
                axisDirection: AxisDirection.down,
                child: Markdown(
                  data: createBotAccountSteps.trim(),
                  onTapLink: (text, href, title) => showSheet(
                    context: context,
                    height: 0.4,
                    maxHeight: 0.8,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16)
                    ),
                    color: theme['color-11'],
                    builder: (context, controller, offset) => LinkOptionsSheet(
                      link: href!, 
                      controller: controller
                    )
                  ),
                  styleSheet: MarkdownStyleSheet(
                    listBullet: TextStyle(
                      color: theme['color-01'],
                      fontSize: 16,
                      fontFamily: 'GGSansSemibold'
                    ),
                    h2: TextStyle(
                      color: theme['color-01'],
                      fontFamily: 'GGSansBold'
                    ),
                    a: const TextStyle(
                      color: Colors.blue
                    ),
                    p: TextStyle(
                      color: theme['color-01'],
                      fontSize: 16
                    ),
                    code: TextStyle(
                      color: theme['color-01'],
                      backgroundColor: theme['color-09']
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
                backgroundColor: theme['color-14'],
                onPressedColor: theme['color-15'],
                child: Center(
                  child: Text(
                    "Watch Tutorial Video",
                    style: TextStyle(
                      color: theme['color-01'],
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