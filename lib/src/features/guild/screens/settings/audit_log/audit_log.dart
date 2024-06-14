import 'package:discord/src/common/utils/extensions.dart';
import 'package:discord/src/common/utils/globals.dart';
import 'package:discord/src/features/guild/screens/settings/audit_log/components/audit_log/list.dart';
import 'package:discord/src/features/guild/screens/settings/audit_log/utils/utils.dart';
import 'package:discord/src/features/guild/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:nyxx/nyxx.dart' as nyxx;
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/common/components/custom_button.dart';
import 'package:discord/src/common/controllers/theme_controller.dart';

import 'package:discord/src/features/guild/screens/settings/audit_log/components/filter_options_sheet.dart';
class AuditLogPage extends ConsumerStatefulWidget {
  final nyxx.Guild? guild;
  const AuditLogPage({required this.guild, super.key});

  @override
  ConsumerState<AuditLogPage> createState() => _AuditLogPageState();
}

class _AuditLogPageState extends ConsumerState<AuditLogPage> {
  late final String _theme = ref.read(themeController);

  late final Color _color1 = appTheme<Color>(_theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
  late final Color _color2 = appTheme<Color>(_theme, light: const Color(0XFF595A63), dark: const Color(0XFF81818D), midnight: const Color(0XFF81818D));
  
  nyxx.Snowflake? _userId;
  (String, nyxx.AuditLogEvent?) _actionType = ('All Actions', null);

  Future<List<(nyxx.User, String, String, nyxx.Snowflake, List<String>)>> getLogs() async {
    List<nyxx.AuditLogEntry> auditLogEntries = await widget.guild?.auditLogs.list(type: _actionType.$2) ?? [];
    List<(nyxx.User, String, String, nyxx.Snowflake, List<String>)> logs = [];
    for (final nyxx.AuditLogEntry auditLogEntry in auditLogEntries) {
      if (actions.containsKey(auditLogEntry.actionType.value)) {
        final action = actions[auditLogEntry.actionType.value]!;
        final (nyxx.User, String, List<String>) info = await action.$4!(auditLogEntry, widget.guild);
        logs.add((info.$1, info.$2, action.$2, auditLogEntry.id, info.$3));
      }
    }
    return logs;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme<Color>(_theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0xFF000000)),
      appBar: AppBar(
        leading:  IconButton(
          onPressed: () => Navigator.pop(context),
          splashRadius: 18,
          icon: Icon(
            Icons.arrow_back,
            color: appTheme<Color>(_theme, light: const Color(0XFF565960), dark: const Color(0XFF878A93), midnight: const Color(0XFF838594))
          )
        ),
        title: Text(
          'Audit Log',
          style: TextStyle(
            color: _color1,
            fontFamily: 'GGSansBold',
            fontSize: 18
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final dynamic result = await showSheet(
                context: context, 
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16)
                ),
                color: appTheme<Color>(_theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0xFF000000)),
                builder:(context, controller, offset) => FilterOptions(
                  actionType: _actionType,
                  controller: controller,
                ), 
                height: 0.3, 
                maxHeight: 0.6
              );
              if (result == null) return;
              setState(() =>  _actionType = result);
            },
            style: const ButtonStyle(
              overlayColor: MaterialStatePropertyAll(Colors.transparent)
            ),
            child: Text(
              'Filter',
              style: TextStyle(
                color: appTheme<Color>(_theme, light: const Color(0xFF5964F4), dark: const Color(0xFF969BF6), midnight: const Color(0XFF6E82F4)),
                fontSize: 16,
                fontFamily: 'GGSansSemibold'
              ),
            )
          ),
          const SizedBox(width: 8)
        ],
        centerTitle: true
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 12, right: 12, bottom: context.padding.bottom + 12),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                  // List<nyxx.AuditLogEntry> entries = await widget.guild!.auditLogs.list();
                  // print(entries[1].options?.membersRemoved);
                  // print(entries[1].options?.deleteMemberDays);
                  // print(entries[0].actionType.name);
                  //   // print(entries[0].options?.channelId);
                  //   // print(entries[0].options?.applicationId);;
                  //   for (nyxx.AuditLogChange change in entries[3].changes ?? []) {
                  //     print("${change.key} : ${change.newValue}");
                  //     print("${change.key} : ${change.oldValue}");
                  
                  
                  //   // if (change.key == 'allow') {
                  //   //   print("ALLOWED");
                  //   //   print(getAllPermissions(nyxx.Permissions(int.parse(change.newValue))));
                  //   // } 
                  //   // if (change.key == 'deny') {
                  //   //   print("DENIED");
                  //   //   print(getAllPermissions(nyxx.Permissions(int.parse(change.newValue))));
                  //   // }
                  //   // if (change.key == 'id') {
                  //   //   print(widget.guild!.roles.get(nyxx.Snowflake(int.parse(change.newValue))));
                  //   // }
                  // }
                  // for (nyxx.Flag<nyxx.Permissions> permission in nyxx.Permissions(275146377232)) {
                  //    switch (permission) {
                  //         case nyxx.Permissions.administrator:
                  //           print('Administrator Perm');
                  //         case  nyxx.Permissions.sendMessages:
                  //           print('Send messages Perm');
                  //         case nyxx.Permissions.attachFiles:
                  //           print("Can attach files");
                  //       }
                  // }
                  // print(nyxx.Permissions(536874000));
                  // for (final change in entries[0].changes!) {
                  //   print("${change.key} : ${change.newValue}");
                  // }
                  // for (nyxx.AuditLogEntry entry in entries) {
                  //   print(entry);
                  // }
                                // nyxx.AuditLogEntry entry = entries[0];
                                // print(entry.actionType.name);
                                // for (nyxx.AuditLogChange change in entry.changes!) {
                                //   print(change.key);
                                //   print(change.oldValue);
                                // }
              },
              child: Row(
                children: [
                  Text(
                    'Filter',
                    style: TextStyle(
                      color: _color1,
                      fontSize: 14,
                      fontFamily: 'GGSansSemibold'
                    ),
                  ),
                  const Spacer(),
                  const FilterTypeHeader(title: 'All Users'),
                  const SizedBox(width: 10),
                  FilterTypeHeader(title: _actionType.$1)
                ],  
              ),
            ),
            const SizedBox(height: 12),
            FutureBuilder(
              future: getLogs(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0XFF536CF8),
                      ),
                    ),
                  );
                }
                else if (snapshot.hasError) {
                  return Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Unexpected error, Please retry',
                            style: TextStyle(
                              color: _color1,
                              fontSize: 16,
                              fontFamily: 'GGSansSemibold'
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomButton(
                            width: 160,
                            height: 40,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(45 * 0.5)
                            ),
                            backgroundColor: const Color(0XFF536CF8),
                            onPressedColor: const Color(0XFF4658CA),
                            applyClickAnimation: true,
                            animationUpperBound: 0.04,
                            child: const Center(
                              child: Text(
                                'Retry',
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontFamily: 'GGSansSemibold'
                                ),
                              ),
                            ),
                            onPressed: () => setState(() {})
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasData) {
                  if (snapshot.data?.isEmpty ?? true) {
                    return Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18, right: 18),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'NO LOGS YET',
                                style: TextStyle(
                                  color: _color1,
                                  fontSize: 18,
                                  fontFamily: 'GGSansBold'
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Once moderators begin moderating, you can moderate the moderation here.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _color2,
                                  fontSize: 16,
                                  fontFamily: 'GGSansSemibold'
                                ),
                              ),
                            ]
                          ),
                        )
                      ),
                    );
                  }
                  return AuditLogList(
                    auditLogInfoList: snapshot.data!,
                  );
                }
                else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
      )
    );
  }
}

class FilterTypeHeader extends ConsumerWidget {
  final String title;
  const FilterTypeHeader({required this.title, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.read(themeController);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: appTheme<Color>(theme, light: const Color(0XFFE5E5E5), dark: const Color(0XFF0F1316), midnight: const Color(0XFF1D2027)),
        borderRadius: BorderRadius.circular(4)
      ),
      child: Text(
        title,
        style: TextStyle(
          color: appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
          fontSize: 12
        ),
      )
    );
  }
}

  // —) vs. En Dash (—) | How to Use in Sentences
  // August 25, 202 - 
