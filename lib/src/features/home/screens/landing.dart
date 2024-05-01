import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';

import '../util/constants.dart';

import '../../../common/utils/cache.dart';
import '../../../common/utils/extensions.dart';
import '../../../common/components/custom_button.dart';


class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme['color-11'],
      appBar: AppBar(
        title: Text(
          "Welcome to Botcord",
          style: TextStyle(
            color: theme['color-01'],
            fontFamily: 'GGsansBold',
            fontSize: 24
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: GlowingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                color: theme['color-15'],
                child: Markdown(
                  data: warningMessage,
                  styleSheet: MarkdownStyleSheet(
                    h2: TextStyle(
                      color: theme['color-01'],
                      fontFamily: 'GGSansBold',
                      fontSize: 18
                    ),
                    strong: TextStyle(
                      color: theme['color-01'],
                      fontFamily: 'GGSansBold',
                      fontSize: 16
                    ),
                    p: TextStyle(
                      color: theme['color-01'],
                      fontSize: 16
                    )
                  ),
                ),
              )
            ),
            const SizedBox(height: 10),
            CustomButton(
              onPressed: () {
                prefs.setBool('is-landed', true);
                Navigator.pushReplacementNamed(
                  context, 
                  '/bots-route',
                  arguments: true
                );
              },
              width: context.getSize.width * 0.90,
              height: 50,
              backgroundColor: theme['color-14'],
              onPressedColor: theme['color-15'],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.getSize.width / 2)
              ),
              applyClickAnimation: true,
              animationUpperBound: 0.08,
              child: Center(
                child: Text(
                  "Agree And Continue",
                  style: TextStyle(
                    color: theme['color-01'],
                    fontFamily: 'GGsansSemibold',
                    fontSize: 16
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}


