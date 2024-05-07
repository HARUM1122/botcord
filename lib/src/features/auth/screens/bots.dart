import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:discord/theme_provider.dart';

import '../utils/utils.dart';

import '../components/bot_list.dart';

import '../../../common/utils/utils.dart';

import '../controller/auth_controller.dart';

class BotsScreen extends ConsumerStatefulWidget {
  final bool fromSplash;
  const BotsScreen({required this.fromSplash, super.key});

  @override
  ConsumerState<BotsScreen> createState() => _BotsScreenState();
}

class _BotsScreenState extends ConsumerState<BotsScreen> {
  String _name = "";
  Timer? _debounce;
  late final AuthController _authController = ref.read(authControllerProvider);
  late final String _theme = ref.read(themeProvider);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme(_theme, light: const Color(0XFFF0F4F7), dark: const Color(0xFF1A1D24), midnight: const Color(0xFF000000)),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Bots",
          style: TextStyle(
            color: appTheme(_theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
            fontFamily: 'GGSansBold',
            fontSize: 24
          ),
        ),
        centerTitle: true,
        leading: Visibility(
          visible: !widget.fromSplash,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            splashRadius: 18,
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0XFF7D818F),
            ),
          )
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/add-bots-route'
              );
            },
            style: const ButtonStyle(
              overlayColor: MaterialStatePropertyAll(Colors.transparent),
            ),
            child: Text(
              "Add bots",
              style: TextStyle(
                color: appTheme<Color>(_theme, light: const Color(0xFF5964F4), dark: const Color(0xFF969BF6), midnight: const Color(0XFF6E82F4)),
                fontSize: 16,
                fontFamily: 'GGSansSemibold'
              )
            ),
          ),
          const SizedBox(width: 10)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18),
        child: Column(
          children: [
            if (_authController.bots.isNotEmpty) ...[
              SizedBox(
                width: double.infinity,
                height: 40,
                child: Theme(
                  data: ThemeData(
                    textSelectionTheme: TextSelectionThemeData(
                      selectionColor: appTheme(_theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)).withOpacity(0.3),
                      cursorColor: appTheme(_theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
                    )
                  ),
                  child: TextField(
                    style: TextStyle(
                      color: appTheme(_theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
                      fontSize: 14
                    ),
                    onChanged: (text) {
                      if (_debounce?.isActive ?? false) _debounce?.cancel();
                      _debounce = Timer(const Duration(milliseconds: 400), () =>
                        setState(() =>_name = text)
                      );
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide.none
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: appTheme(_theme, light: const Color(0XFF2A2E31), dark: const Color(0XFFCDD1D4), midnight: const Color(0XFFDCE0E4))
                      ),
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        color: appTheme(_theme, light: const Color(0XFF585B62), dark: const Color(0XFF83868F), midnight: const Color(0XFF9598A1)),
                        fontSize: 14
                      ),
                      contentPadding: const EdgeInsets.all(8),
                      filled: true,
                      fillColor: appTheme(_theme, light: const Color(0XFFDDE1E4), dark: const Color(0XFF0F1316), midnight: const Color(0XFF0D1017)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20)
            ],
            Consumer(
              builder: (_, ref, __) {
                Map<String, dynamic> bots = ref.watch(authControllerProvider).bots;
                if (bots.isEmpty) {
                   return Expanded(
                    child: Center(
                      child: Text(
                        "You haven't added any bots",
                        style: TextStyle(
                          color: appTheme(_theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
                          fontSize: 20,
                          fontFamily: 'GGSansSemibold'
                        ),
                      ),
                    ),
                  );
                }
                Map<String, dynamic> filteredBots = filter(bots, _name);
                if (filteredBots.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        "No bots were found",
                        style: TextStyle(
                          color: appTheme(_theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
                          fontSize: 20,
                          fontFamily: 'GGSansSemibold'
                        ),
                      ),
                    ),
                  );
                }
                return BotsList(bots: filteredBots);
              }
            )
          ],
        ),
      ),
    );
  }
}