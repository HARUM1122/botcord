
import 'package:discord/src/common/components/avatar.dart';
import 'package:discord/src/common/components/custom_button.dart';
import 'package:discord/src/common/controllers/theme_controller.dart';
import 'package:discord/src/common/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';


import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nyxx/nyxx.dart';

class AuditLogTile extends ConsumerStatefulWidget {
  final (User, String, String, Snowflake, List<String>) auditLogInfo;
  const AuditLogTile({required this.auditLogInfo, super.key});

  @override
  ConsumerState<AuditLogTile> createState() => _AuditLogTileState();
}

class _AuditLogTileState extends ConsumerState<AuditLogTile> {
  late final String _theme = ref.read(themeController);

  late final Color _color1 = appTheme<Color>(_theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
  late final Color _color2 = appTheme<Color>(_theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFFA8AAB0));

  bool _showAdditionalInfo = false;

  Icon _getIcon(String type) => switch(type) {
    'ADD' => Icon(
      Icons.add_circle_outline,
      color: Colors.greenAccent[700],
      size: 22,
    ),
    'UPDATE' => Icon(
      Icons.refresh,
      color: Colors.yellow[700],
      size: 22,
    ),
    _=> Icon(
      Icons.remove_circle_outline,
      color: Colors.red[800],
      size: 22,
    )
  };

  Color _getColor(String type) => switch(type) {
    'ADD' => Colors.greenAccent[700]!,
    'UPDATE' => Colors.yellow[700]!,
    _=> Colors.red[800]!
  };

  @override
  Widget build(BuildContext context) {
    final List<String> allChanges = widget.auditLogInfo.$5;
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: CustomButton(
        backgroundColor: appTheme<Color>(
          _theme,
          light: const Color(0XFFFFFFFF),
          dark: Color(!_showAdditionalInfo ? 0XFF212329 : 0XFF262730),
          midnight: Color(!_showAdditionalInfo ? 0XFF0D0C11 : 0XFF141318)
        ),
        onPressedColor: !_showAdditionalInfo ? appTheme<Color>(
          _theme,
          light: const Color(0XFFE1E1E1),
          dark: const Color(0XFF303238),
          midnight: const Color(0XFF131217)
        )
        : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        applyClickAnimation: false,
        onPressed: () {
          if (allChanges.isNotEmpty) {
            setState(() => _showAdditionalInfo = !_showAdditionalInfo);
          }
        },
        child: Column(
          children: [
            Padding(
              padding: _showAdditionalInfo 
              ? const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10) 
              : const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _getIcon(widget.auditLogInfo.$3),
                  const SizedBox(width: 10),
                  () {
                    final User user =  widget.auditLogInfo.$1;
                    return AvatarWidget(
                      image: user.avatar.url.toString(), 
                      errorWidget: DecoratedBox(
                        decoration: BoxDecoration(
                          color: appTheme<Color>(_theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0xFF000000)),
                          shape: BoxShape.circle
                        ),
                        child: Center(
                          child: Text(
                            user.username[0],
                            style: TextStyle(
                              color: _color1,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      radius: 30, 
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.all(2),
                    );
                  }(),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MarkdownBody(
                          data: '${widget.auditLogInfo.$1.username} ${widget.auditLogInfo.$2}',
                          styleSheet: MarkdownStyleSheet(
                            p: TextStyle(
                              color: _color2,
                              fontSize: 16
                            ),
                            strong: TextStyle(
                              color: _color1,
                              fontSize: 16,
                            )
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          formatDateTime(widget.auditLogInfo.$4.timestamp),
                          style: TextStyle(
                            fontSize: 16,
                            color: _color2
                          ),
                        )
                      ],
                    ),
                  ),
                  if (allChanges.isNotEmpty)
                  Icon(
                    _showAdditionalInfo
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_right,
                    size: 24,
                    color: _color1,
                  )
                ],
              ),
            ),
            if (_showAdditionalInfo)
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                padding: const EdgeInsets.all(8),
                width: double.infinity,
                color: appTheme<Color>(_theme, light: const Color(0XFFF4F4F4), dark: const Color(0XFF2E2F38), midnight: const Color(0XFF191B1F)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 1; i <= allChanges.length; i++)
                      Padding(
                        padding: const EdgeInsets.all(2),
                        child: MarkdownBody(
                          data: '`${i < 10 ? '0$i' : i} -` ${allChanges[i - 1]}',
                          styleSheet: MarkdownStyleSheet(
                            p: TextStyle(
                              color: _color1.withOpacity(0.8),
                              fontSize: 14
                            ),
                            strong: TextStyle(
                              color: _color1,
                              fontSize: 14,
                            ),
                            code: TextStyle(
                              color: _getColor(widget.auditLogInfo.$3),
                              fontFamily: 'GGSansSemibold',
                              fontSize: 14,
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              )
          ],
        )
      ),
    );
  }
}