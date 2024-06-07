import 'package:flutter/material.dart';
import 'tile.dart';

class AuditLogList extends StatelessWidget {
  const AuditLogList({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) => AuditLogTile()
      ),
    );
  }
}