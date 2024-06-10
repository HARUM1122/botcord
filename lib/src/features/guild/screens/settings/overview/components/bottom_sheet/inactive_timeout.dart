import 'package:discord/src/features/guild/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:nyxx/nyxx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/src/features/guild/controllers/channels_controller.dart';

import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/common/utils/extensions.dart';
import 'package:discord/src/common/components/drag_handle.dart';
import 'package:discord/src/common/components/custom_button.dart';
import 'package:discord/src/common/controllers/theme_controller.dart';
import 'package:discord/src/common/components/radio_button_indicator/radio_button_indicator.dart';

class InactiveChannelsDurationSheet extends ConsumerWidget {
  final ScrollController controller;
  final int durationInSeconds;
  const InactiveChannelsDurationSheet({required this.controller, required this.durationInSeconds, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.read(themeController);
    final Color color1 = appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));

    List<Widget> children = [
      Align(
        alignment: Alignment.topCenter,
        child: DragHandle(
          color: appTheme<Color>(theme, light: const Color(0XFFD8DADD), dark: const Color(0XFF2F3039), midnight: const Color(0XFF151518))
        )
      ),
      const SizedBox(height: 10),
      Align(
        alignment: Alignment.topCenter,
        child: Text(
          'Select a Duration',
          style: TextStyle(
            color: color1,
            fontSize: 18,
            fontFamily: 'GGSansBold'
          ),
        ),
      ),
      const SizedBox(height: 20),
      SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: appTheme<Color>(theme, light: const Color(0xFFFFFFFF), dark: const Color(0xFF25282F), midnight: const Color(0XFF141318)),
            borderRadius: BorderRadius.circular(16)
          ),
          child: Column(
            children: [
              ...() {
                List<Widget> durationWidgets = [];
                final List<int> durationsInSeconds = [60, 300, 900, 1800, 3600];

                int length = durationsInSeconds.length;

                for (int i = 0; i < length; i++) {
                  final int seconds = durationsInSeconds[i];
                  durationWidgets.add(
                    DurationRadioButton(
                      durationInSeconds: seconds,
                      borderRadius: BorderRadius.vertical(
                        top: i == 0 
                        ? const Radius.circular(16)
                        : Radius.zero,
                        bottom: i == length - 1
                        ? const Radius.circular(16)
                        : Radius.zero,
                      ),
                      selected: durationInSeconds == seconds
                    )
                  );
                  if (i < length) {
                    durationWidgets.add(
                      Divider(
                        color: appTheme<Color>(theme, light: const Color(0XFFEBEBEB), dark: const Color(0XFF2C2D36), midnight: const Color(0XFF1C1B21)),
                        thickness: 1,
                        height: 0,
                        indent: 15,
                      )
                    );
                  }
                }
                return durationWidgets;
              }(),
            ],
          ),
        ),
      )
    ];
    return ListView.builder(
      controller: controller,
      padding: EdgeInsets.only(top: 8, left: 16, right: 16, bottom: context.padding.bottom + 12),
      itemCount: children.length,
      itemBuilder: (context, idx) => children[idx],
    );
  }
}

class DurationRadioButton extends ConsumerWidget {
  final int durationInSeconds;
  final bool selected;
  final BorderRadius? borderRadius;

  const DurationRadioButton({
    required this.durationInSeconds,
    required this.selected,
    this.borderRadius,
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.read(themeController);
    return CustomButton(
      height: 60,
      onPressed: () => Navigator.pop(context, Duration(seconds: durationInSeconds)),
      backgroundColor: Colors.transparent,
      onPressedColor: appTheme<Color>(theme, light: const Color(0XFFE1E1E1), dark: const Color(0XFF2F323A), midnight: const Color(0XFF202226)),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.zero
      ),
      applyClickAnimation: false,
      child: Row(
        children: [
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              getDuration(Duration(seconds: durationInSeconds)),
              style: TextStyle(
                color: appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
                fontSize: 16,
                fontFamily: 'GGSansSemibold'
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 6),
          RadioButtonIndicator(
            radius: 24, 
            selected: selected
          ),
          const SizedBox(width: 14)
        ],
      ),
    );
  }
}