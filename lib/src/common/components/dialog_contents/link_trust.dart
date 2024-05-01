import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../utils/cache.dart';
import '../../utils/extensions.dart';

import '../../components/custom_button.dart';

class LinkTrustDialog extends StatefulWidget {
  final String link;
  const LinkTrustDialog({required this.link, super.key});

  @override
  State<LinkTrustDialog> createState() => _LinkTrustDialogState();
}

class _LinkTrustDialogState extends State<LinkTrustDialog> {
  bool checked = false;

  Future<void> addDomain(String domainName) async {
    trustedDomains.add(domainName);
    await prefs.setStringList('trusted-domains', trustedDomains);
  }
  @override
  Widget build(BuildContext context) {
    final Uri uri = Uri.parse(widget.link);
    final List<int> indicies = widget.link.getIndicies(uri.host);
    return Container(
      height: context.getSize.height * 0.5,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme['color-11'],
        borderRadius: BorderRadius.circular(12)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Leaving Discord',
            style: TextStyle(
              color: theme['color-01'],
              fontSize: 16,
              fontFamily: 'GGSansBold'
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'This link is taking you to the following website',
            style: TextStyle(
              color: theme['color-02'],
              fontSize: 16
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme['color-10'],
              borderRadius: BorderRadius.circular(10)
            ),
            child: MarkdownBody(
              data: "${widget.link.substring(0, indicies[0])}**${uri.host}**${widget.link.substring(indicies[1])}",
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(
                  color: theme['color-04'],
                  fontSize: 16
                ),
                strong: TextStyle(
                  color: theme['color-01'],
                  fontSize: 16,
                  fontFamily: 'GGSansSemibold'
                )
              ),
            )
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 12, bottom: 12, left: 12),
            decoration: BoxDecoration(
              color: theme['color-10'],
              borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    "Trust ${uri.host} links from now on",
                    style: TextStyle(
                      color: theme['color-02'],
                      fontSize: 16,
                      fontFamily: 'GGSansSemibold'
                    ), 
                  ),
                ),
                Checkbox(
                  value: checked,
                  splashRadius: 0,
                  side: BorderSide(
                    color: theme['color-02'],
                    width: 2
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3)
                  ),
                  activeColor: theme['color-14'],
                  onChanged: (state) => setState(() => checked = !checked)
                )
              ],
            )
          ),
          const Spacer(),
          CustomButton(
            width: double.infinity,
            height: 45,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(45 * 0.5)
            ),
            backgroundColor: theme['color-14'],
            onPressedColor: theme['color-15'],
            applyClickAnimation: true,
            animationUpperBound: 0.04,
            child: Center(
              child: Text(
                "Visit Site",
                style: TextStyle(
                  color: theme['color-01'],
                  fontFamily: 'GGSansSemibold'
                ),
              ),
            ),
            onPressed: () async {
              if (checked) {
                await addDomain(uri.host);
              }
              await launchUrl(uri);
              context.pop();
            },
          ),
          const SizedBox(height: 10),
          CustomButton(
            width: double.infinity,
            height: 45,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(45 * 0.5)
            ),
            backgroundColor: theme['color-07'],
            onPressedColor: theme['color-06'],
            applyClickAnimation: true,
            animationUpperBound: 0.04,
            onPressed: context.pop,
            child: Center(
              child: Text(
                "Go Back",
                style: TextStyle(
                  color: theme['color-01'],
                  fontFamily: 'GGSansSemibold'
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}