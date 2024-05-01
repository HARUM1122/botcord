import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../drag_handle.dart';

import '../../utils/utils.dart';
import '../../utils/cache.dart';
import '../../utils/extensions.dart';

import '../custom_button.dart';

import '../dialog_contents/link_trust.dart';


class LinkOptionsSheet extends StatelessWidget {
  final String link;
  final ScrollController controller;
  const LinkOptionsSheet({required this.link, required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Align(
        alignment: Alignment.topCenter,
        child: DragHandle(
          color: theme['color-06'],
        )
      ),
      const SizedBox(height: 8),
      Align(
        alignment: Alignment.topCenter,
        child: Text(
          "Link Options",
          style: TextStyle(
            color: theme['color-01'],
            fontFamily: 'GGSansBold',
            fontSize: 18
          ),
        ),
      ),
      Align(
        alignment: Alignment.topCenter,
        child: Text(
          link,
          style: TextStyle(
            color: theme['color-05'],
            fontSize: 14,
            fontFamily: 'GGSansSemibold'
          ),
        ),
      ),
      const SizedBox(height: 30),
      DecoratedBox(
        decoration: BoxDecoration(
          color: theme['color-10'],
          borderRadius: BorderRadius.circular(16)
        ),
        child: Column(
          children: [
            CustomButton(
              width: double.infinity,
              height: 60,
              backgroundColor: Colors.transparent,
              onPressedColor: theme['color-12'], 
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16))
              ),
              onPressed: () async {
                context.pop();
                if (trustedDomains.contains(Uri.parse(link).host)) {
                  await launchUrl(Uri.parse(link));
                  return;
                }
                showDialogBox(
                  context: context,
                  child: LinkTrustDialog(
                    link: link,
                  ),
                );
              }, 
              applyClickAnimation: false,
              child: Container(
                padding: const EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Open Link',
                  style: TextStyle(
                    color: theme['color-01'],
                    fontSize: 16,
                    fontFamily: 'GGSansSemibold'
                  ),
                ),
              ), 
            ),
            Divider(
              thickness: 0.2,
              height: 0,
              indent: 50,
              color: theme['color-04'],
            ),
            CustomButton(
              width: double.infinity,
              height: 60,
              backgroundColor: Colors.transparent,
              onPressedColor: theme['color-12'], 
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: link));
                if (!context.mounted) return;
                showSnackBar(
                  context: context, 
                  leading: Icon(
                    Icons.copy,
                    color: theme['color-01'],
                  ),
                  msg: "Link copied"
                );
              }, 
              applyClickAnimation: false,
              child: Container(
                padding: const EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Copy Link',
                  style: TextStyle(
                    color: theme['color-01'],
                    fontSize: 16,
                    fontFamily: 'GGSansSemibold'
                  ),
                ),
              ), 
            ),
            Divider(
              thickness: 0.2,
              height: 0,
              indent: 50,
              color: theme['color-04'],
            ),
            CustomButton(
              width: double.infinity,
              height: 60,
              backgroundColor: Colors.transparent,
              onPressedColor: theme['color-12'],
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(16))
              ),
              onPressed: () => Share.share(link),
              applyClickAnimation: false,
              child: Container(
                padding: const EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Share Link',
                  style: TextStyle(
                    color: theme['color-01'],
                    fontSize: 16,
                    fontFamily: 'GGSansSemibold'
                  ),
                ),
              ), 
            )
          ]
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