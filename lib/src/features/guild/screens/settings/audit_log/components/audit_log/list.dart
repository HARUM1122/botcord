import 'package:flutter/material.dart';

import 'package:nyxx/nyxx.dart';

import 'tile.dart';

class AuditLogList extends StatelessWidget {
  final List<(User, String, String, Snowflake, List<String>)> auditLogInfoList;
  const AuditLogList({
    required this.auditLogInfoList,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowIndicator();
          return true;
        },
        child: ListView.builder(
          itemCount: auditLogInfoList.length,
          itemBuilder: (context, index) => AuditLogTile(
            auditLogInfo: auditLogInfoList[index],
          )
        ),
      ),
    );
  }
}