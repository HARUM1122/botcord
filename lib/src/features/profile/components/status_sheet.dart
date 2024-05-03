import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'radio_button_indicator/radio_button_indicator.dart';

import '../../../common/utils/cache.dart';
import '../../../common/utils/extensions.dart';
import '../../../common/components/drag_handle.dart';
import '../../../common/components/custom_button.dart';
import '../../../common/components/avatar/online_status/status.dart';

import '../../../features/profile/controller/profile_controller.dart';

class StatusSheet extends ConsumerWidget {
  final ScrollController controller;
  const StatusSheet({required this.controller, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ProfileController profileController = ref.read(profileControllerProvider);
    final Map<String, dynamic> botActivity = profileController.botActivity;
    List<Widget> children = [
      Align(
        alignment: Alignment.topCenter,
        child: DragHandle(
          color: theme['color-06'],
        ),
      ),
      const SizedBox(height: 20),
      Align(
        alignment: Alignment.topCenter,
        child: Text(
          'Change Online Status',
          style: TextStyle(
            color: theme['color-01'],
            fontSize: 20,
            fontFamily: 'GGSansBold'
          ),
        ),
      ),
      const SizedBox(height: 10),
      Text(
        "Online Status",
        style: TextStyle(
          color: theme['color-02'],
          fontSize: 14,
          fontFamily: 'GGSansSemibold'
        ),
      ),
      const SizedBox(height: 8),
      Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: theme['color-10'],
          borderRadius: BorderRadius.circular(16)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StatusTile(
              status: 'online',
              title: 'Online',
              selected: botActivity['current-online-status'] == 'online',
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16)
              ),
              controller: profileController,
            ),
            Divider(
              color: theme['color-04'],
              thickness: 0.2,
              height: 0,
              indent: 50,
            ),
            StatusTile(
              status: 'idle',
              title: 'Idle',
              selected: botActivity['current-online-status'] == 'idle',
              borderRadius: BorderRadius.zero,
              controller: profileController,
            ),
            Divider(
              color: theme['color-04'],
              thickness: 0.2,
              height: 0,
              indent: 50,
            ),
            StatusTile(
              status: 'dnd',
              title: 'Do Not Disturb',
              selected: botActivity['current-online-status'] == 'dnd',
              borderRadius: BorderRadius.zero,
              controller: profileController,
            ),
            Divider(
              color: theme['color-04'],
              thickness: 0.2,
              height: 0,
              indent: 50,
            ),
            StatusTile(
              status: 'invisible',
              title: 'Invisible',
              selected: botActivity['current-online-status'] == 'invisible',
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16)
              ),
              controller: profileController,
            )
          ],
        )
      )
    ];
    return ListView.builder(
      padding: EdgeInsets.only(top: 8, left: 12, right: 12, bottom: context.padding.bottom + 12),
      controller: controller,
      itemCount: children.length,
      itemBuilder: (context, idx) => children[idx]
    );
  }
}

class StatusTile extends StatelessWidget {
  final String status;
  final String title;
  final BorderRadius borderRadius;
  final bool selected;
  final ProfileController controller;
  const StatusTile({
    required this.status,
    required this.title,
    required this.borderRadius,
    required this.selected,
    required this.controller,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      height: 60,
      onPressed: () {
        controller.botActivity['current-online-status'] = status;
        controller.updatePresence(save: true);
        Navigator.pop(context);
      },
      backgroundColor: Colors.transparent,
      onPressedColor: theme['color-12'],
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius
      ),
      applyClickAnimation: false,
      child: Row(
        children: [
          const SizedBox(width: 10),
          getOnlineStatus(
            status, 
            20
          ),
          const SizedBox(width: 18),
          Text(
            title,
            style: TextStyle(
              color: theme['color-01'],
              fontSize: 16,
              fontFamily: 'GGSansSemibold'
            ),
          ),
          const Spacer(),
          RadioButtonIndicator(
            radius: 20, 
            selected: selected
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}