import 'dart:async';

import 'package:discord/src/common/components/checkbox_indicator.dart';
import 'package:discord/src/common/components/custom_button.dart';
import 'package:discord/src/common/controllers/theme_controller.dart';
import 'package:discord/src/common/utils/utils.dart';
import 'package:discord/src/features/guild/screens/settings/audit_log/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyxx/nyxx.dart';

class FilterByActionsPage extends ConsumerStatefulWidget {
  final AuditLogEvent? actionType;
  const FilterByActionsPage({required this.actionType, super.key});

  @override
  ConsumerState<FilterByActionsPage> createState() => _FilterByActionsPageState();
}

class _FilterByActionsPageState extends ConsumerState<FilterByActionsPage> {
  late final String _theme = ref.read(themeController);

  late final Color _color1 = appTheme<Color>(_theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF));
  late final Color _color2 = appTheme<Color>(_theme, light: const Color(0XFF4C4F57), dark: const Color(0XFFC8C9D1), midnight: const Color(0xFFFFFFFF));
  
  late final Color _color3 = appTheme<Color>(_theme, light: const Color(0XFFEBEBEB), dark: const Color(0XFF2C2D36), midnight: const Color(0XFF1C1B21));
  late final Color _color4 = appTheme<Color>(_theme, light: const Color(0xFFFFFFFF), dark: const Color(0xFF25282F), midnight: const Color(0XFF141318));
  late final Color _color5 = appTheme<Color>(_theme, light: const Color(0XFFE1E1E1), dark: const Color(0XFF2F323A), midnight: const Color(0XFF202226));

  String _actionName = '';

  Icon getIcon(String type) => switch(type) {
    'ALL' => Icon(
      Icons.list,
      color: _color2,
      size: 22,
    ),
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme<Color>(_theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0xFF000000)),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          splashRadius: 18,
          icon: Icon(
            Icons.arrow_back,
            color: appTheme<Color>(_theme, light: const Color(0XFF565960), dark: const Color(0XFF878A93), midnight: const Color(0XFF838594))
          )
        ),
        title: Text(
          'Filter by Action',
          style: TextStyle(
            color: _color1,
            fontFamily: 'GGSansBold',
            fontSize: 18
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 18, right: 18),
            width: double.infinity,
            height: 40,
            child: Theme(
              data: ThemeData(
                textSelectionTheme: TextSelectionThemeData(
                  selectionColor: _color1.withOpacity(0.3),
                  cursorColor: _color1
                )
              ),
              child: TextField(
                style: TextStyle(
                  color: _color1,
                  fontSize: 14
                ),
                onChanged: (text) => setState(() =>_actionName = text),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide.none
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: appTheme<Color>(_theme, light: const Color(0XFF2A2E31), dark: const Color(0XFFCDD1D4), midnight: const Color(0XFFDCE0E4))
                  ),
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: appTheme<Color>(_theme, light: const Color(0XFF585B62), dark: const Color(0XFF83868F), midnight: const Color(0XFF9598A1)),
                    fontSize: 14
                  ),
                  contentPadding: const EdgeInsets.all(8),
                  filled: true,
                  fillColor: appTheme<Color>(_theme, light: const Color(0XFFDDE1E4), dark: const Color(0XFF0F1316), midnight: const Color(0XFF0D1017)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          () {
            List<(String, String, AuditLogEvent?)> filteredActions = actions.where((element) => element.$1.toLowerCase().contains(_actionName.toLowerCase())).toList();
      
            return Expanded(
              child: ListView.builder(
                itemCount: filteredActions.length,
                itemBuilder: (context, index) => ActionWidget(
                  leading: getIcon(filteredActions[index].$2),
                  action: filteredActions[index],
                  selected: filteredActions[index].$3 == widget.actionType,
                )
              ),
            );
          }()
        ]
      ),
    );
  }
}

class ActionWidget extends ConsumerWidget {
  final Icon leading;
  final (String, String, AuditLogEvent?) action;
  final bool selected;
  const ActionWidget({
    required this.leading,
    required this.action,
    required this.selected,
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String theme = ref.read(themeController);
    return CustomButton(
      onPressed: () => Navigator.pop(context, action.$3),
      backgroundColor: Colors.transparent,
      onPressedColor: appTheme<Color>(theme, light: const Color(0XFFE1E1E1), dark: const Color(0XFF2F323A), midnight: const Color(0XFF202226)),
      applyClickAnimation: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 18),
            Text(
              action.$1,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'GGSansSemibold',
                color: appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF))
              ),
            ),
            const Spacer(),
            CheckBoxIndicator(selected: selected, circular: true)
          ],
        ),
      ),
    );

  }
}