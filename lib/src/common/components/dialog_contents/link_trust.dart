import 'package:discord/src/common/components/checkbox_indicator.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:discord/theme_provider.dart';

import '../../utils/globals.dart';
import '../../utils/utils.dart';
import '../../utils/extensions.dart';

import '../../components/custom_button.dart';

class LinkTrustDialog extends ConsumerStatefulWidget {
  final String link;
  const LinkTrustDialog({required this.link, super.key});

  @override
  ConsumerState<LinkTrustDialog> createState() => _LinkTrustDialogState();
}

class _LinkTrustDialogState extends ConsumerState<LinkTrustDialog> {
  bool _domainTrusted = false;

  Future<void> addDomain(String domainName) async {
    trustedDomains.add(domainName);
    await prefs.setStringList('trusted-domains', trustedDomains);
  }

  @override
  Widget build(BuildContext context) {
    final String theme = ref.read(themeProvider);
    final Uri uri = Uri.parse(widget.link);
    final List<int> indicies = widget.link.getIndicies(uri.host);
    return Container(
      height: context.getSize.height * 0.6,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: appTheme<Color>(theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0xFF000000)),
        borderRadius: BorderRadius.circular(12)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Leaving Discord',
            style: TextStyle(
              color: appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
              fontSize: 16,
              fontFamily: 'GGSansBold'
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'This link is taking you to the following website',
            style: TextStyle(
              color: appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFC5C8CF), midnight: const Color(0xFFFFFFFF)),
              fontSize: 16
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: appTheme<Color>(theme, light: const Color(0xFFFFFFFF), dark: const Color(0XFF262730), midnight: const Color(0XFF141318)),
              borderRadius: BorderRadius.circular(10)
            ),
            child: MarkdownBody(
              data: "${widget.link.substring(0, indicies[0])}**${uri.host}**${widget.link.substring(indicies[1])}",
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(
                  color: appTheme<Color>(theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFF81818D)),
                  fontSize: 16
                ),
                strong: TextStyle(
                  color: appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
                  fontSize: 16,
                  fontFamily: 'GGSansSemibold'
                )
              ),
            )
          ),
          const SizedBox(height: 14),
          CustomButton(
            width: double.infinity,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
            backgroundColor: appTheme<Color>(theme, light: const Color(0xFFFFFFFF), dark: const Color(0XFF262730), midnight: const Color(0XFF141318)),
            onPressedColor: appTheme<Color>(theme, light: const Color(0XFFE1E1E1), dark: const Color(0XFF35363F), midnight: const Color(0XFF242328)),
            applyClickAnimation: false,
            onPressed: () => setState(() => _domainTrusted = !_domainTrusted),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "Trust ${uri.host} links from now on",
                      style: TextStyle(
                        color: appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFC5C8CF), midnight: const Color(0xFFFFFFFF)),
                        fontSize: 16,
                        fontFamily: 'GGSansSemibold'
                      ), 
                    ),
                  ),
                  CheckBoxIndicator(selected: _domainTrusted)
                ],
              ),
            )
          ),
          // Container(
          //   width: double.infinity,
          //   padding: const EdgeInsets.only(top: 12, bottom: 12, left: 12),
          //   decoration: BoxDecoration(
          //     color: appTheme<Color>(theme, light: const Color(0xFFFFFFFF), dark: const Color(0xFF25282F), midnight: const Color(0xFF1A1D24)),
          //     borderRadius: BorderRadius.circular(10)
          //   ),
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       Expanded(
          //         child: Text(
          //           "Trust ${uri.host} links from now on",
          //           style: TextStyle(
          //             color: appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFC5C8CF), midnight: const Color(0xFFFFFFFF)),
          //             fontSize: 16,
          //             fontFamily: 'GGSansSemibold'
          //           ), 
          //         ),
          //       ),
          //       Checkbox(
          //         value: checked,
          //         splashRadius: 0,
          //         side: BorderSide(
          //           color: appTheme<Color>(theme, light: const Color(0xFF31343D), dark: const Color(0xFFC5C8CF), midnight: const Color(0xFFC5C8CF)),
          //           width: 2
          //         ),
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(3)
          //         ),
          //         activeColor: const Color(0xFF5964F4),
          //         onChanged: (state) => setState(() => checked = !checked)
          //       )
          //     ],
          //   )
          // ),
          const Spacer(),
          CustomButton(
            width: double.infinity,
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
                "Visit Site",
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontFamily: 'GGSansSemibold'
                ),
              ),
            ),
            onPressed: () async {
              if (_domainTrusted) {
                await addDomain(uri.host);
              }
              await launchUrl(uri);
              if (!mounted) return;
              Navigator.pop(context);
            },
          ),
          ///
          const SizedBox(height: 10),
          CustomButton(
            width: double.infinity,
            height: 45,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(45 * 0.5)
            ),
            backgroundColor: appTheme<Color>(theme, light: const Color(0XFFDFE1E3), dark: const Color(0XFF373A42), midnight: const Color(0XFF2C2D36)),
            onPressedColor: appTheme<Color>(theme, light: const Color(0XFFC4C6C8), dark: const Color(0XFF4D505A), midnight: const Color(0XFF373A42)),
            applyClickAnimation: true,
            animationUpperBound: 0.04,
            onPressed: () => Navigator.pop(context),
            child: Center(
              child: Text(
                "Go Back",
                style: TextStyle(
                  color: appTheme<Color>(theme, light: const Color(0xFF31343D), dark: const Color(0xFFC5C8CF), midnight: const Color(0xFFC5C8CF)),
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