import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/utils.dart';
import '../components/bot_list.dart';
import '../controller/auth_controller.dart';

import '../../../common/utils/cache.dart';
import '../../../common/utils/extensions.dart';

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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme['color-11'],
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Bots",
          style: TextStyle(
            color: theme['color-01'],
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
            icon: Icon(
              Icons.arrow_back,
              color: theme['color-05'],
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
                color: theme['color-13'],
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
                      selectionColor: theme['color-03'].withOpacity(0.3),
                      cursorColor: theme['color-03']
                    )
                  ),
                  child: TextField(
                    style: TextStyle(
                      color: theme['color-02'],
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
                        color: theme['color-03']
                      ),
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        color: theme['color-03'],
                        fontSize: 14
                      ),
                      contentPadding: const EdgeInsets.all(8),
                      filled: true,
                      fillColor: theme['color-12'],
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
                          color: theme['color-01'],
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
                          color: theme['color-01'],
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