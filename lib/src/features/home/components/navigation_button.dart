import 'package:flutter/material.dart';

class NavigationButton extends StatelessWidget {
  final Function() onPressed;
  final Widget widget;
  final Text title;
  const NavigationButton({
    required this.widget, 
    required this.title, 
    required this.onPressed, 
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: onPressed,
        child: Column(
          children: [
            widget,
            title
          ],
        ),
      ),
    );
  }
}