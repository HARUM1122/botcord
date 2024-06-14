import 'package:discord/src/common/controllers/theme_controller.dart';
import 'package:discord/src/common/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:nyxx/nyxx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryButton extends ConsumerStatefulWidget {
  final GuildCategory category;
  final List<GuildChannel> channels;
  const CategoryButton({
    required this.category,
    required this.channels,
    super.key
  });

  @override
  ConsumerState<CategoryButton> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends ConsumerState<CategoryButton> {

  late final String _theme = ref.read(themeController);

  late final Color _color1 = appTheme<Color>(
    _theme,
    light: const Color(0xFF000000),
    dark: const Color(0xFFFFFFFF),
    midnight: const Color(0xFFFFFFFF)
  ).withOpacity(0.5);
  
  late bool _opened = widget.channels.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _opened = !_opened),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [ 
          Row(
            children: [
              Icon(
                _opened ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                color: _color1,
                size: 12.8,
              ),
              Text(
                widget.category.name,
                style: TextStyle(
                  fontSize: 12.8,
                  fontFamily: 'GGSansBold',
                  color: _color1
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          
        ],
      ),
    );
  }
}